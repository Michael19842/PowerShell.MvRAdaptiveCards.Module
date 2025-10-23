---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#layoutflow
schema: 2.0.0
---

# New-CardLayoutFlow

## SYNOPSIS
Creates a new Flow layout for an Adaptive Card container.

## SYNTAX

```
New-CardLayoutFlow [[-ColumnSpacing] <String>] [[-RowSpacing] <String>] [[-HorizontalItemsAlignment] <String>]
 [[-VerticalItemsAlignment] <String>] [[-ItemFit] <String>] [[-ItemWidth] <Int32>] [[-MinItemWidth] <Int32>]
 [[-MaxItemWidth] <Int32>] [[-TargetWidth] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The New-CardLayoutFlow function creates a Layout.Flow object that controls how items
are arranged in a container.
Flow layouts automatically arrange items in rows, wrapping
to new rows as needed, similar to a flexbox layout.
This layout is available in Teams
and provides responsive, flexible item arrangement.

## EXAMPLES

### EXAMPLE 1
```
New-CardLayoutFlow -ColumnSpacing "Medium" -RowSpacing "Large"
```

Creates a flow layout with medium column spacing and large row spacing.

### EXAMPLE 2
```
New-CardLayoutFlow -MinItemWidth 200 -MaxItemWidth 400 -HorizontalItemsAlignment "Left"
```

Creates a flow layout where items are between 200-400px wide and aligned to the left.

### EXAMPLE 3
```
New-CardLayoutFlow -ItemWidth 300 -VerticalItemsAlignment "Center" -ItemFit "Fill"
```

Creates a flow layout with fixed 300px width items that fill available space and are centered vertically.

## PARAMETERS

### -ColumnSpacing
The space between items horizontally.
Valid values are:
- None: No spacing
- ExtraSmall: Minimal spacing
- Small: Small spacing
- Default: Default spacing (default value)
- Medium: Medium spacing
- Large: Large spacing
- ExtraLarge: Extra large spacing
- Padding: Padding-based spacing

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -RowSpacing
The space between rows of items vertically.
Valid values are:
- None: No spacing
- ExtraSmall: Minimal spacing
- Small: Small spacing
- Default: Default spacing (default value)
- Medium: Medium spacing
- Large: Large spacing
- ExtraLarge: Extra large spacing
- Padding: Padding-based spacing

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -HorizontalItemsAlignment
Controls how the content of the container should be horizontally aligned.
Valid values are: Left, Center (default), Right

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Center
Accept pipeline input: False
Accept wildcard characters: False
```

### -VerticalItemsAlignment
Controls how the content of the container should be vertically aligned.
Valid values are: Top (default), Center, Bottom

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

### -ItemFit
Controls how items should fit inside the container.
Valid values are:
- Fit: Items maintain their aspect ratio (default)
- Fill: Items fill the available space

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Fit
Accept pipeline input: False
Accept wildcard characters: False
```

### -ItemWidth
The width, in pixels, of each item.
Should not be used if MaxItemWidth
and/or MinItemWidth are set.
Specify as an integer (pixels will be added automatically).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinItemWidth
The minimum width, in pixels, of each item.
Should not be used if ItemWidth is set.
Specify as an integer (pixels will be added automatically).
Default is 0.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxItemWidth
The maximum width, in pixels, of each item.
Should not be used if ItemWidth is set.
Specify as an integer (pixels will be added automatically).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetWidth
Controls for which card width the layout should be used.
This enables responsive
layouts that adapt to different screen sizes.

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
### Returns a hashtable representing the Layout.Flow structure.
## NOTES
- This is a Teams-specific layout (version 1.5+)
- ItemWidth should not be combined with MinItemWidth or MaxItemWidth
- Flow layouts automatically wrap items to new rows based on available space
- Use TargetWidth for responsive layouts that change based on card width

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#layoutflow](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#layoutflow)

