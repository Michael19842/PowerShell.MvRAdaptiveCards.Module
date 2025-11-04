---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://learn.microsoft.com/adaptive-cards/authoring-cards/card-schema#backgroundimage
schema: 2.0.0
---

# New-CardBackgroundImage

## SYNOPSIS
Creates a backgroundImage object for use on Adaptive Card containers and layouts.

## SYNTAX

```
New-CardBackgroundImage [-Url] <String> [[-FillMode] <String>] [[-HorizontalAlignment] <String>]
 [[-VerticalAlignment] <String>] [[-ThemedUrls] <ScriptBlock>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardBackgroundImage function produces the hashtable structure expected by the Adaptive Card
schema for the backgroundImage property.
It supports configuring fill behavior, alignment, and optional
theme-specific image URLs.

## EXAMPLES

### EXAMPLE 1
```
New-CardBackgroundImage -Url "https://contoso.com/background.png"
```

Creates a simple background image definition using the default fill and alignment.

### EXAMPLE 2
```
New-CardBackgroundImage -Url "https://contoso.com/pattern.svg" -FillMode Repeat -HorizontalAlignment Center
```

Produces a repeating background centered horizontally.

### EXAMPLE 3
```
New-CardBackgroundImage -Url "https://contoso.com/day.png" -ThemedUrls {
	@{
		theme = "dark"
		url   = "https://contoso.com/night.png"
	}
}
```

Creates a background image with a fallback URL plus a dark theme override.

## PARAMETERS

### -Url
The image URL or Data URI to use as the background.
This is a required value.

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

### -FillMode
Controls how the image should fill the available area.
Defaults to "Cover".
Other valid values include
"RepeatHorizontally", "RepeatVertically", and "Repeat".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Cover
Accept pipeline input: False
Accept wildcard characters: False
```

### -HorizontalAlignment
Determines the horizontal alignment when the image needs to be cropped or repeated.
Defaults to "Left".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Left
Accept pipeline input: False
Accept wildcard characters: False
```

### -VerticalAlignment
Determines the vertical alignment when the image needs to be cropped or repeated.
Defaults to "Top".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Top
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThemedUrls
Optional ScriptBlock that should emit one or more ThemedUrl objects to support theme-specific background
imagery.
Each emitted object must already match the Adaptive Card schema for ThemedUrl.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
### 	Returns a hashtable representing the backgroundImage structure.
## NOTES
- Properties are omitted from the output when their values match the Adaptive Card defaults
- The ThemedUrls scriptblock may return a single object or an array
- Consumers such as New-CardContainer can pipe the resulting hashtable into the backgroundImage property

## RELATED LINKS

[https://learn.microsoft.com/adaptive-cards/authoring-cards/card-schema#backgroundimage](https://learn.microsoft.com/adaptive-cards/authoring-cards/card-schema#backgroundimage)

