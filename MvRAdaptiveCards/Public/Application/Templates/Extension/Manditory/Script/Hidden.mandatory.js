(function () {
    const AC = AdaptiveCards;

    // Core Hidden Elements Handler - Mandatory Extension
    // Ensures elements with isVisible=false are properly hidden

    // Hook into the element rendering process
    const originalCardElementRender = AC.CardElement.prototype.render;

    AC.CardElement.prototype.render = function () {
        const renderedElement = originalCardElementRender.call(this);

        if (renderedElement) {
            // Check if this element has isVisible property
            if (typeof this.isVisible !== 'undefined') {
                renderedElement.setAttribute('data-is-visible', this.isVisible.toString());

                if (!this.isVisible) {
                    renderedElement.classList.add('ac-hidden');
                    // Use !important inline style to override AC's inline styles
                    renderedElement.style.setProperty('display', 'none', 'important');
                    renderedElement.setAttribute('hidden', '');
                    renderedElement.setAttribute('aria-hidden', 'true');
                }
            }

            // Store reference to element for toggle visibility actions
            if (this.id) {
                renderedElement.setAttribute('data-element-id', this.id);
            }
        }

        return renderedElement;
    };

    // Enhanced ToggleVisibility action handler
    const originalToggleVisibilityExecute = AC.ToggleVisibilityAction.prototype.execute;

    AC.ToggleVisibilityAction.prototype.execute = function () {
        // Call the original execute to let AC handle the internal state and toggles
        if (originalToggleVisibilityExecute) {
            originalToggleVisibilityExecute.call(this);
        }

        // Then enforce our display styles on the toggled elements
        if (this.targetElements) {
            // Convert to array - targetElements is an object with element IDs as keys
            let elementsArray = [];
            if (Array.isArray(this.targetElements)) {
                elementsArray = this.targetElements;
            } else if (this.targetElements.length !== undefined) {
                // It's array-like (has length property)
                for (let i = 0; i < this.targetElements.length; i++) {
                    elementsArray.push(this.targetElements[i]);
                }
            } else if (typeof this.targetElements === 'object') {
                // The object keys ARE the element IDs
                for (let key in this.targetElements) {
                    if (this.targetElements.hasOwnProperty(key)) {
                        elementsArray.push(key);
                    }
                }
            }

            elementsArray.forEach(target => {
                const elementId = typeof target === 'string' ? target : (target.elementId || target);

                if (elementId) {
                    // Try multiple selector strategies
                    let element = document.querySelector(`[data-element-id="${elementId}"]`);

                    // If not found, try by ID directly
                    if (!element) {
                        element = document.getElementById(elementId);
                    }

                    if (element) {
                        // Check computed display to see what AC set it to
                        const computedDisplay = window.getComputedStyle(element).display;

                        if (computedDisplay === 'none') {
                            // AC hid it, enforce our hidden styles
                            element.setAttribute('data-is-visible', 'false');
                            element.classList.add('ac-hidden');
                            element.style.setProperty('display', 'none', 'important');
                            element.setAttribute('hidden', '');
                            element.setAttribute('aria-hidden', 'true');
                        } else {
                            // AC showed it, enforce our visible styles
                            element.setAttribute('data-is-visible', 'true');
                            element.classList.remove('ac-hidden');
                            element.style.removeProperty('display');
                            element.removeAttribute('hidden');
                            element.removeAttribute('aria-hidden');
                        }
                    }
                }
            });
        }
    };

    // Parse isVisible property from JSON
    const originalParse = AC.CardElement.prototype.parse;

    AC.CardElement.prototype.parse = function (source, context) {
        originalParse.call(this, source, context);

        if (source.hasOwnProperty('isVisible')) {
            this.isVisible = source.isVisible;
        } else if (typeof this.isVisible === 'undefined') {
            this.isVisible = true; // Default to visible
        }
    };

    console.log("Core.Hidden extension loaded - Hidden elements will be properly styled");
})();
