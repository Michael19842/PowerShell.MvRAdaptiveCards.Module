---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionset
schema: 2.0.0
---

# New-CardActionSet

## SYNOPSIS
Creates a new ActionSet element for an Adaptive Card to group multiple actions together.

## SYNTAX

```
New-CardActionSet [-Actions] <ScriptBlock[]> [[-Fallback] <ScriptBlock>] [[-Id] <String>] [[-Height] <String>]
 [[-HorizontalAlignment] <String>] [[-IsSortKey] <Boolean>] [[-IsVisible] <Boolean>] [[-Lang] <String>]
 [[-Requires] <Hashtable>] [-Separator] [[-Spacing] <String>] [[-TargetWidth] <String>] [[-GridArea] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardActionSet function creates an ActionSet element that displays a collection of actions
in an Adaptive Card.
ActionSets are used to group related actions together and can be placed
anywhere within a card's body, unlike the card-level actions which appear at the bottom.

## EXAMPLES

### EXAMPLE 1
```
New-CardActionSet -Actions {
    New-CardActionToggleVisibility -Title "Show Details" -TargetElements @("DetailPanel")
    New-CardActionToggleVisibility -Title "Show Chart" -TargetElements @("ChartContainer")
}
```

Creates an ActionSet with two toggle visibility actions.

### EXAMPLE 2
```
New-CardActionSet -Actions {
    New-CardActionShowCard -Title "Edit Profile" -Card {
        New-AdaptiveCard -AsObject -Content {
            New-CardTextBlock -Text "Edit your profile information"
        }
    }
} -Id "ProfileActions"
```

Creates an ActionSet with a ShowCard action and assigns an ID for reference.

### EXAMPLE 3
```
New-CardActionSet -Actions {
    New-CardActionToggleVisibility -Title "Toggle Panel 1" -TargetElements @("Panel1")
    New-CardActionToggleVisibility -Title "Toggle Panel 2" -TargetElements @("Panel2")
} -Fallback {
    New-CardTextBlock -Text "Actions not supported on this client"
}
```

Creates an ActionSet with fallback content for unsupported clients.

## PARAMETERS

### -Actions
An array of ScriptBlocks, each containing an action to include in the ActionSet.
Each ScriptBlock should call an action function like New-CardActionToggleVisibility,
New-CardActionShowCard, or other supported action types.

```yaml
Type: ScriptBlock[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fallback
An optional ScriptBlock that generates fallback content for clients that don't support
ActionSet elements.
The fallback content will be displayed instead of the ActionSet
on unsupported clients.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
An optional unique identifier for the ActionSet element.
Useful for referencing the element
in other actions like toggle visibility or for accessibility purposes.

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

### -Height
{{ Fill Height Description }}

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

### -HorizontalAlignment
{{ Fill HorizontalAlignment Description }}

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

### -IsSortKey
{{ Fill IsSortKey Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsVisible
{{ Fill IsVisible Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Lang
{{ Fill Lang Description }}

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

### -Requires
{{ Fill Requires Description }}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Separator
{{ Fill Separator Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Spacing
{{ Fill Spacing Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetWidth
{{ Fill TargetWidth Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GridArea
{{ Fill GridArea Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
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
### Returns a hashtable representing the ActionSet element structure for the Adaptive Card.
## NOTES
- ActionSets are supported in Adaptive Cards schema version 1.2 and later
- Unlike card-level actions, ActionSets can be placed anywhere in the card body
- Each action in the Actions array is executed as a ScriptBlock to generate the action definition
- The Fallback parameter helps ensure graceful degradation on clients that don't support ActionSets
- ActionSets are useful for grouping related actions or placing actions within specific containers

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionset](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionset)

