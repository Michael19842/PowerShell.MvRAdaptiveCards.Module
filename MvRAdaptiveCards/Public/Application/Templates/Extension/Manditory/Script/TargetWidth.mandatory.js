
// Adds client-side support for the Adaptive Card `targetWidth` property.
(function () {
    if (typeof AdaptiveCards === 'undefined') {
        console.warn('TargetWidth extension: AdaptiveCards not available');
        return;
    }

    const AC = AdaptiveCards;
    if (AC.__targetWidthExtensionInitialized) {
        return;
    }
    AC.__targetWidthExtensionInitialized = true;

    const globalScope = typeof window !== 'undefined' ? window : typeof globalThis !== 'undefined' ? globalThis : undefined;
    const ResizeObserverCtor = globalScope && typeof globalScope.ResizeObserver === 'function' ? globalScope.ResizeObserver : undefined;
    const schedule = typeof queueMicrotask === 'function' ? queueMicrotask : cb => setTimeout(cb, 0);
    const logger = (level, ...args) => {
        const consoleObj = typeof console !== 'undefined' ? console : globalScope && globalScope.console ? globalScope.console : undefined;
        if (!consoleObj) {
            return;
        }
        const resolvedLevel = level === 'debug' ? 'log' : level;
        const fn = consoleObj[resolvedLevel] || consoleObj.log;
        if (typeof fn === 'function') {
            //disable logging
            //fn.call(consoleObj, '[TargetWidth]', ...args);
        }
    };

    const parsePatchFlag = '__targetWidthParsePatch';
    const cardElementPrototype = AC.CardElement && AC.CardElement.prototype;
    const baseParse = cardElementPrototype && typeof cardElementPrototype.parse === 'function' ? cardElementPrototype.parse : undefined;
    if (baseParse && !AC[parsePatchFlag]) {
        AC[parsePatchFlag] = true;
        cardElementPrototype.parse = function parseWithTargetWidth(source, context) {
            const result = baseParse.call(this, source, context);
            if (source && typeof source === 'object') {
                let captured;
                if (Object.prototype.hasOwnProperty.call(source, 'targetWidth')) {
                    captured = source.targetWidth;
                } else if (Object.prototype.hasOwnProperty.call(source, 'targetwidth')) {
                    captured = source.targetwidth;
                }
                if (typeof captured !== 'undefined') {
                    try {
                        this.targetWidth = captured;
                    } catch (err) {
                        logger('debug', 'Unable to assign targetWidth directly', err && err.message ? err.message : err);
                    }
                    this.__mvrTargetWidth = captured;
                }
            }
            return result;
        };
        logger('info', 'TargetWidth parse patch installed');
    } else if (!baseParse) {
        logger('warn', 'CardElement.parse missing; unable to capture targetWidth');
    }
    const hasNativeHostWidth = typeof AC.HostWidth === 'object' && AC.HostWidth !== null;
    const fallbackHostWidth = {
        VeryNarrow: 0,
        Narrow: 1,
        Standard: 2,
        Wide: 3,
        0: 'VeryNarrow',
        1: 'Narrow',
        2: 'Standard',
        3: 'Wide'
    };
    const HostWidthEnum = hasNativeHostWidth ? AC.HostWidth : fallbackHostWidth;
    const getHostWidthLabel = value => {
        if (value === undefined || value === null) {
            return String(value);
        }
        if (HostWidthEnum && typeof HostWidthEnum[value] !== 'undefined') {
            return HostWidthEnum[value];
        }
        return String(value);
    };
    const defaultBreakpoints = {
        veryNarrow: 216,
        narrow: 345,
        standard: 500
    };
    const visitedFlag = Symbol('ac-targetwidth-visited');
    const visibilityFlag = Symbol('ac-targetwidth-visibility');
    const displayCache = new WeakMap();

    function getBreakpoints(card) {
        const hostConfig = card && card.hostConfig ? card.hostConfig : undefined;
        const bps = hostConfig && hostConfig.hostWidthBreakpoints ? hostConfig.hostWidthBreakpoints : {};
        const breakpoints = {
            veryNarrow: typeof bps.veryNarrow === 'number' ? bps.veryNarrow : defaultBreakpoints.veryNarrow,
            narrow: typeof bps.narrow === 'number' ? bps.narrow : defaultBreakpoints.narrow,
            standard: typeof bps.standard === 'number' ? bps.standard : defaultBreakpoints.standard
        };
        logger('debug', 'Breakpoints resolved', breakpoints);
        return breakpoints;
    }

    function computeHostWidth(width, card) {
        if (!width || !isFinite(width)) {
            logger('warn', 'Width measurement unavailable, defaulting to Wide', width);
            return HostWidthEnum.Wide;
        }
        const { veryNarrow, narrow, standard } = getBreakpoints(card);
        if (width <= veryNarrow) {
            return HostWidthEnum.VeryNarrow;
        }
        if (width <= narrow) {
            return HostWidthEnum.Narrow;
        }
        if (width <= standard) {
            return HostWidthEnum.Standard;
        }
        return HostWidthEnum.Wide;
    }

    function normalizeHostWidth(value) {
        if (value === undefined || value === null) {
            return undefined;
        }
        if (typeof value === 'number') {
            return value;
        }
        if (typeof value === 'string') {
            const lowered = value.toLowerCase();
            if (lowered in hostWidthLookupByName) {
                return hostWidthLookupByName[lowered];
            }
        }
        if (typeof HostWidthEnum === 'object') {
            for (const key of Object.keys(HostWidthEnum)) {
                if (HostWidthEnum[key] === value) {
                    const parsed = Number(key);
                    if (!Number.isNaN(parsed)) {
                        return parsed;
                    }
                }
            }
        }
        return value;
    }

    const hostWidthLookupByName = {
        verynarrow: HostWidthEnum.VeryNarrow,
        narrow: HostWidthEnum.Narrow,
        standard: HostWidthEnum.Standard,
        wide: HostWidthEnum.Wide
    };

    function parseTargetWidthString(value) {
        if (typeof value !== 'string') {
            return undefined;
        }
        const normalized = value.trim().toLowerCase();
        let condition;
        let widthName;
        if (normalized.includes(':')) {
            const [prefix, suffix] = normalized.split(':');
            condition = prefix;
            widthName = suffix;
        } else {
            widthName = normalized;
        }
        const widthValue = widthName in hostWidthLookupByName ? hostWidthLookupByName[widthName] : undefined;
        if (widthValue === undefined) {
            return undefined;
        }
        return { condition, width: widthValue };
    }

    function evaluateTargetWidthValue(value, hostWidth) {
        const normalizedHostWidth = normalizeHostWidth(hostWidth);
        if (value === undefined || value === null) {
            logger('debug', 'evaluateTargetWidthValue: no target width supplied, defaulting to visible');
            return true;
        }
        if (typeof value.matches === 'function') {
            try {
                const result = !!value.matches(normalizedHostWidth);
                logger('debug', 'evaluateTargetWidthValue: using matches()', 'hostWidth', getHostWidthLabel(normalizedHostWidth), 'result', result);
                return result;
            } catch (err) {
                logger('warn', 'Error evaluating targetWidth.matches', err);
            }
        }
        if (typeof value === 'number') {
            const result = normalizedHostWidth === normalizeHostWidth(value);
            logger('debug', 'evaluateTargetWidthValue: numeric comparison', 'target', value, 'hostWidth', normalizedHostWidth, 'result', result);
            return result;
        }
        if (typeof value === 'string') {
            const parsed = parseTargetWidthString(value);
            if (!parsed) {
                logger('debug', 'evaluateTargetWidthValue: unable to parse target width string', value, 'defaulting to visible');
                return true;
            }
            const result = evaluateCondition(parsed, normalizedHostWidth);
            logger('debug', 'evaluateTargetWidthValue: parsed string', value, '->', parsed, 'hostWidth', normalizedHostWidth, 'result', result);
            return result;
        }
        if (typeof value === 'object' && value) {
            const hasWidth = 'width' in value ? value.width : undefined;
            const hasCondition = 'condition' in value ? value.condition : undefined;
            if (typeof hasWidth === 'number' || typeof hasWidth === 'string') {
                const widthValue = normalizeHostWidth(hasWidth);
                const conditionValue = typeof hasCondition === 'string' ? hasCondition.toLowerCase() : hasCondition;
                const result = evaluateCondition({ condition: conditionValue, width: widthValue }, normalizedHostWidth);
                logger('debug', 'evaluateTargetWidthValue: object evaluation', 'target', { condition: conditionValue, width: widthValue }, 'hostWidth', normalizedHostWidth, 'result', result);
                return result;
            }
        }
        logger('debug', 'evaluateTargetWidthValue: unsupported target width format', value, 'defaulting to visible');
        return true;
    }

    function evaluateCondition(target, hostWidth) {
        if (!target || typeof target.width === 'undefined') {
            return true;
        }
        const targetWidth = normalizeHostWidth(target.width);
        if (typeof targetWidth !== 'number') {
            logger('debug', 'evaluateCondition: target width not numeric', target.width, '->', targetWidth, 'defaulting to visible');
            return true;
        }
        const condition = target.condition;
        if (condition === undefined || condition === null || condition === '') {
            const result = hostWidth === targetWidth;
            logger('debug', 'evaluateCondition: exact match required', 'target', targetWidth, 'host', hostWidth, 'result', result);
            return result;
        }
        if (condition === 'atleast' || condition === 0) {
            const result = hostWidth >= targetWidth;
            logger('debug', 'evaluateCondition: atleast', 'target', targetWidth, 'host', hostWidth, 'result', result);
            return result;
        }
        if (condition === 'atmost' || condition === 1) {
            const result = hostWidth <= targetWidth;
            logger('debug', 'evaluateCondition: atmost', 'target', targetWidth, 'host', hostWidth, 'result', result);
            return result;
        }
        const result = hostWidth === targetWidth;
        logger('debug', 'evaluateCondition: unknown condition, falling back to equality', condition, 'target', targetWidth, 'host', hostWidth, 'result', result);
        return result;
    }

    function visitCardTree(node, hostWidth, markKey) {
        if (!node || typeof node !== 'object') {
            return;
        }
        if (node[markKey]) {
            return;
        }
        node[markKey] = true;

        if (hostWidth !== undefined && 'hostWidth' in node) {
            try {
                node.hostWidth = hostWidth;
            } catch (err) {
                /* no-op */
            }
        }

        if ('enableAutomaticReflow' in node) {
            try {
                node.enableAutomaticReflow = true;
            } catch (err) {
                /* no-op */
            }
        }

        if (typeof node.getItemCount === 'function' && typeof node.getItemAt === 'function') {
            const count = Number(node.getItemCount());
            for (let i = 0; i < count; i++) {
                visitCardTree(node.getItemAt(i), hostWidth, markKey);
            }
        }

        if (typeof node.getActionCount === 'function' && typeof node.getActionAt === 'function') {
            const count = Number(node.getActionCount());
            for (let i = 0; i < count; i++) {
                visitCardTree(node.getActionAt(i), hostWidth, markKey);
            }
        }

        if ('items' in node && Array.isArray(node.items)) {
            for (const item of node.items) {
                visitCardTree(item, hostWidth, markKey);
            }
        }

        delete node[markKey];
    }

    function describeNode(node) {
        if (!node || typeof node !== 'object') {
            return 'unknown';
        }
        const ctorName = typeof node.constructor === 'function' && node.constructor.name ? node.constructor.name : 'Anonymous';
        const id = typeof node.id === 'string' && node.id ? `#${node.id}` : '';
        const target = node.targetWidth ? String(node.targetWidth) : 'no target';
        return `${ctorName}${id} (${target})`;
    }

    function applyVisibility(node, hostWidth, markKey) {
        if (!node || typeof node !== 'object') {
            return;
        }
        if (node[markKey]) {
            return;
        }
        node[markKey] = true;

        logger('debug', 'Visiting node', describeNode(node));

        const hasOwnTargetWidth = Object.prototype.hasOwnProperty.call(node, 'targetWidth');
        const inPrototypeTargetWidth = 'targetWidth' in node;
        logger('debug', 'targetWidth presence', describeNode(node), 'hasOwn', hasOwnTargetWidth, 'inPrototype', inPrototypeTargetWidth);
        const hasTargetWidthProperty = hasOwnTargetWidth || inPrototypeTargetWidth;
        let targetWidthValue;
        if (hasTargetWidthProperty) {
            try {
                targetWidthValue = node.targetWidth;
            } catch (err) {
                targetWidthValue = `__error__: ${err && err.message ? err.message : err}`;
            }
            logger('debug', 'targetWidth property detected', describeNode(node), 'raw value type', typeof targetWidthValue, 'value', targetWidthValue);
        } else {
            try {
                const sampleKeys = Object.getOwnPropertyNames(node).slice(0, 10);
                logger('debug', 'targetWidth missing; own property names', describeNode(node), sampleKeys);
            } catch (err) {
                logger('debug', 'targetWidth missing; unable to list properties', err);
            }
        }

        const canFilter = typeof node.shouldRenderForTargetWidth === 'function';
        const hasTargetWidth = typeof targetWidthValue !== 'undefined' && targetWidthValue !== null;
        let shouldRender;
        if (canFilter) {
            shouldRender = !!node.shouldRenderForTargetWidth(hostWidth);
        } else if (hasTargetWidth) {
            shouldRender = evaluateTargetWidthValue(targetWidthValue, hostWidth);
        } else {
            shouldRender = true;
        }

        if (canFilter || hasTargetWidth) {
            const displayTarget = hasTargetWidth ? (typeof targetWidthValue === 'object' && targetWidthValue && typeof targetWidthValue.toString === 'function' ? targetWidthValue.toString() : String(targetWidthValue)) : 'none';
            logger('debug', 'Evaluated node', describeNode(node), 'targetWidth', displayTarget, '->', shouldRender ? 'visible' : 'hidden', 'for hostWidth', getHostWidthLabel(hostWidth), '(' + hostWidth + ')');
        }

        applyDomVisibility(node, shouldRender);

        if (typeof node.getItemCount === 'function' && typeof node.getItemAt === 'function') {
            const count = Number(node.getItemCount());
            for (let i = 0; i < count; i++) {
                applyVisibility(node.getItemAt(i), hostWidth, markKey);
            }
        }

        if (typeof node.getActionCount === 'function' && typeof node.getActionAt === 'function') {
            const count = Number(node.getActionCount());
            for (let i = 0; i < count; i++) {
                applyVisibility(node.getActionAt(i), hostWidth, markKey);
            }
        }

        if ('items' in node && Array.isArray(node.items)) {
            for (const item of node.items) {
                applyVisibility(item, hostWidth, markKey);
            }
        }

        delete node[markKey];
    }

    function applyDomVisibility(node, shouldRender) {
        const element = node.renderedElement || node._renderedElement;
        if (element && typeof element.style !== 'undefined') {
            logger('log', 'Applying DOM visibility to element', element.className || element.tagName || element, '->', shouldRender ? 'show' : 'hide');
            updateDisplay(element, shouldRender);
        }

        const separator = node.renderedSeparatorElement || node._renderedSeparatorElement;
        if (separator && typeof separator.style !== 'undefined') {
            logger('log', 'Applying DOM visibility to separator', separator.className || separator.tagName || separator, '->', shouldRender ? 'show' : 'hide');
            updateDisplay(separator, shouldRender);
        }
    }

    function updateDisplay(element, shouldRender) {
        if (!element) {
            return;
        }
        if (!shouldRender) {
            if (!displayCache.has(element)) {
                logger('debug', 'Hiding DOM element', element.className || element.tagName || element);
            }
            if (!displayCache.has(element)) {
                displayCache.set(element, element.style.display || '');
            }
            element.style.display = 'none';
        } else {
            if (displayCache.has(element)) {
                const original = displayCache.get(element);
                displayCache.delete(element);
                logger('debug', 'Restoring DOM element display', element.className || element.tagName || element, '->', original);
                element.style.display = original;
            } else if (element.style.display === 'none') {
                logger('debug', 'Resetting DOM element display to default', element.className || element.tagName || element);
                element.style.display = '';
            }
        }
    }

    function refreshCard(card) {
        if (card && typeof card.updateLayout === 'function') {
            try {
                card.updateLayout(true);
                return;
            } catch (err) {
                /* fall through */
            }
        }
        if (card && typeof card.invalidate === 'function') {
            try {
                card.invalidate();
            } catch (err) {
                /* no-op */
            }
        }
    }

    function disconnectElement(element) {
        if (!element || typeof element !== 'object') {
            return;
        }
        if (element.__targetWidthObserver) {
            try {
                element.__targetWidthObserver.disconnect();
            } catch (err) {
                /* no-op */
            }
            element.__targetWidthObserver = undefined;
        }
        if (element.__targetWidthResizeHandler && globalScope && typeof globalScope.removeEventListener === 'function') {
            globalScope.removeEventListener('resize', element.__targetWidthResizeHandler);
            element.__targetWidthResizeHandler = undefined;
        }
    }

    function measureWidth(element) {
        if (!element) {
            return 0;
        }
        const rect = element.getBoundingClientRect ? element.getBoundingClientRect() : undefined;
        if (rect && rect.width) {
            return rect.width;
        }
        return element.offsetWidth || element.clientWidth || 0;
    }

    function resolveMeasurementTarget(element) {
        if (!element || typeof element !== 'object') {
            return element;
        }
        const parent = element.parentElement;
        if (!parent || parent === element) {
            return element;
        }
        const tag = parent.tagName ? parent.tagName.toLowerCase() : '';
        if (!tag || tag === 'body' || tag === 'html') {
            return element;
        }
        if (typeof globalScope !== 'undefined' && globalScope && typeof globalScope.getComputedStyle === 'function') {
            try {
                const style = globalScope.getComputedStyle(parent);
                if (style && style.display && style.display.includes('inline')) {
                    return element;
                }
            } catch (err) {
                logger('debug', 'resolveMeasurementTarget: unable to inspect parent style', err && err.message ? err.message : err);
            }
        }
        return parent;
    }

    function attachResizeHandling(card, element) {
        if (!card || !element) {
            return;
        }

        disconnectElement(element);
        card.__targetWidthMeasureElement = undefined;

        const runVisibilityPass = hostWidth => {
            logger('debug', 'Running visibility pass', getHostWidthLabel(hostWidth));
            visitCardTree(card, hostWidth, visitedFlag);
            applyVisibility(card, hostWidth, visibilityFlag);
        };

        const update = () => {
            if (!element.isConnected) {
                logger('debug', 'Render element not connected, aborting update');
                return;
            }
            let measurementTarget = card.__targetWidthMeasureElement;
            if (!measurementTarget || !measurementTarget.isConnected) {
                measurementTarget = resolveMeasurementTarget(element);
                card.__targetWidthMeasureElement = measurementTarget;
            }
            const width = measureWidth(measurementTarget);
            const hostWidth = computeHostWidth(width, card);
            const changed = card.__currentTargetWidth !== hostWidth;

            const measurementLabel = measurementTarget && measurementTarget.tagName ? measurementTarget.tagName.toLowerCase() : measurementTarget;
            logger('debug', 'Measured width', width, 'from', measurementLabel, 'computed hostWidth', getHostWidthLabel(hostWidth), '(', hostWidth, ')', 'changed', changed);

            card.__currentTargetWidth = hostWidth;
            runVisibilityPass(hostWidth);

            if (changed) {
                logger('debug', 'Host width changed, refreshing card');
                refreshCard(card);
                schedule(() => {
                    if (!element.isConnected) {
                        logger('debug', 'Post-refresh: element disconnected, skipping');
                        return;
                    }
                    logger('debug', 'Post-refresh visibility pass');
                    runVisibilityPass(card.__currentTargetWidth);
                });
            }
        };

        if (ResizeObserverCtor) {
            try {
                const observer = new ResizeObserverCtor(() => update());
                observer.observe(element);
                element.__targetWidthObserver = observer;
            } catch (err) {
                logger('warn', 'ResizeObserver attach failed', err);
            }
        }

        if (!ResizeObserverCtor && globalScope && typeof globalScope.addEventListener === 'function') {
            const handler = () => update();
            globalScope.addEventListener('resize', handler);
            element.__targetWidthResizeHandler = handler;
            logger('debug', 'Global resize fallback registered');
        }

        schedule(update);
    }

    const baseRender = AC.AdaptiveCard.prototype.render;
    AC.AdaptiveCard.prototype.render = function renderWithTargetWidth() {
        const element = baseRender.call(this);
        if (!element) {
            logger('warn', 'Render returned no element');
            return element;
        }

        if (this.__targetWidthElement && this.__targetWidthElement !== element) {
            disconnectElement(this.__targetWidthElement);
        }

        this.__targetWidthElement = element;
        logger('debug', 'Render complete, attaching resize handling');
        attachResizeHandling(this, element);
        return element;
    };

    logger('info', 'TargetWidth extension loaded');
})();
