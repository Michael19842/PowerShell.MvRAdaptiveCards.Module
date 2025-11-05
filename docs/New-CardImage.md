---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#image
schema: 2.0.0
---

# New-CardImage

## SYNOPSIS
Creates a new Image element for an Adaptive Card.

## SYNTAX

```
New-CardImage [-Url] <String> [[-AltText] <String>] [[-FitMode] <String>] [[-Size] <String>] [[-Id] <String>]
 [[-BackgroundColor] <String>] [[-Height] <String>] [[-HorizontalAlignment] <String>]
 [[-HorizontalContentAlignment] <String>] [[-VerticalContentAlignment] <String>] [[-Width] <String>]
 [[-Style] <String>] [-Separator] [[-Spacing] <String>] [-AllowExpand] [[-SelectAction] <ScriptBlock>]
 [[-Fallback] <ScriptBlock>] [[-Requires] <Hashtable>] [[-TargetWidth] <String>] [[-ThemedUrls] <Array>]
 [[-Lang] <String>] [[-GridArea] <String>] [-IsHidden] [-IsSortKey] [-AsBase64]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardImage function creates an Image element that displays images in an Adaptive Card.
It supports various sizing options, fit modes, and accessibility features to ensure proper
image display across different devices and platforms.

## EXAMPLES

### EXAMPLE 1
```
New-CardImage -Url "https://example.com/logo.png" -AltText "Company Logo"
```

Creates a basic image element with a URL and alt text.

### EXAMPLE 2
```
New-CardImage -Url "https://example.com/photo.jpg" -AltText "Team Photo" -Size "Large" -FitMode "Cover"
```

Creates a large image that covers its allocated space, potentially cropping parts of the image.

### EXAMPLE 3
```
New-CardImage -Url "https://example.com/chart.png" -AltText "Sales Chart" -Id "SalesChart" -AllowExpand -Separator
```

Creates an expandable image with a separator line above it and an ID for reference in actions.

### EXAMPLE 4
```
New-CardImage -Url "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==" -AltText "Red pixel" -Size "Small"
```

Creates a small image using a data URL (base64 encoded image).

## PARAMETERS

### -Url
The URL of the image to display.
Supports both HTTP/HTTPS URLs and data URLs.
The image should be accessible by the client application displaying the Adaptive Card.

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

### -AltText
Alternative text for the image, used for accessibility purposes.
This text is read by
screen readers and displayed when the image cannot be loaded.
Should describe the content
or purpose of the image.

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

### -FitMode
Specifies how the image should be fitted within its allocated space.
Valid values are:
- Cover: Scale the image to cover the entire area, may crop parts of the image
- Contain: Scale the image to fit completely within the area, may leave empty space
- Fill: Stretch the image to fill the entire area, may distort the image proportions

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

### -Size
The size of the image.
Valid values are:
- Auto: Automatic sizing based on the image's natural dimensions
- Stretch: Stretch to fill available width
- Small: Small fixed size
- Medium: Medium fixed size
- Large: Large fixed size

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

### -Id
An optional unique identifier for the Image element.
Useful for referencing the image
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

### -BackgroundColor
The background color to render behind the image. Accepts CSS color values and host color resources.

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

### -Height
Controls the height of the image. Valid values are "auto", "stretch", or a number followed by "px".

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

### -HorizontalAlignment
Controls how the image should be horizontally aligned within its parent container.
Valid values are: Left, Center, Right.

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

### -HorizontalContentAlignment
Controls how the image content is aligned horizontally within its bounding box when height and width are set.
Valid values are: Left, Center, Right.

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

### -VerticalContentAlignment
Controls how the image content is aligned vertically within its bounding box when height and width are set.
Valid values are: Top, Center, Bottom.

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

### -Width
Controls the width of the image. Valid values are "auto", "stretch", or a number followed by "px".

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

### -Style
Specifies the image style. Valid values are: Default, Person, RoundedCorners.

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

### -Separator
A switch parameter that adds a separator line above the image element.
Useful for
visually separating the image from preceding elements.

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
Controls the amount of space between the image and the previous element.
Valid values are: None, ExtraSmall, Small, Default, Medium, Large, ExtraLarge, Padding.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllowExpand
A switch parameter that allows the image to be expanded when clicked/tapped.
When enabled, users can interact with the image to view it in a larger format.

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
A scriptblock that returns an Adaptive Card action to invoke when the image is clicked or tapped.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fallback
A scriptblock that returns fallback content if the image cannot be rendered.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Requires
Hashtable of host capability requirements for the image element.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetWidth
Controls the card widths at which this image should be displayed. Supports responsive values
such as VeryNarrow, Narrow, Standard, Wide, atLeast:<Width>, and atMost:<Width>.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThemedUrls
Array of themed URLs for the image. Each entry should include theme-specific URLs, such as
@{ theme = "dark"; url = "https://example.com/dark.png" }.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Lang
Specifies the locale associated with the image element.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GridArea
Sets the layout grid area in which the image should render when using Layout.AreaGrid.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 20
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsHidden
When specified, sets isVisible to false so the image starts hidden.

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

### -IsSortKey
When specified, marks the image as usable as a sort key in sortable collections.

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

### -AsBase64
{{ Fill AsBase64 Description }}

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
### Returns a hashtable representing the Image element structure for the Adaptive Card.
## NOTES
- The Url parameter should point to an accessible image resource
- AltText is crucial for accessibility and should meaningfully describe the image
- FitMode and Size parameters work together to control image appearance
- AllowExpand provides interactive image viewing capabilities
- The Separator parameter helps with visual organization of card elements
- Data URLs are supported for embedding small images directly in the card

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#image](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#image)

