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


    // Donut Chart element

    class ChartDonut extends AC.CardElement {
        //#region Schema

        static get typeName() {
            return "Chart.Donut";
        }

        //#endregion

        //#region Properties

        title;
        colorSet = "categorical";
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
            container.className = "ac-chart-donut-container";

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
            const colors = this.data.map((item, index) => {
                if (item.color) {
                    return item.color;
                }
                const palette = this.getColorPalette(this.colorSet);
                return palette[index % palette.length];
            });

            // Create the chart
            try {
                new Chart(canvas, {
                    type: 'doughnut',
                    data: {
                        labels: labels,
                        datasets: [{
                            data: values,
                            backgroundColor: colors,
                            borderWidth: 2,
                            borderColor: '#ffffff',
                            hoverOffset: 8,
                            hoverBorderWidth: 3
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: true,
                        aspectRatio: 2,
                        plugins: {
                            legend: {
                                display: true,
                                position: 'right',
                                align: 'center',
                                labels: {
                                    boxWidth: 15,
                                    padding: 10,
                                    font: {
                                        size: 12,
                                        family: "'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif"
                                    },
                                    color: '#333333',
                                    usePointStyle: true,
                                    pointStyle: 'circle'
                                }
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
                                    label: function (context) {
                                        const label = context.label || '';
                                        const value = context.parsed || 0;
                                        const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                        const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
                                        return `${label}: ${value} (${percentage}%)`;
                                    }
                                }
                            }
                        },
                        cutout: '60%', // This creates the donut hole
                        animation: {
                            animateRotate: true,
                            animateScale: true,
                            duration: 750,
                            easing: 'easeOutQuart'
                        }
                    }
                });
            } catch (error) {
                console.error("Error creating donut chart:", error);
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
            return "Chart.Donut";
        }

        toJSON(target) {
            super.toJSON(target);

            if (this.title) {
                target.title = this.title;
            }

            if (this.colorSet && this.colorSet !== "categorical") {
                target.colorSet = this.colorSet;
            }

            if (this.data && this.data.length > 0) {
                target.data = this.data;
            }
        }

        parse(source, context) {
            super.parse(source, context);

            this.title = source["title"];
            this.colorSet = source["colorSet"] || "categorical";

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
    AC.GlobalRegistry.elements.register(ChartDonut.typeName, ChartDonut);
})();