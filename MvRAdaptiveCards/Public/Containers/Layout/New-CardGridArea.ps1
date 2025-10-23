<#
.SYNOPSIS
    Creates a new GridArea definition for use in Layout.AreaGrid layouts.

.DESCRIPTION
    The New-CardGridArea function creates a GridArea object that defines a named region
    within an AreaGrid layout. Elements can then be placed into these named areas using
    the grid.area property. This is similar to CSS Grid Template Areas, allowing precise
    control over element positioning in a grid layout.

.PARAMETER Name
    The name of the grid area. Elements reference this name using their grid.area property
    to be placed in this area. Required parameter.

.PARAMETER Row
    The start row index of the area. Row indices start at 1. Default is 1.

.PARAMETER Column
    The start column index of the area. Column indices start at 1. Default is 1.

.PARAMETER RowSpan
    Defines how many rows the area should span. Default is 1 (single row).

.PARAMETER ColumnSpan
    Defines how many columns the area should span. Default is 1 (single column).

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the GridArea structure.

.EXAMPLE
    New-CardGridArea -Name "header" -Row 1 -Column 1 -ColumnSpan 2

    Creates a grid area named "header" in the first row spanning two columns.

.EXAMPLE
    New-CardGridArea -Name "sidebar" -Row 2 -Column 1 -RowSpan 3

    Creates a grid area named "sidebar" starting at row 2, column 1, spanning 3 rows.

.EXAMPLE
    $areas = @(
        New-CardGridArea -Name "header" -Row 1 -Column 1 -ColumnSpan 3
        New-CardGridArea -Name "nav" -Row 2 -Column 1
        New-CardGridArea -Name "main" -Row 2 -Column 2 -RowSpan 2
        New-CardGridArea -Name "sidebar" -Row 2 -Column 3 -RowSpan 2
        New-CardGridArea -Name "footer" -Row 3 -Column 1
    )
    New-CardLayoutAreaGrid -Areas $areas -Columns @(20, 60, 20)

    Creates a complete grid layout with header, navigation, main content, sidebar, and footer areas.

.EXAMPLE
    # Create area and use it in a container
    $area = New-CardGridArea -Name "content" -Row 1 -Column 1
    New-CardTextBlock -Text "Hello" -GridArea "content"

    Creates a grid area and places a text block in it.

.NOTES
    - This is a Teams-specific feature (version 1.5+)
    - Row and column indices are 1-based (start at 1, not 0)
    - Areas can overlap if needed, though this is generally avoided in practice
    - Elements reference areas using the grid.area property
    - The Name parameter is required as elements need it to reference the area

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#gridarea

.LINK
    New-CardLayoutAreaGrid
#>
function New-CardGridArea {
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [int]
        $Row = 1,

        [Parameter(Mandatory = $false)]
        [int]
        $Column = 1,

        [Parameter(Mandatory = $false)]
        [int]
        $RowSpan = 1,

        [Parameter(Mandatory = $false)]
        [int]
        $ColumnSpan = 1
    )

    $GridArea = @{
        name = $Name
    }

    # Only add properties if they differ from defaults
    if ($Row -ne 1) {
        $GridArea.row = $Row
    }

    if ($Column -ne 1) {
        $GridArea.column = $Column
    }

    if ($RowSpan -ne 1) {
        $GridArea.rowSpan = $RowSpan
    }

    if ($ColumnSpan -ne 1) {
        $GridArea.columnSpan = $ColumnSpan
    }

    if ( $PSCmdlet.ShouldProcess("Creating GridArea '$Name'")) {
        return $GridArea
    }
}
