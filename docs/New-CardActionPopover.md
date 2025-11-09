---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionpopover
schema: 2.0.0
---

# New-CardActionPopover

## SYNOPSIS
Creates a new Action.Popover element that displays content in a popup overlay.

## SYNTAX

```
New-CardActionPopover [-Title] <String> [-Card] <ScriptBlock> [[-Id] <String>] [[-Style] <String>]
 [[-IconUrl] <String>] [[-IsEnabled] <Boolean>] [[-Mode] <String>] [[-Tooltip] <String>] [[-Fallback] <Object>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardActionPopover function creates an Action.Popover element that displays
additional content in a popup or overlay when clicked or tapped.
This action type
is useful for showing detailed information, forms, or interactive content without
navigating away from the current card context.
The popover can contain any valid
Adaptive Card elements including text, images, inputs, and even nested actions.

## EXAMPLES

### EXAMPLE 1
```
New-CardActionPopover -Title "Show Details" -Card {
    New-CardContainer -Content {
        New-CardTextBlock -Text "Additional Information" -Weight "Bolder"
        New-CardTextBlock -Text "This content appears in a popup overlay."
    }
}
```

Creates a popover action that displays additional content in an overlay.

### EXAMPLE 2
```
$detailCard = New-CardContainer -Content {
    New-CardTextBlock -Text "Product Details" -Size "Large" -Weight "Bolder"
    New-CardFactSet -Facts @{
        "Price" = "$99.99"
        "Availability" = "In Stock"
        "Rating" = "4.5 stars"
    }
}
New-CardActionPopover -Title "View Details" -Card $detailCard -IconUrl "info,regular"
```

Creates a popover with detailed product information and an info icon.

### EXAMPLE 3
```
New-CardActionPopover -Title "Quick Form" -Card {
    New-CardContainer -Content {
        New-CardTextBlock -Text "Contact Form" -Weight "Bolder"
        New-CardInputText -Id "name" -Placeholder "Your Name"
        New-CardInputText -Id "email" -Placeholder "Your Email"
        New-CardActionSubmit -Title "Submit" -Id "submitContact"
    }
} -Style "positive"
```

Creates a popover containing a simple contact form with positive styling.

### EXAMPLE 4
```
New-CardActionPopover -Title "Help" -Card {
    New-CardContainer -Content {
        New-CardTextBlock -Text "Need Help?" -Weight "Bolder"
        New-CardTextBlock -Text "Contact support for assistance with your order."
        New-CardActionOpenUrl -Title "Contact Support" -Url "https://support.company.com"
    }
} -Fallback { New-CardActionOpenUrl -Title "Help" -Url "https://help.company.com" }
```

Creates a popover with help content and a fallback action for unsupported hosts.

## PARAMETERS

### -Title
The text to display on the action button.
This is what users will see and click to
open the popover (e.g., "More Details", "Show Form", "View Information").

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Card
The Adaptive Card content to display in the popover.
This can be a complete card
definition created using other New-Card* cmdlets from this module.
The card content
will be rendered in the popup overlay when the action is triggered.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
An optional unique identifier for the action.
Useful for tracking action usage or for
accessibility purposes.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Style
The visual style of the action button.
Valid values are:
- default: Standard button appearance
- positive: Positive/success styling (typically green or blue)
- destructive: Destructive/warning styling (typically red)

The actual appearance depends on the host application's theme and implementation.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -IconUrl
A URL (or Base64-encoded Data URI) to a PNG, GIF, JPEG or SVG image to be displayed
on the left of the action's title.
Also accepts icon names from the Adaptive Card
icon catalog in the format \<icon-name\>\[,regular|filled\].

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsEnabled
Controls whether the action is enabled or disabled.
When set to $false, the action
cannot be clicked and will appear disabled.
Default is $true.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mode
Controls if the action is primary or secondary.
Secondary actions appear in an overflow menu.
Valid values are "primary" and "secondary".
Default is "primary".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: Primary
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tooltip
The tooltip text to display when the action is hovered over.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fallback
An alternate action to render if Action.Popover is not supported by the host application.
Can be a scriptblock that returns another action or the string "drop" to hide the action.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Collections.Hashtable
### Returns a hashtable representing the Action.Popover structure for the Adaptive Card.
## NOTES
- Action.Popover is a preview feature and may not be supported in all Adaptive Cards hosts
- The popover content should be designed to work well in an overlay/modal context
- Consider the size and complexity of the popover content for good user experience
- Popovers can contain interactive elements including inputs and actions
- The card parameter accepts the same content structure as a full Adaptive Card
- Not all hosts may support popover actions, so consider providing fallback actions
- Popover actions are typically rendered as buttons that open modal dialogs or overlays

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionpopover](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionpopover)

