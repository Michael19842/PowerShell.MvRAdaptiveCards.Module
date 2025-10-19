---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#textblock
schema: 2.0.0
---

# New-CardTextBlock

## SYNOPSIS
Creates a new TextBlock element for an Adaptive Card.

## SYNTAX

```
New-CardTextBlock [[-Text] <String>] [[-Size] <String>] [[-Weight] <String>] [[-Color] <String>]
 [[-Id] <String>] [-Wrap] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardTextBlock function creates a TextBlock element that displays text content in an Adaptive Card.
TextBlocks support various formatting options including size, weight, color, and text wrapping.
They are fundamental building blocks for displaying textual information in Adaptive Cards.

## EXAMPLES

### EXAMPLE 1
```
New-CardTextBlock -Text "Welcome to our application!" -Size "Large" -Weight "Bolder"
```

Creates a large, bold welcome message.

### EXAMPLE 2
```
New-CardTextBlock -Text "⚠️ This is a warning message" -Color "Warning" -Wrap
```

Creates a warning-colored text block with wrapping enabled and an emoji icon.

### EXAMPLE 3
```
New-CardTextBlock -Text "Status: System is operational" -Color "Good" -Id "StatusText"
```

Creates a success-colored status message with an ID for potential reference in actions.

### EXAMPLE 4
```
New-CardTextBlock -Text "This is a very long text that should wrap to multiple lines when displayed" -Wrap
```

Creates a text block with wrapping enabled for long content.

## PARAMETERS

### -Text
The text content to display in the TextBlock.
Supports plain text and Markdown formatting
depending on the host application's capabilities.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Size
The size of the text.
Common values include:
- Default: Standard text size
- Small: Smaller than default
- Medium: Medium size text
- Large: Large text
- ExtraLarge: Extra large text
Default value is "Default".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -Weight
The weight (boldness) of the text.
Common values include:
- Default: Normal text weight
- Lighter: Lighter than normal
- Bolder: Bold text
Default value is "Default".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -Color
The color scheme to apply to the text.
Valid values are:
- Default: Default text color
- Dark: Dark text color
- Light: Light text color  
- Accent: Accent color (typically blue)
- Good: Success/positive color (typically green)
- Warning: Warning color (typically orange/yellow)
- Attention: Attention/error color (typically red)
Default value is "Default".

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

### -Id
An optional unique identifier for the TextBlock element.
Useful for referencing the element
in actions like toggle visibility or for accessibility purposes.

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

### -Wrap
A switch parameter that enables text wrapping.
When specified, long text will wrap to multiple
lines instead of being truncated.
Without this parameter, text may be clipped if it exceeds the available width.

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
### Returns a hashtable representing the TextBlock element structure for the Adaptive Card.
## NOTES
- The Size and Weight parameters accept string values that correspond to Adaptive Card schema values
- Color values map to the host application's theme colors
- The Wrap parameter is essential for longer text content to ensure readability
- Markdown formatting support depends on the host application (Teams, Outlook, etc.)
- The Id parameter is optional but recommended when the text needs to be referenced by actions

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#textblock](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#textblock)

