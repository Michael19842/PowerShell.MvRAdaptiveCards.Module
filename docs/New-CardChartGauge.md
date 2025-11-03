---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version:
schema: 2.0.0
---

# New-CardChartGauge

## SYNOPSIS
Creates a Chart.Gauge element for an Adaptive Card.

## SYNTAX

```
New-CardChartGauge [[-Value] <Double>] [[-Min] <Double>] [[-Max] <Double>] [[-Title] <String>]
 [[-SubLabel] <String>] [[-ValueFormat] <String>] [[-Segments] <Array>] [[-ShowLegend] <Boolean>]
 [[-ShowMinMax] <Boolean>] [[-ColorSet] <String>] [[-Id] <String>] [[-Height] <String>]
 [[-HorizontalAlignment] <String>] [-Separator] [[-Spacing] <String>] [[-IsVisible] <Boolean>]
 [[-Requires] <Hashtable>] [[-Fallback] <Object>] [[-TargetWidth] <String>] [[-GridArea] <String>]
 [[-Lang] <String>] [[-IsSortKey] <Boolean>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The New-CardChartGauge function creates a gauge chart element that displays a single value
within a defined range, typically shown as a semicircular or circular indicator.
Gauge charts
are ideal for displaying metrics like completion percentage, progress indicators, performance
scores, or any measurement against a scale.

## EXAMPLES

### EXAMPLE 1
```
New-CardChartGauge -Value 75 -Min 0 -Max 100 -Title "Project Completion"
```

Creates a simple gauge showing 75% completion.

### EXAMPLE 2
```
New-CardChartGauge -Value 85 -Max 100 -Title "Performance Score" -SubLabel "Quarterly Review" -ValueFormat "Percentage"
```

Creates a gauge with a subtitle showing performance as a percentage.

### EXAMPLE 3
```
$segments = @(
    @{ min = 0; max = 40; label = "Low"; color = "#D13438" }
    @{ min = 40; max = 70; label = "Medium"; color = "#FFB900" }
    @{ min = 70; max = 100; label = "High"; color = "#00CC6A" }
)
New-CardChartGauge -Value 82 -Max 100 -Title "Customer Satisfaction" -Segments $segments -ShowLegend $true
```

Creates a gauge with colored segments representing satisfaction levels.

### EXAMPLE 4
```
New-CardChartGauge -Value 45 -Min 0 -Max 100 -Title "Storage Used" -ValueFormat "Fraction" -ShowMinMax $true
```

Creates a gauge showing storage usage displayed as a fraction with min/max values visible.

## PARAMETERS

### -Value
The current value to display on the gauge.
Default is 0.

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Min
The minimum value of the gauge scale.
Default is 0.

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Max
The maximum value of the gauge scale.
This parameter is required to define the upper bound.

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
The title text displayed above or near the gauge chart.

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

### -SubLabel
Additional descriptive text displayed below the value, providing context for the measurement.

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

### -ValueFormat
The format used to display the gauge's value.
Valid values are:
- Percentage: Displays the value as a percentage (e.g., "75%")
- Fraction: Displays the value as a fraction (e.g., "75/100")
Default is "Percentage".

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

### -Segments
An array of segment objects that define colored ranges on the gauge.
Each segment should be
a hashtable with properties like min, max, label, and color to create visual zones
(e.g., red zone for low, yellow for medium, green for high).

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowLegend
Controls whether the legend should be displayed.
Default is $true.
Set to $false to hide the legend.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowMinMax
Controls whether the minimum and maximum values should be displayed on the gauge.
Default is $true.
Set to $false to hide these values.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ColorSet
The name of the set of colors to use to render the chart.
Valid values are:
- categorical: Use distinct colors
- sequential: Use a gradient from light to dark
- diverging: Use colors that diverge from a midpoint

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

### -Id
A unique identifier for the element.
Useful for referencing in actions or for accessibility.

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

### -Height
Controls the height of the element.
Valid values: "auto", "stretch".

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

### -HorizontalAlignment
Controls how the element should be horizontally aligned.
Valid values: "Left", "Center", "Right".

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

### -Separator
Displays a separator line above the element to visually separate it from the previous element.

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
Valid values: "None", "ExtraSmall", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding".

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

### -IsVisible
Controls the visibility of the element.
Default is $true.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Requires
Hashtable of capabilities the element requires the host to support.

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

### -Fallback
Alternate element or "drop" to render if this element type is unsupported.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetWidth
Controls for which card width the element should be displayed.
Enables responsive layouts.
Valid values: "VeryNarrow", "Narrow", "Standard", "Wide", or atLeast/atMost variants.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
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
Position: 19
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
Position: 20
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsSortKey
Controls whether the element should be used as a sort key by elements that allow sorting.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 21
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

### [hashtable]
### Returns a hashtable representing the Chart.Gauge element with all configured properties.
## NOTES
- Introduced in Adaptive Cards version 1.5
- Gauge charts are excellent for KPIs and single-value metrics
- Segments allow visual zones to indicate ranges (good/warning/critical)

## RELATED LINKS

[New-AdaptiveCard]()

[New-CardChartDonut]()

[New-CardProgressBar]()

