// Ensures custom `bleed` metadata survives AdaptiveCards parsing.
(function () {
    if (typeof AdaptiveCards === 'undefined') {
        if (typeof console !== 'undefined' && console.warn) {
            console.warn('[Bleed] AdaptiveCards not available');
        }
        return;
    }

    const AC = AdaptiveCards;
    const scope = typeof window !== 'undefined' ? window : (typeof globalThis !== 'undefined' ? globalThis : undefined);
    const schedule = typeof queueMicrotask === 'function' ? queueMicrotask : cb => setTimeout(cb, 0);

    const log = (level, ...args) => {
        const consoleObj = typeof console !== 'undefined' ? console : scope && scope.console ? scope.console : undefined;
        if (!consoleObj) {
            return;
        }
        const method = level === 'debug' ? 'log' : level;
        const fn = consoleObj[method] || consoleObj.log;
        if (typeof fn === 'function') {
            //disable logging
            //fn.call(consoleObj, '[Bleed]', ...args);
        }
    };

    const patchFlag = '__bleedParsePatch';

    const describeElement = element => {
        if (!element || typeof element !== 'object') {
            return 'unknown';
        }
        const ctor = typeof element.constructor === 'function' && element.constructor.name ? element.constructor.name : 'Anonymous';
        const id = typeof element.id === 'string' && element.id ? `#${element.id}` : '';
        return `${ctor}${id}`;
    };

    const cardElementProto = AC.CardElement && AC.CardElement.prototype;
    const baseParse = cardElementProto && typeof cardElementProto.parse === 'function' ? cardElementProto.parse : undefined;

    if (!baseParse) {
        log('warn', 'CardElement.parse missing; cannot preserve bleed metadata');
        return;
    }

    if (AC[patchFlag]) {
        return;
    }

    AC[patchFlag] = true;

    cardElementProto.parse = function parseWithBleed(source, context) {
        const result = baseParse.call(this, source, context);
        if (source && typeof source === 'object') {
            let captured;
            if (Object.prototype.hasOwnProperty.call(source, 'bleed')) {
                captured = source.bleed;
            } else if (Object.prototype.hasOwnProperty.call(source, 'Bleed')) {
                captured = source.Bleed;
            }

            if (typeof captured !== 'undefined') {
                try {
                    if (typeof this.setBleed === 'function') {
                        this.setBleed(!!captured);
                    } else {
                        this.bleed = captured;
                    }
                } catch (err) {
                    log('debug', 'Unable to assign bleed directly', err && err.message ? err.message : err);
                }
                this.__mvrBleed = captured;
                log('debug', 'Captured bleed value', captured, 'for', describeElement(this));
            } else {
                log('debug', 'No bleed metadata on source', describeElement(this));
            }
        }
        return result;
    };

    const containerProto = AC.Container && AC.Container.prototype;
    if (containerProto && !containerProto.__mvrBleedRenderPatch) {
        containerProto.__mvrBleedRenderPatch = true;
        const baseRender = typeof containerProto.render === 'function' ? containerProto.render : undefined;

        containerProto.render = function renderWithBleed() {
            const element = baseRender ? baseRender.call(this) : undefined;

            const applyBleed = target => {
                if (!target) {
                    return;
                }

                const bleedFlag = typeof this.getBleed === 'function' ? this.getBleed() : this.bleed;
                const isBleeding = typeof this.isBleeding === 'function' ? this.isBleeding() : false;
                const active = !!bleedFlag || !!isBleeding;

                if (active) {
                    target.classList.add('mvr-bleed-container');
                    target.dataset.mvrBleed = 'true';
                } else {
                    target.classList.remove('mvr-bleed-container');
                    delete target.dataset.mvrBleed;
                }

                log('debug', 'Render container', describeElement(this), 'bleed', bleedFlag, 'isBleeding()', isBleeding, 'active', active);
            };

            applyBleed(element);
            if (element) {
                schedule(() => applyBleed(element));
            }

            return element;
        };
    }

    log('info', 'Bleed parse patch installed');
})();
