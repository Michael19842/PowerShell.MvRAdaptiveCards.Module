
<#
.SYNOPSIS
    Creates a new Column element for use within a ColumnSet.

.DESCRIPTION
    The New-CardColumn function creates a Column element that defines a single column within a ColumnSet.
    Columns can contain card elements and can be sized using various width options.

.PARAMETER Content
    A ScriptBlock containing the card elements to be included inside the column.

.PARAMETER Width
    The width of the column. Can be:
    - "auto": Column width fits the content
    - "stretch": Column takes remaining space
    - A number (1, 2, etc.): Relative width compared to other columns
    - A pixel value: Specific width like "50px"

.PARAMETER Style
    The visual style to apply to the column. Valid values: Default, Emphasis, Accent, Good, Warning, Attention.

.PARAMETER VerticalContentAlignment
    Defines how content should be aligned vertically within the column.
    Valid values: Top, Center, Bottom.

.PARAMETER BackgroundImage
    Specifies the background image for the column. Can be a URL or a BackgroundImage object.

.PARAMETER Bleed
    When set, the column will bleed through its parent's padding.

.PARAMETER MinHeight
    Specifies the minimum height of the column in pixels.

.PARAMETER Spacing
    Controls the amount of space between this column and the preceding column.
    Valid values: None, ExtraSmall, Small, Default, Medium, Large, ExtraLarge, Padding.

.PARAMETER Separator
    When set, draws a separating line between this column and the previous column.

.PARAMETER SelectAction
    An Action object that will be invoked when the Column is tapped or selected.

.PARAMETER Id
    An optional unique identifier for the column element.

.PARAMETER Rtl
    When set, content in this column should be presented right to left.

.PARAMETER Fallback
    A ScriptBlock that returns an alternate element to render if this column is unsupported.

.PARAMETER Requires
    A hashtable of capabilities the column requires the host application to support.

.PARAMETER Hidden
    When set, the column will not be visible.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the Column element structure.

.EXAMPLE
    New-CardColumn -Width "auto" -Content {
        New-CardImage -Url "https://example.com/avatar.png" -Size "Small"
    }

    Creates a column that auto-sizes to fit an image.

.EXAMPLE
    New-CardColumn -Width 2 -VerticalContentAlignment "Center" -Content {
        New-CardTextBlock -Text "Centered content in a column that's twice as wide"
    }

    Creates a column with relative width of 2 and centered content.

.EXAMPLE
    New-CardColumn -Width "stretch" -Style "Emphasis" -Content {
        New-CardTextBlock -Text "Title" -Weight "Bolder"
        New-CardTextBlock -Text "Description"
    }

    Creates a column that stretches to fill available space with emphasis styling.

.NOTES
    - Columns must be used within a ColumnSet (New-CardColumnSet)
    - Width values determine how space is distributed among columns
    - Relative widths (numbers) are proportional to each other

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#column
#>
function New-CardColumn {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Alias('Items')]
        [Parameter(Mandatory = $false)]
        [scriptblock]
        $Content,

        [Parameter(Mandatory = $false)]
        [object]
        $Width,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Default", "Emphasis", "Accent", "Good", "Warning", "Attention")]
        [string]
        $Style = "Default",

        [Parameter(Mandatory = $false)]
        [ValidateSet("Top", "Center", "Bottom")]
        [string]
        $VerticalContentAlignment,

        [Parameter(Mandatory = $false)]
        [object]
        $BackgroundImage,

        [Parameter(Mandatory = $false)]
        [switch]
        $Bleed,

        [Parameter(Mandatory = $false)]
        [int]
        $MinHeight,

        [Parameter(Mandatory = $false)]
        [ValidateSet("None", "ExtraSmall", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")]
        [string]
        $Spacing,

        [Parameter(Mandatory = $false)]
        [switch]
        $Separator,

        [Parameter(Mandatory = $false)]
        [object]
        $SelectAction,

        [Parameter(Mandatory = $false)]
        [string]
        $Id,

        [Parameter(Mandatory = $false)]
        [switch]
        $Rtl,

        [Parameter(Mandatory = $false)]
        [scriptblock]
        $Fallback,

        [Parameter(Mandatory = $false)]
        [hashtable]
        $Requires,

        [Alias('Hide')]
        [Parameter(Mandatory = $false)]
        [switch]
        $Hidden
    )

    $ColumnObj = @{
        type  = "Column"
        items = [System.Collections.ArrayList]@()
    }

    if ($PSBoundParameters.ContainsKey('Width')) {
        # Width can be "auto", "stretch", a number, or a pixel value like "50px"
        $ColumnObj.width = $Width
    }

    if ($PSBoundParameters.ContainsKey('Style') -and $Style -ne "Default") {
        $ColumnObj.style = $Style.ToLower()
    }

    if ($PSBoundParameters.ContainsKey('VerticalContentAlignment')) {
        $ColumnObj.verticalContentAlignment = $VerticalContentAlignment
    }

    if ($PSBoundParameters.ContainsKey('BackgroundImage')) {
        $ColumnObj.backgroundImage = $BackgroundImage
    }

    if ($Bleed) {
        $ColumnObj.bleed = $true
    }

    if ($PSBoundParameters.ContainsKey('MinHeight')) {
        $ColumnObj.minHeight = "${MinHeight}px"
    }

    if ($PSBoundParameters.ContainsKey('Spacing') -and $Spacing -ne "Default") {
        $ColumnObj.spacing = $Spacing
    }

    if ($Separator) {
        $ColumnObj.separator = $true
    }

    if ($PSBoundParameters.ContainsKey('SelectAction')) {
        $ColumnObj.selectAction = $SelectAction
    }

    if ($PSBoundParameters.ContainsKey('Id')) {
        $ColumnObj.id = $Id
    }

    if ($Rtl) {
        $ColumnObj.rtl = $true
    }

    if ($PSBoundParameters.ContainsKey('Fallback')) {
        $ColumnObj.fallback = Invoke-Command -ScriptBlock $Fallback
    }

    if ($PSBoundParameters.ContainsKey('Requires')) {
        $ColumnObj.requires = $Requires
    }

    if ($Hidden) {
        $ColumnObj.isVisible = $false
    }

    # Execute the Content scriptblock if provided
    if ($PSBoundParameters.ContainsKey('Content')) {
        $ContentResult = Invoke-Command -ScriptBlock $Content

        if ($ContentResult -is [array]) {
            [void]($ColumnObj.items.AddRange($ContentResult))
        }
        elseif ($null -ne $ContentResult) {
            [void]($ColumnObj.items.Add($ContentResult))
        }
    }

    if ($PSCmdlet.ShouldProcess("Creating Column element with $($ColumnObj.items.Count) item(s)")) {
        return $ColumnObj
    }
}
