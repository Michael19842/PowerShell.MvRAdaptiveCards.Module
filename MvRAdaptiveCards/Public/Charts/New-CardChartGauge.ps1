<#
.SYNOPSIS
    Creates a Chart.Gauge element for an Adaptive Card.

.DESCRIPTION
    The New-CardChartGauge function creates a gauge chart element that displays a single value
    within a defined range, typically shown as a semicircular or circular indicator. Gauge charts
    are ideal for displaying metrics like completion percentage, progress indicators, performance
    scores, or any measurement against a scale.

.PARAMETER Value
    The current value to display on the gauge. Default is 0.

.PARAMETER Min
    The minimum value of the gauge scale. Default is 0.

.PARAMETER Max
    The maximum value of the gauge scale. This parameter is required to define the upper bound.

.PARAMETER Title
    The title text displayed above or near the gauge chart.

.PARAMETER SubLabel
    Additional descriptive text displayed below the value, providing context for the measurement.

.PARAMETER ValueFormat
    The format used to display the gauge's value. Valid values are:
    - Percentage: Displays the value as a percentage (e.g., "75%")
    - Fraction: Displays the value as a fraction (e.g., "75/100")
    Default is "Percentage".

.PARAMETER Segments
    An array of segment objects that define colored ranges on the gauge. Each segment should be
    a hashtable with properties like min, max, label, and color to create visual zones
    (e.g., red zone for low, yellow for medium, green for high).

.PARAMETER ShowLegend
    Controls whether the legend should be displayed. Default is $true.
    Set to $false to hide the legend.

.PARAMETER ShowMinMax
    Controls whether the minimum and maximum values should be displayed on the gauge.
    Default is $true. Set to $false to hide these values.

.PARAMETER ColorSet
    The name of the set of colors to use to render the chart. Valid values are:
    - categorical: Use distinct colors
    - sequential: Use a gradient from light to dark
    - diverging: Use colors that diverge from a midpoint

.PARAMETER Id
    A unique identifier for the element. Useful for referencing in actions or for accessibility.

.PARAMETER Height
    Controls the height of the element. Valid values: "auto", "stretch".

.PARAMETER HorizontalAlignment
    Controls how the element should be horizontally aligned. Valid values: "Left", "Center", "Right".

.PARAMETER Separator
    Displays a separator line above the element to visually separate it from the previous element.

.PARAMETER Spacing
    Controls the amount of space between this element and the previous one.
    Valid values: "None", "ExtraSmall", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding".

.PARAMETER IsVisible
    Controls the visibility of the element. Default is $true.

.PARAMETER Requires
    Hashtable of capabilities the element requires the host to support.

.PARAMETER Fallback
    Alternate element or "drop" to render if this element type is unsupported.

.PARAMETER TargetWidth
    Controls for which card width the element should be displayed. Enables responsive layouts.
    Valid values: "VeryNarrow", "Narrow", "Standard", "Wide", or atLeast/atMost variants.

.PARAMETER GridArea
    The area of a Layout.AreaGrid layout in which the element should be displayed.

.PARAMETER Lang
    The locale associated with the element.

.PARAMETER IsSortKey
    Controls whether the element should be used as a sort key by elements that allow sorting.

.OUTPUTS
    [hashtable]
    Returns a hashtable representing the Chart.Gauge element with all configured properties.

.EXAMPLE
    New-CardChartGauge -Value 75 -Min 0 -Max 100 -Title "Project Completion"

    Creates a simple gauge showing 75% completion.

.EXAMPLE
    New-CardChartGauge -Value 85 -Max 100 -Title "Performance Score" -SubLabel "Quarterly Review" -ValueFormat "Percentage"

    Creates a gauge with a subtitle showing performance as a percentage.

.EXAMPLE
    $segments = @(
        @{ min = 0; max = 40; label = "Low"; color = "#D13438" }
        @{ min = 40; max = 70; label = "Medium"; color = "#FFB900" }
        @{ min = 70; max = 100; label = "High"; color = "#00CC6A" }
    )
    New-CardChartGauge -Value 82 -Max 100 -Title "Customer Satisfaction" -Segments $segments -ShowLegend $true

    Creates a gauge with colored segments representing satisfaction levels.

.EXAMPLE
    New-CardChartGauge -Value 45 -Min 0 -Max 100 -Title "Storage Used" -ValueFormat "Fraction" -ShowMinMax $true

    Creates a gauge showing storage usage displayed as a fraction with min/max values visible.

.NOTES
    - Introduced in Adaptive Cards version 1.5
    - Gauge charts are excellent for KPIs and single-value metrics
    - Segments allow visual zones to indicate ranges (good/warning/critical)

.LINK
    New-AdaptiveCard

.LINK
    New-CardChartDonut

.LINK
    New-CardProgressBar
#>
function New-CardChartGauge {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $false)]
        [double]$Value,

        [Parameter(Mandatory = $false)]
        [double]$Min,

        [Parameter(Mandatory = $false)]
        [double]$Max,

        [Parameter(Mandatory = $false)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        [string]$SubLabel,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Percentage", "Fraction")]
        [string]$ValueFormat,

        [Parameter(Mandatory = $false)]
        [array]$Segments,

        [Parameter(Mandatory = $false)]
        [bool]$ShowLegend,

        [Parameter(Mandatory = $false)]
        [bool]$ShowMinMax,

        [Parameter(Mandatory = $false)]
        [ValidateSet("categorical", "sequential", "diverging")]
        [string]$ColorSet,

        [Parameter(Mandatory = $false)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [ValidateSet("auto", "stretch")]
        [string]$Height,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Left", "Center", "Right")]
        [string]$HorizontalAlignment,

        [Parameter(Mandatory = $false)]
        [switch]$Separator,

        [Parameter(Mandatory = $false)]
        [ValidateSet("None", "ExtraSmall", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")]
        [string]$Spacing,

        [Parameter(Mandatory = $false)]
        [bool]$IsVisible,

        [Parameter(Mandatory = $false)]
        [hashtable]$Requires,

        [Parameter(Mandatory = $false)]
        [object]$Fallback,

        [Parameter(Mandatory = $false)]
        [ValidateSet("VeryNarrow", "Narrow", "Standard", "Wide", "atLeast:VeryNarrow", "atMost:VeryNarrow",
            "atLeast:Narrow", "atMost:Narrow", "atLeast:Standard", "atMost:Standard",
            "atLeast:Wide", "atMost:Wide")]
        [string]$TargetWidth,

        [Parameter(Mandatory = $false)]
        [string]$GridArea,

        [Parameter(Mandatory = $false)]
        [string]$Lang,

        [Parameter(Mandatory = $false)]
        [bool]$IsSortKey
    )

    $ChartGauge = @{
        type = "Chart.Gauge"
    }

    if ($PSBoundParameters.ContainsKey('Value')) {
        $ChartGauge.value = $Value
    }
    if ($PSBoundParameters.ContainsKey('Min')) {
        $ChartGauge.min = $Min
    }
    if ($PSBoundParameters.ContainsKey('Max')) {
        $ChartGauge.max = $Max
    }
    if ($PSBoundParameters.ContainsKey('Title')) {
        $ChartGauge.title = $Title
    }
    if ($PSBoundParameters.ContainsKey('SubLabel')) {
        $ChartGauge.subLabel = $SubLabel
    }
    if ($PSBoundParameters.ContainsKey('ValueFormat')) {
        $ChartGauge.valueFormat = $ValueFormat
    }
    if ($PSBoundParameters.ContainsKey('Segments')) {
        $ChartGauge.segments = $Segments
    }
    if ($PSBoundParameters.ContainsKey('ShowLegend')) {
        $ChartGauge.showLegend = $ShowLegend
    }
    if ($PSBoundParameters.ContainsKey('ShowMinMax')) {
        $ChartGauge.showMinMax = $ShowMinMax
    }
    if ($PSBoundParameters.ContainsKey('ColorSet')) {
        $ChartGauge.colorSet = $ColorSet
    }
    if ($PSBoundParameters.ContainsKey('Id')) {
        $ChartGauge.id = $Id
    }
    if ($PSBoundParameters.ContainsKey('Height')) {
        $ChartGauge.height = $Height
    }
    if ($PSBoundParameters.ContainsKey('HorizontalAlignment')) {
        $ChartGauge.horizontalAlignment = $HorizontalAlignment
    }
    if ($Separator) {
        $ChartGauge.separator = $true
    }
    if ($PSBoundParameters.ContainsKey('Spacing')) {
        $ChartGauge.spacing = $Spacing
    }
    if ($PSBoundParameters.ContainsKey('IsVisible')) {
        $ChartGauge.isVisible = $IsVisible
    }
    if ($PSBoundParameters.ContainsKey('Requires')) {
        $ChartGauge.requires = $Requires
    }
    if ($PSBoundParameters.ContainsKey('Fallback')) {
        $ChartGauge.fallback = $Fallback
    }
    if ($PSBoundParameters.ContainsKey('TargetWidth')) {
        $ChartGauge.targetWidth = $TargetWidth
    }
    if ($PSBoundParameters.ContainsKey('GridArea')) {
        $ChartGauge.'grid.area' = $GridArea
    }
    if ($PSBoundParameters.ContainsKey('Lang')) {
        $ChartGauge.lang = $Lang
    }
    if ($PSBoundParameters.ContainsKey('IsSortKey')) {
        $ChartGauge.isSortKey = $IsSortKey
    }

    #Return the Chart.Gauge object
    if ($PSCmdlet.ShouldProcess("Creating Chart.Gauge with Value '$Value'")) {
        return $ChartGauge
    }
}


# 1.0
# colorSet
# string
# The name of the set of colors to use to render the chart. See Chart colors reference.

# Valid values:
# "categorical",
# "sequential",
# "diverging"
# 1.5
# fallback
# One of
# object
# string
# An alternate element to render if the type of this one is unsupported or if the host application doesn't support all the capabilities specified in the requires property.

# Valid values:
# Container,
# ActionSet,
# ColumnSet,
# Media,
# RichTextBlock,
# Table,
# TextBlock,
# FactSet,
# ImageSet,
# Image,
# Input.Text,
# Input.Date,
# Input.Time,
# Input.Number,
# Input.Toggle,
# Input.ChoiceSet,
# Input.Rating,
# Rating,
# CompoundButton,
# Icon,
# Carousel,
# Badge,
# ProgressRing,
# ProgressBar,
# Chart.Donut,
# Chart.Pie,
# Chart.VerticalBar.Grouped,
# Chart.VerticalBar,
# Chart.HorizontalBar,
# Chart.HorizontalBar.Stacked,
# Chart.Line,
# Chart.Gauge,
# CodeBlock,
# Component.graph.microsoft.com/user,
# Component.graph.microsoft.com/users,
# Component.graph.microsoft.com/resource,
# Component.graph.microsoft.com/file,
# Component.graph.microsoft.com/event,
# "drop"
# 1.2
# grid.area
# string
# Teams
# The area of a Layout.AreaGrid layout in which an element should be displayed.

# 1.5
# height
# string
# "auto"
# The height of the element. When set to stretch, the element will use the remaining vertical space in its container.

# Valid values:
# "auto",
# "stretch"
# 1.1
# horizontalAlignment
# string
# Controls how the element should be horizontally aligned.

# Valid values:
# "Left",
# "Center",
# "Right"
# 1.0
# id
# string
# A unique identifier for the element or action. Input elements must have an id, otherwise they will not be validated and their values will not be sent to the Bot.

# 1.0
# isSortKey
# boolean
# false
# Controls whether the element should be used as a sort key by elements that allow sorting across a collection of elements.

# 1.5
# isVisible
# boolean
# true
# Controls the visibility of the element.

# 1.2
# lang
# string
# The locale associated with the element.

# 1.1
# max
# number
# The maximum value of the gauge.

# 1.5
# min
# number
# 0
# The minimum value of the gauge.

# 1.5
# requires
# object
# {}
# A list of capabilities the element requires the host application to support. If the host application doesn't support at least one of the listed capabilities, the element is not rendered (or its fallback is rendered if provided).

# Valid values:
# HostCapabilities
# 1.2
# segments
# Array of
# object
# The segments to display in the gauge.

# Valid values:
# GaugeChartLegend
# 1.5
# separator
# boolean
# false
# Controls whether a separator line should be displayed above the element to visually separate it from the previous element. No separator will be displayed for the first element in a container, even if this property is set to true.

# 1.0
# showLegend
# boolean
# true
# Controls if the legend should be displayed.

# 1.5
# showMinMax
# boolean
# true
# Controls if the min/max values should be displayed.

# 1.5
# spacing
# string
# "Default"
# Controls the amount of space between this element and the previous one. No space will be added for the first element in a container.

# Valid values:
# "None",
# "ExtraSmall"
# Preview
# ,
# "Small",
# "Default",
# "Medium",
# "Large",
# "ExtraLarge",
# "Padding"
# 1.0
# subLabel
# string
# The sub-label of the gauge.

# 1.5
# targetWidth
# string
# TeamsCopilot
# Controls for which card width the element should be displayed. If targetWidth isn't specified, the element is rendered at all card widths. Using targetWidth makes it possible to author responsive cards that adapt their layout to the available horizontal space. For more details, see Responsive layout.

# Valid values:
# "VeryNarrow",
# "Narrow",
# "Standard",
# "Wide",
# "atLeast:VeryNarrow",
# "atMost:VeryNarrow",
# "atLeast:Narrow",
# "atMost:Narrow",
# "atLeast:Standard",
# "atMost:Standard",
# "atLeast:Wide",
# "atMost:Wide"
# 1.0
# title
# string
# The title of the chart.

# 1.5
# value
# number
# 0
# The value of the gauge.

# 1.5
# valueFormat
# string
# "Percentage"
# The format used to display the gauge's value.

# Valid values:
# "Percentage",
# "Fraction"
# 1.5