<#
.SYNOPSIS
    Creates a new Donut Chart element for an Adaptive Card.

.DESCRIPTION
    The New-CardChartDonut function creates a donut chart element that visualizes data in a circular
    format with a hollow center. Donut charts are excellent for showing proportions and percentages
    of a whole, making them ideal for displaying category distributions, budget allocations, or
    completion statuses.

.PARAMETER Title
    The title of the chart that will be displayed above the donut chart.

.PARAMETER Data
    An array of hashtables representing the data to display in the chart. Each hashtable should contain:
    - label: The name/label for the data segment
    - value: The numeric value for the segment
    - color: (Optional) The color for the segment (overrides colorSet)

.PARAMETER ColorSet
    The name of the set of colors to use to render the chart. Valid values are:
    - categorical: Use distinct colors for each segment (default)
    - sequential: Use a gradient of colors from light to dark
    - diverging: Use colors that diverge from a midpoint

.PARAMETER Id
    A unique identifier for the element. Useful for referencing in actions or for accessibility.

.PARAMETER Height
    The height of the element. Valid values are:
    - auto: The element will size itself based on content (default)
    - stretch: The element will use the remaining vertical space in its container

.PARAMETER HorizontalAlignment
    Controls how the element should be horizontally aligned. Valid values are:
    - Left: Align to the left
    - Center: Center the element
    - Right: Align to the right

.PARAMETER Spacing
    Controls the amount of space between this element and the previous one. Valid values are:
    - None: No spacing
    - ExtraSmall: Minimal spacing
    - Small: Small spacing
    - Default: Default spacing
    - Medium: Medium spacing
    - Large: Large spacing
    - ExtraLarge: Extra large spacing
    - Padding: Padding spacing

.PARAMETER Separator
    A switch parameter that adds a separator line above the element to visually separate it from
    the previous element.

.PARAMETER IsVisible
    Controls the visibility of the element. Set to $false to hide the element.

.PARAMETER isSortKey
    A switch parameter that controls whether the element should be used as a sort key by elements
    that allow sorting across a collection of elements.

.PARAMETER Lang
    The locale associated with the element (e.g., "en-US", "fr-FR").

.PARAMETER GridArea
    The area of a Layout.AreaGrid layout in which the element should be displayed.

.PARAMETER TargetWidth
    Controls for which card width the element should be displayed. Valid values are:
    - VeryNarrow, Narrow, Standard, Wide
    - atLeast:VeryNarrow, atLeast:Narrow, atLeast:Standard, atLeast:Wide
    - atMost:VeryNarrow, atMost:Narrow, atMost:Standard, atMost:Wide

.PARAMETER Fallback
    A scriptblock that generates an alternate element to render if the host doesn't support donut charts.

.PARAMETER Requires
    A hashtable of capabilities the element requires the host application to support.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the Chart.Donut element structure.

.EXAMPLE
    $data = @(
        @{ label = "Product A"; value = 35 }
        @{ label = "Product B"; value = 25 }
        @{ label = "Product C"; value = 20 }
        @{ label = "Product D"; value = 20 }
    )

    New-CardChartDonut -Title "Product Distribution" -Data $data -ColorSet "categorical"

    Creates a donut chart showing product distribution with categorical colors.

.EXAMPLE
    $budgetData = @(
        @{ label = "Development"; value = 45; color = "#0078D4" }
        @{ label = "Marketing"; value = 25; color = "#00CC6A" }
        @{ label = "Operations"; value = 20; color = "#FFB900" }
        @{ label = "Other"; value = 10; color = "#E74856" }
    )

    New-CardChartDonut -Title "Budget Allocation" -Data $budgetData -HorizontalAlignment "Center"

    Creates a centered donut chart with custom colors for each segment.

.EXAMPLE
    New-CardChartDonut -Title "Task Completion" -Data @(
        @{ label = "Completed"; value = 75 }
        @{ label = "In Progress"; value = 15 }
        @{ label = "Not Started"; value = 10 }
    ) -ColorSet "sequential" -Separator

    Creates a donut chart with sequential colors and a separator line above it.

.NOTES
    - Donut charts require Adaptive Cards version 1.5 or later
    - Data values are automatically converted to percentages
    - Each data segment should have a label and value
    - Custom colors override the colorSet parameter
    - The center of the donut remains empty, distinguishing it from a pie chart

.LINK
    https://adaptivecards.io/explorer/Chart.Donut.html

.LINK
    New-CardChartPie

.LINK
    New-CardChartVerticalBar
#>
function New-CardChartDonut {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $false)]
        [string]$Title,

        [Parameter(Mandatory = $true)]
        [ValidateScript({
                foreach ($item in $_) {
                    if ($item -isnot [hashtable]) {
                        throw "Data must be an array of hashtables. Each hashtable should contain 'label' and 'value' properties."
                    }
                    if (-not $item.ContainsKey('label') -or -not $item.ContainsKey('value')) {
                        throw "Each data item must have 'label' and 'value' properties."
                    }
                    if ($item.value -isnot [int] -and $item.value -isnot [double]) {
                        throw "The 'value' property must be numeric."
                    }
                }
                return $true
            })]
        [hashtable[]]$Data,

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
        [ValidateSet("None", "ExtraSmall", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")]
        [string]$Spacing,

        [Parameter(Mandatory = $false)]
        [switch]$Separator,

        [Parameter(Mandatory = $false)]
        [bool]$IsVisible,

        [Parameter(Mandatory = $false)]
        [switch]$isSortKey,

        [Parameter(Mandatory = $false)]
        [string]$Lang,

        [Parameter(Mandatory = $false)]
        [string]$GridArea,

        [Parameter(Mandatory = $false)]
        [ValidatePattern('^(VeryNarrow|Narrow|Standard|Wide|atLeast:(VeryNarrow|Narrow|Standard|Wide)|atMost:(VeryNarrow|Narrow|Standard|Wide))$')]
        [string]$TargetWidth,

        [Parameter(Mandatory = $false)]
        [scriptblock]$Fallback,

        [Parameter(Mandatory = $false)]
        [hashtable]$Requires
    )

    $chart = @{
        type = "Chart.Donut"
        data = @()
    }

    # Process data array
    foreach ($item in $Data) {
        $dataItem = @{
            label = $item.label
            value = $item.value
        }

        if ($item.ContainsKey('color')) {
            $dataItem.color = $item.color
        }

        $chart.data += $dataItem
    }

    if ($Title) {
        $chart.title = $Title
    }

    if ($ColorSet) {
        $chart.colorSet = $ColorSet
    }

    if ($Id) {
        $chart.id = $Id
    }

    if ($Height) {
        $chart.height = $Height
    }

    if ($HorizontalAlignment) {
        $chart.horizontalAlignment = $HorizontalAlignment
    }

    if ($Spacing) {
        $chart.spacing = $Spacing
    }

    if ($Separator) {
        $chart.separator = $true
    }

    if ($PSBoundParameters.ContainsKey('IsVisible')) {
        $chart.isVisible = $IsVisible
    }

    if ($isSortKey) {
        $chart.isSortKey = $true
    }

    if ($Lang) {
        $chart.lang = $Lang
    }

    if ($GridArea) {
        $chart.'grid.area' = $GridArea
    }

    if ($TargetWidth) {
        $chart.targetWidth = $TargetWidth
    }

    if ($Fallback) {
        $chart.fallback = & $Fallback
    }

    if ($Requires) {
        $chart.requires = $Requires
    }

    if ($PSCmdlet.ShouldProcess("Creating Chart.Donut element with title '$Title'")) {
        return $chart
    }
}