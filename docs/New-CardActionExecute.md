---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionexecute
schema: 2.0.0
---

# New-CardActionExecute

## SYNOPSIS
Creates a new Action.Execute element for executing bot commands in Adaptive Cards.

## SYNTAX

```
New-CardActionExecute [-Title] <String> [[-Verb] <String>] [[-Data] <Object>] [[-Id] <String>]
 [[-Style] <String>] [[-IconUrl] <String>] [[-IsEnabled] <Boolean>] [[-Mode] <String>] [[-Tooltip] <String>]
 [[-AssociatedInputs] <String>] [[-ConditionallyEnabled] <Boolean>] [[-Fallback] <Object>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardActionExecute function creates an Action.Execute element that sends data to a bot
or backend service when clicked or tapped.
This action is commonly used in bot frameworks
like Microsoft Bot Framework to trigger specific bot behaviors, execute commands, or
initiate workflows based on user interaction.

## EXAMPLES

### EXAMPLE 1
```
New-CardActionExecute -Title "Submit Order" -Verb "submitOrder"
```

Creates an execute action that submits an order with all input values.

### EXAMPLE 2
```
New-CardActionExecute -Title "Get Weather" -Verb "getWeather" -Data @{ location = "Seattle" }
```

Creates an execute action with specific data payload.

### EXAMPLE 3
```
New-CardActionExecute -Title "Process Payment" -Verb "processPayment" -Style "positive" -IconUrl "payment,regular"
```

Creates an execute action with positive styling and an icon.

### EXAMPLE 4
```
$executeAction = New-CardActionExecute -Title "Advanced Search" -Verb "search" -AssociatedInputs "none" -Data { @{ searchType = "advanced" } }
```

Creates an execute action that doesn't send input values, only custom data.

### EXAMPLE 5
```
New-CardActionExecute -Title "Submit Form" -Verb "submitForm" -ConditionallyEnabled $true -Tooltip "Complete required fields to enable"
```

Creates a conditionally enabled execute action for Teams.

## PARAMETERS

### -Title
The text to display on the action button.
This is what users will see and click to
execute the action (e.g., "Submit Order", "Get Weather", "Process Request").

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

### -Verb
The verb of the action that identifies what operation should be performed.
This is
typically used by the bot or backend service to determine how to handle the request.
Examples include "submitOrder", "getWeather", "processPayment", etc.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Data
The data to send to the bot when the action is executed.
Can be either:
- Object: Data is sent along with input values as key/value pairs
- String: Only the string data is sent, input values are ignored
- ScriptBlock: Executed to generate the data object

```yaml
Type: Object
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
Useful for tracking action usage or for
accessibility purposes.

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
Position: 5
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
Position: 6
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
Position: 7
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
Position: 8
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
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssociatedInputs
Controls which input values are sent with the action.
Valid values are:
- "auto": All input values in the card are sent (default behavior)
- "none": No input values are sent, only the Data parameter content

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: Auto
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConditionallyEnabled
Controls if the action is enabled only when at least one required input has been
filled by the user.
This is a Teams-specific feature.
Default is $false.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fallback
An alternate action to render if Action.Execute is not supported by the host application.
Can be a scriptblock that returns another action or the string "drop" to hide the action.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
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
### Returns a hashtable representing the Action.Execute structure for the Adaptive Card.
## NOTES
- Action.Execute was introduced in Adaptive Cards schema version 1.4
- The Verb parameter is used by bots to route and handle different types of actions
- Data can be combined with input values or used independently
- ConditionallyEnabled is a Teams-specific feature and may not work in other hosts
- The action sends HTTP POST requests to the bot's messaging endpoint
- Input validation occurs before the action is executed if AssociatedInputs is "auto"

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionexecute](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionexecute)

