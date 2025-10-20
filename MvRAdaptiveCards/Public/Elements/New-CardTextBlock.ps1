<#
.SYNOPSIS
    Creates a new TextBlock element for an Adaptive Card.

.DESCRIPTION
    The New-CardTextBlock function creates a TextBlock element that displays text content in an Adaptive Card.
    TextBlocks support various formatting options including size, weight, color, and text wrapping.
    They are fundamental building blocks for displaying textual information in Adaptive Cards.

.PARAMETER Text
    The text content to display in the TextBlock. Supports plain text and Markdown formatting
    depending on the host application's capabilities.

.PARAMETER labelFor
    Specifies the ID of another element that this TextBlock serves as a label for.
    This is used for accessibility purposes to associate labels with form elements.

.PARAMETER MaximumNumberOfLines
    The maximum number of lines to display. Text that exceeds this limit will be truncated.
    Alias: MaxLines

.PARAMETER Style
    The text style to apply. Valid values are:
    - default: Standard text style
    - columnHeader: Styled as a column header
    - heading: Styled as a heading

.PARAMETER Height
    Controls the height behavior of the TextBlock. Valid values are:
    - auto: Height adjusts automatically to content (default)
    - stretch: TextBlock stretches to fill available vertical space

.PARAMETER HorizontalAlignment
    Controls the horizontal alignment of the text within its container. Valid values are:
    - Left: Aligns text to the left side
    - Center: Centers text horizontally
    - Right: Aligns text to the right side

.PARAMETER GridArea
    Specifies the named grid area where the TextBlock should be placed when used in a grid layout.
    This corresponds to the CSS grid-area property.

.PARAMETER Weight
    The weight (boldness) of the text. Valid values are:
    - Default: Normal text weight
    - Lighter: Lighter than normal
    - Bolder: Bold text
    Default value is "Default".

.PARAMETER Color
    The color scheme to apply to the text. Valid values are:
    - Default: Default text color
    - Dark: Dark text color
    - Light: Light text color
    - Accent: Accent color (typically blue)
    - Good: Success/positive color (typically green)
    - Warning: Warning color (typically orange/yellow)
    - Attention: Attention/error color (typically red)
    Default value is "Default".

.PARAMETER Id
    A unique identifier for the TextBlock element. Useful for referencing the element
    in actions like toggle visibility or for accessibility purposes.

.PARAMETER FontType
    The font family to use for the text. Valid values are:
    - Default: Default system font
    - Monospace: Monospace font for code or data display

.PARAMETER Fallback
    A scriptblock that defines fallback content to display if the TextBlock cannot be rendered
    or is not supported by the host. Should return an appropriate Adaptive Card element.

.PARAMETER Requires
    A hashtable specifying feature requirements for the TextBlock. Used to declare dependencies
    on specific Adaptive Card features or host capabilities.

.PARAMETER Language
    Specifies the language/locale for the TextBlock element. Used for proper text rendering
    and accessibility features. Alias: Lang

.PARAMETER Size
    The size of the text. Valid values are:
    - Small: Smaller than default
    - Default: Standard text size
    - Medium: Medium size text
    - Large: Large text
    - ExtraLarge: Extra large text

.PARAMETER Spacing
    Controls the amount of spacing above the TextBlock. Valid values are:
    - None: No spacing
    - Small: Small spacing
    - Default: Default spacing
    - Medium: Medium spacing
    - Large: Large spacing
    - ExtraLarge: Extra large spacing
    - Padding: Adds padding around the element

.PARAMETER Separator
    When specified, adds a separator line above the TextBlock to visually separate it from
    preceding content.

.PARAMETER Wrap
    When specified, enables text wrapping. Long text will wrap to multiple lines instead
    of being truncated. Essential for longer text content to ensure readability.

.PARAMETER IsSortKey
    When specified, marks this TextBlock as a sort key element. Used in scenarios where
    multiple elements need to be sorted or grouped.

.PARAMETER IsSubtle
    When specified, displays the text in a more subtle/muted appearance, typically with
    reduced opacity or lighter color.

.PARAMETER IsHidden
    When specified, sets the TextBlock to be hidden (isVisible = false). The element will
    not be displayed but can be shown programmatically. Alias: Hidden

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the TextBlock element structure for the Adaptive Card.

.EXAMPLE
    New-CardTextBlock -Text "Welcome to our application!" -Size "Large" -Weight "Bolder"

    Creates a large, bold welcome message.

.EXAMPLE
    New-CardTextBlock -Text "This is a warning message" -Color "Warning" -Wrap

    Creates a warning-colored text block with wrapping enabled.

.EXAMPLE
    New-CardTextBlock -Text "Status: System is operational" -Color "Good" -Id "StatusText"

    Creates a success-colored status message with an ID for potential reference in actions.

.EXAMPLE
    New-CardTextBlock -Text "This is a very long text that should wrap to multiple lines when displayed" -Wrap -MaximumNumberOfLines 3

    Creates a text block with wrapping enabled and limited to 3 lines maximum.

.EXAMPLE
    New-CardTextBlock -Text "Column Title" -Style "columnHeader" -HorizontalAlignment "Center" -Separator

    Creates a centered column header with a separator above it.

.EXAMPLE
    New-CardTextBlock -Text "Error Details:" -labelFor "error-input" -Color "Attention" -Weight "Bolder"

    Creates a label for another element with error styling.

.EXAMPLE
    New-CardTextBlock -Text "Code Example: console.log('Hello');" -FontType "Monospace" -IsSubtle

    Creates subtle monospace text, ideal for code snippets.

.NOTES
    - The Size and Weight parameters accept string values that correspond to Adaptive Card schema values
    - Color values map to the host application's theme colors
    - The Wrap parameter is essential for longer text content to ensure readability
    - Markdown formatting support depends on the host application (Teams, Outlook, etc.)
    - The Id parameter is useful when the text needs to be referenced by actions or used with labelFor
    - MaximumNumberOfLines works best in combination with Wrap to control text overflow
    - FontType "Monospace" is ideal for displaying code, data, or technical content
    - IsSubtle provides a less prominent text appearance for secondary information
    - Style parameter affects the semantic meaning and visual appearance of the text

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#textblock
#>
function New-CardTextBlock {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [string]
        $Text,

        [Parameter(Mandatory = $false)]
        [string]
        $labelFor,

        [Parameter(Mandatory = $false)]
        [Alias("MaxLines")]
        [int]
        $MaximumNumberOfLines,

        [Parameter(Mandatory = $false)]
        [string]
        [ValidateSet("default", "columnHeader", "heading")]
        $Style,

        [Parameter(Mandatory = $false)]
        [ValidateSet("auto", "stretch")]
        [string]
        $Height,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Left", "Center", "Right")]
        [string]
        $HorizontalAlignment,

        [Parameter(Mandatory = $false)]
        [string]
        $GridArea,

        [Parameter(Mandatory = $false)]
        [validateSet("Default", "Lighter", "Bolder")]
        [string]
        $Weight = "Default",
        [string]
        [ValidateSet("Default", "Dark", "Light", "Accent", "Good", "Warning", "Attention")]
        $Color = "Default",

        [string]
        [Parameter(Mandatory = $false)]
        $Id,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Default", "Monospace")]
        [string]
        $FontType,

        [parameter(Mandatory = $false)]
        [scriptblock]
        $Fallback,

        [parameter(Mandatory = $false)]
        [hashtable]
        $Requires,

        [Parameter(Mandatory = $false)]
        [Alias("Lang")]
        [string]
        $Language,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Small", "Default", "Medium", "Large", "ExtraLarge")]
        [string]
        $Size,

        [parameter(Mandatory = $false)]
        [ValidateSet("None", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")]
        [string]
        $Spacing,

        [switch]
        $Separator,

        [switch]
        $Wrap,

        [switch]
        $IsSortKey,

        [switch]
        $IsSubtle,


        [alias("Hidden")]
        [switch]
        $IsHidden


    )

    $TextBlock = @{
        type = "TextBlock"
        text = $Text
    }
    if ($Size) {
        $TextBlock.size = $Size
    }

    if ($Weight) {
        $TextBlock.weight = $Weight
    }
    if ($Color) {
        $TextBlock.color = $Color
    }

    if ($Id) {
        $TextBlock.id = $Id
    }
    if ($Wrap) {
        $TextBlock.wrap = $true
    }
    if ($labelFor) {
        $TextBlock.labelFor = $labelFor
    }
    if ($null -ne $MaximumNumberOfLines) {
        $TextBlock.maxLines = $MaximumNumberOfLines
    }
    if ($Style) {
        $TextBlock.style = $Style
    }
    if ($FontType) {
        $TextBlock.fontType = $FontType
    }
    if ($Height) {
        $TextBlock.height = $Height
    }
    if ($HorizontalAlignment) {
        $TextBlock.horizontalAlignment = $HorizontalAlignment
    }
    if ($GridArea) {
        $TextBlock.gridArea = $GridArea
    }
    if ($Spacing) {
        $TextBlock.spacing = $Spacing
    }
    if ($Separator) {
        $TextBlock.separator = $true
    }
    if ($IsSortKey) {
        $TextBlock.isSortKey = $true
    }
    if ($IsSubtle) {
        $TextBlock.isSubtle = $true
    }
    if ($IsHidden) {
        $TextBlock.isVisible = $false
    }
    if ($Requires) {
        $TextBlock.requires = $Requires
    }
    if ($Fallback) {
        $TextBlock.fallback = Invoke-Command -ScriptBlock $Fallback
    }
    if ($Language) {
        $TextBlock.lang = $Language
    }


    if ( $PSCmdlet.ShouldProcess("Creating TextBlock element with text '$Text'." ) ) {
        return $TextBlock
    }
}