---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionshowcard
schema: 2.0.0
---

# New-CardActionShowCard

## SYNOPSIS
Creates a new Action.ShowCard element that displays a card when the action is triggered.

## SYNTAX

```
New-CardActionShowCard [-Card] <ScriptBlock> [-Title] <String> [[-Id] <String>] [[-Style] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardActionShowCard function creates an Action.ShowCard element that, when clicked or tapped,
reveals an inline card with additional content.
This is useful for progressive disclosure of information,
allowing users to reveal more details or input forms without navigating away from the main card.

## EXAMPLES

### EXAMPLE 1
```
New-CardActionShowCard -Title "Show Details" -Card {
    New-AdaptiveCard -AsObject -Content {
        New-CardTextBlock -Text "Here are the additional details..."
        New-CardFactSet -Facts @{
            "Created" = "2023-01-15"
            "Status" = "Active"
        }
    }
}
```

Creates a ShowCard action that reveals a card with details when clicked.

### EXAMPLE 2
```
New-CardActionShowCard -Title "Edit Settings" -Style "positive" -Card {
    New-AdaptiveCard -AsObject -Content {
        New-CardTextBlock -Text "Configuration Options" -Weight "Bolder"
        New-CardContainer -Content {
            New-CardTextBlock -Text "Modify your preferences here"
        }
    }
} -Id "EditAction"
```

Creates a positive-styled ShowCard action for editing settings with an ID.

### EXAMPLE 3
```
New-CardActionShowCard -Title "⚠️ Delete Item" -Style "destructive" -Card {
    New-AdaptiveCard -AsObject -Content {
        New-CardTextBlock -Text "Are you sure you want to delete this item?" -Color "Attention"
        New-CardTextBlock -Text "This action cannot be undone." -Size "Small"
    }
}
```

Creates a destructive-styled ShowCard action for a deletion confirmation.

## PARAMETERS

### -Card
A ScriptBlock that generates the card content to be shown when the action is triggered.
The ScriptBlock should typically call New-AdaptiveCard with -AsObject to create a nested card structure.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
The text to display on the action button.
This is what users will see and click to reveal the card.

```yaml
Type: String
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
Useful for tracking action usage or for accessibility purposes.

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
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.

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
### Returns a hashtable representing the Action.ShowCard structure for the Adaptive Card.
## NOTES
- ShowCard actions create inline expansion of content within the same card
- The Card parameter should use New-AdaptiveCard with -AsObject for proper nesting
- ShowCard actions are ideal for forms, details, confirmations, and progressive disclosure
- The revealed card inherits the parent card's styling context
- Multiple ShowCard actions can be used, but only one can be expanded at a time
- The Style parameter affects the button appearance, not the revealed card content

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionshowcard](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionshowcard)

