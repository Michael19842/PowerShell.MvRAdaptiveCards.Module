(function () {
    const AC = AdaptiveCards;

    class Badge extends AC.CardElement {
        constructor() {
            super();
            this.text = "";
            this.color = "default"; // default|accent|good|warning|attention|neutral|brand
            this.icon = undefined; // Fluent UI icon name
            this.iconUrl = undefined;
            this.size = "small"; // extra-small|small|medium|large|extra-large
            this.appearance = "filled"; // filled|outline|ghost|subtle
            this.shape = "rounded"; // rounded|circular|square
            this.iconPosition = "start"; // start|end
            this.disabled = false;
            this.interactive = false;
            this.tooltip = undefined;
            this.badge = undefined; // nested badge support
            this.iconSize = undefined; // auto|small|medium|large
            this.textStyle = undefined; // normal|semibold|bold
        }

        // required: tell the framework this element's JSON type name
        getJsonTypeName() {
            return "Badge";
        }

        // parse JSON properties (called when card.parse is used)
        parse(source, errors) {
            super.parse(source, errors);
            if (source.text !== undefined) this.text = source.text;
            if (source.style !== undefined) this.style = source.style;
            if (source.color !== undefined) this.style = source.color;
            if (source.icon !== undefined) this.icon = source.icon;
            if (source.iconUrl !== undefined) this.iconUrl = source.iconUrl;
            if (source.size !== undefined) this.size = source.size;
            if (source.appearance !== undefined) this.appearance = source.appearance;
            if (source.shape !== undefined) this.shape = source.shape;
            if (source.iconPosition !== undefined) this.iconPosition = source.iconPosition;
            if (source.disabled !== undefined) this.disabled = source.disabled;
            if (source.interactive !== undefined) this.interactive = source.interactive;
            if (source.tooltip !== undefined) this.tooltip = source.tooltip;
            if (source.badge !== undefined) this.badge = source.badge;
            if (source.iconSize !== undefined) this.iconSize = source.iconSize;
            if (source.textStyle !== undefined) this.textStyle = source.textStyle;
        }

        // get schema definition
        getSchemaKey() {
            return "Badge";
        }

        // validation
        isValid() {
            return super.isValid() && (this.text || this.icon || this.iconUrl);
        }

        // called to render the element into a DOM node
        internalRender() {
            const wrapper = document.createElement("span");
            wrapper.className = "ac-badge";

            // Apply size
            wrapper.setAttribute("data-ac-badge-size", this.size);
            wrapper.classList.add(`ac-badge-size-${this.size}`);

            // Apply color
            wrapper.setAttribute("data-ac-badge-color", this.style);
            wrapper.classList.add(`ac-badge-style-${this.style}`);

            // Apply appearance
            wrapper.setAttribute("data-ac-badge-appearance", this.appearance);
            wrapper.classList.add(`ac-badge-appearance-${this.appearance}`);

            // Apply shape
            wrapper.setAttribute("data-ac-badge-shape", this.shape);
            wrapper.classList.add(`ac-badge-shape-${this.shape}`);

            // Apply states
            if (this.disabled) {
                wrapper.classList.add("ac-badge-disabled");
                wrapper.setAttribute("aria-disabled", "true");
            }

            if (this.interactive) {
                wrapper.classList.add("ac-badge-interactive");
                wrapper.setAttribute("role", "button");
                wrapper.setAttribute("tabindex", this.disabled ? "-1" : "0");

                // Add keyboard support for interactive badges
                wrapper.addEventListener("keydown", (e) => {
                    if (e.key === "Enter" || e.key === " ") {
                        e.preventDefault();
                        wrapper.click();
                    }
                });
            }

            // Apply tooltip
            if (this.tooltip) {
                wrapper.setAttribute("title", this.tooltip);
                wrapper.setAttribute("aria-label", this.tooltip);
            }

            // Create content container
            const content = document.createElement("span");
            content.className = "ac-badge-content";

            // Icon handling with position support (Fluent UI icon or iconUrl)
            if (this.icon || this.iconUrl) {
                const iconContainer = document.createElement("span");
                iconContainer.className = "ac-badge-icon-container";

                if (this.icon) {
                    // Use Fluent UI icon
                    this.renderFluentIcon(iconContainer);
                } else if (this.iconUrl) {
                    // Use iconUrl (legacy support)
                    const img = document.createElement("img");
                    img.className = "ac-badge-icon";
                    img.src = this.iconUrl;
                    img.alt = this.tooltip || this.text || "";

                    // Apply icon size if specified
                    if (this.iconSize) {
                        img.classList.add(`ac-badge-icon-size-${this.iconSize}`);
                    }

                    iconContainer.appendChild(img);
                }

                // Position icon based on iconPosition
                if (this.iconPosition === "end" && this.text) {
                    // Add text first, then icon
                    if (this.text) {
                        const txt = this.createTextElement();
                        content.appendChild(txt);
                    }
                    content.appendChild(iconContainer);
                } else {
                    // Default: icon first, then text (start position)
                    content.appendChild(iconContainer);
                    if (this.text) {
                        const txt = this.createTextElement();
                        content.appendChild(txt);
                    }
                }
            } else if (this.text) {
                // Text only
                const txt = this.createTextElement();
                content.appendChild(txt);
            }

            wrapper.appendChild(content);

            // Handle nested badge
            if (this.badge) {
                const nestedBadge = document.createElement("span");
                nestedBadge.className = "ac-badge-nested";
                nestedBadge.innerText = this.badge;
                wrapper.appendChild(nestedBadge);
            }

            // Apply host container styling
            if (this.hostConfig) {
                this.applyHostConfigStyles(wrapper);
            }

            return wrapper;
        }

        // Helper method to create text element
        createTextElement() {
            const txt = document.createElement("span");
            txt.className = "ac-badge-text";
            txt.innerText = this.text || "";

            // Apply text style if specified
            if (this.textStyle) {
                txt.classList.add(`ac-badge-text-${this.textStyle}`);
            }

            return txt;
        }

        // Convert icon name from PascalCase to snake_case for Fluent UI
        convertIconName(name) {
            return name
                .replace(/([A-Z])/g, '_$1')
                .toLowerCase()
                .substring(1);
        }

        // Render Fluent UI icon
        renderFluentIcon(container) {
            const iconName = this.convertIconName(this.icon);

            // Map badge sizes to icon sizes
            const sizeMap = {
                'extra-small': '12',
                'small': '16',
                'medium': '20',
                'large': '20',
                'extra-large': '24'
            };

            const size = sizeMap[this.size] || '16';
            const style = 'regular'; // Badges typically use regular style
            const url = `https://unpkg.com/@fluentui/svg-icons@1.1.222/icons/${iconName}_${size}_${style}.svg`;

            // Create a placeholder
            const iconSpan = document.createElement("span");
            iconSpan.className = "ac-badge-icon ac-badge-icon-fluent";
            iconSpan.innerHTML = `<span class="ac-badge-icon-loading">...</span>`;
            container.appendChild(iconSpan);

            // Load the SVG icon asynchronously
            fetch(url)
                .then(response => {
                    if (response.ok) {
                        return response.text();
                    }
                    throw new Error('Icon not found');
                })
                .then(svg => {
                    iconSpan.innerHTML = svg;
                    const svgElement = iconSpan.querySelector('svg');
                    if (svgElement) {
                        svgElement.classList.add('ac-badge-icon-svg');
                        svgElement.setAttribute('aria-hidden', 'true');
                        svgElement.setAttribute('focusable', 'false');

                        // Apply icon size if specified
                        if (this.iconSize) {
                            svgElement.classList.add(`ac-badge-icon-size-${this.iconSize}`);
                        }
                    }
                })
                .catch(error => {
                    console.warn(`Failed to load badge icon: ${iconName}`, error);
                    iconSpan.innerHTML = `<span class="ac-badge-icon-fallback">◯</span>`;
                });
        }

        // Apply host config styles
        applyHostConfigStyles(element) {
            // Apply any host config specific styling
            if (this.hostConfig && this.hostConfig.badge) {
                const badgeConfig = this.hostConfig.badge;

                if (badgeConfig.fontFamily) {
                    element.style.fontFamily = badgeConfig.fontFamily;
                }

                if (badgeConfig.fontSize) {
                    element.style.fontSize = badgeConfig.fontSize;
                }
            }
        }

        // Serialization support
        toJSON() {
            const result = super.toJSON();

            if (this.text) result.text = this.text;
            if (this.color !== "default") result.color = this.color;
            if (this.icon) result.icon = this.icon;
            if (this.iconUrl) result.iconUrl = this.iconUrl;
            if (this.size !== "small") result.size = this.size;
            if (this.appearance !== "filled") result.appearance = this.appearance;
            if (this.shape !== "rounded") result.shape = this.shape;
            if (this.iconPosition !== "start") result.iconPosition = this.iconPosition;
            if (this.disabled) result.disabled = this.disabled;
            if (this.interactive) result.interactive = this.interactive;
            if (this.tooltip) result.tooltip = this.tooltip;
            if (this.badge) result.badge = this.badge;
            if (this.iconSize) result.iconSize = this.iconSize;
            if (this.textStyle) result.textStyle = this.textStyle;

            return result;
        }

        // Accessibility support
        updateAriaAttributes() {
            const element = this.renderedElement;
            if (!element) return;

            if (this.tooltip) {
                element.setAttribute("aria-label", this.tooltip);
            } else if (this.text) {
                element.setAttribute("aria-label", this.text);
            }

            if (this.disabled) {
                element.setAttribute("aria-disabled", "true");
            }

            if (this.interactive) {
                element.setAttribute("role", "button");
                element.setAttribute("tabindex", this.disabled ? "-1" : "0");
            }
        }

        // Focus management for interactive badges
        focus() {
            if (this.renderedElement && this.interactive && !this.disabled) {
                this.renderedElement.focus();
            }
        }

        // Click handler setup
        setupClickHandler(onClick) {
            if (this.renderedElement && this.interactive && onClick) {
                this.renderedElement.addEventListener("click", (e) => {
                    if (!this.disabled) {
                        onClick(e, this);
                    }
                });
            }
        }
    }


    // register the element globally so AdaptiveCards recognizes "Badge" in JSON
    AC.AdaptiveCard.onProcessMarkdown = AC.AdaptiveCard.onProcessMarkdown || null;
    AC.GlobalRegistry.elements.register("Badge", Badge);

})();