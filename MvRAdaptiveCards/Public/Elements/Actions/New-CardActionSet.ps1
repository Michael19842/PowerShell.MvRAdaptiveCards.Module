<#
.SYNOPSIS
    Creates a new ActionSet element for an Adaptive Card to group multiple actions together.

.DESCRIPTION
    The New-CardActionSet function creates an ActionSet element that displays a collection of actions
    in an Adaptive Card. ActionSets are used to group related actions together and can be placed
    anywhere within a card's body, unlike the card-level actions which appear at the bottom.

.PARAMETER Actions
    An array of ScriptBlocks, each containing an action to include in the ActionSet.
    Each ScriptBlock should call an action function like New-CardActionToggleVisibility,
    New-CardActionShowCard, or other supported action types.

.PARAMETER Fallback
    An optional ScriptBlock that generates fallback content for clients that don't support
    ActionSet elements. The fallback content will be displayed instead of the ActionSet
    on unsupported clients.

.PARAMETER Id
    An optional unique identifier for the ActionSet element. Useful for referencing the element
    in other actions like toggle visibility or for accessibility purposes.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the ActionSet element structure for the Adaptive Card.

.EXAMPLE
    New-CardActionSet -Actions {
        New-CardActionToggleVisibility -Title "Show Details" -TargetElements @("DetailPanel")
        New-CardActionToggleVisibility -Title "Show Chart" -TargetElements @("ChartContainer")
    }

    Creates an ActionSet with two toggle visibility actions.

.EXAMPLE
    New-CardActionSet -Actions {
        New-CardActionShowCard -Title "Edit Profile" -Card {
            New-AdaptiveCard -AsObject -Content {
                New-CardTextBlock -Text "Edit your profile information"
            }
        }
    } -Id "ProfileActions"

    Creates an ActionSet with a ShowCard action and assigns an ID for reference.

.EXAMPLE
    New-CardActionSet -Actions {
        New-CardActionToggleVisibility -Title "Toggle Panel 1" -TargetElements @("Panel1")
        New-CardActionToggleVisibility -Title "Toggle Panel 2" -TargetElements @("Panel2")
    } -Fallback {
        New-CardTextBlock -Text "Actions not supported on this client"
    }

    Creates an ActionSet with fallback content for unsupported clients.

.NOTES
    - ActionSets are supported in Adaptive Cards schema version 1.2 and later
    - Unlike card-level actions, ActionSets can be placed anywhere in the card body
    - Each action in the Actions array is executed as a ScriptBlock to generate the action definition
    - The Fallback parameter helps ensure graceful degradation on clients that don't support ActionSets
    - ActionSets are useful for grouping related actions or placing actions within specific containers

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionset
#>
function New-CardActionSet {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [scriptblock[]]$Actions,

        [Parameter(Mandatory = $false)]
        [scriptblock]$Fallback,

        [string]
        [Parameter(Mandatory = $false)]
        $Id

    )

    $ActionSet = @{
        type    = "ActionSet"
        actions = @()
    }

    if ($Id) {
        $ActionSet.id = $Id
    }

    if ($Fallback) {
        $ActionSet.fallback = Invoke-Command -ScriptBlock $Fallback
    }

    foreach ($Action in $Actions) {
        $ActionSet.actions += Invoke-Command -ScriptBlock $Action
    }

    if ( $PSCmdlet.ShouldProcess("Creating ActionSet element with ID '$Id'." ) ) {
        return $ActionSet
    }
}