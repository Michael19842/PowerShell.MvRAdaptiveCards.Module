---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://learn.microsoft.com/adaptive-cards/authoring-cards/card-schema#backgroundimage
schema: 2.0.0
---

# New-CardBackgroundImageThemedUrl

## SYNOPSIS
Creates a ThemedUrl object for Adaptive Card background images.

## SYNTAX

```
New-CardBackgroundImageThemedUrl [-Theme] <String> [-Url] <String> [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Generates the hashtable structure required by the Adaptive Card schema to supply
theme-specific background image URLs.
Intended to be used from the ThemedUrls
ScriptBlock parameter of New-CardBackgroundImage.

## EXAMPLES

### EXAMPLE 1
```
New-CardBackgroundImage -Url "https://contoso.com/default.png" -ThemedUrls {
    New-CardBackgroundImageThemedUrl -Theme "dark" -Url "https://contoso.com/dark.png"
}
```

Adds a dark-mode background image override in addition to the default URL.

## PARAMETERS

### -Theme
Name of the theme this URL applies to (for example, "dark" or "highContrast").

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

### -Url
Image URL or Data URI that should be applied when the referenced theme is active.

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
### Returns a hashtable representing a ThemedUrl object.
## NOTES

## RELATED LINKS

[https://learn.microsoft.com/adaptive-cards/authoring-cards/card-schema#backgroundimage](https://learn.microsoft.com/adaptive-cards/authoring-cards/card-schema#backgroundimage)

