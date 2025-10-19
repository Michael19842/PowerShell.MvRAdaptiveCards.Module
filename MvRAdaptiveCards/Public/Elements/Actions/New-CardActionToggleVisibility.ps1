<#
.SYNOPSIS
    Creates a new Action.ToggleVisibility element that shows or hides targeted card elements.

.DESCRIPTION
    The New-CardActionToggleVisibility function creates an Action.ToggleVisibility element that toggles
    the visibility of specified card elements when clicked or tapped. This is useful for creating
    interactive cards where users can show/hide sections, details, or supplementary information
    without leaving the card context.

.PARAMETER TargetElements
    An array of element IDs that will be toggled when the action is triggered. Each element
    must have an ID assigned for the toggle action to work. Elements with matching IDs will
    have their visibility state inverted (visible becomes hidden, hidden becomes visible).

.PARAMETER Title
    The text to display on the action button. This is what users will see and click to toggle
    the visibility of the target elements.

.PARAMETER Style
    The visual style of the action button. Valid values are:
    - default: Standard button appearance
    - positive: Positive/success styling (typically green or blue)
    - destructive: Destructive/warning styling (typically red)

    The actual appearance depends on the host application's theme and implementation.
    Note: This parameter is defined but may not be fully implemented in the current function.

.PARAMETER Id
    An optional unique identifier for the action. Useful for tracking action usage or for accessibility purposes.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the Action.ToggleVisibility structure for the Adaptive Card.

.EXAMPLE
    New-CardActionToggleVisibility -Title "Show Details" -TargetElements @("DetailPanel", "AdditionalInfo")

    Creates a toggle action that shows/hides elements with IDs "DetailPanel" and "AdditionalInfo".

.EXAMPLE
    New-CardActionToggleVisibility -Title "Toggle Chart" -TargetElements @("SalesChart") -Id "ChartToggle"

    Creates a toggle action for a single chart element with an emoji icon and an action ID.

.EXAMPLE
    New-CardActionToggleVisibility -Title "Hide Sensitive Data" -TargetElements @("SSN", "CreditCard", "BankAccount") -Style "destructive"

    Creates a toggle action to hide multiple sensitive data fields with destructive styling.

.NOTES
    - All target elements must have unique IDs set for the toggle action to function properly
    - Elements are toggled individually - if some are visible and others hidden, they will all switch states
    - ToggleVisibility actions are supported in Adaptive Cards schema version 1.2 and later
    - The initial visibility state of target elements is determined by their isVisible property (default: true)
    - This action type provides a way to create collapsible sections and progressive disclosure interfaces
    - The Style parameter is defined in the function but may require additional implementation

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actiontogglevisibility
#>
function New-CardActionToggleVisibility {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]

    param (
        [Parameter(Mandatory = $true)]
        [string[]]$TargetElements,

        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        [ValidateSet("default", "positive", "destructive")]
        [string]$Style,

        [Parameter(Mandatory = $false)]
        [string]$Id

    )

    $ToggleVisibilityAction = @{
        type  = "Action.ToggleVisibility"
        title = $Title
    }

    if ($TargetElements) {
        $ToggleVisibilityAction.targetElements = $TargetElements
    }


    if ($Id) {
        $ToggleVisibilityAction.id = $Id
    }

    if ($Style) {
        $ToggleVisibilityAction.style = $Style
    }

    if ( $PSCmdlet.ShouldProcess("Creating ToggleVisibility action with title '$Title'." ) ) {
        return $ToggleVisibilityAction
    }
}