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

.PARAMETER Size
    The size of the text. Common values include:
    - Default: Standard text size
    - Small: Smaller than default
    - Medium: Medium size text
    - Large: Large text
    - ExtraLarge: Extra large text
    Default value is "Default".

.PARAMETER Weight
    The weight (boldness) of the text. Common values include:
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
    An optional unique identifier for the TextBlock element. Useful for referencing the element
    in actions like toggle visibility or for accessibility purposes.

.PARAMETER Wrap
    A switch parameter that enables text wrapping. When specified, long text will wrap to multiple
    lines instead of being truncated. Without this parameter, text may be clipped if it exceeds the available width.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the TextBlock element structure for the Adaptive Card.

.EXAMPLE
    New-CardTextBlock -Text "Welcome to our application!" -Size "Large" -Weight "Bolder"

    Creates a large, bold welcome message.

.EXAMPLE
    New-CardTextBlock -Text "This is a warning message" -Color "Warning" -Wrap

    Creates a warning-colored text block with wrapping enabled and an emoji icon.

.EXAMPLE
    New-CardTextBlock -Text "Status: System is operational" -Color "Good" -Id "StatusText"

    Creates a success-colored status message with an ID for potential reference in actions.

.EXAMPLE
    New-CardTextBlock -Text "This is a very long text that should wrap to multiple lines when displayed" -Wrap

    Creates a text block with wrapping enabled for long content.

.NOTES
    - The Size and Weight parameters accept string values that correspond to Adaptive Card schema values
    - Color values map to the host application's theme colors
    - The Wrap parameter is essential for longer text content to ensure readability
    - Markdown formatting support depends on the host application (Teams, Outlook, etc.)
    - The Id parameter is optional but recommended when the text needs to be referenced by actions

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#textblock
#>
function New-CardTextBlock {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [string]
        $Text,
        [string]
        $Size = "Default",
        [string]
        $Weight = "Default",
        [string]
        [ValidateSet("Default", "Dark", "Light", "Accent", "Good", "Warning", "Attention")]
        $Color = "Default",
        [string]
        [Parameter(Mandatory = $false)]
        $Id,
        [switch]
        $Wrap
    )

    $TextBlock = @{
        type   = "TextBlock"
        text   = $Text
        size   = $Size
        weight = $Weight
        color  = $Color
    }
    if ($Id) {
        $TextBlock.id = $Id
    }
    if ($Wrap) {
        $TextBlock.wrap = $true
    }

    if ( $PSCmdlet.ShouldProcess("Creating TextBlock element with text '$Text'." ) ) {
        return $TextBlock
    }
}