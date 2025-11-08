(function () {
    const AC = AdaptiveCards;

    // OpenUrlDialog Action handler
    class ActionOpenUrlDialog extends AC.Action {
        //#region Schema

        static get typeName() {
            return "Action.OpenUrlDialog";
        }

        //#endregion

        //#region Properties

        url;
        dialogTitle;
        dialogWidth;
        dialogHeight;

        //#endregion

        //#region Serialization

        getJsonTypeName() {
            return "Action.OpenUrlDialog";
        }

        toJSON(target) {
            super.toJSON(target);

            if (this.url) {
                target.url = this.url;
            }
            if (this.dialogTitle) {
                target.dialogTitle = this.dialogTitle;
            }
            if (this.dialogWidth) {
                target.dialogWidth = this.dialogWidth;
            }
            if (this.dialogHeight) {
                target.dialogHeight = this.dialogHeight;
            }
        }

        parse(source, context) {
            super.parse(source, context);

            this.url = source["url"];
            this.dialogTitle = source["dialogTitle"];
            this.dialogWidth = source["dialogWidth"] || "medium";
            this.dialogHeight = source["dialogHeight"] || "medium";
        }

        //#endregion

        //#region Helper Methods

        // Convert size keywords to pixel values
        getSizeInPixels(size, dimension) {
            const sizeMap = {
                small: dimension === 'width' ? '400px' : '300px',
                medium: dimension === 'width' ? '600px' : '450px',
                large: dimension === 'width' ? '800px' : '600px'
            };

            // If size ends with 'px', use it as-is
            if (typeof size === 'string' && size.endsWith('px')) {
                return size;
            }

            // Otherwise, look up in size map
            return sizeMap[size] || sizeMap.medium;
        }

        //#endregion

        //#region Execution

        execute() {
            if (!this.url) {
                console.warn("Action.OpenUrlDialog: No URL specified");
                return;
            }

            try {
                // Validate URL format
                const urlPattern = /^(https?:\/\/)|(mailto:)|(tel:)/i;
                if (!urlPattern.test(this.url)) {
                    console.warn("Action.OpenUrlDialog: Invalid URL format - must start with http://, https://, mailto:, or tel:");
                    return;
                }

                // Calculate dimensions
                const width = this.getSizeInPixels(this.dialogWidth, 'width');
                const height = this.getSizeInPixels(this.dialogHeight, 'height');

                console.log(`Opening URL in dialog: ${this.url} (${width} x ${height})`);

                // Create modal overlay
                const overlay = document.createElement('div');
                overlay.className = 'ac-dialog-overlay';

                // Create dialog container
                const dialog = document.createElement('div');
                dialog.className = 'ac-dialog-container';
                dialog.style.width = width;
                dialog.style.height = height;

                // Create dialog header
                const header = document.createElement('div');
                header.className = 'ac-dialog-header';

                const title = document.createElement('div');
                title.className = 'ac-dialog-title';
                title.textContent = this.dialogTitle || 'Dialog';

                const closeButton = document.createElement('button');
                closeButton.className = 'ac-dialog-close';
                closeButton.innerHTML = '×';
                closeButton.setAttribute('aria-label', 'Close dialog');
                closeButton.onclick = () => {
                    document.body.removeChild(overlay);
                };

                header.appendChild(title);
                header.appendChild(closeButton);

                // Create iframe for content
                const iframe = document.createElement('iframe');
                iframe.className = 'ac-dialog-iframe';
                iframe.src = this.url;
                iframe.setAttribute('sandbox', 'allow-scripts allow-same-origin allow-forms allow-popups');
                iframe.setAttribute('loading', 'lazy');

                // Create dialog body
                const body = document.createElement('div');
                body.className = 'ac-dialog-body';
                body.appendChild(iframe);

                // Assemble dialog
                dialog.appendChild(header);
                dialog.appendChild(body);
                overlay.appendChild(dialog);

                // Add to document
                document.body.appendChild(overlay);

                // Close on overlay click
                overlay.onclick = (e) => {
                    if (e.target === overlay) {
                        document.body.removeChild(overlay);
                    }
                };

                // Close on Escape key
                const escapeHandler = (e) => {
                    if (e.key === 'Escape') {
                        if (document.body.contains(overlay)) {
                            document.body.removeChild(overlay);
                        }
                        document.removeEventListener('keydown', escapeHandler);
                    }
                };
                document.addEventListener('keydown', escapeHandler);

                // Prevent body scroll when dialog is open
                document.body.style.overflow = 'hidden';

                // Restore body scroll when dialog is closed
                const observer = new MutationObserver((mutations) => {
                    mutations.forEach((mutation) => {
                        mutation.removedNodes.forEach((node) => {
                            if (node === overlay) {
                                document.body.style.overflow = '';
                                observer.disconnect();
                            }
                        });
                    });
                });
                observer.observe(document.body, { childList: true });

            } catch (error) {
                console.error("Action.OpenUrlDialog: Failed to open URL in dialog", error);
            }
        }

        //#endregion
    }

    // Register the action with Adaptive Cards
    AC.GlobalRegistry.actions.register(ActionOpenUrlDialog.typeName, ActionOpenUrlDialog);

    console.log("Action.OpenUrlDialog extension loaded");
})();
