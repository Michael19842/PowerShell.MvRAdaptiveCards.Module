<#
.SYNOPSIS
    Creates a new AreaGrid layout for an Adaptive Card container.

.DESCRIPTION
    The New-CardLayoutAreaGrid function creates a Layout.AreaGrid object that enables
    CSS Grid-like layout capabilities for Adaptive Card containers. This layout allows
    precise control over element positioning using named grid areas, similar to
    CSS Grid Template Areas. This layout is available in Teams (version 1.5+).

.PARAMETER Areas
    An array of GridArea objects that define the named areas in the grid layout.
    Each area can span multiple rows and columns. Use New-CardGridArea to create
    these area definitions.

.PARAMETER Columns
    An array defining the columns in the grid layout. Each column can be defined as:
    - A percentage of available width (e.g., 50 for 50%)
    - A pixel value (specify as integer, will be converted to "Npx" format)
    - A string with explicit format (e.g., "200px", "33.33%")

.PARAMETER ColumnSpacing
    The space between columns. Valid values are:
    - None: No spacing
    - ExtraSmall: Minimal spacing
    - Small: Small spacing
    - Default: Default spacing (default value)
    - Medium: Medium spacing
    - Large: Large spacing
    - ExtraLarge: Extra large spacing
    - Padding: Padding-based spacing

.PARAMETER RowSpacing
    The space between rows. Valid values are:
    - None: No spacing
    - ExtraSmall: Minimal spacing
    - Small: Small spacing
    - Default: Default spacing (default value)
    - Medium: Medium spacing
    - Large: Large spacing
    - ExtraLarge: Extra large spacing
    - Padding: Padding-based spacing

.PARAMETER TargetWidth
    Controls for which card width the layout should be used. This enables responsive
    layouts that adapt to different screen sizes.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the Layout.AreaGrid structure.

.EXAMPLE
    $areas = @(
        New-CardGridArea -Name "header" -Row 1 -Column 1 -ColumnSpan 2
        New-CardGridArea -Name "sidebar" -Row 2 -Column 1
        New-CardGridArea -Name "content" -Row 2 -Column 2
    )
    New-CardLayoutAreaGrid -Areas $areas -Columns @(30, 70) -RowSpacing "Medium"

    Creates a grid layout with a header spanning two columns and a sidebar/content layout below.

.EXAMPLE
    New-CardLayoutAreaGrid -Columns @("200px", "1fr", "200px") -ColumnSpacing "Large"

    Creates a three-column grid with fixed 200px sidebars and flexible center column.

.EXAMPLE
    $areas = @(
        @{ name = "nav"; row = 1; column = 1 }
        @{ name = "main"; row = 1; column = 2; rowSpan = 2 }
        @{ name = "footer"; row = 2; column = 1 }
    )
    New-CardLayoutAreaGrid -Areas $areas -Columns @(25, 75) -TargetWidth "atLeast:Standard"

    Creates a responsive grid that only applies when the card is Standard width or larger.

.NOTES
    - This is a Teams-specific layout (version 1.5+)
    - Areas define named regions that elements can be assigned to using the grid.area property
    - Columns can be defined as percentages, pixels, or fractional units
    - Elements reference grid areas using the grid.area parameter
    - Similar to CSS Grid Template Areas for familiar web layout patterns

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#layoutareagrid
#>
function New-CardLayoutAreaGrid {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $false)]
        [scriptblock]
        $Areas,

        [Parameter(Mandatory = $false)]
        [array]
        $Columns,

        [Parameter(Mandatory = $false)]
        [ValidateSet("None", "ExtraSmall", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")]
        [string]
        $ColumnSpacing = "Default",

        [Parameter(Mandatory = $false)]
        [ValidateSet("None", "ExtraSmall", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")]
        [string]
        $RowSpacing = "Default",

        [Parameter(Mandatory = $false)]
        [ValidateSet("VeryNarrow", "Narrow", "Standard", "Wide",
            "atLeast:VeryNarrow", "atMost:VeryNarrow",
            "atLeast:Narrow", "atMost:Narrow",
            "atLeast:Standard", "atMost:Standard",
            "atLeast:Wide", "atMost:Wide")]
        [string]
        $TargetWidth
    )

    $Layout = @{
        type = "Layout.AreaGrid"
    }

    # Add areas if provided
    if ($Areas) {
        $Layout.areas = $Areas
    }

    # Add columns if provided, handling different formats
    if ($Columns) {
        $processedColumns = @()
        foreach ($col in $Columns) {
            if ($col -is [int]) {
                # If it's a pure integer, treat as percentage
                $processedColumns += $col
            }
            elseif ($col -is [string]) {
                # If it's already a string (e.g., "200px", "1fr"), use as-is
                $processedColumns += $col
            }
            else {
                # Default to treating as percentage
                $processedColumns += $col
            }
        }
        $Layout.columns = $processedColumns
    }

    # Only add spacing properties if they differ from defaults
    if ($ColumnSpacing -and $ColumnSpacing -ne "Default" ) {
        $Layout.columnSpacing = $ColumnSpacing
    }

    if ($RowSpacing -and $RowSpacing -ne "Default") {
        $Layout.rowSpacing = $RowSpacing
    }

    if ($TargetWidth) {
        $Layout.targetWidth = $TargetWidth
    }

    if ($PSCmdlet.ShouldProcess("Creating Layout AreaGrid")) {
        return $Layout
    }
}
