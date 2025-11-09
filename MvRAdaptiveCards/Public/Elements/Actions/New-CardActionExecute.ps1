<#
.SYNOPSIS
    Creates a new Action.Execute element for executing bot commands in Adaptive Cards.

.DESCRIPTION
    The New-CardActionExecute function creates an Action.Execute element that sends data to a bot
    or backend service when clicked or tapped. This action is commonly used in bot frameworks
    like Microsoft Bot Framework to trigger specific bot behaviors, execute commands, or
    initiate workflows based on user interaction.

.PARAMETER Title
    The text to display on the action button. This is what users will see and click to
    execute the action (e.g., "Submit Order", "Get Weather", "Process Request").

.PARAMETER Verb
    The verb of the action that identifies what operation should be performed. This is
    typically used by the bot or backend service to determine how to handle the request.
    Examples include "submitOrder", "getWeather", "processPayment", etc.

.PARAMETER Data
    The data to send to the bot when the action is executed. Can be either:
    - Object: Data is sent along with input values as key/value pairs
    - String: Only the string data is sent, input values are ignored
    - ScriptBlock: Executed to generate the data object

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

.PARAMETER AssociatedInputs
    Controls which input values are sent with the action. Valid values are:
    - "auto": All input values in the card are sent (default behavior)
    - "none": No input values are sent, only the Data parameter content

.PARAMETER ConditionallyEnabled
    Controls if the action is enabled only when at least one required input has been
    filled by the user. This is a Teams-specific feature. Default is $false.

.PARAMETER Fallback
    An alternate action to render if Action.Execute is not supported by the host application.
    Can be a scriptblock that returns another action or the string "drop" to hide the action.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the Action.Execute structure for the Adaptive Card.

.EXAMPLE
    New-CardActionExecute -Title "Submit Order" -Verb "submitOrder"

    Creates an execute action that submits an order with all input values.

.EXAMPLE
    New-CardActionExecute -Title "Get Weather" -Verb "getWeather" -Data @{ location = "Seattle" }

    Creates an execute action with specific data payload.

.EXAMPLE
    New-CardActionExecute -Title "Process Payment" -Verb "processPayment" -Style "positive" -IconUrl "payment,regular"

    Creates an execute action with positive styling and an icon.

.EXAMPLE
    $executeAction = New-CardActionExecute -Title "Advanced Search" -Verb "search" -AssociatedInputs "none" -Data { @{ searchType = "advanced" } }

    Creates an execute action that doesn't send input values, only custom data.

.EXAMPLE
    New-CardActionExecute -Title "Submit Form" -Verb "submitForm" -ConditionallyEnabled $true -Tooltip "Complete required fields to enable"

    Creates a conditionally enabled execute action for Teams.

.NOTES
    - Action.Execute was introduced in Adaptive Cards schema version 1.4
    - The Verb parameter is used by bots to route and handle different types of actions
    - Data can be combined with input values or used independently
    - ConditionallyEnabled is a Teams-specific feature and may not work in other hosts
    - The action sends HTTP POST requests to the bot's messaging endpoint
    - Input validation occurs before the action is executed if AssociatedInputs is "auto"

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionexecute
#>
function New-CardActionExecute {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        [string]$Verb,

        [Parameter(Mandatory = $false)]
        [object]$Data,

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
        [ValidateSet("auto", "none")]
        [string]$AssociatedInputs = "auto",

        [Parameter(Mandatory = $false)]
        [bool]$ConditionallyEnabled = $false,

        [Parameter(Mandatory = $false)]
        [object]$Fallback
    )

    $ExecuteAction = @{
        type  = "Action.Execute"
        title = $Title
    }
    # Apply default fallback from settings if none provided and default is set
    if ($Null -eq $Fallback -and $_MvRACSettings.General.DefaultFallback) {
        $Fallback = [scriptblock]::Create($_MvRACSettings.General.DefaultFallback)
    }

    if ($Verb) {
        $ExecuteAction.verb = $Verb
    }

    if ($null -ne $Data) {
        if ($Data -is [scriptblock]) {
            $ExecuteAction.data = Invoke-Command -ScriptBlock $Data
        }
        else {
            $ExecuteAction.data = $Data
        }
    }

    if ($Id) {
        $ExecuteAction.id = $Id
    }

    if ($Style) {
        $ExecuteAction.style = $Style
    }

    if ($IconUrl) {
        $ExecuteAction.iconUrl = $IconUrl
    }

    if (-not $IsEnabled) {
        $ExecuteAction.isEnabled = $IsEnabled
    }

    if ($Mode -ne "primary") {
        $ExecuteAction.mode = $Mode
    }

    if ($Tooltip) {
        $ExecuteAction.tooltip = $Tooltip
    }

    if ($AssociatedInputs -ne "auto") {
        $ExecuteAction.associatedInputs = $AssociatedInputs
    }

    if ($ConditionallyEnabled) {
        $ExecuteAction.conditionallyEnabled = $ConditionallyEnabled
    }

    if ($Fallback) {
        if ($Fallback -is [scriptblock]) {
            $ExecuteAction.fallback = Invoke-Command -ScriptBlock $Fallback
        }
        else {
            $ExecuteAction.fallback = $Fallback
        }
    }

    if ($PSCmdlet.ShouldProcess("Creating Execute action with title '$Title' and verb '$Verb'")) {
        return $ExecuteAction
    }
}