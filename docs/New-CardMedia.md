---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version:
schema: 2.0.0
---

# New-CardMedia

## SYNOPSIS
Creates a Media element for Adaptive Cards that can play audio or video content.

## SYNTAX

```
New-CardMedia [-Sources] <Hashtable> [[-Poster] <String>] [[-AltText] <String>] [[-CaptionSources] <Array>]
 [[-Id] <String>] [[-Height] <String>] [-Separator] [[-Spacing] <String>] [-IsHidden] [[-Requires] <Hashtable>]
 [[-Fallback] <ScriptBlock>] [[-TargetWidth] <String>] [[-Lang] <String>] [[-GridArea] <String>] [-IsSortKey]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardMedia function creates a Media element that displays audio or video content
in an Adaptive Card.
Supports multiple sources and formats, including YouTube, Vimeo, and Dailymotion.

## EXAMPLES

### EXAMPLE 1
```
New-CardMedia -Sources @(
    @{ mimeType = "video/mp4"; url = "https://example.com/video.mp4" }
) -Poster "https://example.com/poster.jpg" -AltText "Demo Video"
```

### EXAMPLE 2
```
# YouTube video
New-CardMedia -Sources @(
    @{ mimeType = "video/youtube"; url = "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }
) -AltText "YouTube Video"
```

### EXAMPLE 3
```
# With captions
New-CardMedia -Sources @(
    @{ mimeType = "video/mp4"; url = "https://example.com/video.mp4" }
) -CaptionSources @(
    @{ mimeType = "text/vtt"; url = "https://example.com/captions-en.vtt"; label = "English" },
    @{ mimeType = "text/vtt"; url = "https://example.com/captions-es.vtt"; label = "Spanish" }
) -AltText "Video with Captions"
```

## PARAMETERS

### -Sources
Array of media sources.
Each source should be a hashtable with 'mimeType' and 'url' properties.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Poster
URL of the poster image to display before the media is played.

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

### -AltText
Alternate text for accessibility purposes.

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

### -CaptionSources
Array of caption sources.
Each should be a hashtable with 'mimeType', 'url', and optional 'label' properties.
Note: Caption sources are not used for YouTube, Dailymotion, or Vimeo sources.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Unique identifier for the element.

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

### -Height
The height of the element.
Valid values: "auto", "stretch"

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

### -Separator
If true, draw a separating line at the top of the element.

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
Controls the amount of spacing between this element and the preceding element.

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

### -IsHidden
{{ Fill IsHidden Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Hide

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Requires
A series of key/value pairs indicating features that the item requires with corresponding minimum version.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fallback
ScriptBlock that generates fallback content if Media is not supported.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetWidth
Controls for which card width the element should be displayed.

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

### -Lang
The locale associated with the element.

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
The area of a Layout.AreaGrid layout in which the element should be displayed.

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

### -IsSortKey
Controls whether the element should be used as a sort key.

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

## NOTES

## RELATED LINKS
