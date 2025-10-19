<#
.SYNOPSIS
    Creates an Icon element for an Adaptive Card using Fluent UI icons.

.DESCRIPTION
    The New-CardIcon function creates an Icon element for Adaptive Cards using the Fluent UI icon library.
    Icons are visual elements that can represent actions, objects, or concepts in your card. This function
    supports customization of icon appearance including color, size, style, and layout properties.

    The icon names are validated against the Fluent UI icon collection and include tab completion for ease of use.
    Icons can be styled with different colors, sizes (from xxSmall to xxLarge), and styles (Regular or Filled).
    You can also add interactive behavior with SelectAction and provide fallback content for unsupported scenarios.

.PARAMETER Name
    The name of the Fluent UI icon to display. This parameter supports tab completion and validation against
    the available icon collection. Examples include "Calendar", "Mail", "Shield", "Warning", "Error", etc.

.PARAMETER Color
    Specifies the color scheme for the icon. Valid values are:
    - Default: Uses the theme's default icon color
    - Dark: Dark color variant
    - Light: Light color variant
    - Accent: Uses the theme's accent color
    - Good: Green color, typically used for success or positive states
    - Warning: Orange/yellow color, used for warnings
    - Attention: Red color, used for errors or critical states
    Default value is "Default".

.PARAMETER Size
    Controls the size of the icon. Valid values are:
    - xxSmall: Extra extra small
    - xSmall: Extra small
    - Small: Small size
    - Standard: Standard size (default)
    - Medium: Medium size
    - Large: Large size
    - xLarge: Extra large
    - xxLarge: Extra extra large
    Default value is "Standard".

.PARAMETER Style
    Determines the visual style of the icon. Valid values are:
    - Regular: Outline style (default)
    - Filled: Solid filled style
    Default value is "Regular".

.PARAMETER Spacing
    Controls the amount of spacing above the icon. Valid values are:
    - None: No spacing
    - Small: Small spacing
    - Default: Default spacing
    - Medium: Medium spacing
    - Large: Large spacing
    - ExtraLarge: Extra large spacing

.PARAMETER TargetWidth
    Specifies the target width for the icon in adaptive layouts. Valid values include:
    - VeryNarrow, Narrow, Standard, Wide
    - atLeast:VeryNarrow, atMost:VeryNarrow, etc.

.PARAMETER SelectAction
    A scriptblock that defines the action to perform when the icon is selected/clicked.
    The scriptblock should return an Adaptive Card action element.

.PARAMETER Fallback
    A scriptblock that defines fallback content to display if the icon cannot be rendered
    or is not supported by the host. Should return an appropriate Adaptive Card element.

.PARAMETER Id
    A unique identifier for the icon element. Useful for referencing the element programmatically.

.PARAMETER Lang
    Specifies the language/locale for the icon element.

.PARAMETER HorizontalAlignment
    Controls the horizontal alignment of the icon within its container. Valid values are:
    - Left: Aligns the icon to the left side
    - Center: Centers the icon horizontally
    - Right: Aligns the icon to the right side

.PARAMETER GridArea
    Specifies the named grid area where the icon should be placed when used in a grid layout.
    This corresponds to the CSS grid-area property.

.PARAMETER IsVisible
    Controls whether the icon is visible. When specified, the icon will be visible.
    When not specified or set to $false, the icon will be hidden.

.PARAMETER isSortKey
    When specified, marks this icon as a sort key element.

.PARAMETER separator
    When specified, adds a separator line above the icon.

.OUTPUTS
    System.Collections.Hashtable
    Returns a hashtable representing the Icon element that can be used in an Adaptive Card.

.EXAMPLE
    New-CardIcon -Name "Calendar"

    Creates a basic calendar icon with default settings (Standard size, Default color, Regular style).

.EXAMPLE
    New-CardIcon -Name "Mail" -Color "Accent" -Size "Large"

    Creates a mail icon with accent color and large size.

.EXAMPLE
    New-CardIcon -Name "Shield" -Style "Filled" -Color "Good" -HorizontalAlignment "Center"

    Creates a filled shield icon in good (green) color, centered horizontally.

.EXAMPLE
    New-CardIcon -Name "Warning" -Color "Warning" -SelectAction {
        New-CardActionOpenUrl -Url "https://example.com/help"
    }

    Creates a warning icon that opens a URL when clicked.

.EXAMPLE
    New-CardIcon -Name "Error" -Color "Attention" -Id "error-icon" -Spacing "Medium" -separator

    Creates an error icon with attention color, medium spacing, and a separator above it.

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#icon

.NOTES
    This function is part of the MvRAdaptiveCards module for creating Adaptive Cards in PowerShell.
    The icon names correspond to the Fluent UI icon library.
#>
function New-CardIcon {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript( {
                if ( $_AdaptiveCardIconCollection -contains $_ ) {
                    return $true
                }
                else {
                    throw "Invalid icon name '$_'. Valid names are: $($_AdaptiveCardIconCollection -join ', ')"
                }
            } )]
        [String]$Name,
        [ValidateSet("Default", "Dark", "Light", "Accent", "Good", "Warning", "Attention")]
        [string]$Color ,
        [ValidateSet("xxSmall", "xSmall", "Small", "Standard", "Medium", "Large", "xLarge", "xxLarge")]
        [string]$Size ,
        [ValidateSet("Regular", "Filled")]
        [string]$Style ,

        [parameter(Mandatory = $false)]
        [ValidateSet("None", "Small", "Default", "Medium", "Large", "ExtraLarge")]
        [string]$Spacing,

        [parameter(Mandatory = $false)]
        [ValidateSet("VeryNarrow", "Narrow", "Standard", "Wide", "atLeast:VeryNarrow", "atMost:VeryNarrow", "atLeast:Narrow", "atMost:Narrow", "atLeast:Standard", "atMost:Standard", "atLeast:Wide", "atMost:Wide")]
        [string]$TargetWidth,

        [scriptblock]$SelectAction,

        [scriptblock]$Fallback,

        [Parameter(Mandatory = $false)]
        [string]
        $Id,

        [Parameter(Mandatory = $false)]
        [string]
        $Lang,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Left", "Center", "Right")]
        [string]$HorizontalAlignment,

        [Parameter(Mandatory = $false)]
        [string]$GridArea,

        [Alias("Hide")]
        [switch] $IsHidden,
        [switch] $isSortKey,
        [switch] $separator
    )

    $Icon = @{
        type = "Icon"
        name = $Name
    }

    if ($Color) {
        $Icon.color = $Color
    }
    if ($Size ) {
        $Icon.size = $Size
    }
    if ($Style) {
        $Icon.style = $Style
    }

    if ($SelectAction) {
        $Icon.selectAction = Invoke-Command -ScriptBlock $SelectAction
    }

    if ($Fallback) {
        $Icon.fallback = Invoke-Command -ScriptBlock $Fallback
    }
    if ($Id) {
        $Icon.id = $Id
    }

    if ($IsHidden) {
        $Icon.isVisible = $false
    }

    if ($isSortKey ) {
        $Icon.isSortKey = $true
    }

    if ($separator -eq $true) {
        $Icon.separator = $true
    }

    if ($Lang) {
        $Icon.lang = $Lang
    }

    if ($Spacing) {
        $Icon.spacing = $Spacing
    }

    if ($TargetWidth) {
        $Icon.targetWidth = $TargetWidth
    }
    if ($HorizontalAlignment) {
        $Icon.horizontalAlignment = $HorizontalAlignment
    }
    if ($GridArea) {
        $Icon."grid.area" = $GridArea
    }

    if ( $PSCmdlet.ShouldProcess("Creating Icon element with name '$Name'." ) ) {
        return ($Icon)
    }
}

