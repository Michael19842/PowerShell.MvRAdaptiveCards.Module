<#
.SYNOPSIS
    Creates a new Action.Popover element that displays content in a popup overlay.

.DESCRIPTION
    The New-CardActionPopover function creates an Action.Popover element that displays
    additional content in a popup or overlay when clicked or tapped. This action type
    is useful for showing detailed information, forms, or interactive content without
    navigating away from the current card context. The popover can contain any valid
    Adaptive Card elements including text, images, inputs, and even nested actions.

.PARAMETER Title
    The text to display on the action button. This is what users will see and click to
    open the popover (e.g., "More Details", "Show Form", "View Information").

.PARAMETER Card
    The Adaptive Card content to display in the popover. This can be a complete card
    definition created using other New-Card* cmdlets from this module. The card content
    will be rendered in the popup overlay when the action is triggered.

.PARAMETER Id
    An optional unique identifier for the action. Useful for tracking action usage or for
    accessibility purposes.

.PARAMETER Style
    The visual style of the action button. Valid values are:
    - default: Standard button appearance
    - positive: Positive/success styling (typically green or blue)
    - destructive: Destructive/warning styling (typically red)

    The actual appearance depends on the host application's theme and implementation.

.PARAMETER IconUrl
    A URL (or Base64-encoded Data URI) to a PNG, GIF, JPEG or SVG image to be displayed
    on the left of the action's title. Also accepts icon names from the Adaptive Card
    icon catalog in the format <icon-name>[,regular|filled].

.PARAMETER IsEnabled
    Controls whether the action is enabled or disabled. When set to $false, the action
    cannot be clicked and will appear disabled. Default is $true.

.PARAMETER Mode
    Controls if the action is primary or secondary. Secondary actions appear in an overflow menu.
    Valid values are "primary" and "secondary". Default is "primary".

.PARAMETER Tooltip
    The tooltip text to display when the action is hovered over.

.PARAMETER Fallback
    An alternate action to render if Action.Popover is not supported by the host application.
    Can be a scriptblock that returns another action or the string "drop" to hide the action.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the Action.Popover structure for the Adaptive Card.

.EXAMPLE
    New-CardActionPopover -Title "Show Details" -Card {
        New-CardContainer -Content {
            New-CardTextBlock -Text "Additional Information" -Weight "Bolder"
            New-CardTextBlock -Text "This content appears in a popup overlay."
        }
    }

    Creates a popover action that displays additional content in an overlay.

.EXAMPLE
    $detailCard = New-CardContainer -Content {
        New-CardTextBlock -Text "Product Details" -Size "Large" -Weight "Bolder"
        New-CardFactSet -Facts @{
            "Price" = "$99.99"
            "Availability" = "In Stock"
            "Rating" = "4.5 stars"
        }
    }
    New-CardActionPopover -Title "View Details" -Card $detailCard -IconUrl "info,regular"

    Creates a popover with detailed product information and an info icon.

.EXAMPLE
    New-CardActionPopover -Title "Quick Form" -Card {
        New-CardContainer -Content {
            New-CardTextBlock -Text "Contact Form" -Weight "Bolder"
            New-CardInputText -Id "name" -Placeholder "Your Name"
            New-CardInputText -Id "email" -Placeholder "Your Email"
            New-CardActionSubmit -Title "Submit" -Id "submitContact"
        }
    } -Style "positive"

    Creates a popover containing a simple contact form with positive styling.

.EXAMPLE
    New-CardActionPopover -Title "Help" -Card {
        New-CardContainer -Content {
            New-CardTextBlock -Text "Need Help?" -Weight "Bolder"
            New-CardTextBlock -Text "Contact support for assistance with your order."
            New-CardActionOpenUrl -Title "Contact Support" -Url "https://support.company.com"
        }
    } -Fallback { New-CardActionOpenUrl -Title "Help" -Url "https://help.company.com" }

    Creates a popover with help content and a fallback action for unsupported hosts.

.NOTES
    - Action.Popover is a preview feature and may not be supported in all Adaptive Cards hosts
    - The popover content should be designed to work well in an overlay/modal context
    - Consider the size and complexity of the popover content for good user experience
    - Popovers can contain interactive elements including inputs and actions
    - The card parameter accepts the same content structure as a full Adaptive Card
    - Not all hosts may support popover actions, so consider providing fallback actions
    - Popover actions are typically rendered as buttons that open modal dialogs or overlays

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionpopover
#>
function New-CardActionPopover {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $true)]
        [scriptblock]$Card,

        [Parameter(Mandatory = $false)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [ValidateSet("default", "positive", "destructive")]
        [string]$Style = "default",

        [Parameter(Mandatory = $false)]
        [string]$IconUrl,

        [Parameter(Mandatory = $false)]
        [bool]$IsEnabled = $true,

        [Parameter(Mandatory = $false)]
        [ValidateSet("primary", "secondary")]
        [string]$Mode = "primary",

        [Parameter(Mandatory = $false)]
        [string]$Tooltip,

        [Parameter(Mandatory = $false)]
        [object]$Fallback
    )

    $PopoverAction = @{
        type  = "Action.Popover"
        title = $Title
    }

    # Apply default fallback from settings if none provided and default is set
    if ($Null -eq $Fallback -and $_MvRACSettings.General.DefaultFallback) {
        $Fallback = [scriptblock]::Create($_MvRACSettings.General.DefaultFallback)
    }
    # Execute the card scriptblock to get the popover content
    if ($Card) {
        $PopoverAction.card = Invoke-Command -ScriptBlock $Card
    }

    if ($Id) {
        $PopoverAction.id = $Id
    }

    if ($Style) {
        $PopoverAction.style = $Style
    }

    if ($IconUrl) {
        $PopoverAction.iconUrl = $IconUrl
    }

    if (-not $IsEnabled) {
        $PopoverAction.isEnabled = $IsEnabled
    }

    if ($Mode -ne "primary") {
        $PopoverAction.mode = $Mode
    }

    if ($Tooltip) {
        $PopoverAction.tooltip = $Tooltip
    }

    if ($Fallback) {
        if ($Fallback -is [scriptblock]) {
            $PopoverAction.fallback = Invoke-Command -ScriptBlock $Fallback
        }
        else {
            $PopoverAction.fallback = $Fallback
        }
    }

    if ($PSCmdlet.ShouldProcess("Creating Popover action with title '$Title'")) {
        return $PopoverAction
    }
}