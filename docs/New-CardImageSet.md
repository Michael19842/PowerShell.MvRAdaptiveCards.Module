---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#imageset
schema: 2.0.0
---

# New-CardImageSet

## SYNOPSIS
Creates an ImageSet element for an Adaptive Card to display a collection of images.

## SYNTAX

```
New-CardImageSet [-Images] <ScriptBlock> [[-ImageSize] <String>] [[-Fallback] <ScriptBlock>]
 [[-GridArea] <String>] [[-Height] <String>] [[-HorizontalAlignment] <String>] [[-Id] <String>]
 [[-BackgroundColor] <String>] [[-Spacing] <Object>] [[-Language] <String>] [-Separator] [-IsSortKey]
 [-IsHidden] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardImageSet function creates an ImageSet element for Adaptive Cards that displays a collection of images
in a compact layout.
ImageSets are useful for showing galleries, thumbnails, or related images together.
This function supports customization of image size, spacing, alignment, and other layout properties.

The Images parameter accepts a scriptblock that should return one or more image elements created with New-CardImage.
All images in the set will be displayed with the same size as specified by the ImageSize parameter.

## EXAMPLES

### EXAMPLE 1
```
New-CardImageSet -Images {
    New-CardImage -Url "https://example.com/image1.jpg" -AltText "Image 1"
    New-CardImage -Url "https://example.com/image2.jpg" -AltText "Image 2"
    New-CardImage -Url "https://example.com/image3.jpg" -AltText "Image 3"
} -ImageSize "Medium"
```

Creates an ImageSet with three images, all displayed at medium size.

### EXAMPLE 2
```
New-CardImageSet -Images {
    New-CardImage -Url "https://example.com/thumb1.jpg" -AltText "Thumbnail 1"
    New-CardImage -Url "https://example.com/thumb2.jpg" -AltText "Thumbnail 2"
} -ImageSize "Small" -HorizontalAlignment "Center" -Spacing "Medium"
```

Creates a centered ImageSet with small thumbnails and medium spacing above it.

### EXAMPLE 3
```
New-CardImageSet -Images {
    New-CardImage -Url "https://example.com/gallery1.jpg" -AltText "Gallery Image 1"
    New-CardImage -Url "https://example.com/gallery2.jpg" -AltText "Gallery Image 2"
} -ImageSize "Large" -BackgroundColor "Light" -Id "photo-gallery" -Separator
```

Creates a large ImageSet with light background, separator, and a custom ID for reference.

### EXAMPLE 4
```
New-CardImageSet -Images {
    New-CardImage -Url "https://example.com/product1.jpg" -AltText "Product 1"
    New-CardImage -Url "https://example.com/product2.jpg" -AltText "Product 2"
} -Fallback {
    New-CardTextBlock -Text "Product images not available"
} -Height "Stretch"
```

Creates an ImageSet with fallback content and stretch height behavior.

## PARAMETERS

### -Images
A scriptblock containing the image elements to be included in the ImageSet.
The scriptblock should return
one or more New-CardImage elements.
All images will be displayed with uniform sizing.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImageSize
Controls the size of all images in the set.
Valid values are:
- Small: Small image size
- Medium: Medium image size (typically default)
- Large: Large image size
All images in the set will use this uniform size.

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

### -Fallback
A scriptblock that defines fallback content to display if the ImageSet cannot be rendered
or is not supported by the host.
Should return an appropriate Adaptive Card element.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GridArea
Specifies the named grid area where the ImageSet should be placed when used in a grid layout.
This corresponds to the CSS grid-area property.

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
Controls the height behavior of the ImageSet.
Valid values are:
- Auto: Height adjusts automatically to content (default)
- Stretch: ImageSet stretches to fill available vertical space

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
Controls the horizontal alignment of the ImageSet within its container.
Valid values are:
- Left: Aligns the ImageSet to the left side
- Center: Centers the ImageSet horizontally
- Right: Aligns the ImageSet to the right side

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

### -Id
A unique identifier for the ImageSet element.
Useful for referencing the element programmatically
or for styling purposes.

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

### -BackgroundColor
Specifies the background color for the ImageSet.
Valid values are:
- Default: Uses the theme's default background color
- Dark: Dark background color
- Light: Light background color
- Accent: Uses the theme's accent background color
- Good: Green background, typically used for success states
- Warning: Orange/yellow background, used for warnings
- Attention: Red background, used for errors or critical states

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

### -Spacing
Controls the amount of spacing above the ImageSet.
Valid values are:
- None: No spacing
- Small: Small spacing
- Default: Default spacing
- Medium: Medium spacing
- Large: Large spacing
- ExtraLarge: Extra large spacing
- Padding: Adds padding around the element

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

### -Language
Specifies the language/locale for the ImageSet element.
Used for proper text rendering
and accessibility features.
Alias: Lang

```yaml
Type: String
Parameter Sets: (All)
Aliases: Lang

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Separator
When specified, adds a separator line above the ImageSet to visually separate it from
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

### -IsSortKey
When specified, marks this ImageSet as a sort key element.
Used in scenarios where
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

### -IsHidden
When specified, sets the ImageSet to be hidden (isVisible = false).
The element will
not be displayed but can be shown programmatically.
Alias: Hide

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
### Returns a hashtable representing the ImageSet element that can be used in an Adaptive Card.
## NOTES
This function is part of the MvRAdaptiveCards module for creating Adaptive Cards in PowerShell.
ImageSets are ideal for displaying multiple related images in a compact, uniform layout.
All images in the set will be displayed with the same size regardless of their original dimensions.
Consider using individual Image elements if you need different sizes for different images.

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#imageset](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#imageset)

