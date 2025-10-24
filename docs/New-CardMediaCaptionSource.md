---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version:
schema: 2.0.0
---

# New-CardMediaCaptionSource

## SYNOPSIS
Creates a caption source object for use with Media elements in Adaptive Cards.

## SYNTAX

```
New-CardMediaCaptionSource [-Url] <String> [[-MimeType] <String>] [[-Label] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardMediaCaptionSource function creates a caption source object that defines
subtitles or captions for video content in Media elements.
Each caption source specifies
a URL to a caption file (typically WebVTT format) and optional label and MIME type.

## EXAMPLES

### EXAMPLE 1
```
New-CardMediaCaptionSource -Url "https://example.com/captions-en.vtt" -MimeType "text/vtt" -Label "English"
```

### EXAMPLE 2
```
# Multiple caption sources
$captions = @(
    New-CardMediaCaptionSource -Url "https://example.com/captions-en.vtt" -MimeType "text/vtt" -Label "English"
    New-CardMediaCaptionSource -Url "https://example.com/captions-es.vtt" -MimeType "text/vtt" -Label "Spanish"
    New-CardMediaCaptionSource -Url "https://example.com/captions-fr.vtt" -MimeType "text/vtt" -Label "French"
)
New-CardMedia -Sources @{...} -CaptionSources $captions
```

## PARAMETERS

### -Url
The URL of the caption file.
Typically points to a WebVTT (.vtt) file.

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

### -MimeType
The MIME type of the caption file.
Common value: "text/vtt" for WebVTT files.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Text/vtt
Accept pipeline input: False
Accept wildcard characters: False
```

### -Label
The label for this caption source, typically the language name (e.g., "English", "Spanish").
This label is shown to users when selecting captions.

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
## NOTES
Caption sources are not used for YouTube, Dailymotion, or Vimeo videos.
WebVTT (Web Video Text Tracks) is the standard format for captions.

## RELATED LINKS
