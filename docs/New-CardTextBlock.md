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
New-CardTextBlock [[-Text] <String>] [[-labelFor] <String>] [[-MaximumNumberOfLines] <Int32>]
 [[-Style] <String>] [[-Height] <String>] [[-HorizontalAlignment] <String>] [[-GridArea] <String>]
 [[-Weight] <String>] [[-Color] <String>] [[-Id] <String>] [[-FontType] <String>] [[-Fallback] <ScriptBlock>]
 [[-Requires] <Hashtable>] [[-Language] <String>] [[-Size] <String>] [[-Spacing] <String>] [-Separator] [-Wrap]
 [-IsSortKey] [-IsSubtle] [-IsHidden] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
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

### -labelFor
Specifies the ID of another element that this TextBlock serves as a label for.
This is used for accessibility purposes to associate labels with form elements.

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

### -MaximumNumberOfLines
The maximum number of lines to display. Text that exceeds this limit will be truncated.
Alias: MaxLines

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: MaxLines

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Style
The text style to apply. Valid values are:
- default: Standard text style
- columnHeader: Styled as a column header
- heading: Styled as a heading

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

### -Height
Controls the height behavior of the TextBlock. Valid values are:
- auto: Height adjusts automatically to content (default)
- stretch: TextBlock stretches to fill available vertical space

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

### -HorizontalAlignment
Controls the horizontal alignment of the text within its container. Valid values are:
- Left: Aligns text to the left side
- Center: Centers text horizontally
- Right: Aligns text to the right side

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

### -GridArea
Specifies the named grid area where the TextBlock should be placed when used in a grid layout.
This corresponds to the CSS grid-area property.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
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
Position: 8
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
Position: 9
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
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FontType
The font family to use for the text. Valid values are:
- Default: Default system font
- Monospace: Monospace font for code or data display

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

### -Fallback
A scriptblock that defines fallback content to display if the TextBlock cannot be rendered
or is not supported by the host. Should return an appropriate Adaptive Card element.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Requires
A hashtable specifying feature requirements for the TextBlock. Used to declare dependencies
on specific Adaptive Card features or host capabilities.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Language
Specifies the language/locale for the TextBlock element. Used for proper text rendering
and accessibility features. Alias: Lang

```yaml
Type: String
Parameter Sets: (All)
Aliases: Lang

Required: False
Position: 14
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
Position: 15
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -Spacing
Controls the amount of spacing above the TextBlock. Valid values are:
- None: No spacing
- Small: Small spacing
- Default: Default spacing
- Medium: Medium spacing
- Large: Large spacing
- ExtraLarge: Extra large spacing
- Padding: Adds padding around the element

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Separator
When specified, adds a separator line above the TextBlock to visually separate it from
preceding content.

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

### -IsSortKey
When specified, marks this TextBlock as a sort key element. Used in scenarios where
multiple elements need to be sorted or grouped.

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

### -IsSubtle
When specified, displays the text in a more subtle/muted appearance, typically with
reduced opacity or lighter color.

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

### -IsHidden
When specified, sets the TextBlock to be hidden (isVisible = false). The element will
not be displayed but can be shown programmatically. Alias: Hidden

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Hidden

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

