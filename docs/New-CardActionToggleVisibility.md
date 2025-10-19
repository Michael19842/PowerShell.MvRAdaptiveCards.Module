---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actiontogglevisibility
schema: 2.0.0
---

# New-CardActionToggleVisibility

## SYNOPSIS
Creates a new Action.ToggleVisibility element that shows or hides targeted card elements.

## SYNTAX

```
New-CardActionToggleVisibility [-TargetElements] <String[]> [-Title] <String> [[-Style] <String>]
 [[-Id] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardActionToggleVisibility function creates an Action.ToggleVisibility element that toggles
the visibility of specified card elements when clicked or tapped.
This is useful for creating
interactive cards where users can show/hide sections, details, or supplementary information
without leaving the card context.

## EXAMPLES

### EXAMPLE 1
```
New-CardActionToggleVisibility -Title "Show Details" -TargetElements @("DetailPanel", "AdditionalInfo")
```

Creates a toggle action that shows/hides elements with IDs "DetailPanel" and "AdditionalInfo".

### EXAMPLE 2
```
New-CardActionToggleVisibility -Title "🔍 Toggle Chart" -TargetElements @("SalesChart") -Id "ChartToggle"
```

Creates a toggle action for a single chart element with an emoji icon and an action ID.

### EXAMPLE 3
```
New-CardActionToggleVisibility -Title "Hide Sensitive Data" -TargetElements @("SSN", "CreditCard", "BankAccount") -Style "destructive"
```

Creates a toggle action to hide multiple sensitive data fields with destructive styling.

## PARAMETERS

### -TargetElements
An array of element IDs that will be toggled when the action is triggered.
Each element
must have an ID assigned for the toggle action to work.
Elements with matching IDs will
have their visibility state inverted (visible becomes hidden, hidden becomes visible).

```yaml
Type: String[]
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
This is what users will see and click to toggle
the visibility of the target elements.

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

### -Style
The visual style of the action button.
Valid values are:
- default: Standard button appearance
- positive: Positive/success styling (typically green or blue)
- destructive: Destructive/warning styling (typically red)

The actual appearance depends on the host application's theme and implementation.
Note: This parameter is defined but may not be fully implemented in the current function.

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

### -Id
An optional unique identifier for the action.
Useful for tracking action usage or for accessibility purposes.

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
### Returns a hashtable representing the Action.ToggleVisibility structure for the Adaptive Card.
## NOTES
- All target elements must have unique IDs set for the toggle action to function properly
- Elements are toggled individually - if some are visible and others hidden, they will all switch states
- ToggleVisibility actions are supported in Adaptive Cards schema version 1.2 and later
- The initial visibility state of target elements is determined by their isVisible property (default: true)
- This action type provides a way to create collapsible sections and progressive disclosure interfaces
- The Style parameter is defined in the function but may require additional implementation

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actiontogglevisibility](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actiontogglevisibility)

