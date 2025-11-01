<#
.SYNOPSIS
    Creates a new ColumnSet element for an Adaptive Card.

.DESCRIPTION
    The New-CardColumnSet function creates a ColumnSet element that divides a region into columns,
    allowing elements to sit side-by-side. Use New-CardColumn within the Columns scriptblock to
    define individual columns with their own content and properties.

.PARAMETER Columns
    A ScriptBlock containing one or more New-CardColumn commands that define the columns in the set.
    Each column can have its own width, content, and styling.

.PARAMETER Style
    The visual style to apply to the column set. Valid values are:
    - Default: Standard appearance
    - Emphasis: Subtle emphasis styling
    - Accent: Accent color styling
    - Good: Success/positive styling (typically green)
    - Warning: Warning/caution styling (typically orange/yellow)
    - Attention: Attention-grabbing styling (typically red)

.PARAMETER Id
    An optional unique identifier for the column set element.

.PARAMETER SelectAction
    An Action object that will be invoked when the ColumnSet is tapped or selected.
    Action.ShowCard is not supported.

.PARAMETER HorizontalAlignment
    Controls how the column set should be horizontally aligned. Valid values: Left, Center, Right.

.PARAMETER Height
    The height of the column set. Valid values: "auto", "stretch".

.PARAMETER MinHeight
    Specifies the minimum height of the column set in pixels (e.g., 80).

.PARAMETER Spacing
    Controls the amount of space between this element and the previous one.
    Valid values: None, ExtraSmall, Small, Default, Medium, Large, ExtraLarge, Padding.

.PARAMETER Separator
    When set, displays a separator line above the column set.

.PARAMETER Bleed
    When set, the column set will bleed through its parent's padding.

.PARAMETER GridArea
    The area of a Layout.AreaGrid layout in which the element should be displayed.

.PARAMETER TargetWidth
    Controls for which card width the element should be displayed.
    Valid values: VeryNarrow, Narrow, Standard, Wide, atLeast:*, atMost:*.

.PARAMETER IsSortKey
    When set, the element will be used as a sort key.

.PARAMETER Lang
    The locale associated with the element.

.PARAMETER Requires
    A hashtable of capabilities the element requires the host application to support.

.PARAMETER Fallback
    A ScriptBlock that returns an alternate element to render if this element is unsupported.

.PARAMETER Hidden
    When set, the column set will not be visible.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the ColumnSet element structure for the Adaptive Card.

.EXAMPLE
    New-CardColumnSet -Columns {
        New-CardColumn -Width "auto" -Content {
            New-CardImage -Url "https://example.com/icon.png" -Size "Small"
        }
        New-CardColumn -Width "stretch" -Content {
            New-CardTextBlock -Text "Title" -Weight "Bolder"
            New-CardTextBlock -Text "Description text"
        }
    }

    Creates a two-column layout with an image in the first column (auto-sized) and text in the second column (stretched).

.EXAMPLE
    New-CardColumnSet -Style "Emphasis" -Columns {
        New-CardColumn -Width 1 -Content {
            New-CardTextBlock -Text "Column 1"
        }
        New-CardColumn -Width 2 -Content {
            New-CardTextBlock -Text "Column 2 (twice as wide)"
        }
    }

    Creates a column set with emphasis styling where the second column is twice as wide as the first.

.EXAMPLE
    New-CardColumnSet -SelectAction (New-CardActionOpenUrl -Url "https://example.com") -Columns {
        New-CardColumn -Width "auto" -Content {
            New-CardIcon -Name "Link"
        }
        New-CardColumn -Width "stretch" -Content {
            New-CardTextBlock -Text "Click anywhere to open link"
        }
    }

    Creates a clickable column set that opens a URL when tapped.

.NOTES
    - Column widths can be "auto", "stretch", a pixel width like "50px", or a relative number (e.g., 1, 2)
    - Use New-CardColumn to define individual columns within the ColumnSet
    - ColumnSets are useful for creating side-by-side layouts and responsive designs

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#columnset
#>
function New-CardColumnSet {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [scriptblock]
        $Columns,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Default", "Emphasis", "Accent", "Good", "Warning", "Attention")]
        [string]
        $Style = "Default",

        [Parameter(Mandatory = $false)]
        [string]
        $Id,

        [Parameter(Mandatory = $false)]
        [object]
        $SelectAction,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Left", "Center", "Right")]
        [string]
        $HorizontalAlignment,

        [Parameter(Mandatory = $false)]
        [ValidateSet("auto", "stretch")]
        [string]
        $Height,

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
        [switch]
        $Bleed,

        [Parameter(Mandatory = $false)]
        [string]
        $GridArea,

        [Parameter(Mandatory = $false)]
        [ValidateSet("VeryNarrow", "Narrow", "Standard", "Wide", "atLeast:VeryNarrow", "atMost:VeryNarrow", "atLeast:Narrow", "atMost:Narrow", "atLeast:Standard", "atMost:Standard", "atLeast:Wide", "atMost:Wide")]
        [string]
        $TargetWidth,

        [Parameter(Mandatory = $false)]
        [switch]
        $IsSortKey,

        [Parameter(Mandatory = $false)]
        [string]
        $Lang,

        [Parameter(Mandatory = $false)]
        [hashtable]
        $Requires,

        [Parameter(Mandatory = $false)]
        [scriptblock]
        $Fallback,

        [Alias('Hide')]
        [Parameter(Mandatory = $false)]
        [switch]
        $Hidden
    )

    $ColumnSetObj = @{
        type    = "ColumnSet"
        columns = [System.Collections.ArrayList]@()
    }

    if ($PSBoundParameters.ContainsKey('Style') -and $Style -ne "Default") {
        $ColumnSetObj.style = $Style.ToLower()
    }

    if ($PSBoundParameters.ContainsKey('Id')) {
        $ColumnSetObj.id = $Id
    }

    if ($PSBoundParameters.ContainsKey('SelectAction')) {
        $ColumnSetObj.selectAction = $SelectAction
    }

    if ($PSBoundParameters.ContainsKey('HorizontalAlignment')) {
        $ColumnSetObj.horizontalAlignment = $HorizontalAlignment
    }

    if ($PSBoundParameters.ContainsKey('Height')) {
        $ColumnSetObj.height = $Height
    }

    if ($PSBoundParameters.ContainsKey('MinHeight')) {
        $ColumnSetObj.minHeight = "${MinHeight}px"
    }

    if ($PSBoundParameters.ContainsKey('Spacing') -and $Spacing -ne "Default") {
        $ColumnSetObj.spacing = $Spacing
    }

    if ($Separator) {
        $ColumnSetObj.separator = $true
    }

    if ($Bleed) {
        $ColumnSetObj.bleed = $true
    }

    if ($PSBoundParameters.ContainsKey('GridArea')) {
        $ColumnSetObj.'grid.area' = $GridArea
    }

    if ($PSBoundParameters.ContainsKey('TargetWidth')) {
        $ColumnSetObj.targetWidth = $TargetWidth
    }

    if ($IsSortKey) {
        $ColumnSetObj.isSortKey = $true
    }

    if ($Hidden) {
        $ColumnSetObj.isVisible = $false
    }

    if ($PSBoundParameters.ContainsKey('Lang')) {
        $ColumnSetObj.lang = $Lang
    }

    if ($PSBoundParameters.ContainsKey('Requires')) {
        $ColumnSetObj.requires = $Requires
    }

    if ($PSBoundParameters.ContainsKey('Fallback')) {
        $ColumnSetObj.fallback = Invoke-Command -ScriptBlock $Fallback
    }

    # Execute the Columns scriptblock to get column definitions
    $ColumnsResult = Invoke-Command -ScriptBlock $Columns

    if ($ColumnsResult -is [array]) {
        [void]($ColumnSetObj.columns.AddRange($ColumnsResult))
    }
    else {
        [void]($ColumnSetObj.columns.Add($ColumnsResult))
    }

    if ($PSCmdlet.ShouldProcess("Creating ColumnSet element with $($ColumnSetObj.columns.Count) column(s)")) {
        return $ColumnSetObj
    }
}
