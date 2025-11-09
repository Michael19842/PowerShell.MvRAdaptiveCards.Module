---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version:
schema: 2.0.0
---

# New-CardProgressRing

## SYNOPSIS
Creates a new ProgressRing element for an Adaptive Card.

## SYNTAX

```
New-CardProgressRing [[-Label] <String>] [[-LabelPosition] <String>] [[-Size] <String>] [[-Id] <String>]
 [[-Height] <String>] [[-HorizontalAlignment] <String>] [[-GridArea] <String>] [[-Spacing] <String>]
 [[-TargetWidth] <String>] [[-Lang] <String>] [[-Requires] <Hashtable>] [[-Fallback] <Object>] [-IsHidden]
 [-IsSortKey] [-Separator] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardProgressRing function creates a ProgressRing element that displays a circular
progress indicator in an Adaptive Card.
ProgressRings are typically used to show indeterminate
progress or loading states with an optional label.
They provide a visually distinct alternative
to progress bars with a circular design that works well in compact spaces.

## EXAMPLES

### EXAMPLE 1
```
New-CardProgressRing
```

Creates a simple progress ring with default medium size and no label.

### EXAMPLE 2
```
New-CardProgressRing -Label "Loading..." -Size Large
```

Creates a large progress ring with a "Loading..." label below it.

### EXAMPLE 3
```
New-CardProgressRing -Label "Processing" -LabelPosition Above -Size Small
```

Creates a small progress ring with the label positioned above it.

### EXAMPLE 4
```
New-AdaptiveCard -Body {
    New-CardTextBlock -Text "System Status" -Weight Bolder
    New-CardProgressRing -Label "Initializing services..." -Size Medium -HorizontalAlignment Center
    New-CardTextBlock -Text "Please wait while we set up your environment." -Size Small -Color Accent
}
```

Creates a card with a centered progress ring showing system initialization status.

### EXAMPLE 5
```
New-CardProgressRing -Label "Syncing data" -Size Tiny -Fallback {
    New-CardTextBlock -Text "⟳ Syncing data..." -Color Accent
}
```

Creates a progress ring with fallback content for hosts that don't support ProgressRing.

## PARAMETERS

### -Label
The optional text label to display with the progress ring.
This text provides context
about what is being loaded or processed.

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

### -LabelPosition
Controls the relative position of the label to the progress ring.
Valid values are:
- Below: Label appears below the progress ring (default)
- Above: Label appears above the progress ring
- Before: Label appears to the left of the progress ring
- After: Label appears to the right of the progress ring

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

### -Size
Controls the size of the progress ring.
Valid values are:
- Tiny: Very small progress ring
- Small: Small progress ring
- Medium: Medium-sized progress ring (default)
- Large: Large progress ring

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

### -Id
A unique identifier for the ProgressRing element.
Useful for referencing the element
programmatically or for accessibility purposes.

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
Controls the height behavior of the ProgressRing.
Valid values are:
- auto: Height adjusts automatically to content (default)
- stretch: ProgressRing stretches to fill available vertical space

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
Controls the horizontal alignment of the progress ring within its container.
Valid values are:
- Left: Aligns progress ring to the left side
- Center: Centers progress ring horizontally
- Right: Aligns progress ring to the right side

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
Specifies the named grid area where the ProgressRing should be placed when used in a grid layout.
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

### -Spacing
Controls the amount of spacing above the progress ring.
Valid values are:
- None: No spacing
- ExtraSmall: Extra small spacing
- Small: Small spacing
- Default: Default spacing
- Medium: Medium spacing
- Large: Large spacing
- ExtraLarge: Extra large spacing
- Padding: Padding spacing

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

### -TargetWidth
Specifies the target width for the progress ring in adaptive layouts.
Valid values include:
- VeryNarrow, Narrow, Standard, Wide
- atLeast:VeryNarrow, atMost:VeryNarrow
- atLeast:Narrow, atMost:Narrow
- atLeast:Standard, atMost:Standard
- atLeast:Wide, atMost:Wide

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

### -Lang
Specifies the language/locale for the ProgressRing element.
Used for proper rendering
and accessibility features.

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

### -Requires
A hashtable specifying feature requirements for the ProgressRing.
Used to declare dependencies
on specific Adaptive Card features or host capabilities.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fallback
A scriptblock that defines fallback content to display if the ProgressRing cannot be rendered
or is not supported by the host.
Should return an appropriate Adaptive Card element.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsHidden
When specified, sets the progress ring to be hidden (isVisible = false).
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

### -IsSortKey
When specified, marks this element as a sort key for collections that allow sorting.

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

### -Separator
When specified, displays a separator line above the ProgressRing to visually separate it
from the previous element.
No separator will be displayed for the first element in a container.

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

### System.Collections.Hashtable
## NOTES
- ProgressRing elements are typically used for indeterminate progress (unknown completion time)
- Unlike ProgressBar, ProgressRing doesn't show specific completion percentages
- The circular design makes progress rings suitable for compact layouts
- Consider the size and label position based on your card's overall design
- Progress rings are ideal for loading states, background processes, or ongoing operations

## RELATED LINKS

[New-AdaptiveCard
New-CardProgressBar
New-CardTextBlock]()

