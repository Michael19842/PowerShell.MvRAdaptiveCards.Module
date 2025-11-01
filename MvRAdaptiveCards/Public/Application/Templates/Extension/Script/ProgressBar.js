(function () {
    const AC = AdaptiveCards;

    class ProgressBar extends AC.CardElement {
        constructor() {
            super();
            this.value = undefined; // Current value (undefined = indeterminate mode)
            this.max = 100; // Maximum value
            this.color = "accent"; // accent|good|warning|attention
            this.thickness = "medium"; // thin|medium|thick
            this.showLabel = false; // Show percentage label
            this.labelPosition = "end"; // end|top|bottom|none
            this.animated = false; // Enable animation
            this.striped = false; // Enable striped appearance
            this.borderRadius = "rounded"; // rounded|square|pill
        }

        // Required: tell the framework this element's JSON type name
        getJsonTypeName() {
            return "ProgressBar";
        }

        // Parse JSON properties (called when card.parse is used)
        parse(source, errors) {
            super.parse(source, errors);

            if (source.value !== undefined) this.value = source.value;
            if (source.max !== undefined) this.max = source.max;
            if (source.color !== undefined) this.color = source.color.toLowerCase();
            if (source.thickness !== undefined) this.thickness = source.thickness;
            if (source.showLabel !== undefined) this.showLabel = source.showLabel;
            if (source.labelPosition !== undefined) this.labelPosition = source.labelPosition;
            if (source.animated !== undefined) this.animated = source.animated;
            if (source.striped !== undefined) this.striped = source.striped;
            if (source.borderRadius !== undefined) this.borderRadius = source.borderRadius;
        }

        // Get schema definition
        getSchemaKey() {
            return "ProgressBar";
        }

        // Validation
        isValid() {
            // Progress bar is valid even without value (indeterminate mode)
            return super.isValid() && this.max > 0;
        }

        // Calculate percentage
        getPercentage() {
            if (this.value === undefined || this.value === null) {
                return undefined; // Indeterminate
            }
            const percentage = (this.value / this.max) * 100;
            return Math.min(Math.max(percentage, 0), 100); // Clamp between 0-100
        }

        // Check if in indeterminate mode
        isIndeterminate() {
            return this.value === undefined || this.value === null;
        }

        // Called to render the element into a DOM node
        internalRender() {
            const container = document.createElement("div");
            container.className = "ac-progressbar-container";

            // Create wrapper for label positioning
            const wrapper = document.createElement("div");
            wrapper.className = "ac-progressbar-wrapper";
            wrapper.setAttribute("data-label-position", this.labelPosition);

            // Create the progress bar track
            const track = document.createElement("div");
            track.className = "ac-progressbar-track";
            track.setAttribute("role", "progressbar");

            // Apply thickness
            track.classList.add(`ac-progressbar-thickness-${this.thickness}`);
            track.setAttribute("data-thickness", this.thickness);

            // Apply border radius
            track.classList.add(`ac-progressbar-radius-${this.borderRadius}`);
            track.setAttribute("data-border-radius", this.borderRadius);

            // Create the progress fill
            const fill = document.createElement("div");
            fill.className = "ac-progressbar-fill";
            fill.setAttribute("data-color", this.color);
            fill.classList.add(`ac-progressbar-fill-${this.color}`);

            // Apply striped appearance
            if (this.striped) {
                fill.classList.add("ac-progressbar-striped");
            }

            // Check if indeterminate or determinate
            if (this.isIndeterminate()) {
                // Indeterminate mode
                fill.classList.add("ac-progressbar-indeterminate");
                track.removeAttribute("aria-valuenow");
                track.setAttribute("aria-valuemin", "0");
                track.setAttribute("aria-valuemax", "100");
                track.setAttribute("aria-label", "Loading...");
                fill.style.width = "100%";

                // Always animate in indeterminate mode
                fill.classList.add("ac-progressbar-animated");
            } else {
                // Determinate mode
                const percentage = this.getPercentage();
                fill.style.width = `${percentage}%`;

                // Apply animation if enabled
                if (this.animated) {
                    fill.classList.add("ac-progressbar-animated");
                }

                // ARIA attributes
                track.setAttribute("aria-valuenow", this.value);
                track.setAttribute("aria-valuemin", "0");
                track.setAttribute("aria-valuemax", this.max);
                track.setAttribute("aria-label", `Progress: ${Math.round(percentage)}%`);
            }

            track.appendChild(fill);

            // Create label if needed
            let label = null;
            if (this.showLabel && !this.isIndeterminate() && this.labelPosition !== "none") {
                label = document.createElement("span");
                label.className = "ac-progressbar-label";
                const percentage = this.getPercentage();
                label.innerText = `${Math.round(percentage)}%`;
                label.setAttribute("aria-hidden", "true"); // Hidden from screen readers (track already has aria-label)
            }

            // Position label based on labelPosition
            if (label) {
                switch (this.labelPosition) {
                    case "top":
                        wrapper.appendChild(label);
                        wrapper.appendChild(track);
                        wrapper.classList.add("ac-progressbar-label-top");
                        break;
                    case "bottom":
                        wrapper.appendChild(track);
                        wrapper.appendChild(label);
                        wrapper.classList.add("ac-progressbar-label-bottom");
                        break;
                    case "end":
                    default:
                        const flexContainer = document.createElement("div");
                        flexContainer.className = "ac-progressbar-flex";
                        flexContainer.appendChild(track);
                        flexContainer.appendChild(label);
                        wrapper.appendChild(flexContainer);
                        wrapper.classList.add("ac-progressbar-label-end");
                        break;
                }
            } else {
                wrapper.appendChild(track);
            }

            container.appendChild(wrapper);

            // Apply host config styles
            if (this.hostConfig) {
                this.applyHostConfigStyles(container);
            }

            return container;
        }

        // Apply host config styles
        applyHostConfigStyles(element) {
            if (this.hostConfig && this.hostConfig.progressBar) {
                const config = this.hostConfig.progressBar;

                if (config.fontFamily) {
                    element.style.fontFamily = config.fontFamily;
                }

                if (config.fontSize) {
                    const labels = element.querySelectorAll(".ac-progressbar-label");
                    labels.forEach(label => {
                        label.style.fontSize = config.fontSize;
                    });
                }
            }
        }

        // Serialization support
        toJSON() {
            const result = super.toJSON();

            if (this.value !== undefined) result.value = this.value;
            if (this.max !== 100) result.max = this.max;
            if (this.color !== "accent") result.color = this.color;
            if (this.thickness !== "medium") result.thickness = this.thickness;
            if (this.showLabel) result.showLabel = this.showLabel;
            if (this.labelPosition !== "end") result.labelPosition = this.labelPosition;
            if (this.animated) result.animated = this.animated;
            if (this.striped) result.striped = this.striped;
            if (this.borderRadius !== "rounded") result.borderRadius = this.borderRadius;

            return result;
        }

        // Update progress value dynamically (useful for interactive scenarios)
        updateValue(newValue) {
            this.value = newValue;
            if (this.renderedElement) {
                const fill = this.renderedElement.querySelector(".ac-progressbar-fill");
                const track = this.renderedElement.querySelector(".ac-progressbar-track");
                const label = this.renderedElement.querySelector(".ac-progressbar-label");

                if (fill && track) {
                    if (this.isIndeterminate()) {
                        fill.classList.add("ac-progressbar-indeterminate");
                        fill.style.width = "100%";
                        track.removeAttribute("aria-valuenow");
                        track.setAttribute("aria-label", "Loading...");
                    } else {
                        fill.classList.remove("ac-progressbar-indeterminate");
                        const percentage = this.getPercentage();
                        fill.style.width = `${percentage}%`;
                        track.setAttribute("aria-valuenow", this.value);
                        track.setAttribute("aria-label", `Progress: ${Math.round(percentage)}%`);

                        if (label) {
                            label.innerText = `${Math.round(percentage)}%`;
                        }
                    }
                }
            }
        }

        // Update max value dynamically
        updateMax(newMax) {
            if (newMax > 0) {
                this.max = newMax;
                if (this.renderedElement) {
                    const track = this.renderedElement.querySelector(".ac-progressbar-track");
                    if (track) {
                        track.setAttribute("aria-valuemax", this.max);
                    }
                    // Recalculate percentage with new max
                    this.updateValue(this.value);
                }
            }
        }

        // Accessibility support
        updateAriaAttributes() {
            const track = this.renderedElement?.querySelector(".ac-progressbar-track");
            if (!track) return;

            if (this.isIndeterminate()) {
                track.removeAttribute("aria-valuenow");
                track.setAttribute("aria-label", "Loading...");
            } else {
                const percentage = this.getPercentage();
                track.setAttribute("aria-valuenow", this.value);
                track.setAttribute("aria-label", `Progress: ${Math.round(percentage)}%`);
            }

            track.setAttribute("aria-valuemin", "0");
            track.setAttribute("aria-valuemax", this.max);
        }
    }

    // Register the element globally so AdaptiveCards recognizes "ProgressBar" in JSON
    AC.GlobalRegistry.elements.register("ProgressBar", ProgressBar);

})();
