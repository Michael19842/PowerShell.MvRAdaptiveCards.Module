(function () {
    const AC = AdaptiveCards;

    // Popover Action handler
    class ActionPopover extends AC.Action {
        //#region Schema

        static get typeName() {
            return "Action.Popover";
        }

        //#endregion

        //#region Properties

        card;

        //#endregion

        //#region Serialization

        getJsonTypeName() {
            return "Action.Popover";
        }

        toJSON(target) {
            super.toJSON(target);

            if (this.card) {
                target.card = this.card;
            }
        }

        parse(source, context) {
            super.parse(source, context);

            this.card = source["card"];
        }

        //#endregion

        //#region Execution

        execute() {
            if (!this.card) {
                console.warn("Action.Popover: No card content specified");
                return;
            }

            try {
                this.showPopover();
            } catch (error) {
                console.error("Action.Popover: Failed to show popover", error);
            }
        }

        showPopover() {
            // Create popover overlay
            const overlay = this.createOverlay();

            // Create popover container
            const popoverContainer = this.createPopoverContainer();

            // Create close button
            const closeButton = this.createCloseButton(overlay);

            // Create card content
            const cardContent = this.createCardContent();

            // Assemble popover
            const popoverHeader = document.createElement('div');
            popoverHeader.className = 'ac-popover-header';
            popoverHeader.appendChild(closeButton);

            popoverContainer.appendChild(popoverHeader);
            popoverContainer.appendChild(cardContent);
            overlay.appendChild(popoverContainer);

            // Add to DOM
            document.body.appendChild(overlay);

            // Add event listeners
            this.addEventListeners(overlay, popoverContainer);

            // Show with animation
            requestAnimationFrame(() => {
                overlay.classList.add('ac-popover-show');
                popoverContainer.classList.add('ac-popover-show');
            });

            console.log("Action.Popover: Popover displayed");

            // Debug: Log popover structure
            setTimeout(() => {
                console.log("Action.Popover: Final popover structure:", {
                    overlay: overlay,
                    container: popoverContainer,
                    content: cardContent,
                    contentChildren: cardContent.children.length,
                    containerDimensions: {
                        width: popoverContainer.offsetWidth,
                        height: popoverContainer.offsetHeight
                    }
                });
            }, 100);
        }

        createOverlay() {
            const overlay = document.createElement('div');
            overlay.className = 'ac-popover-overlay';
            return overlay;
        }

        createPopoverContainer() {
            const container = document.createElement('div');
            container.className = 'ac-popover-container';
            return container;
        }

        createCloseButton(overlay) {
            const closeButton = document.createElement('button');
            closeButton.innerHTML = '&times;';
            closeButton.className = 'ac-popover-close';
            closeButton.setAttribute('aria-label', 'Close popover');
            closeButton.setAttribute('type', 'button');

            closeButton.addEventListener('click', (e) => {
                e.stopPropagation();
                this.closePopover(overlay);
            });

            return closeButton;
        }

        createCardContent() {
            const cardContainer = document.createElement('div');
            cardContainer.className = 'ac-popover-content';

            try {
                console.log("Action.Popover: Card content to render:", this.card);

                // Ensure we have card content
                if (!this.card) {
                    throw new Error("No card content provided");
                }

                // Create a new Adaptive Card instance for the popover content
                const adaptiveCard = new AC.AdaptiveCard();

                // Set up host configuration - try to use existing config or use default
                try {
                    if (window.adaptiveCardHostConfig) {
                        console.log("Action.Popover: Using existing host config");
                        adaptiveCard.hostConfig = window.adaptiveCardHostConfig;
                    } else if (AC.defaultHostConfig) {
                        console.log("Action.Popover: Using default host config");
                        adaptiveCard.hostConfig = AC.defaultHostConfig;
                    } else {
                        console.log("Action.Popover: Creating basic host config");
                        // Use minimal host config to avoid errors
                        const hostConfig = new AC.HostConfig();
                        adaptiveCard.hostConfig = hostConfig;
                    }
                } catch (configError) {
                    console.warn("Action.Popover: Error setting host config, using default:", configError);
                    // Don't set any host config, let it use the default
                }

                // Parse the card content
                console.log("Action.Popover: Parsing card content...");

                // Check if the card content needs to be wrapped in an AdaptiveCard structure
                let cardData = this.card;
                if (cardData.type && cardData.type !== "AdaptiveCard") {
                    // Wrap the content in a proper AdaptiveCard structure
                    console.log("Action.Popover: Wrapping content in AdaptiveCard structure");
                    cardData = {
                        type: "AdaptiveCard",
                        version: "1.5",
                        body: [cardData]
                    };
                }

                console.log("Action.Popover: Final card data to parse:", cardData);
                adaptiveCard.parse(cardData);

                // Render the card
                console.log("Action.Popover: Rendering card...");
                const renderedCard = adaptiveCard.render();

                if (renderedCard) {
                    console.log("Action.Popover: Card rendered successfully:", renderedCard);
                    cardContainer.appendChild(renderedCard);

                    // Add some debug info
                    console.log("Action.Popover: Container has children:", cardContainer.children.length);
                    console.log("Action.Popover: Rendered card dimensions:", {
                        width: renderedCard.offsetWidth,
                        height: renderedCard.offsetHeight
                    });
                } else {
                    throw new Error("Failed to render card content - render() returned null");
                }

            } catch (error) {
                console.error("Action.Popover: Error rendering card content", error);
                console.error("Action.Popover: Card data was:", this.card);

                // Create detailed fallback content
                const errorContainer = document.createElement('div');
                errorContainer.className = 'ac-popover-error';

                const errorTitle = document.createElement('h3');
                errorTitle.textContent = 'Error loading popover content';
                errorTitle.style.margin = '0 0 10px 0';

                const errorDetails = document.createElement('div');
                errorDetails.textContent = error.message;
                errorDetails.style.fontSize = '12px';
                errorDetails.style.color = '#666';

                const cardInfo = document.createElement('pre');
                cardInfo.textContent = JSON.stringify(this.card, null, 2);
                cardInfo.style.cssText = `
                    font-size: 10px;
                    background: #f5f5f5;
                    padding: 10px;
                    border-radius: 4px;
                    overflow: auto;
                    max-height: 200px;
                    margin-top: 10px;
                `;

                errorContainer.appendChild(errorTitle);
                errorContainer.appendChild(errorDetails);
                errorContainer.appendChild(cardInfo);
                cardContainer.appendChild(errorContainer);
            }

            return cardContainer;
        }

        addEventListeners(overlay, popoverContainer) {
            // Close on overlay click (but not on popover content click)
            overlay.addEventListener('click', (e) => {
                if (e.target === overlay) {
                    this.closePopover(overlay);
                }
            });

            // Prevent closing when clicking inside the popover
            popoverContainer.addEventListener('click', (e) => {
                e.stopPropagation();
            });

            // Close on Escape key
            const handleKeyDown = (e) => {
                if (e.key === 'Escape') {
                    this.closePopover(overlay);
                    document.removeEventListener('keydown', handleKeyDown);
                }
            };
            document.addEventListener('keydown', handleKeyDown);

            // Store the event handler for cleanup
            overlay._keydownHandler = handleKeyDown;
        }

        closePopover(overlay) {
            // Add closing animation
            overlay.style.opacity = '0';
            const container = overlay.querySelector('.ac-popover-container');
            if (container) {
                container.style.transform = 'scale(0.8)';
            }

            // Remove from DOM after animation
            setTimeout(() => {
                if (overlay && overlay.parentNode) {
                    // Clean up event listener
                    if (overlay._keydownHandler) {
                        document.removeEventListener('keydown', overlay._keydownHandler);
                    }
                    overlay.parentNode.removeChild(overlay);
                }
            }, 300);

            console.log("Action.Popover: Popover closed");
        }

        //#endregion
    }

    // Load CSS file for popover styles
    function loadPopoverCSS() {
        // Check if CSS is already loaded
        if (document.querySelector('#ac-popover-styles')) {
            return;
        }

        // Try to find the CSS file relative to the script location
        const scripts = document.getElementsByTagName('script');
        let cssPath = null;

        for (let script of scripts) {
            if (script.src && script.src.includes('Action.Popover.js')) {
                cssPath = script.src.replace('/Script/Action.Popover.js', '/Style/Action.Popover.css');
                break;
            }
        }

        // Fallback: assume CSS is in the same directory structure
        if (!cssPath) {
            const currentScript = document.currentScript || scripts[scripts.length - 1];
            if (currentScript && currentScript.src) {
                cssPath = currentScript.src.replace('/Script/Action.Popover.js', '/Style/Action.Popover.css');
            }
        }

        // Create and append link element
        const link = document.createElement('link');
        link.id = 'ac-popover-styles';
        link.rel = 'stylesheet';
        link.type = 'text/css';

        if (cssPath) {
            link.href = cssPath;
        } else {
            // Fallback: try relative path
            link.href = '../Style/Action.Popover.css';
        }

        link.onerror = function () {
            console.warn('Action.Popover: Could not load CSS file. Popover may not display correctly.');
        };

        document.head.appendChild(link);
    }

    // Load the CSS
    loadPopoverCSS();

    // Register the action with Adaptive Cards
    AC.GlobalRegistry.actions.register(ActionPopover.typeName, ActionPopover);

    console.log("Action.Popover extension loaded");
})();