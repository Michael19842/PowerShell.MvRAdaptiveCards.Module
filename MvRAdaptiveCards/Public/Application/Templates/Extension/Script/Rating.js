(function () {
    const AC = AdaptiveCards;

    // Rating Input element
    class RatingInput extends AC.Input {
        constructor() {
            super();
            this.max = 5;
            this.value = 0;
            this.size = 'medium';
            this.color = 'neutral';
            this.iconSet = 'star';
            this.count = 0;
            this.allowClear = true;
        }

        getJsonTypeName() {
            return "Input.Rating";
        }

        parse(source, context) {
            super.parse(source, context);

            if (source.max !== undefined) {
                this.max = source.max;
            }
            if (source.value !== undefined) {
                this.value = source.value;
            }
            if (source.size !== undefined) {
                this.size = source.size;
            }
            if (source.color !== undefined) {
                this.color = source.color;
            }
            if (source.iconSet !== undefined) {
                this.iconSet = source.iconSet;
            }
            if (source.count !== undefined) {
                this.count = source.count;
            }
            if (source.allowClear !== undefined) {
                this.allowClear = source.allowClear;
            }
        }

        internalRender() {
            const container = document.createElement('div');
            container.className = 'ac-rating-container';
            container.setAttribute('data-size', this.size);
            container.setAttribute('data-color', this.color);

            // Create rating items
            for (let i = 1; i <= this.max; i++) {
                const ratingItem = document.createElement('button');
                ratingItem.type = 'button';
                ratingItem.className = 'ac-rating-item';
                ratingItem.setAttribute('data-value', i);
                ratingItem.setAttribute('aria-label', `Rate ${i} out of ${this.max}`);

                // Create icon
                const icon = document.createElement('span');
                icon.className = 'ac-rating-icon';
                icon.setAttribute('data-icon', this.iconSet);

                // Set icon content based on iconSet
                switch (this.iconSet) {
                    case 'star':
                        icon.innerHTML = '★';
                        break;
                    case 'heart':
                        icon.innerHTML = '♥';
                        break;
                    case 'thumb':
                        icon.innerHTML = '👍';
                        break;
                    default:
                        icon.innerHTML = '★';
                }

                ratingItem.appendChild(icon);

                // Add click handler
                ratingItem.addEventListener('click', (e) => {
                    e.preventDefault();
                    const clickedValue = parseInt(ratingItem.getAttribute('data-value'));

                    // If clicking the same value and allowClear is true, clear the rating
                    if (this.allowClear && this.value === clickedValue) {
                        this.value = 0;
                    } else {
                        this.value = clickedValue;
                    }

                    this.updateDisplay(container);
                    this.valueChanged();
                });

                // Add hover handlers
                ratingItem.addEventListener('mouseenter', () => {
                    this.highlightRating(container, i);
                });

                container.appendChild(ratingItem);
            }

            // Add container hover out handler
            container.addEventListener('mouseleave', () => {
                this.highlightRating(container, this.value);
            });

            // Show count if specified
            if (this.count > 0) {
                const countLabel = document.createElement('span');
                countLabel.className = 'ac-rating-count';
                countLabel.textContent = `(${this.count})`;
                container.appendChild(countLabel);
            }

            // Set initial display
            this.updateDisplay(container);

            // Keyboard support
            container.setAttribute('role', 'radiogroup');
            container.setAttribute('aria-label', `Rating input, ${this.max} stars`);

            return container;
        }

        highlightRating(container, value) {
            const items = container.querySelectorAll('.ac-rating-item');
            items.forEach((item, index) => {
                if (index < value) {
                    item.classList.add('ac-rating-hover');
                } else {
                    item.classList.remove('ac-rating-hover');
                }
            });
        }

        updateDisplay(container) {
            const items = container.querySelectorAll('.ac-rating-item');
            items.forEach((item, index) => {
                if (index < this.value) {
                    item.classList.add('ac-rating-selected');
                } else {
                    item.classList.remove('ac-rating-selected');
                }
            });
        }

        isSet() {
            return this.value !== undefined && this.value !== null && this.value > 0;
        }

        isValid() {
            if (this.isRequired && !this.isSet()) {
                return false;
            }
            return true;
        }

        get isInteractive() {
            return true;
        }

        getDefaultSerializationContext() {
            return new AC.SerializationContext();
        }

        internalValidateProperties(context) {
            super.internalValidateProperties(context);

            if (this.max < 1) {
                context.logParseEvent(
                    this,
                    AC.ValidationEvent.InvalidPropertyValue,
                    "max must be at least 1"
                );
            }
        }

        toJSON() {
            const result = super.toJSON();

            if (this.max !== 5) {
                result.max = this.max;
            }
            if (this.value !== 0) {
                result.value = this.value;
            }
            if (this.size !== 'medium') {
                result.size = this.size;
            }
            if (this.color !== 'neutral') {
                result.color = this.color;
            }
            if (this.iconSet !== 'star') {
                result.iconSet = this.iconSet;
            }
            if (this.count !== 0) {
                result.count = this.count;
            }
            if (this.allowClear !== true) {
                result.allowClear = this.allowClear;
            }

            return result;
        }
    }

    // Register the Rating input
    AC.GlobalRegistry.elements.register("Input.Rating", RatingInput);

    // Expose for debugging
    if (typeof window !== 'undefined') {
        window.RatingExtension = {
            RatingInput
        };
    }

    console.log('Rating Input extension loaded successfully');

})();
