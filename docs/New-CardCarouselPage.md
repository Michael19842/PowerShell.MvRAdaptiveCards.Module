---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version:
schema: 2.0.0
---

# New-CardCarouselPage

## SYNOPSIS
Creates a page for a Carousel container.

## SYNTAX

```
New-CardCarouselPage [-Items] <ScriptBlock> [[-BackgroundImage] <Object>] [[-MinHeight] <String>]
 [[-MaxHeight] <String>] [[-VerticalContentAlignment] <String>] [[-Style] <String>] [-Rtl]
 [[-SelectAction] <Object>] [-ShowBorder] [-RoundedCorners] [[-Layouts] <Array>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a carousel page that contains elements to be displayed in a carousel.

## EXAMPLES

### EXAMPLE 1
```
New-CardCarouselPage {
    New-CardTextBlock -Text "Welcome" -Size ExtraLarge
    New-CardImage -Url "https://example.com/welcome.jpg"
}
```

### EXAMPLE 2
```
New-CardCarouselPage -Style 'emphasis' -Items {
    New-CardTextBlock -Text "Featured Item" -Weight Bolder
    New-CardTextBlock -Text "Special offer today only!"
}
```

## PARAMETERS

### -Items
A scriptblock that generates the elements for this page.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases: Content

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackgroundImage
Defines the page's background image (URL or object).

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinHeight
The minimum height of the page in pixels (format: "100px").

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

### -MaxHeight
The maximum height of the page in pixels (format: "500px").

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

### -VerticalContentAlignment
Controls how the page's content should be vertically aligned.
Valid values: Top, Center, Bottom

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

### -Style
The style of the page.
Valid values: default, emphasis, accent, good, attention, warning

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

### -Rtl
Controls if the content should be rendered right-to-left.

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

### -SelectAction
An action to invoke when the page is tapped or clicked.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowBorder
Controls if a border should be displayed around the page.

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

### -RoundedCorners
Controls if the page should have rounded corners.

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

### -Layouts
Array of layout objects for responsive layout support.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
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

## RELATED LINKS
