---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#richtextblock
schema: 2.0.0
---

# New-CardRichTextBlock

## SYNOPSIS
Creates a new RichTextBlock element for an Adaptive Card with advanced inline formatting capabilities.

## SYNTAX

```
New-CardRichTextBlock [-Text] <String> [[-Id] <String>] [[-HorizontalAlignment] <String>]
 [[-FontType] <String>] [[-Size] <String>] [[-Weight] <String>] [[-NamedSelectActions] <Hashtable>]
 [-Separator] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-CardRichTextBlock function creates a RichTextBlock element that supports rich text formatting
through an intuitive tag-based markup system.
Unlike simple TextBlocks, RichTextBlocks can contain
multiple text runs with different styles, colors, weights, and even interactive actions within a single block.

The function uses a custom markup language with tags like {{bold}}, {{color:Good}}, {{action:myAction}}, etc.
to define formatting and behavior for different parts of the text.
This enables complex text layouts
with mixed formatting, colors, and interactivity all within a single text element.

## EXAMPLES

### EXAMPLE 1
```
New-CardRichTextBlock -Text "This is {{bold}}bold text{{/bold}} and this is {{color:Good}}green text{{/color}}."
```

Creates a rich text block with bold formatting and colored text using inline tags.

### EXAMPLE 2
```
$text = @"
Welcome {{bold}}{{color:Good}}John Doe{{/color}}{{/bold}}!
Your account status is {{color:Good}}{{bold}}Active{{/bold}}{{/color}}.
Click {{action:viewProfile}}here{{/action}} to view your profile.
"@
```

$actions = @{
    "viewProfile" = { New-CardActionShowCard -Title "Profile" -Card {
        New-AdaptiveCard -AsObject -Content { 
            New-CardTextBlock -Text "Profile details..." 
        }
    }}
}

New-CardRichTextBlock -Text $text -NamedSelectActions $actions

Creates a rich text block with nested formatting, colors, and an interactive action link.

### EXAMPLE 3
```
$complexText = @"
{{size:Large}}{{bold}}System Status Report{{/bold}}{{/size}}
```

{{color:Good}}✅ All systems operational{{/color}}
{{color:Warning}}⚠️ Minor performance degradation detected{{/color}}
{{color:Attention}}🚨 Critical error in database connection{{/color}}

{{monospace}}Error Code: DB_CONN_001{{/monospace}}
{{italic}}Last updated: $(Get-Date){{/italic}}

For more information, {{action:contactSupport}}contact support{{/action}}.
"@

$actions = @{
    "contactSupport" = { New-CardActionOpenUrl -Url "mailto:support@company.com" }
}

New-CardRichTextBlock -Text $complexText -NamedSelectActions $actions -Id "StatusReport"

Creates a complex system status report with multiple formatting styles, colors, and an action link.

### EXAMPLE 4
```
New-CardRichTextBlock -Text "Code example: {{monospace}}{{highlight}}Get-Process | Select-Object Name{{/highlight}}{{/monospace}}" -FontType "Default" -HorizontalAlignment "Left"
```

Creates a text block demonstrating code formatting with monospace font and highlighting.

### EXAMPLE 5
```
$styledText = @"
{{bold}}{{size:Large}}Product Features{{/size}}{{/bold}}
```

• {{color:Good}}Fast performance{{/color}} - Up to 10x faster
• {{color:Accent}}Easy integration{{/color}} - Simple API
• {{strikethrough}}Expensive licensing{{/strikethrough}} {{color:Good}}Now free!{{/color}}
• {{underline}}24/7 support{{/underline}} available

{{subtle}}{{size:Small}}* Terms and conditions apply{{/size}}{{/subtle}}
"@

New-CardRichTextBlock -Text $styledText -HorizontalAlignment "Left" -Separator

Creates a product features list with various formatting styles and a separator.

## PARAMETERS

### -Text
The text content with embedded formatting tags.
Tags use the format {{tagname}} for opening and {{/tagname}} 
for closing.
Some tags support values using {{tagname:value}} syntax.

Supported formatting tags:
- Style: {{bold}}, {{italic}}, {{strikethrough}}, {{underline}}, {{highlight}}
- Weight: {{bolder}}, {{lighter}}, {{weight:value}}
- Size: {{small}}, {{medium}}, {{large}}, {{extraLarge}}, {{size:value}}
- Color: {{color:colorname}} (Default, Dark, Light, Accent, Good, Warning, Attention)
- Font: {{monospace}}, {{fontType:value}}
- Visibility: {{hidden}}, {{subtle}}
- Language: {{lang:code}}
- Actions: {{action:actionname}} (references NamedSelectActions)

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

### -Id
An optional unique identifier for the RichTextBlock element.
Useful for referencing the element
in actions like toggle visibility or for accessibility purposes.

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

### -HorizontalAlignment
The horizontal alignment of the text block.
Valid values are:
- Left: Align text to the left (default)
- Center: Center the text
- Right: Align text to the right
- Justify: Justify the text (stretch to fill width)

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

### -FontType
The font family to use for the text block.
Valid values are:
- Default: Use the default system font
- Monospace: Use a monospace font (good for code or data)

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

### -Size
The default size for text in the block.
Valid values are:
- Small: Smaller than default text
- Default: Standard text size
- Medium: Medium sized text
- Large: Large text
- ExtraLarge: Extra large text
Note: Individual text runs can override this with size tags.

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

### -Weight
The default weight (boldness) for text in the block.
Valid values are:
- Lighter: Lighter than normal text
- Default: Normal text weight
- Bolder: Bold text
Note: Individual text runs can override this with weight tags.

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

### -NamedSelectActions
A hashtable containing named actions that can be referenced within the text using {{action:name}} tags.
Each key in the hashtable should be an action name, and each value should be a ScriptBlock that
generates an action using functions like New-CardActionToggleVisibility, New-CardActionShowCard, etc.

Example: @{ "showDetails" = { New-CardActionShowCard -Title "Details" -Card {...} } }

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Separator
A switch parameter that adds a separator line above the RichTextBlock element.
Useful for
visually separating the text block from preceding elements.

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
### Returns a hashtable representing the RichTextBlock element structure for the Adaptive Card.
## NOTES
- Tags can be nested for combined effects (e.g., {{bold}}{{color:Good}}text{{/color}}{{/bold}})
- All opening tags must have corresponding closing tags
- Color values must match Adaptive Card color scheme values
- Action names in {{action:name}} tags must exist in the NamedSelectActions hashtable
- The function performs validation to ensure proper tag matching and valid values
- Text runs are automatically created for each formatted segment
- Unknown tags generate warnings but don't break the function
- The markup language is designed to be intuitive and similar to HTML/XML

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#richtextblock](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#richtextblock)

[New-CardTextRun]()

[New-CardTextBlock]()

