(function () {
    const AC = AdaptiveCards;

    class CompoundButton extends AC.CardElement {
        constructor() {
            super();
            this.title = "";
            this.description = "";
            this.icon = undefined;
            this.badge = undefined;
            this.selectAction = undefined;
        }

        // required: tell the framework this element's JSON type name
        getJsonTypeName() {
            return "CompoundButton";
        }

        // parse JSON properties (called when card.parse is used)
        parse(source, context) {
            super.parse(source, context);
            if (source.title !== undefined) this.title = source.title;
            if (source.description !== undefined) this.description = source.description;
            if (source.icon !== undefined) this.icon = source.icon;
            if (source.badge !== undefined) this.badge = source.badge;
            if (source.selectAction !== undefined) {
                console.log("CompoundButton: Parsing selectAction", source.selectAction);
                // Create action based on type
                const actionType = source.selectAction.type;
                if (actionType === "Action.Submit") {
                    this.selectAction = new AC.SubmitAction();
                } else if (actionType === "Action.OpenUrl") {
                    this.selectAction = new AC.OpenUrlAction();
                } else if (actionType === "Action.Execute") {
                    this.selectAction = new AC.ExecuteAction();
                } else if (actionType === "Action.ToggleVisibility") {
                    this.selectAction = new AC.ToggleVisibilityAction();
                }

                if (this.selectAction) {
                    this.selectAction.parse(source.selectAction, context);
                    this.selectAction.setParent(this);
                }
                console.log("CompoundButton: Parsed selectAction result", this.selectAction);
            }
        }

        // get schema definition
        getSchemaKey() {
            return "CompoundButton";
        }

        // validation
        isValid() {
            return super.isValid() && (this.title || this.description);
        }

        // called to render the element into a DOM node
        internalRender() {
            const button = document.createElement("button");
            button.className = "ac-compound-button";
            button.type = "button";

            // Make button keyboard accessible
            button.setAttribute("tabindex", "0");

            // Create button content container
            const contentContainer = document.createElement("div");
            contentContainer.className = "ac-compound-button-content";

            // Create left section (icon if present)
            if (this.icon) {
                const iconContainer = document.createElement("div");
                iconContainer.className = "ac-compound-button-icon";

                // Handle icon - could be an Icon element or simple name
                if (typeof this.icon === 'string') {
                    // Simple icon name
                    const iconElement = document.createElement("i");
                    iconElement.className = `ac-icon ac-icon-${this.icon}`;
                    iconContainer.appendChild(iconElement);
                } else if (this.icon.name) {
                    // Icon object with name property
                    const iconElement = document.createElement("i");
                    iconElement.className = `ac-icon ac-icon-${this.icon.name}`;
                    if (this.icon.color) {
                        iconElement.setAttribute("data-icon-color", this.icon.color);
                    }
                    if (this.icon.size) {
                        iconElement.setAttribute("data-icon-size", this.icon.size);
                    }
                    iconContainer.appendChild(iconElement);
                }

                contentContainer.appendChild(iconContainer);
            }

            // Create middle section (title and description)
            const textContainer = document.createElement("div");
            textContainer.className = "ac-compound-button-text";

            if (this.title) {
                const titleElement = document.createElement("div");
                titleElement.className = "ac-compound-button-title";
                titleElement.textContent = this.title;
                textContainer.appendChild(titleElement);
            }

            if (this.description) {
                const descElement = document.createElement("div");
                descElement.className = "ac-compound-button-description";
                descElement.textContent = this.description;
                textContainer.appendChild(descElement);
            }

            contentContainer.appendChild(textContainer);

            // Create right section (badge if present)
            if (this.badge) {
                const badgeContainer = document.createElement("div");
                badgeContainer.className = "ac-compound-button-badge";

                if (typeof this.badge === 'string' || typeof this.badge === 'number') {
                    // Simple text/number badge
                    const badgeElement = document.createElement("span");
                    badgeElement.className = "ac-badge ac-badge-small";
                    badgeElement.textContent = this.badge;
                    badgeContainer.appendChild(badgeElement);
                } else {
                    // Badge object - would need Badge element registered
                    const badgeElement = document.createElement("span");
                    badgeElement.className = "ac-badge ac-badge-small";
                    badgeElement.textContent = this.badge.text || this.badge.value || "";
                    badgeContainer.appendChild(badgeElement);
                }

                contentContainer.appendChild(badgeContainer);
            }

            button.appendChild(contentContainer);

            // Handle click action
            if (this.selectAction) {
                console.log("CompoundButton: Setting up click handler for action", this.selectAction);
                button.addEventListener("click", (e) => {
                    e.preventDefault();
                    e.stopPropagation();

                    console.log("CompoundButton: Button clicked, executing action", this.selectAction);
                    if (this.selectAction) {
                        this.selectAction.execute();
                    }
                });

                // Keyboard support
                button.addEventListener("keydown", (e) => {
                    if (e.key === "Enter" || e.key === " ") {
                        e.preventDefault();
                        button.click();
                    }
                });

                // Add visual feedback for interactive button
                button.classList.add("ac-compound-button-interactive");
            }

            // Add hover effects
            button.addEventListener("mouseenter", () => {
                button.classList.add("ac-compound-button-hover");
            });

            button.addEventListener("mouseleave", () => {
                button.classList.remove("ac-compound-button-hover");
            });

            // Add focus effects
            button.addEventListener("focus", () => {
                button.classList.add("ac-compound-button-focus");
            });

            button.addEventListener("blur", () => {
                button.classList.remove("ac-compound-button-focus");
            });

            return button;
        }
    }

    // Register the element with AdaptiveCards
    AC.GlobalRegistry.elements.register("CompoundButton", CompoundButton);

    console.log("CompoundButton element registered");
})();
