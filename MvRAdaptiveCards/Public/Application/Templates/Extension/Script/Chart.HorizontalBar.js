(function () {
    const AC = AdaptiveCards;


    (function LoadChartJSLibrary() {
        return new Promise((resolve, reject) => {
            if (typeof Chart !== 'undefined') {
                resolve();
                return;
            }

            // Load Chart.js library
            const script = document.createElement("script");
            script.src = "https://cdn.jsdelivr.net/npm/chart.js";
            script.onload = () => {
                console.log("Chart.js library loaded");
                resolve();
            };
            script.onerror = () => {
                console.error("Failed to load Chart.js library");
                reject();
            };
            document.head.appendChild(script);
        });
    })();


    // Horizontal Bar Chart element

    class ChartHorizontalBar extends AC.CardElement {
        //#region Schema

        static get typeName() {
            return "Chart.HorizontalBar";
        }

        //#endregion

        //#region Properties

        title;
        xAxisTitle;
        yAxisTitle;
        color;
        colorSet = "categorical";
        displayMode = "AbsoluteWithAxis";
        data = [];

        //#endregion

        //#region Color Sets

        getColorPalette(colorSet) {
            const palettes = {
                categorical: [
                    '#0078D4', '#00CC6A', '#FFB900', '#E74856', '#8764B8',
                    '#00B7C3', '#038387', '#C239B3', '#FF8C00', '#00A4EF'
                ],
                sequential: [
                    '#E3F2FD', '#BBDEFB', '#90CAF9', '#64B5F6', '#42A5F5',
                    '#2196F3', '#1E88E5', '#1976D2', '#1565C0', '#0D47A1'
                ],
                diverging: [
                    '#D32F2F', '#F44336', '#E57373', '#FFCDD2', '#F5F5F5',
                    '#C5E1A5', '#9CCC65', '#7CB342', '#558B2F', '#33691E'
                ]
            };

            return palettes[colorSet] || palettes.categorical;
        }

        getColorValue(colorName) {
            const colorMap = {
                good: '#00CC6A',
                warning: '#FFB900',
                attention: '#E74856',
                neutral: '#808080',
                categoricalRed: '#E74856',
                categoricalPurple: '#8764B8',
                categoricalLavender: '#C7C3E0',
                categoricalBlue: '#0078D4',
                categoricalLightBlue: '#00B7C3',
                categoricalTeal: '#038387',
                categoricalGreen: '#00CC6A',
                categoricalLime: '#8CBF26',
                categoricalMarigold: '#FFB900',
                sequential1: '#E3F2FD',
                sequential2: '#BBDEFB',
                sequential3: '#90CAF9',
                sequential4: '#64B5F6',
                sequential5: '#42A5F5',
                sequential6: '#2196F3',
                sequential7: '#1E88E5',
                sequential8: '#1976D2',
                divergingBlue: '#0078D4',
                divergingLightBlue: '#00B7C3',
                divergingCyan: '#00FFFF',
                divergingTeal: '#038387',
                divergingYellow: '#FFB900',
                divergingPeach: '#FFAA44',
                divergingLightRed: '#FF6B6B',
                divergingRed: '#E74856',
                divergingMaroon: '#A4262C',
                divergingGray: '#808080'
            };

            return colorMap[colorName] || colorName;
        }

        //#endregion

        //#region Rendering

        internalRender() {
            if (!this.data || this.data.length === 0) {
                const errorDiv = document.createElement("div");
                errorDiv.className = "ac-chart-error";
                errorDiv.textContent = "No data available for chart";
                return errorDiv;
            }

            // Check if Chart.js is available
            if (typeof Chart === 'undefined') {
                const errorDiv = document.createElement("div");
                errorDiv.className = "ac-chart-error";
                errorDiv.textContent = "Chart.js library is required but not loaded";
                return errorDiv;
            }

            const container = document.createElement("div");
            container.className = "ac-chart-horizontalbar-container";

            // Add title if provided
            if (this.title) {
                const titleElement = document.createElement("div");
                titleElement.className = "ac-chart-title";
                titleElement.textContent = this.title;
                container.appendChild(titleElement);
            }

            // Create canvas wrapper for aspect ratio
            const canvasWrapper = document.createElement("div");
            canvasWrapper.className = "ac-chart-canvas-wrapper";

            // Create canvas element
            const canvas = document.createElement("canvas");
            canvas.className = "ac-chart-canvas";
            canvasWrapper.appendChild(canvas);
            container.appendChild(canvasWrapper);

            // Prepare chart data
            const labels = this.data.map(item => item.label || '');
            const values = this.data.map(item => item.value || 0);

            // Get colors - use custom colors if provided, otherwise use color palette
            let colors;
            if (this.color) {
                // Single color for all bars
                const colorValue = this.getColorValue(this.color);
                colors = values.map(() => colorValue);
            } else {
                // Use color palette or individual colors from data
                colors = this.data.map((item, index) => {
                    if (item.color) {
                        return this.getColorValue(item.color);
                    }
                    const palette = this.getColorPalette(this.colorSet);
                    return palette[index % palette.length];
                });
            }

            // Determine chart configuration based on displayMode
            const showAxes = this.displayMode !== 'AbsoluteNoAxis';
            const isPartToWhole = this.displayMode === 'PartToWhole';

            // Calculate total for PartToWhole mode
            let chartValues = values;
            if (isPartToWhole) {
                const total = values.reduce((a, b) => a + b, 0);
                chartValues = total > 0 ? values.map(v => (v / total) * 100) : values;
            }

            // Create the chart
            try {
                new Chart(canvas, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            data: chartValues,
                            backgroundColor: colors,
                            borderWidth: 0,
                            barThickness: 'flex',
                            maxBarThickness: 40,
                            borderRadius: 4
                        }]
                    },
                    options: {
                        indexAxis: 'y', // This makes it horizontal
                        responsive: true,
                        maintainAspectRatio: true,
                        aspectRatio: this.data.length > 5 ? 1.5 : 2,
                        plugins: {
                            legend: {
                                display: false
                            },
                            tooltip: {
                                enabled: true,
                                backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                titleFont: {
                                    size: 14,
                                    weight: 'bold'
                                },
                                bodyFont: {
                                    size: 13
                                },
                                padding: 12,
                                cornerRadius: 4,
                                displayColors: true,
                                callbacks: {
                                    label: (context) => {
                                        const label = context.label || '';
                                        const value = values[context.dataIndex];
                                        if (isPartToWhole) {
                                            const percentage = context.parsed.x.toFixed(1);
                                            return `${label}: ${value} (${percentage}%)`;
                                        }
                                        return `${label}: ${value}`;
                                    }
                                }
                            }
                        },
                        scales: {
                            x: {
                                display: showAxes,
                                beginAtZero: true,
                                grid: {
                                    display: showAxes,
                                    color: 'rgba(0, 0, 0, 0.1)'
                                },
                                ticks: {
                                    font: {
                                        size: 12,
                                        family: "'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif"
                                    },
                                    color: '#666666',
                                    callback: function (value) {
                                        if (isPartToWhole) {
                                            return value + '%';
                                        }
                                        return value;
                                    }
                                },
                                title: {
                                    display: showAxes && this.xAxisTitle ? true : false,
                                    text: this.xAxisTitle || '',
                                    font: {
                                        size: 13,
                                        weight: '600'
                                    },
                                    color: '#333333'
                                },
                                max: isPartToWhole ? 100 : undefined
                            },
                            y: {
                                display: showAxes,
                                grid: {
                                    display: false
                                },
                                ticks: {
                                    font: {
                                        size: 12,
                                        family: "'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif"
                                    },
                                    color: '#666666'
                                },
                                title: {
                                    display: showAxes && this.yAxisTitle ? true : false,
                                    text: this.yAxisTitle || '',
                                    font: {
                                        size: 13,
                                        weight: '600'
                                    },
                                    color: '#333333'
                                }
                            }
                        },
                        animation: {
                            duration: 750,
                            easing: 'easeOutQuart'
                        }
                    }
                });
            } catch (error) {
                console.error("Error creating horizontal bar chart:", error);
                const errorDiv = document.createElement("div");
                errorDiv.className = "ac-chart-error";
                errorDiv.textContent = "Error creating chart: " + error.message;
                return errorDiv;
            }

            return container;
        }

        //#endregion

        //#region Serialization

        getJsonTypeName() {
            return "Chart.HorizontalBar";
        }

        toJSON(target) {
            super.toJSON(target);

            if (this.title) {
                target.title = this.title;
            }

            if (this.xAxisTitle) {
                target.xAxisTitle = this.xAxisTitle;
            }

            if (this.yAxisTitle) {
                target.yAxisTitle = this.yAxisTitle;
            }

            if (this.color) {
                target.color = this.color;
            }

            if (this.colorSet && this.colorSet !== "categorical") {
                target.colorSet = this.colorSet;
            }

            if (this.displayMode && this.displayMode !== "AbsoluteWithAxis") {
                target.displayMode = this.displayMode;
            }

            if (this.data && this.data.length > 0) {
                target.data = this.data;
            }
        }

        parse(source, context) {
            super.parse(source, context);

            this.title = source["title"];
            this.xAxisTitle = source["xAxisTitle"];
            this.yAxisTitle = source["yAxisTitle"];
            this.color = source["color"];
            this.colorSet = source["colorSet"] || "categorical";
            this.displayMode = source["displayMode"] || "AbsoluteWithAxis";

            if (source["data"] && Array.isArray(source["data"])) {
                this.data = source["data"].map(item => ({
                    label: item.label || '',
                    value: typeof item.value === 'number' ? item.value : 0,
                    color: item.color || null
                }));
            }
        }

        //#endregion
    }

    // Register the custom element with Adaptive Cards
    AC.GlobalRegistry.elements.register(ChartHorizontalBar.typeName, ChartHorizontalBar);
})();
