# ![header](https://github.com/Michael19842/PowerShell.MvRAdaptiveCards.Module/blob/main/docs/images/logo40x57.png) MvRAdaptiveCards
PowerShell Module for creating (and posting) Adaptive Cards in PowerShell.

![header](https://github.com/Michael19842/PowerShell.MvRAdaptiveCards.Module/blob/main/docs/images/header.png)

![PowerShell Gallery Downloads](https://img.shields.io/powershellgallery/dt/MvRAdaptiveCards)
![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/MvRAdaptiveCards)



## Overview
This module provides a framework of easy-to-use functions for working with Adaptive Cards in PowerShell in a similar fashion as the popular module PSWriteHTML does for HTML generation. Creating Adaptive Cards in PowerShell can be complex due to the JSON structure required by Adaptive Cards. This module simplifies the process by providing cmdlets that allow you to build Adaptive Cards using PowerShell objects (and has built-in support for posting these cards to Microsoft Teams channels).

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

### Previewing cards in the Adaptive Cards Designer

You can also directly open and edit your card in the [Adaptive Cards Online Designer](https://adaptivecards.microsoft.com/designer) using the `Out-OnlineDesigner` cmdlet:

```powershell
New-AdaptiveCard -Content {
    New-CardContainer -Content {
        New-CardTextBlock -Text "Welcome to the Adaptive Cards demo!" -Size 'Large' -Weight 'Bolder' -Color 'Good'
        New-CardTextBlock -Text "This is a container inside the adaptive card." -Color 'Dark'
    } -Style 'Good'
} | Out-OnlineDesigner

```
> This generates the Adaptive Card JSON, creates a temporary file, and opens it in the Adaptive Cards Designer in an iFrame. Then it posts the card to that iFrame on the ready event. It is a bit hacky, but it works great when you want to quickly prototype or edit your cards.

![designer](https://github.com/Michael19842/PowerShell.MvRAdaptiveCards.Module/blob/main/docs/images/example.png)

### Previewing cards locally using the built-in previewer

You can also preview your card directly in a built-in previewer (Using the JavaScript based renderer) using the `Out-CardPreview` cmdlet:

```powershell
New-AdaptiveCard -Content {
    New-CardContainer -Content {
        New-CardImage -Url "https://adaptivecards.io/content/cats/1.png" -AltText "Example Image" -Id "CatImage"
        New-CardTextBlock -Text "Welcome to the Adaptive Cards demo!" -Size 'Large' -Weight 'Bolder' -Color 'Good'
        New-CardTextBlock -Text "This is a container inside the adaptive card." -Color 'Dark'
    } -Style 'Good'
} -Actions {
    New-CardActionToggleVisibility -Title "Toggle Cat Image" -TargetElements @("CatImage")
} | Out-CardPreview
```
![preview](https://github.com/Michael19842/PowerShell.MvRAdaptiveCards.Module/blob/main/docs/images/previewsmall.png)

## Sending Cards using Outlook as client
You can send Adaptive Cards via Outlook using the `Send-CardViaClassicOutlook` cmdlet. Here's an example:

```powershell
# Create an Adaptive Card
New-AdaptiveCard -Content {
    New-CardContainer -Content {
        New-CardTextBlock -Text "Hello from MvRAdaptiveCards!" -Size 'Large' -Weight 'Bolder' -Color 'Good'
        New-CardTextBlock -Text "This card was sent via Outlook." -Color 'Dark'
    } -Style 'Emphasis'
} | Send-CardViaClassicOutlook -To  'someone.who.uses@outlook.com' -Subject 'Adaptive Card from PowerShell'
```
> Note: You do need to have Outlook installed and configured on your machine for this to work.

## Template System
The module includes a powerful templating system that allows you to create reusable card templates with dynamic content replacement. You can define template tags in your card structure and replace them with actual content at runtime using the `Build-CardFromTemplate` cmdlet.

Templating supports both simple text and complex structures, making it easy to create Adaptive Cards dynamically.

#### Example: Basic Text Replacement
```powershell
# Create a template with placeholder text
$template = New-CardContainer -Content {
    New-CardTextBlock -Text "Hello, !{{UserName}}! Welcome to our application." -Wrap
    New-CardTextBlock -Text "Your role is: !{{UserRole}}" -Color "Accent"
}

# Create the final card by replacing template tags with actual values
New-AdaptiveCard -Content {
    Build-CardFromTemplate -Content $template -Tags @{
        UserName = "Michael"
        UserRole = "Administrator"
    }
} | Out-OnlineDesigner
```

#### Example: Dynamic Structure Replacement
```powershell
# Create a template with a placeholder for a complex structure
$template = New-CardContainer -Content {
    New-CardTextBlock -Text "User Information" -Size "Large" -Weight "Bolder"
    New-CardContainer -Content {
        New-CardTemplateTag -TagName "UserFacts"
    }
}

#Use the Find-CardTemplateTags cmdlet to retrieve the tags defined in the template (optional step for debugging)
Find-CardTemplateTags -Content $template

# Create the final card by replacing the template tag with a FactSet
New-AdaptiveCard -Content {
    Build-CardFromTemplate -Content $template -Tags @{
        UserFacts = {
            New-CardFactSet -Facts @{
                Name       = "Ben"
                Role       = "Administrator"
                Department = "IT"
            }
    }
}
} | Out-OnlineDesigner
```
## Using RichTextBlock
The module provides the `New-CardRichTextBlock` cmdlet to create RichTextBlock elements in Adaptive Cards. RichTextBlock allows for advanced inline formatting, including bold, italic, strikethrough, color changes, and more. This is done using a simple markup syntax (HTML like) within the text string. The following tags are supported:
- `{{bolder}}...{{/bolder}}` for **bold** (Also `{{b}}...{{/b}}`,`{{bold}}...{{/bold}}`,`{{strong}}...{{/strong}}`)
- `{{italic}}...{{/italic}}` for *italic* (Also `{{i}}...{{/i}}`,`{{emphasis}}...{{/emphasis}}`)
- `{{strikethrough}}...{{/strikethrough}}` for ~~strikethrough~~ (Also `{{s}}...{{/s}}`,`{{strike}}...{{/strike}}`)
- `{{color:ColorName}}...{{/color}}` for changing text color
- `{{size:SizeName}}...{{/size}}` for changing text size
- `{{action:ActionName}}...{{/action}}` for defining selectable actions
- `{{id:Identifier}}...{{/id}}` for assigning identifiers to text segments
- `{{small}}...{{/small}}` for small text size
- `{{medium}}...{{/medium}}` for medium text size
- `{{large}}...{{/large}}` for large text size
- `{{extralarge}}...{{/extralarge}}` for extra large text size
- `{{hidden}}...{{/hidden}}` for hidden text
- `{{fontType:FontType}}...{{/fontType}}` for specifying font type (e.g., `Default`, `Monospace`)
- `{{monospace}}...{{/monospace}}` for monospace font type

> Important: Tags must be properly closed. the module can throw an error if it encounters unclosed tags.

### Example: Creating a RichTextBlock
```powershell
# Create a RichTextBlock with various formatting options
New-AdaptiveCard -Content {
    New-CardRichTextBlock -text "This is a {{bolder}}bold{{/bolder}} text, this is a {{italic}}italic{{/italic}} text, and this is a {{strikethrough}}strikethrough{{/strikethrough}} text."
} | Out-OnlineDesigner
```

### Example: RichTextBlock with Actions
```powershell
# Create a RichTextBlock with selectable actions
New-AdaptiveCard -Content {
    New-CardRichTextBlock -Text "Click {{action:ShowDetails}}{{b}}here{{/b}}{{/action}} to see more details." -NamedSelectActions @{
        ShowDetails = {
            New-CardActionToggleVisibility -Title "Toggle Details" -TargetElements @("DetailsSection")
        }
    }
    New-CardContainer -Id "DetailsSection" -Content {
        New-CardTextBlock -Text "Here are the additional details you wanted to see!" -Wrap
    }
} | Out-OnlineDesigner
```

## Sending Adaptive Cards
The module provides cmdlets to send Adaptive Cards via various channels, including Microsoft Teams, classic Outlook, and SMTP. Do note that sending card via some SMTP might result in cards not rendering properly due to security restrictions in service (e.g. Google Gmail).

It also has built-in support for saving the configuration of your Teams connection, or SMTTP configuration for easy reuse. The saved configuration is stored in the appdata folder of the current user. Any sensitive information like passwords are securely encrypted, and can only be used by the same user on the same machine.

## Functions
An extensive set of function documentation (*generated using PlatyPS*) is available **here: [MvRAdaptiveCards Documentation](docs/MvRAdaptiveCards.md)**

## Development
This module is still under active development. There is a long list of planned features and improvements including:
- Testing framework for automated tests (using Pester) [partially implemented]
- Additional examples for your reference
- Input fields
- More action types
- Chart support
- Additional arguments for existing functions

So, do keep an eye out for new releases! More features and improvements are on the way.

## Contributing
Contributions are welcome! If you have ideas for new features, improvements, or bug fixes, please feel free to open an issue or submit a pull request on the [GitHub repository](https://github.com/Michael19842/PowerShell.MvRAdaptiveCards.Module). And remember to be kind and respectful in all interactions.
