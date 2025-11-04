(function () {
    const AC = AdaptiveCards;

    // Load Chart.js library if not already loaded
    (function LoadChartJSLibrary() {
        return new Promise((resolve, reject) => {
            if (typeof Chart !== 'undefined') {
                resolve();
                return;
            }

            const script = document.createElement("script");
            script.src = "https://cdn.jsdelivr.net/npm/chart.js";
            script.onload = () => {
                console.log("Chart.js library loaded for Chart.Gauge");
                resolve();
            };
            script.onerror = () => {
                console.error("Failed to load Chart.js library");
                reject();
            };
            document.head.appendChild(script);
        });
    })();

    class ChartGauge extends AC.CardElement {
        constructor() {
            super();
            this.value = 0;
            this.min = 0;
            this.max = 100;
            this.title = undefined;
            this.subLabel = undefined;
            this.valueFormat = "percentage";
            this.segments = undefined;
            this.showLegend = true;
            this.showMinMax = true;
            this.colorSet = "categorical";
            this._chart = undefined;
        }

        getJsonTypeName() {
            return "Chart.Gauge";
        }

        parse(source, context) {
            super.parse(source, context);
            if (source.value !== undefined) this.value = source.value;
            if (source.min !== undefined) this.min = source.min;
            if (source.max !== undefined) this.max = source.max;
            if (source.title !== undefined) this.title = source.title;
            if (source.subLabel !== undefined) this.subLabel = source.subLabel;
            if (source.valueFormat !== undefined) this.valueFormat = source.valueFormat.toLowerCase();
            if (source.segments !== undefined) this.segments = source.segments;
            if (source.showLegend !== undefined) this.showLegend = source.showLegend;
            if (source.showMinMax !== undefined) this.showMinMax = source.showMinMax;
            if (source.colorSet !== undefined) this.colorSet = source.colorSet.toLowerCase();
        }

        getColorPalette(colorSet) {
            const palettes = {
                categorical: ['#0078D4', '#8764B8', '#00CC6A', '#FFB900', '#D13438'],
                sequential: ['#E6F2FF', '#B3D9FF', '#80BFFF', '#4DA6FF', '#1A8CFF', '#0078D4', '#0063B1', '#004F8F'],
                diverging: ['#D13438', '#E74856', '#F6757A', '#FAA0A4', '#FCCCCF', '#F5F5F5', '#B3E6D0', '#66D4A8', '#00CC6A']
            };
            return palettes[colorSet] || palettes.categorical;
        }

        resolveColor(colorName) {
            const colorMap = {
                'good': '#00CC6A', 'warning': '#FFB900', 'attention': '#D13438', 'neutral': '#8A8886',
                'categoricalRed': '#D13438', 'categoricalPurple': '#8764B8', 'categoricalBlue': '#0078D4',
                'categoricalGreen': '#00CC6A', 'categoricalLime': '#498205', 'categoricalMarigold': '#FFB900',
                'sequential1': '#E6F2FF', 'sequential2': '#B3D9FF', 'sequential3': '#80BFFF', 'sequential4': '#4DA6FF',
                'divergingRed': '#D13438', 'divergingYellow': '#FFB900', 'divergingGray': '#8A8886'
            };
            return colorMap[colorName] || colorName;
        }

        getSegmentColor(value) {
            const percentage = ((value - this.min) / (this.max - this.min)) * 100;
            const palette = this.getColorPalette(this.colorSet);

            if (this.colorSet === 'sequential') {
                const colorIndex = Math.floor((percentage / 100) * (palette.length - 1));
                return palette[colorIndex];
            } else if (this.colorSet === 'diverging') {
                if (percentage < 33) return palette[0];
                if (percentage < 66) return palette[5];
                return palette[8];
            } else {
                if (percentage < 33) return palette[4];
                if (percentage < 66) return palette[3];
                return palette[2];
            }
        }

        _lightenColor(color, amount) {
            if (!color) return color;
            const hexMatch = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(color.trim());
            if (!hexMatch) {
                return color;
            }

            const toComponent = (value) => parseInt(value, 16);
            const r = toComponent(hexMatch[1]);
            const g = toComponent(hexMatch[2]);
            const b = toComponent(hexMatch[3]);

            const lighten = (channel) => {
                const target = 255;
                const diff = target - channel;
                return Math.max(0, Math.min(255, Math.round(channel + diff * amount)));
            };

            const lr = lighten(r);
            const lg = lighten(g);
            const lb = lighten(b);

            const toHex = (channel) => channel.toString(16).padStart(2, '0');
            return `#${toHex(lr)}${toHex(lg)}${toHex(lb)}`;
        }

        _compileSegments() {
            if (!Array.isArray(this.segments) || this.segments.length === 0) {
                return null;
            }

            const totalRange = this.max - this.min;
            const safeRange = totalRange === 0 ? 1 : totalRange;
            const toFraction = (value) => (value - this.min) / safeRange;
            const clamp = (fraction) => Math.max(0, Math.min(1, fraction));

            const usesSize = this.segments.some(segment => segment.size !== undefined && segment.size !== null);
            const compiled = [];

            if (usesSize) {
                let cumulative = this.min;
                this.segments.forEach(segment => {
                    const segmentSize = Number(segment.size) || 0;
                    const segmentStart = cumulative;
                    const segmentEnd = cumulative + segmentSize;
                    cumulative = segmentEnd;

                    const startFraction = clamp(toFraction(segmentStart));
                    const endFraction = clamp(toFraction(segmentEnd));

                    if (endFraction <= startFraction) {
                        return;
                    }

                    compiled.push({
                        startFraction,
                        endFraction,
                        color: this.resolveColor(segment.color) || segment.color,
                        label: segment.legend || segment.label || '',
                        min: segmentStart,
                        max: segmentEnd
                    });
                });
            } else {
                this.segments.forEach(segment => {
                    const rawMin = segment.min !== undefined ? segment.min : this.min;
                    const rawMax = segment.max !== undefined ? segment.max : rawMin;
                    const startValue = Math.max(this.min, rawMin);
                    const endValue = Math.min(this.max, rawMax);

                    const startFraction = clamp(toFraction(startValue));
                    const endFraction = clamp(toFraction(endValue));

                    if (endFraction <= startFraction) {
                        return;
                    }

                    compiled.push({
                        startFraction,
                        endFraction,
                        color: this.resolveColor(segment.color) || segment.color,
                        label: segment.legend || segment.label || '',
                        min: startValue,
                        max: endValue
                    });
                });
            }

            return compiled.length > 0 ? compiled : null;
        }

        formatValue(value) {
            if (this.valueFormat === "fraction") {
                return `${value}/${this.max}`;
            }
            const percentage = ((value - this.min) / (this.max - this.min)) * 100;
            return `${Math.round(percentage)}%`;
        }

        internalRender() {
            const container = document.createElement("div");
            container.className = "ac-chart-gauge-container";

            if (this.title) {
                const titleElement = document.createElement("div");
                titleElement.className = "ac-chart-gauge-title";
                titleElement.textContent = this.title;
                container.appendChild(titleElement);
            }

            const canvasWrapper = document.createElement("div");
            canvasWrapper.className = "ac-chart-gauge-canvas-wrapper";
            canvasWrapper.style.position = "relative";

            const canvas = document.createElement("canvas");
            canvas.className = "ac-chart-gauge-canvas";
            canvas.setAttribute("role", "img");
            canvas.setAttribute("aria-label", `Gauge chart showing ${this.formatValue(this.value)}`);
            canvasWrapper.appendChild(canvas);

            const valueDisplay = document.createElement("div");
            valueDisplay.className = "ac-chart-gauge-value";
            valueDisplay.textContent = this.formatValue(this.value);
            canvasWrapper.appendChild(valueDisplay);

            if (this.subLabel) {
                const subLabelElement = document.createElement("div");
                subLabelElement.className = "ac-chart-gauge-sublabel";
                subLabelElement.textContent = this.subLabel;
                canvasWrapper.appendChild(subLabelElement);
            }

            container.appendChild(canvasWrapper);

            if (this.showMinMax) {
                const minMaxContainer = document.createElement("div");
                minMaxContainer.className = "ac-chart-gauge-minmax";

                const minLabel = document.createElement("span");
                minLabel.className = "ac-chart-gauge-min";
                minLabel.textContent = this.min;

                const maxLabel = document.createElement("span");
                maxLabel.className = "ac-chart-gauge-max";
                maxLabel.textContent = this.max;

                minMaxContainer.appendChild(minLabel);
                minMaxContainer.appendChild(maxLabel);
                container.appendChild(minMaxContainer);
            }

            if (this.showLegend && this.segments && this.segments.length > 0) {
                const legend = document.createElement("div");
                legend.className = "ac-chart-gauge-legend";

                this.segments.forEach(segment => {
                    const legendItem = document.createElement("div");
                    legendItem.className = "ac-chart-gauge-legend-item";

                    const colorBox = document.createElement("span");
                    colorBox.className = "ac-chart-gauge-legend-color";
                    colorBox.style.backgroundColor = this.resolveColor(segment.color) || segment.color;

                    const label = document.createElement("span");
                    label.className = "ac-chart-gauge-legend-label";
                    label.textContent = segment.legend || segment.label || '';

                    legendItem.appendChild(colorBox);
                    legendItem.appendChild(label);
                    legend.appendChild(legendItem);
                });

                container.appendChild(legend);
            }

            setTimeout(() => this.renderChart(canvas), 0);
            return container;
        }

        renderChart(canvas) {
            if (typeof Chart === 'undefined') {
                console.error("Chart.js library not loaded");
                return;
            }

            if (this._chart) {
                this._chart.destroy();
                this._chart = undefined;
            }

            const ctx = canvas.getContext('2d');
            const totalRange = this.max - this.min;
            const safeRange = totalRange === 0 ? 1 : totalRange;
            const clampedValue = Math.max(this.min, Math.min(this.value, this.max));
            const valueFraction = (clampedValue - this.min) / safeRange;

            const compiledSegments = this._compileSegments();
            const resolvedValueColor = this.resolveColor(this.getSegmentColor(clampedValue) || '#0078D4');
            const trackColor = this._lightenColor(resolvedValueColor, compiledSegments ? 0.82 : 0.72) || '#E6E6E6';

            const gaugeChart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    datasets: [{
                        data: [1],
                        backgroundColor: ['rgba(255, 255, 255, 0)'],
                        borderWidth: 0,
                        circumference: 180,
                        rotation: 270
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    aspectRatio: 2,
                    cutout: '75%',
                    layout: {
                        padding: {
                            top: 24,
                            right: 16,
                            bottom: 12,
                            left: 16
                        }
                    },
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            enabled: false
                        },
                        gaugeBackground: {
                            segments: compiledSegments,
                            trackColor,
                            valueColor: resolvedValueColor,
                            valueFraction
                        },
                        gaugeMarker: {
                            valueFraction,
                            color: '#1F1F1F',
                            highlightColor: 'rgba(255, 255, 255, 0.35)',
                            tipLength: undefined,
                            baseRadius: undefined,
                            baseOffset: undefined,
                            borderColor: 'rgba(0, 0, 0, 1)',
                            borderWidth: 0.25
                        }
                    }
                },
                plugins: [{
                    id: 'gaugeBackground',
                    beforeDatasetsDraw: (chart, args, pluginOptions) => {
                        const ctx = chart.ctx;
                        const meta = chart.getDatasetMeta(0);
                        const options = pluginOptions || chart.config.options.plugins.gaugeBackground || {};

                        if (!meta || !meta.data || meta.data.length === 0) {
                            return;
                        }

                        const arc = meta.data[0];
                        if (!arc) {
                            return;
                        }

                        const trackColorFill = options.trackColor || '#E6E6E6';
                        const segments = Array.isArray(options.segments) ? options.segments : null;
                        const valueFraction = Math.max(0, Math.min(options.valueFraction ?? 0, 1));
                        const valueColor = options.valueColor || '#0078D4';
                        const startAngle = arc.startAngle;
                        const endAngle = arc.endAngle;
                        const sweep = endAngle - startAngle;
                        const centerX = arc.x;
                        const centerY = arc.y;
                        const innerRadius = arc.innerRadius;
                        const outerRadius = arc.outerRadius;

                        const drawArcSection = (sectionStart, sectionEnd, fillStyle) => {
                            if (sectionEnd <= sectionStart) {
                                return;
                            }
                            ctx.beginPath();
                            ctx.arc(centerX, centerY, outerRadius, sectionStart, sectionEnd);
                            ctx.arc(centerX, centerY, innerRadius, sectionEnd, sectionStart, true);
                            ctx.closePath();
                            ctx.fillStyle = fillStyle;
                            ctx.fill();
                        };

                        ctx.save();
                        drawArcSection(startAngle, endAngle, trackColorFill);

                        if (segments) {
                            segments.forEach(segment => {
                                const segStart = startAngle + sweep * segment.startFraction;
                                const segEnd = startAngle + sweep * segment.endFraction;
                                const color = segment.color || trackColorFill;
                                drawArcSection(segStart, segEnd, color);
                            });
                        } else if (valueFraction > 0) {
                            const valueStart = startAngle;
                            const valueEnd = startAngle + sweep * valueFraction;
                            drawArcSection(valueStart, valueEnd, valueColor);
                        }

                        ctx.restore();
                    }
                }, {
                    id: 'gaugeMarker',
                    afterDatasetsDraw: (chart, args, pluginOptions) => {
                        const ctx = chart.ctx;
                        const meta = chart.getDatasetMeta(0);
                        const markerOptions = pluginOptions || chart.config.options.plugins.gaugeMarker || {};
                        const fraction = Math.max(0, Math.min(markerOptions.valueFraction ?? 0, 1));
                        const markerColor = markerOptions.color || '#333333';
                        const highlightColor = markerOptions.highlightColor || 'rgba(255, 255, 255, 0.2)';
                        const borderColor = markerOptions.borderColor || 'rgba(0, 0, 0, 0.25)';
                        const borderWidth = markerOptions.borderWidth ?? 0.2;

                        if (!meta || !meta.data || meta.data.length === 0) return;

                        const arcs = meta.data.filter(arc => arc && arc.circumference > 0);
                        if (arcs.length === 0) return;

                        const firstArc = arcs[0];
                        const lastArc = arcs[arcs.length - 1];
                        const startAngle = firstArc.startAngle;
                        const endAngle = lastArc.endAngle;
                        const sweep = endAngle - startAngle;
                        const angle = startAngle + sweep * fraction;

                        const innerRadius = firstArc.innerRadius;
                        const outerRadius = firstArc.outerRadius;
                        const thickness = outerRadius - innerRadius;
                        const centerX = firstArc.x;
                        const centerY = firstArc.y;

                        const tipLength = markerOptions.tipLength
                            ?? Math.max(Math.min(thickness * 0.95, 32), 14);
                        const baseRadius = markerOptions.baseRadius
                            ?? Math.max(Math.min(thickness * 0.55, 18), 7);
                        const baseOffset = markerOptions.baseOffset
                            ?? Math.max(baseRadius * 0.7, 5);

                        const lightenColor = (input, amount) => this._lightenColor(input, amount);
                        const baseLight = lightenColor(markerColor, 0.15);
                        const innerLight = lightenColor(markerColor, 0.38);

                        const radialCenterRadius = innerRadius + thickness * 0.5;
                        const markerX = centerX + Math.cos(angle) * radialCenterRadius;
                        const markerY = centerY + Math.sin(angle) * radialCenterRadius;

                        ctx.save();
                        ctx.translate(markerX, markerY);
                        ctx.rotate(angle + Math.PI / 2);

                        const gradient = ctx.createLinearGradient(0, -tipLength, 0, baseOffset + baseRadius);
                        gradient.addColorStop(0, innerLight);
                        gradient.addColorStop(0.55, markerColor);
                        gradient.addColorStop(1, baseLight);

                        ctx.beginPath();
                        ctx.moveTo(0, -tipLength);
                        ctx.quadraticCurveTo(baseRadius, -tipLength * 0.35, baseRadius * 0.95, baseOffset);
                        ctx.arc(0, baseOffset, baseRadius, 0, Math.PI, false);
                        ctx.quadraticCurveTo(-baseRadius, -tipLength * 0.35, 0, -tipLength);
                        ctx.closePath();
                        ctx.fillStyle = gradient;
                        ctx.fill();

                        if (borderWidth > 0) {
                            ctx.lineWidth = borderWidth;
                            ctx.strokeStyle = borderColor;
                            ctx.stroke();
                        }

                        ctx.beginPath();
                        const highlightTip = tipLength * 0.6;
                        const highlightRadius = Math.max(baseRadius * 0.55, 4);
                        const highlightOffset = baseOffset * 0.65;
                        ctx.moveTo(0, -highlightTip);
                        ctx.quadraticCurveTo(highlightRadius * 0.85, -highlightTip * 0.28, highlightRadius * 0.9, highlightOffset);
                        ctx.arc(0, highlightOffset, highlightRadius, 0, Math.PI, false);
                        ctx.quadraticCurveTo(-highlightRadius * 0.85, -highlightTip * 0.28, 0, -highlightTip);
                        ctx.closePath();
                        ctx.fillStyle = highlightColor;
                        ctx.fill();

                        ctx.restore();
                    }
                }]
            });

            this._chart = gaugeChart;
        }

        toJSON() {
            const result = super.toJSON();
            if (this.value !== undefined) result.value = this.value;
            if (this.min !== undefined) result.min = this.min;
            if (this.max !== undefined) result.max = this.max;
            if (this.title !== undefined) result.title = this.title;
            if (this.subLabel !== undefined) result.subLabel = this.subLabel;
            if (this.valueFormat !== undefined) result.valueFormat = this.valueFormat;
            if (this.segments !== undefined) result.segments = this.segments;
            if (this.showLegend !== undefined) result.showLegend = this.showLegend;
            if (this.showMinMax !== undefined) result.showMinMax = this.showMinMax;
            if (this.colorSet !== undefined) result.colorSet = this.colorSet;
            return result;
        }
    }

    AC.GlobalRegistry.elements.register("Chart.Gauge", ChartGauge);
    console.log("Chart.Gauge element registered");
})();
