<#
.SYNOPSIS
    Creates a new Action.ResetInputs element that resets specified input fields in an Adaptive Card.

.DESCRIPTION
    The New-CardActionResetInputs function creates an Action.ResetInputs element that clears
    the values of specified input fields when clicked or tapped. This is useful for creating
    forms where users need to clear multiple input fields at once, such as "Clear Form" or
    "Reset" functionality in Adaptive Cards.

.PARAMETER Title
    The text to display on the action button. This is what users will see and click to reset
    the input fields (e.g., "Reset Form", "Clear All", "Start Over").

.PARAMETER TargetInputIds
    An array of input element IDs that should be reset when the action is triggered. Only
    input elements with matching IDs will be cleared. If not specified, all input fields
    in the card will be reset.

.PARAMETER Id
    An optional unique identifier for the action. Useful for tracking action usage or for
    accessibility purposes.

.PARAMETER Style
    The visual style of the action button. Valid values are:
    - default: Standard button appearance
    - positive: Positive/success styling (typically green or blue)
    - destructive: Destructive/warning styling (typically red) - useful for reset actions

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
    An alternate action to render if Action.ResetInputs is not supported by the host application.
    Can be a scriptblock that returns another action or the string "drop" to hide the action.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the Action.ResetInputs structure for the Adaptive Card.

.EXAMPLE
    New-CardActionResetInputs -Title "Clear Form"

    Creates a reset action that clears all input fields in the card.

.EXAMPLE
    New-CardActionResetInputs -Title "Reset User Info" -TargetInputIds @("NameInput", "EmailInput", "PhoneInput")

    Creates a reset action that only clears the specified input fields.

.EXAMPLE
    New-CardActionResetInputs -Title "Start Over" -Style "destructive" -IconUrl "refresh,regular" -Tooltip "Clear all entered data"

    Creates a reset action with destructive styling, an icon, and a tooltip.

.EXAMPLE
    $resetAction = New-CardActionResetInputs -Title "Reset" -TargetInputIds @("SearchBox") -Id "SearchReset"

    Creates a reset action for a specific search input with an action ID.

.NOTES
    - Action.ResetInputs was introduced in Adaptive Cards schema version 1.5
    - Target input elements must have unique IDs for selective reset functionality
    - If TargetInputIds is not specified, all input fields in the card will be reset
    - This action only affects input elements (Input.Text, Input.Number, Input.Date, etc.)
    - The reset action clears values but does not change other input properties like placeholder text
    - Consider using destructive styling for reset actions to make their impact clear to users

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionresetinputs
#>
function New-CardActionResetInputs {
    [system.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'ResetInputs action is a singular concept')]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        [string[]]$TargetInputIds,

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
        [Object]$Fallback
    )

    $ResetInputsAction = @{
        type  = "Action.ResetInputs"
        title = $Title
    }
    # Apply default fallback from settings if none provided and default is set
    if ($Null -eq $Fallback -and $_MvRACSettings.General.DefaultFallback) {
        $Fallback = [scriptblock]::Create($_MvRACSettings.General.DefaultFallback)
    }

    if ($TargetInputIds -and $TargetInputIds.Count -gt 0) {
        $ResetInputsAction.targetInputIds = $TargetInputIds
    }

    if ($Id) {
        $ResetInputsAction.id = $Id
    }

    if ($Style) {
        $ResetInputsAction.style = $Style
    }

    if ($IconUrl) {
        $ResetInputsAction.iconUrl = $IconUrl
    }

    if (-not $IsEnabled) {
        $ResetInputsAction.isEnabled = $IsEnabled
    }

    if ($Mode -ne "primary") {
        $ResetInputsAction.mode = $Mode
    }

    if ($Tooltip) {
        $ResetInputsAction.tooltip = $Tooltip
    }

    if ($Fallback) {
        if ($Fallback -is [scriptblock]) {
            $ResetInputsAction.fallback = Invoke-Command -ScriptBlock $Fallback
        }
        else {
            $ResetInputsAction.fallback = $Fallback
        }
    }

    if ($PSCmdlet.ShouldProcess("Creating ResetInputs action with title '$Title'")) {
        return $ResetInputsAction
    }
}