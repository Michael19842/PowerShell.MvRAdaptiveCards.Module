---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionresetinputs
schema: 2.0.0
---

# New-CardActionResetInputs

## SYNOPSIS
Creates a new Action.ResetInputs element that resets specified input fields in an Adaptive Card.

## SYNTAX

```
New-CardActionResetInputs [-Title] <String> [[-TargetInputIds] <String[]>] [[-Id] <String>] [[-Style] <String>]
 [[-IconUrl] <String>] [[-IsEnabled] <Boolean>] [[-Mode] <String>] [[-Tooltip] <String>] [[-Fallback] <Object>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardActionResetInputs function creates an Action.ResetInputs element that clears
the values of specified input fields when clicked or tapped.
This is useful for creating
forms where users need to clear multiple input fields at once, such as "Clear Form" or
"Reset" functionality in Adaptive Cards.

## EXAMPLES

### EXAMPLE 1
```
New-CardActionResetInputs -Title "Clear Form"
```

Creates a reset action that clears all input fields in the card.

### EXAMPLE 2
```
New-CardActionResetInputs -Title "Reset User Info" -TargetInputIds @("NameInput", "EmailInput", "PhoneInput")
```

Creates a reset action that only clears the specified input fields.

### EXAMPLE 3
```
New-CardActionResetInputs -Title "Start Over" -Style "destructive" -IconUrl "refresh,regular" -Tooltip "Clear all entered data"
```

Creates a reset action with destructive styling, an icon, and a tooltip.

### EXAMPLE 4
```
$resetAction = New-CardActionResetInputs -Title "Reset" -TargetInputIds @("SearchBox") -Id "SearchReset"
```

Creates a reset action for a specific search input with an action ID.

## PARAMETERS

### -Title
The text to display on the action button.
This is what users will see and click to reset
the input fields (e.g., "Reset Form", "Clear All", "Start Over").

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

### -TargetInputIds
An array of input element IDs that should be reset when the action is triggered.
Only
input elements with matching IDs will be cleared.
If not specified, all input fields
in the card will be reset.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
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
- destructive: Destructive/warning styling (typically red) - useful for reset actions

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
An alternate action to render if Action.ResetInputs is not supported by the host application.
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
### Returns a hashtable representing the Action.ResetInputs structure for the Adaptive Card.
## NOTES
- Action.ResetInputs was introduced in Adaptive Cards schema version 1.5
- Target input elements must have unique IDs for selective reset functionality
- If TargetInputIds is not specified, all input fields in the card will be reset
- This action only affects input elements (Input.Text, Input.Number, Input.Date, etc.)
- The reset action clears values but does not change other input properties like placeholder text
- Consider using destructive styling for reset actions to make their impact clear to users

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionresetinputs](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionresetinputs)

