(function () {
    const AC = AdaptiveCards;

    class Icon extends AC.CardElement {
        constructor() {
            super();
            this.name = "";
            this.color = "default";
            this.size = "standard";
            this.style = "regular"; // regular or filled
        }

        // required: tell the framework this element's JSON type name
        getJsonTypeName() {
            return "Icon";
        }

        // parse JSON properties
        parse(source, errors) {
            super.parse(source, errors);
            if (source.name !== undefined) this.name = source.name;
            if (source.color !== undefined) this.color = source.color;
            if (source.size !== undefined) this.size = source.size;
            if (source.style !== undefined) this.style = source.style;
        }

        // get schema definition
        getSchemaKey() {
            return "Icon";
        }

        // validation
        isValid() {
            return super.isValid() && this.name;
        }

        // Convert icon name from PascalCase to snake_case for Fluent UI
        convertIconName(name) {
            // Convert PascalCase to snake_case and lowercase
            return name
                .replace(/([A-Z])/g, '_$1')
                .toLowerCase()
                .substring(1); // remove leading underscore
        }

        // Get the SVG icon from Fluent UI CDN
        async loadFluentIcon() {
            const iconName = this.convertIconName(this.name);
            const sizeMap = {
                'xxsmall': '12',
                'xsmall': '16',
                'small': '20',
                'standard': '24',
                'medium': '28',
                'large': '32',
                'xlarge': '48',
                'xxlarge': '48'
            };
            const styleMap = {
                'regular': 'regular',
                'filled': 'filled'
            };

            const size = sizeMap[this.size.toLowerCase()] || '24';
            const style = styleMap[this.style.toLowerCase()] || 'regular';
            const url = `https://unpkg.com/@fluentui/svg-icons@1.1.222/icons/${iconName}_${size}_${style}.svg`;

            try {
                const response = await fetch(url);
                if (response.ok) {
                    return await response.text();
                }
            } catch (error) {
                console.warn(`Failed to load icon: ${iconName}`, error);
            }
            return null;
        }

        // called to render the element into a DOM node
        internalRender() {
            const wrapper = document.createElement("span");
            wrapper.className = "ac-icon";

            // Apply size class
            wrapper.setAttribute("data-ac-icon-size", this.size.toLowerCase());
            wrapper.classList.add(`ac-icon-size-${this.size.toLowerCase()}`);

            // Apply color class
            wrapper.setAttribute("data-ac-icon-color", this.color.toLowerCase());
            wrapper.classList.add(`ac-icon-color-${this.color.toLowerCase()}`);

            // Apply style class
            wrapper.setAttribute("data-ac-icon-style", this.style.toLowerCase());
            wrapper.classList.add(`ac-icon-style-${this.style.toLowerCase()}`);

            // Create icon container
            const iconContainer = document.createElement("span");
            iconContainer.className = "ac-icon-svg-container";
            iconContainer.innerHTML = `<span class="ac-icon-loading">Loading...</span>`;

            wrapper.appendChild(iconContainer);

            // Load the SVG icon asynchronously
            this.loadFluentIcon().then(svg => {
                if (svg) {
                    iconContainer.innerHTML = svg;
                    const svgElement = iconContainer.querySelector('svg');
                    if (svgElement) {
                        svgElement.classList.add('ac-icon-svg');
                        svgElement.setAttribute('aria-hidden', 'true');
                        svgElement.setAttribute('focusable', 'false');
                    }
                } else {
                    // Fallback if icon cannot be loaded
                    iconContainer.innerHTML = `<span class="ac-icon-fallback" title="${this.name}">◯</span>`;
                }
            }).catch(error => {
                console.error('Error rendering icon:', error);
                iconContainer.innerHTML = `<span class="ac-icon-fallback" title="${this.name}">◯</span>`;
            });

            return wrapper;
        }

        // Serialization support
        toJSON() {
            const result = super.toJSON();

            if (this.name) result.name = this.name;
            if (this.color !== "default") result.color = this.color;
            if (this.size !== "standard") result.size = this.size;
            if (this.style !== "regular") result.style = this.style;

            return result;
        }
    }

    // register the element globally so AdaptiveCards recognizes "Icon" in JSON
    AC.GlobalRegistry.elements.register("Icon", Icon);

})();
