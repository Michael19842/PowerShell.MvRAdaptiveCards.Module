(function () {
    const AC = AdaptiveCards;

    // Extended Container class with layout support
    class ExtendedContainer extends AC.Container {
        constructor() {
            super();
            this.layouts = [];
        }

        parse(source, context) {
            super.parse(source, context);

            if (source.layouts && Array.isArray(source.layouts)) {
                this.layouts = source.layouts.map(layoutData => {
                    const layout = this.createLayout(layoutData);
                    if (layout) {
                        layout.parse(layoutData);
                    }
                    return layout;
                }).filter(l => l !== null);
            }
        }

        createLayout(layoutData) {
            if (!layoutData || !layoutData.type) {
                return null;
            }

            switch (layoutData.type) {
                case 'Layout.Flow':
                    return new LayoutFlow();
                case 'Layout.AreaGrid':
                    return new LayoutAreaGrid();
                case 'Layout.Stack':
                    return new LayoutStack();
                default:
                    console.warn('Unknown layout type:', layoutData.type);
                    return null;
            }
        }

        internalRender() {
            const containerElement = super.internalRender();

            if (this.layouts && this.layouts.length > 0) {
                // Apply the first matching layout based on current width
                const activeLayout = this.getActiveLayout();
                if (activeLayout) {
                    // The container element has a div that contains the items
                    // We need to apply the layout to that inner container
                    const itemsContainer = containerElement.querySelector('.ac-container-inner') || containerElement;
                    activeLayout.applyToContainer(itemsContainer, this);
                }
            }

            return containerElement;
        }

        getActiveLayout() {
            if (!this.layouts || this.layouts.length === 0) {
                return null;
            }

            // For now, return the first layout
            // In a full implementation, this would check targetWidth
            return this.layouts[0];
        }

        toJSON() {
            const result = super.toJSON();
            if (this.layouts && this.layouts.length > 0) {
                result.layouts = this.layouts.map(l => l.toJSON());
            }
            return result;
        }
    }

    // Layout.Flow implementation
    class LayoutFlow {
        constructor() {
            this.type = 'Layout.Flow';
            this.columnSpacing = 'Default';
            this.rowSpacing = 'Default';
            this.horizontalItemsAlignment = 'Center';
            this.verticalItemsAlignment = 'Top';
            this.itemFit = 'Fit';
            this.itemWidth = null;
            this.minItemWidth = null;
            this.maxItemWidth = null;
            this.targetWidth = null;
        }

        parse(source) {
            if (source.columnSpacing) this.columnSpacing = source.columnSpacing;
            if (source.rowSpacing) this.rowSpacing = source.rowSpacing;
            if (source.horizontalItemsAlignment) this.horizontalItemsAlignment = source.horizontalItemsAlignment;
            if (source.verticalItemsAlignment) this.verticalItemsAlignment = source.verticalItemsAlignment;
            if (source.itemFit) this.itemFit = source.itemFit;
            if (source.itemWidth) this.itemWidth = source.itemWidth;
            if (source.minItemWidth) this.minItemWidth = source.minItemWidth;
            if (source.maxItemWidth) this.maxItemWidth = source.maxItemWidth;
            if (source.targetWidth) this.targetWidth = source.targetWidth;
        }

        applyToContainer(containerElement, container) {
            // Add flow layout class
            containerElement.classList.add('ac-layout-flow');

            // Override any existing display and flex direction
            containerElement.style.display = 'flex';
            containerElement.style.flexDirection = 'row'; // Explicitly set to row
            containerElement.style.flexWrap = 'wrap';

            // Apply alignment
            const alignmentMap = {
                'Left': 'flex-start',
                'Center': 'center',
                'Right': 'flex-end'
            };
            containerElement.style.justifyContent = alignmentMap[this.horizontalItemsAlignment] || 'center';

            const verticalAlignmentMap = {
                'Top': 'flex-start',
                'Center': 'center',
                'Bottom': 'flex-end'
            };
            containerElement.style.alignItems = verticalAlignmentMap[this.verticalItemsAlignment] || 'flex-start';

            // Apply spacing
            const spacingMap = {
                'None': '0px',
                'ExtraSmall': '4px',
                'Small': '8px',
                'Default': '12px',
                'Medium': '16px',
                'Large': '24px',
                'ExtraLarge': '32px',
                'Padding': '16px'
            };

            const colGap = spacingMap[this.columnSpacing] || '12px';
            const rowGap = spacingMap[this.rowSpacing] || '12px';
            containerElement.style.gap = `${rowGap} ${colGap}`;

            // Apply item sizing to children
            const children = containerElement.querySelectorAll(':scope > *');
            children.forEach(child => {
                if (this.itemWidth) {
                    child.style.width = this.itemWidth;
                    child.style.flexGrow = '0';
                    child.style.flexShrink = '0';
                } else {
                    if (this.minItemWidth) {
                        child.style.minWidth = this.minItemWidth;
                    }
                    if (this.maxItemWidth) {
                        child.style.maxWidth = this.maxItemWidth;
                    }
                    if (this.itemFit === 'Fill') {
                        child.style.flexGrow = '1';
                    }
                }
            });
        } toJSON() {
            const result = { type: this.type };
            if (this.columnSpacing !== 'Default') result.columnSpacing = this.columnSpacing;
            if (this.rowSpacing !== 'Default') result.rowSpacing = this.rowSpacing;
            if (this.horizontalItemsAlignment !== 'Center') result.horizontalItemsAlignment = this.horizontalItemsAlignment;
            if (this.verticalItemsAlignment !== 'Top') result.verticalItemsAlignment = this.verticalItemsAlignment;
            if (this.itemFit !== 'Fit') result.itemFit = this.itemFit;
            if (this.itemWidth) result.itemWidth = this.itemWidth;
            if (this.minItemWidth) result.minItemWidth = this.minItemWidth;
            if (this.maxItemWidth) result.maxItemWidth = this.maxItemWidth;
            if (this.targetWidth) result.targetWidth = this.targetWidth;
            return result;
        }
    }

    // Layout.AreaGrid implementation
    class LayoutAreaGrid {
        constructor() {
            this.type = 'Layout.AreaGrid';
            this.areas = [];
            this.columns = [];
            this.columnSpacing = 'Default';
            this.rowSpacing = 'Default';
            this.targetWidth = null;
        }

        parse(source) {
            if (source.areas) this.areas = source.areas;
            if (source.columns) this.columns = source.columns;
            if (source.columnSpacing) this.columnSpacing = source.columnSpacing;
            if (source.rowSpacing) this.rowSpacing = source.rowSpacing;
            if (source.targetWidth) this.targetWidth = source.targetWidth;
        }

        applyToContainer(containerElement, container) {
            // Add grid layout class
            containerElement.classList.add('ac-layout-areagrid');

            // Apply CSS Grid
            containerElement.style.display = 'grid';

            // Apply columns
            if (this.columns && this.columns.length > 0) {
                const columnTemplate = this.columns.map(col => {
                    if (typeof col === 'number') {
                        return `${col}%`;
                    }
                    return col;
                }).join(' ');
                containerElement.style.gridTemplateColumns = columnTemplate;
            }

            // Apply spacing
            const spacingMap = {
                'None': '0px',
                'ExtraSmall': '4px',
                'Small': '8px',
                'Default': '12px',
                'Medium': '16px',
                'Large': '24px',
                'ExtraLarge': '32px',
                'Padding': '16px'
            };

            const colGap = spacingMap[this.columnSpacing] || '12px';
            const rowGap = spacingMap[this.rowSpacing] || '12px';
            containerElement.style.columnGap = colGap;
            containerElement.style.rowGap = rowGap;

            // Apply grid areas to children
            if (this.areas && this.areas.length > 0) {
                const children = container.getItemAt ?
                    Array.from({ length: container.getItemCount() }, (_, i) => container.getItemAt(i)) :
                    [];

                children.forEach((item, index) => {
                    if (item['grid.area'] || (item._parent && item._parent['grid.area'])) {
                        const areaName = item['grid.area'] || item._parent['grid.area'];
                        const area = this.areas.find(a => a.name === areaName);

                        if (area) {
                            const childElement = containerElement.children[index];
                            if (childElement) {
                                const row = area.row || 1;
                                const column = area.column || 1;
                                const rowSpan = area.rowSpan || 1;
                                const columnSpan = area.columnSpan || 1;

                                childElement.style.gridRow = `${row} / span ${rowSpan}`;
                                childElement.style.gridColumn = `${column} / span ${columnSpan}`;
                            }
                        }
                    }
                });
            }
        }

        toJSON() {
            const result = { type: this.type };
            if (this.areas && this.areas.length > 0) result.areas = this.areas;
            if (this.columns && this.columns.length > 0) result.columns = this.columns;
            if (this.columnSpacing !== 'Default') result.columnSpacing = this.columnSpacing;
            if (this.rowSpacing !== 'Default') result.rowSpacing = this.rowSpacing;
            if (this.targetWidth) result.targetWidth = this.targetWidth;
            return result;
        }
    }

    // Layout.Stack implementation
    class LayoutStack {
        constructor() {
            this.type = 'Layout.Stack';
            this.spacing = 'Default';
            this.targetWidth = null;
        }

        parse(source) {
            if (source.spacing) this.spacing = source.spacing;
            if (source.targetWidth) this.targetWidth = source.targetWidth;
        }

        applyToContainer(containerElement, container) {
            // Add stack layout class
            containerElement.classList.add('ac-layout-stack');

            // Apply vertical stacking
            containerElement.style.display = 'flex';
            containerElement.style.flexDirection = 'column';

            // Apply spacing
            const spacingMap = {
                'None': '0px',
                'ExtraSmall': '4px',
                'Small': '8px',
                'Default': '12px',
                'Medium': '16px',
                'Large': '24px',
                'ExtraLarge': '32px',
                'Padding': '16px'
            };

            const gap = spacingMap[this.spacing] || '12px';
            containerElement.style.gap = gap;
        }

        toJSON() {
            const result = { type: this.type };
            if (this.spacing !== 'Default') result.spacing = this.spacing;
            if (this.targetWidth) result.targetWidth = this.targetWidth;
            return result;
        }
    }

    // Register the extended Container
    AC.GlobalRegistry.elements.unregister("Container");
    AC.GlobalRegistry.elements.register("Container", ExtendedContainer);

    // Expose for debugging
    if (typeof window !== 'undefined') {
        window.LayoutExtensions = {
            ExtendedContainer,
            LayoutFlow,
            LayoutAreaGrid,
            LayoutStack
        };
    }

    console.log('Container Layouts extension loaded successfully');

})();
