# MvRAdaptiveCards
PowerShell Module for creating (and posting) Adaptive Cards in PowerShell.

## Overview
This module provides functions for working with Adaptive Cards in PowerShell in a similar fashion as the popular module PSWriteHTML does for HTML generation. Creating Adaptive Cards in PowerShell can be complex due to the JSON structure required by Adaptive Cards. This module simplifies the process by providing cmdlets that allow you to build Adaptive Cards using PowerShell objects (and has built-in support for posting these cards to Microsoft Teams channels).

If you are familiar with PSWriteHTML, you'll find the approach in MvRAdaptiveCards quite similar.

## Install MvRAdaptiveCards
You can install the module directly from the PowerShell Gallery using the following command:

```powershell
Install-Module -Name MvRAdaptiveCards
```

This module is compatible with PowerShell 5.1 and later versions.

## Example Usage
You are probably excited to get started! Here is a simple example of how to create an Adaptive Card using MvRAdaptiveCards:

```powershell 
# Import the module
Import-Module MvRAdaptiveCards

# Create a new Adaptive Card
New-CardAdaptiveCard -Content {
    New-CardContainer -Content {
        New-CardTextBlock -Text "Welcome to the Adaptive Cards demo!" -Size 'Large' -Weight 'Bolder' -Color 'Good'
        New-CardTextBlock -Text "This is a container inside the adaptive card." -Color 'Dark'
    } -Style 'Emphasis'
}
#This will output the JSON structure of the Adaptive Card which you can then use in your applications or post to Microsoft Teams.
```

You can also directly open and edit your card in the [Adaptive Cards Online Designer](https://adaptivecards.microsoft.com/designer) using the `Out-OnlineDesigner` cmdlet:

```powershell
New-CardAdaptiveCard -Content {
    New-CardContainer -Content {
        New-CardTextBlock -Text "Welcome to the Adaptive Cards demo!" -Size 'Large' -Weight 'Bolder' -Color 'Good'
        New-CardTextBlock -Text "This is a container inside the adaptive card." -Color 'Dark'
    } -Style 'Good'
} | Out-OnlineDesigner 

```

> This generates the Adaptive Card JSON, creates a temporary file, and opens it in the Adaptive Cards Designer in an iFrame. Then it posts the card to that iFrame on the ready event. It is a bit hacky, but it works great when you want to quickly prototype or edit your cards.



## Functions
An extensive set of function documentation (*generated using PlatyPS*) is available **here: [MvRAdaptiveCards Documentation](docs/MvRAdaptiveCards.md)**