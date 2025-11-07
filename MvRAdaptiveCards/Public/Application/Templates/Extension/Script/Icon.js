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

        // Get the SVG size and scale factor for the requested size
        // Fluent UI icons are typically available in: 20, 24
        // Some icons may have 16, 28, 32, 48 but not consistently
        // We'll use the most common sizes and scale as needed
        getSizeMapping(requestedSize) {
            const normalizedSize = requestedSize.toLowerCase().replace(/([a-z])([A-Z])/g, '$1$2').toLowerCase();

            const sizeMap = {
                'xxsmall': { svgSize: '20', targetSize: 12, scale: 0.6 },    // 12px - scale down 20px
                'xsmall': { svgSize: '20', targetSize: 16, scale: 0.8 },     // 16px - scale down 20px
                'small': { svgSize: '20', targetSize: 20, scale: 1.0 },      // 20px - exact match
                'standard': { svgSize: '24', targetSize: 24, scale: 1.0 },   // 24px - exact match
                'medium': { svgSize: '24', targetSize: 28, scale: 1.167 },   // 28px - scale up 24px
                'large': { svgSize: '24', targetSize: 32, scale: 1.333 },    // 32px - scale up 24px
                'xlarge': { svgSize: '24', targetSize: 40, scale: 1.667 },   // 40px - scale up 24px
                'xxlarge': { svgSize: '24', targetSize: 48, scale: 2.0 }     // 48px - scale up 24px
            };

            return sizeMap[normalizedSize] || sizeMap['standard'];
        }

        // Get the SVG icon URL from Fluent UI CDN
        getFluentIconUrl() {
            const iconName = this.convertIconName(this.name);
            const sizeMapping = this.getSizeMapping(this.size);
            const styleMap = {
                'regular': 'regular',
                'filled': 'filled'
            };

            const style = styleMap[this.style.toLowerCase()] || 'regular';
            const url = `https://unpkg.com/@fluentui/svg-icons@1.1.222/icons/${iconName}_${sizeMapping.svgSize}_${style}.svg`;

            console.log(`Icon URL: ${this.name} (size: ${this.size}) -> ${iconName}_${sizeMapping.svgSize}_${style}.svg (scale: ${sizeMapping.scale}x) = ${url}`);

            return { url, scale: sizeMapping.scale };
        }

        // called to render the element into a DOM node
        internalRender() {
            const wrapper = document.createElement("span");
            wrapper.className = "ac-icon";

            // Normalize size for CSS classes
            const normalizedSize = this.size.toLowerCase().replace(/([a-z])([A-Z])/g, '$1$2').toLowerCase();

            // Apply size class
            wrapper.setAttribute("data-ac-icon-size", normalizedSize);
            wrapper.classList.add(`ac-icon-size-${normalizedSize}`);

            // Apply color class
            wrapper.setAttribute("data-ac-icon-color", this.color.toLowerCase());
            wrapper.classList.add(`ac-icon-color-${this.color.toLowerCase()}`);

            // Apply style class
            wrapper.setAttribute("data-ac-icon-style", this.style.toLowerCase());
            wrapper.classList.add(`ac-icon-style-${this.style.toLowerCase()}`);

            // Create icon container
            const iconContainer = document.createElement("span");
            iconContainer.className = "ac-icon-svg-container";

            // Get icon URL and scale factor
            const { url, scale } = this.getFluentIconUrl();

            // Create img element pointing to Fluent UI CDN (avoids CORS issues)
            const img = document.createElement("img");
            img.className = "ac-icon-svg";
            img.src = url;
            img.alt = this.name;
            img.setAttribute('aria-hidden', 'true');
            img.setAttribute('focusable', 'false');

            // Apply scale if needed
            if (scale !== 1.0) {
                img.style.transform = `scale(${scale})`;
                img.style.transformOrigin = 'center';
                // Add a class to identify scaled icons
                img.classList.add('ac-icon-scaled');
            }

            // Handle load errors
            img.onerror = () => {
                const convertedName = this.convertIconName(this.name);
                console.error(`Failed to load icon: ${this.name} (${convertedName})`);
                iconContainer.innerHTML = `<span class="ac-icon-fallback" title="${this.name}">⚠</span>`;
            };

            iconContainer.appendChild(img);
            wrapper.appendChild(iconContainer);

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
