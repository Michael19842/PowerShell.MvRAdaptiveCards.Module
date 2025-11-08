(function () {
    const AC = AdaptiveCards;

    // OpenUrl Action handler
    class ActionOpenUrl extends AC.Action {
        //#region Schema

        static get typeName() {
            return "Action.OpenUrl";
        }

        //#endregion

        //#region Properties

        url;

        //#endregion

        //#region Serialization

        getJsonTypeName() {
            return "Action.OpenUrl";
        }

        toJSON(target) {
            super.toJSON(target);

            if (this.url) {
                target.url = this.url;
            }
        }

        parse(source, context) {
            super.parse(source, context);

            this.url = source["url"];
        }

        //#endregion

        //#region Execution

        execute() {
            if (!this.url) {
                console.warn("Action.OpenUrl: No URL specified");
                return;
            }

            try {
                // Validate URL format
                const urlPattern = /^(https?:\/\/)|(mailto:)|(tel:)/i;
                if (!urlPattern.test(this.url)) {
                    console.warn("Action.OpenUrl: Invalid URL format - must start with http://, https://, mailto:, or tel:");
                    return;
                }

                // Open URL in new window/tab
                console.log("Opening URL:", this.url);
                window.open(this.url, '_blank', 'noopener,noreferrer');
            } catch (error) {
                console.error("Action.OpenUrl: Failed to open URL", error);
            }
        }

        //#endregion
    }

    // Register the action with Adaptive Cards
    AC.GlobalRegistry.actions.register(ActionOpenUrl.typeName, ActionOpenUrl);

    console.log("Action.OpenUrl extension loaded");
})();
