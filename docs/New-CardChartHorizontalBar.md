---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version:
schema: 2.0.0
---

# New-CardChartHorizontalBar

## SYNOPSIS
Creates a horizontal bar chart element for Adaptive Cards.

## SYNTAX

```
New-CardChartHorizontalBar [-Data] <Array> [[-Title] <String>] [[-Color] <String>] [[-ColorSet] <String>]
 [[-DisplayMode] <String>] [[-XAxisTitle] <String>] [[-YAxisTitle] <String>] [[-Id] <String>]
 [[-Height] <String>] [[-HorizontalAlignment] <String>] [-Separator] [[-Spacing] <String>]
 [[-IsVisible] <Boolean>] [[-IsSortKey] <Boolean>] [[-TargetWidth] <String>] [[-GridArea] <String>]
 [[-Lang] <String>] [[-Fallback] <ScriptBlock>] [[-Requires] <Hashtable>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a Chart.HorizontalBar element with configurable data points, colors, and display options.

## EXAMPLES

### EXAMPLE 1
```
New-CardChartHorizontalBar -Title "Sales Data" -Data @(
    @{ label = "Q1"; value = 100 },
    @{ label = "Q2"; value = 150 },
    @{ label = "Q3"; value = 120 }
) -ColorSet "categorical"
```

### EXAMPLE 2
```
New-CardChartHorizontalBar -Title "Progress" -Data @(
    @{ label = "Complete"; value = 75; color = "good" },
    @{ label = "Remaining"; value = 25; color = "neutral" }
) -DisplayMode "PartToWhole"
```

## PARAMETERS

### -Data
Array of data points for the chart.
Each data point should be a hashtable with properties like label, value, and optional color.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
The title of the chart.

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

### -Color
The color to use for all data points.
Valid values include: good, warning, attention, neutral, and various categorical, sequential, and diverging colors.

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

### -ColorSet
The name of the set of colors to use to render the chart.
Valid values: categorical, sequential, diverging.

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

### -DisplayMode
Controls how the chart should be visually laid out.
Valid values: AbsoluteWithAxis, AbsoluteNoAxis, PartToWhole.
Default is AbsoluteWithAxis.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: AbsoluteWithAxis
Accept pipeline input: False
Accept wildcard characters: False
```

### -XAxisTitle
The title of the x axis.

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

### -YAxisTitle
The title of the y axis.

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

### -Id
A unique identifier for the element.

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

### -Height
The height of the element.
Valid values: auto, stretch.

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

### -HorizontalAlignment
Controls how the element should be horizontally aligned.
Valid values: Left, Center, Right.

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

### -Separator
Controls whether a separator line should be displayed above the element.

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
Controls the amount of space between this element and the previous one.
Valid values: None, ExtraSmall, Small, Default, Medium, Large, ExtraLarge, Padding.

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

### -IsVisible
Controls the visibility of the element.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsSortKey
Controls whether the element should be used as a sort key.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: False
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
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GridArea
The area of a Layout.AreaGrid layout in which an element should be displayed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
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
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fallback
An alternate element to render if this element type is unsupported.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Requires
A hashtable of capabilities the element requires the host application to support.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
Default value: None
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

## NOTES

## RELATED LINKS
