<#
.SYNOPSIS
    Creates a new Flow layout for an Adaptive Card container.

.DESCRIPTION
    The New-CardLayoutFlow function creates a Layout.Flow object that controls how items
    are arranged in a container. Flow layouts automatically arrange items in rows, wrapping
    to new rows as needed, similar to a flexbox layout. This layout is available in Teams
    and provides responsive, flexible item arrangement.

.PARAMETER ColumnSpacing
    The space between items horizontally. Valid values are:
    - None: No spacing
    - ExtraSmall: Minimal spacing
    - Small: Small spacing
    - Default: Default spacing (default value)
    - Medium: Medium spacing
    - Large: Large spacing
    - ExtraLarge: Extra large spacing
    - Padding: Padding-based spacing

.PARAMETER RowSpacing
    The space between rows of items vertically. Valid values are:
    - None: No spacing
    - ExtraSmall: Minimal spacing
    - Small: Small spacing
    - Default: Default spacing (default value)
    - Medium: Medium spacing
    - Large: Large spacing
    - ExtraLarge: Extra large spacing
    - Padding: Padding-based spacing

.PARAMETER HorizontalItemsAlignment
    Controls how the content of the container should be horizontally aligned.
    Valid values are: Left, Center (default), Right

.PARAMETER VerticalItemsAlignment
    Controls how the content of the container should be vertically aligned.
    Valid values are: Top (default), Center, Bottom

.PARAMETER ItemFit
    Controls how items should fit inside the container.
    Valid values are:
    - Fit: Items maintain their aspect ratio (default)
    - Fill: Items fill the available space

.PARAMETER ItemWidth
    The width, in pixels, of each item. Should not be used if MaxItemWidth
    and/or MinItemWidth are set. Specify as an integer (pixels will be added automatically).

.PARAMETER MinItemWidth
    The minimum width, in pixels, of each item. Should not be used if ItemWidth is set.
    Specify as an integer (pixels will be added automatically). Default is 0.

.PARAMETER MaxItemWidth
    The maximum width, in pixels, of each item. Should not be used if ItemWidth is set.
    Specify as an integer (pixels will be added automatically).

.PARAMETER TargetWidth
    Controls for which card width the layout should be used. This enables responsive
    layouts that adapt to different screen sizes.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the Layout.Flow structure.

.EXAMPLE
    New-CardLayoutFlow -ColumnSpacing "Medium" -RowSpacing "Large"

    Creates a flow layout with medium column spacing and large row spacing.

.EXAMPLE
    New-CardLayoutFlow -MinItemWidth 200 -MaxItemWidth 400 -HorizontalItemsAlignment "Left"

    Creates a flow layout where items are between 200-400px wide and aligned to the left.

.EXAMPLE
    New-CardLayoutFlow -ItemWidth 300 -VerticalItemsAlignment "Center" -ItemFit "Fill"

    Creates a flow layout with fixed 300px width items that fill available space and are centered vertically.

.NOTES
    - This is a Teams-specific layout (version 1.5+)
    - ItemWidth should not be combined with MinItemWidth or MaxItemWidth
    - Flow layouts automatically wrap items to new rows based on available space
    - Use TargetWidth for responsive layouts that change based on card width

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#layoutflow
#>
function New-CardLayoutFlow {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet("None", "ExtraSmall", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")]
        [string]
        $ColumnSpacing = "Default",

        [Parameter(Mandatory = $false)]
        [ValidateSet("None", "ExtraSmall", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")]
        [string]
        $RowSpacing = "Default",

        [Parameter(Mandatory = $false)]
        [ValidateSet("Left", "Center", "Right")]
        [string]
        $HorizontalItemsAlignment = "Center",

        [Parameter(Mandatory = $false)]
        [ValidateSet("Top", "Center", "Bottom")]
        [string]
        $VerticalItemsAlignment = "Top",

        [Parameter(Mandatory = $false)]
        [ValidateSet("Fit", "Fill")]
        [string]
        $ItemFit = "Fit",

        [Parameter(Mandatory = $false)]
        [int]
        $ItemWidth,

        [Parameter(Mandatory = $false)]
        [int]
        $MinItemWidth = 0,

        [Parameter(Mandatory = $false)]
        [int]
        $MaxItemWidth,

        [Parameter(Mandatory = $false)]
        [ValidateSet("VeryNarrow", "Narrow", "Standard", "Wide",
            "atLeast:VeryNarrow", "atMost:VeryNarrow",
            "atLeast:Narrow", "atMost:Narrow",
            "atLeast:Standard", "atMost:Standard",
            "atLeast:Wide", "atMost:Wide")]
        [string]
        $TargetWidth
    )

    # Validate mutually exclusive parameters
    if ($ItemWidth -and ($MinItemWidth -or $MaxItemWidth)) {
        Write-Warning "ItemWidth should not be used together with MinItemWidth or MaxItemWidth. Using ItemWidth only."
    }

    $Layout = @{
        type = "Layout.Flow"
    }

    # Only add properties if they differ from defaults
    if ($ColumnSpacing -and $ColumnSpacing -ne "Default") {
        $Layout.columnSpacing = $ColumnSpacing
    }

    if ($RowSpacing -and $RowSpacing -ne "Default") {
        $Layout.rowSpacing = $RowSpacing
    }

    if ($HorizontalItemsAlignment -and $HorizontalItemsAlignment -ne "Center") {
        $Layout.horizontalItemsAlignment = $HorizontalItemsAlignment
    }

    if ($VerticalItemsAlignment -and $VerticalItemsAlignment -ne "Top") {
        $Layout.verticalItemsAlignment = $VerticalItemsAlignment
    }

    if ($ItemFit -and $ItemFit -ne "Fit") {
        $Layout.itemFit = $ItemFit
    }

    if ($ItemWidth) {
        $Layout.itemWidth = "${ItemWidth}px"
    }
    elseif ($MinItemWidth -or $MaxItemWidth) {
        if ($MinItemWidth -gt 0) {
            $Layout.minItemWidth = "${MinItemWidth}px"
        }
        if ($MaxItemWidth) {
            $Layout.maxItemWidth = "${MaxItemWidth}px"
        }
    }

    if ($TargetWidth) {
        $Layout.targetWidth = $TargetWidth
    }

    if ($PSCmdlet.ShouldProcess("Creating Layout.Flow object")) {
        return $Layout
    }
}
