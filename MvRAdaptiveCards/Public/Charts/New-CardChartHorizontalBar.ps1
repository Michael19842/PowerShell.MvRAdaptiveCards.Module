<#
.SYNOPSIS
Creates a horizontal bar chart element for Adaptive Cards.

.DESCRIPTION
Creates a Chart.HorizontalBar element with configurable data points, colors, and display options.

.PARAMETER Data
Array of data points for the chart. Each data point should be a hashtable with properties like label, value, and optional color.

.PARAMETER Title
The title of the chart.

.PARAMETER Color
The color to use for all data points. Valid values include: good, warning, attention, neutral, and various categorical, sequential, and diverging colors.

.PARAMETER ColorSet
The name of the set of colors to use to render the chart. Valid values: categorical, sequential, diverging.

.PARAMETER DisplayMode
Controls how the chart should be visually laid out. Valid values: AbsoluteWithAxis, AbsoluteNoAxis, PartToWhole. Default is AbsoluteWithAxis.

.PARAMETER XAxisTitle
The title of the x axis.

.PARAMETER YAxisTitle
The title of the y axis.

.PARAMETER Id
A unique identifier for the element.

.PARAMETER Height
The height of the element. Valid values: auto, stretch.

.PARAMETER HorizontalAlignment
Controls how the element should be horizontally aligned. Valid values: Left, Center, Right.

.PARAMETER Separator
Controls whether a separator line should be displayed above the element.

.PARAMETER Spacing
Controls the amount of space between this element and the previous one. Valid values: None, ExtraSmall, Small, Default, Medium, Large, ExtraLarge, Padding.

.PARAMETER IsVisible
Controls the visibility of the element.

.PARAMETER IsSortKey
Controls whether the element should be used as a sort key.

.PARAMETER TargetWidth
Controls for which card width the element should be displayed.

.PARAMETER GridArea
The area of a Layout.AreaGrid layout in which an element should be displayed.

.PARAMETER Lang
The locale associated with the element.

.PARAMETER Fallback
An alternate element to render if this element type is unsupported.

.PARAMETER Requires
A hashtable of capabilities the element requires the host application to support.

.EXAMPLE
New-CardChartHorizontalBar -Title "Sales Data" -Data @(
    @{ label = "Q1"; value = 100 },
    @{ label = "Q2"; value = 150 },
    @{ label = "Q3"; value = 120 }
) -ColorSet "categorical"

.EXAMPLE
New-CardChartHorizontalBar -Title "Progress" -Data @(
    @{ label = "Complete"; value = 75; color = "good" },
    @{ label = "Remaining"; value = 25; color = "neutral" }
) -DisplayMode "PartToWhole"
#>
function New-CardChartHorizontalBar {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [Array]$Data,

        [Parameter(Mandatory = $false)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        [ValidateSet('good', 'warning', 'attention', 'neutral', 'categoricalRed', 'categoricalPurple',
            'categoricalLavender', 'categoricalBlue', 'categoricalLightBlue', 'categoricalTeal',
            'categoricalGreen', 'categoricalLime', 'categoricalMarigold', 'sequential1', 'sequential2',
            'sequential3', 'sequential4', 'sequential5', 'sequential6', 'sequential7', 'sequential8',
            'divergingBlue', 'divergingLightBlue', 'divergingCyan', 'divergingTeal', 'divergingYellow',
            'divergingPeach', 'divergingLightRed', 'divergingRed', 'divergingMaroon', 'divergingGray')]
        [string]$Color,

        [Parameter(Mandatory = $false)]
        [ValidateSet('categorical', 'sequential', 'diverging')]
        [string]$ColorSet,

        [Parameter(Mandatory = $false)]
        [ValidateSet('AbsoluteWithAxis', 'AbsoluteNoAxis', 'PartToWhole')]
        [string]$DisplayMode = 'AbsoluteWithAxis',

        [Parameter(Mandatory = $false)]
        [string]$XAxisTitle,

        [Parameter(Mandatory = $false)]
        [string]$YAxisTitle,

        [Parameter(Mandatory = $false)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [ValidateSet('auto', 'stretch')]
        [string]$Height,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Left', 'Center', 'Right')]
        [string]$HorizontalAlignment,

        [Parameter(Mandatory = $false)]
        [switch]$Separator,

        [Parameter(Mandatory = $false)]
        [ValidateSet('None', 'ExtraSmall', 'Small', 'Default', 'Medium', 'Large', 'ExtraLarge', 'Padding')]
        [string]$Spacing,

        [Parameter(Mandatory = $false)]
        [bool]$IsVisible = $true,

        [Parameter(Mandatory = $false)]
        [bool]$IsSortKey = $false,

        [Parameter(Mandatory = $false)]
        [ValidateSet('VeryNarrow', 'Narrow', 'Standard', 'Wide', 'atLeast:VeryNarrow', 'atMost:VeryNarrow',
            'atLeast:Narrow', 'atMost:Narrow', 'atLeast:Standard', 'atMost:Standard', 'atLeast:Wide', 'atMost:Wide')]
        [string]$TargetWidth,

        [Parameter(Mandatory = $false)]
        [string]$GridArea,

        [Parameter(Mandatory = $false)]
        [string]$Lang,

        [Parameter(Mandatory = $false)]
        [scriptblock]$Fallback,

        [Parameter(Mandatory = $false)]
        [hashtable]$Requires
    )

    $element = @{
        type = 'Chart.HorizontalBar'
        data = $Data
    }

    if ($Title) { $element.title = $Title }
    if ($Color) { $element.color = $Color }
    if ($ColorSet) { $element.colorSet = $ColorSet }
    if ($DisplayMode) { $element.displayMode = $DisplayMode }
    if ($XAxisTitle) { $element.xAxisTitle = $XAxisTitle }
    if ($YAxisTitle) { $element.yAxisTitle = $YAxisTitle }
    if ($Id) { $element.id = $Id }
    if ($Height) { $element.height = $Height }
    if ($HorizontalAlignment) { $element.horizontalAlignment = $HorizontalAlignment }
    if ($Separator) { $element.separator = $true }
    if ($Spacing) { $element.spacing = $Spacing }
    if ($PSBoundParameters.ContainsKey('IsVisible')) { $element.isVisible = $IsVisible }
    if ($IsSortKey) { $element.isSortKey = $true }
    if ($TargetWidth) { $element.targetWidth = $TargetWidth }
    if ($GridArea) { $element.'grid.area' = $GridArea }
    if ($Lang) { $element.lang = $Lang }
    if ($Fallback) {
        $element.fallback = Invoke-Command -ScriptBlock $Fallback
    }
    if ($Requires) { $element.requires = $Requires }

    if ($PSCmdlet.ShouldProcess("Creating Chart.HorizontalBar element", "New-CardChartHorizontalBar")) {
        return $element
    }
}