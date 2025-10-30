---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://adaptivecards.io/explorer/Chart.Donut.html
schema: 2.0.0
---

# New-CardChartDonut

## SYNOPSIS
Creates a new Donut Chart element for an Adaptive Card.

## SYNTAX

```
New-CardChartDonut [[-Title] <String>] [-Data] <Hashtable[]> [[-ColorSet] <String>] [[-Id] <String>]
 [[-Height] <String>] [[-HorizontalAlignment] <String>] [[-Spacing] <String>] [-Separator]
 [[-IsVisible] <Boolean>] [-isSortKey] [[-Lang] <String>] [[-GridArea] <String>] [[-TargetWidth] <String>]
 [[-Fallback] <ScriptBlock>] [[-Requires] <Hashtable>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardChartDonut function creates a donut chart element that visualizes data in a circular
format with a hollow center.
Donut charts are excellent for showing proportions and percentages
of a whole, making them ideal for displaying category distributions, budget allocations, or
completion statuses.

## EXAMPLES

### EXAMPLE 1
```
$data = @(
    @{ label = "Product A"; value = 35 }
    @{ label = "Product B"; value = 25 }
    @{ label = "Product C"; value = 20 }
    @{ label = "Product D"; value = 20 }
)
```

New-CardChartDonut -Title "Product Distribution" -Data $data -ColorSet "categorical"

Creates a donut chart showing product distribution with categorical colors.

### EXAMPLE 2
```
$budgetData = @(
    @{ label = "Development"; value = 45; color = "#0078D4" }
    @{ label = "Marketing"; value = 25; color = "#00CC6A" }
    @{ label = "Operations"; value = 20; color = "#FFB900" }
    @{ label = "Other"; value = 10; color = "#E74856" }
)
```

New-CardChartDonut -Title "Budget Allocation" -Data $budgetData -HorizontalAlignment "Center"

Creates a centered donut chart with custom colors for each segment.

### EXAMPLE 3
```
New-CardChartDonut -Title "Task Completion" -Data @(
    @{ label = "Completed"; value = 75 }
    @{ label = "In Progress"; value = 15 }
    @{ label = "Not Started"; value = 10 }
) -ColorSet "sequential" -Separator
```

Creates a donut chart with sequential colors and a separator line above it.

## PARAMETERS

### -Title
The title of the chart that will be displayed above the donut chart.

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

### -Data
An array of hashtables representing the data to display in the chart.
Each hashtable should contain:
- label: The name/label for the data segment
- value: The numeric value for the segment
- color: (Optional) The color for the segment (overrides colorSet)

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ColorSet
The name of the set of colors to use to render the chart.
Valid values are:
- categorical: Use distinct colors for each segment (default)
- sequential: Use a gradient of colors from light to dark
- diverging: Use colors that diverge from a midpoint

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
A unique identifier for the element.
Useful for referencing in actions or for accessibility.

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
The height of the element.
Valid values are:
- auto: The element will size itself based on content (default)
- stretch: The element will use the remaining vertical space in its container

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
Controls how the element should be horizontally aligned.
Valid values are:
- Left: Align to the left
- Center: Center the element
- Right: Align to the right

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

### -Spacing
Controls the amount of space between this element and the previous one.
Valid values are:
- None: No spacing
- ExtraSmall: Minimal spacing
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
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Separator
A switch parameter that adds a separator line above the element to visually separate it from
the previous element.

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

### -IsVisible
Controls the visibility of the element.
Set to $false to hide the element.

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

### -isSortKey
A switch parameter that controls whether the element should be used as a sort key by elements
that allow sorting across a collection of elements.

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

### -Lang
The locale associated with the element (e.g., "en-US", "fr-FR").

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

### -GridArea
The area of a Layout.AreaGrid layout in which the element should be displayed.

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

### -TargetWidth
Controls for which card width the element should be displayed.
Valid values are:
- VeryNarrow, Narrow, Standard, Wide
- atLeast:VeryNarrow, atLeast:Narrow, atLeast:Standard, atLeast:Wide
- atMost:VeryNarrow, atMost:Narrow, atMost:Standard, atMost:Wide

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

### -Fallback
A scriptblock that generates an alternate element to render if the host doesn't support donut charts.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
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
Position: 13
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
### Returns a hashtable representing the Chart.Donut element structure.
## NOTES
- Donut charts require Adaptive Cards version 1.5 or later
- Data values are automatically converted to percentages
- Each data segment should have a label and value
- Custom colors override the colorSet parameter
- The center of the donut remains empty, distinguishing it from a pie chart

## RELATED LINKS

[https://adaptivecards.io/explorer/Chart.Donut.html](https://adaptivecards.io/explorer/Chart.Donut.html)

[New-CardChartPie]()

[New-CardChartVerticalBar]()

