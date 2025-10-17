<#
.SYNOPSIS
    Creates a new Action.ShowCard element that displays a card when the action is triggered.

.DESCRIPTION
    The New-CardActionShowCard function creates an Action.ShowCard element that, when clicked or tapped,
    reveals an inline card with additional content. This is useful for progressive disclosure of information,
    allowing users to reveal more details or input forms without navigating away from the main card.

.PARAMETER Card
    A ScriptBlock that generates the card content to be shown when the action is triggered.
    The ScriptBlock should typically call New-AdaptiveCard with -AsObject to create a nested card structure.

.PARAMETER Title
    The text to display on the action button. This is what users will see and click to reveal the card.

.PARAMETER Id
    An optional unique identifier for the action. Useful for tracking action usage or for accessibility purposes.

.PARAMETER Style
    The visual style of the action button. Valid values are:
    - default: Standard button appearance
    - positive: Positive/success styling (typically green or blue)
    - destructive: Destructive/warning styling (typically red)
    
    The actual appearance depends on the host application's theme and implementation.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the Action.ShowCard structure for the Adaptive Card.

.EXAMPLE
    New-CardActionShowCard -Title "Show Details" -Card {
        New-AdaptiveCard -AsObject -Content {
            New-CardTextBlock -Text "Here are the additional details..."
            New-CardFactSet -Facts @{
                "Created" = "2023-01-15"
                "Status" = "Active"
            }
        }
    }
    
    Creates a ShowCard action that reveals a card with details when clicked.

.EXAMPLE
    New-CardActionShowCard -Title "Edit Settings" -Style "positive" -Card {
        New-AdaptiveCard -AsObject -Content {
            New-CardTextBlock -Text "Configuration Options" -Weight "Bolder"
            New-CardContainer -Content {
                New-CardTextBlock -Text "Modify your preferences here"
            }
        }
    } -Id "EditAction"
    
    Creates a positive-styled ShowCard action for editing settings with an ID.

.EXAMPLE
    New-CardActionShowCard -Title "⚠️ Delete Item" -Style "destructive" -Card {
        New-AdaptiveCard -AsObject -Content {
            New-CardTextBlock -Text "Are you sure you want to delete this item?" -Color "Attention"
            New-CardTextBlock -Text "This action cannot be undone." -Size "Small"
        }
    }
    
    Creates a destructive-styled ShowCard action for a deletion confirmation.

.NOTES
    - ShowCard actions create inline expansion of content within the same card
    - The Card parameter should use New-AdaptiveCard with -AsObject for proper nesting
    - ShowCard actions are ideal for forms, details, confirmations, and progressive disclosure
    - The revealed card inherits the parent card's styling context
    - Multiple ShowCard actions can be used, but only one can be expanded at a time
    - The Style parameter affects the button appearance, not the revealed card content

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionshowcard
#>
function New-CardActionShowCard {
    param (
        [Parameter(Mandatory = $true)]
        [scriptblock]$Card,
        
        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        [string]$Id,

        [parameter(Mandatory = $false)]
        [ValidateSet("default", "positive", "destructive")]
        [string]$Style

    )

    $ShowCardAction = @{
        type  = "Action.ShowCard"
        title = $Title
        card  = Invoke-Command -ScriptBlock $Card
    }

    if ($Id) {
        $ShowCardAction.id = $Id
    }

    if ($Style) {
        $ShowCardAction.style = $Style
    }

    return $ShowCardAction
}