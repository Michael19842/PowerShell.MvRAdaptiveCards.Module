---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version:
schema: 2.0.0
---

# New-CardProgressBar

## SYNOPSIS
Creates a new ProgressBar element for an Adaptive Card.

## SYNTAX

```
New-CardProgressBar [[-Value] <Double>] [[-Max] <Double>] [[-Color] <String>] [[-Id] <String>]
 [[-Height] <String>] [[-HorizontalAlignment] <String>] [[-GridArea] <String>] [[-Spacing] <String>]
 [[-TargetWidth] <String>] [[-Lang] <String>] [[-Requires] <Hashtable>] [[-Fallback] <ScriptBlock>] [-IsHidden]
 [-IsSortKey] [-Separator] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardProgressBar function creates a ProgressBar element that displays a progress indicator
in an Adaptive Card.
ProgressBars can show determinate progress (with a specific value) or
indeterminate progress (when no value is specified).
They support color customization and
configurable maximum values.

## EXAMPLES

### EXAMPLE 1
```
New-CardProgressBar -Value 75
```

Creates a progress bar at 75% completion (75 out of 100).

### EXAMPLE 2
```
New-CardProgressBar -Value 30 -Max 50 -Color Good
```

Creates a green progress bar at 60% completion (30 out of 50).

### EXAMPLE 3
```
New-CardProgressBar -Color Warning
```

Creates an indeterminate progress bar in warning color (no specific value).

### EXAMPLE 4
```
New-AdaptiveCard -Body {
    New-CardTextBlock -Text "Download Progress" -Weight Bolder
    New-CardProgressBar -Value 45 -Max 100 -Color Accent -Id "downloadProgress"
    New-CardTextBlock -Text "45% Complete" -Size Small -Color Good
}
```

Creates a card with a labeled progress bar showing download progress.

## PARAMETERS

### -Value
The current value of the progress bar.
Must be between 0 and the Max value.
If not specified, the progress bar will be in indeterminate mode.

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

### -Max
The maximum value of the progress bar.
Default is 100.
The progress percentage is calculated as (Value / Max) * 100.

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

### -Color
The color scheme for the progress bar.
Valid values are:
- Accent: Uses the theme's accent color (default, also used for indeterminate mode)
- Good: Green color, typically used for success or positive progress
- Warning: Orange/yellow color, used for warnings or caution states
- Attention: Red color, used for errors or critical states
Note: Color has no effect when the ProgressBar is in indeterminate mode (no Value specified).

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
A unique identifier for the ProgressBar element.
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
Controls the height behavior of the ProgressBar.
Valid values are:
- auto: Height adjusts automatically to content (default)
- stretch: ProgressBar stretches to fill available vertical space

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
Controls the horizontal alignment of the progress bar within its container.
Valid values are:
- Left: Aligns progress bar to the left side
- Center: Centers progress bar horizontally
- Right: Aligns progress bar to the right side

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
Specifies the named grid area where the ProgressBar should be placed when used in a grid layout.
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
Controls the amount of spacing above the progress bar.
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
Specifies the target width for the progress bar in adaptive layouts.
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
Specifies the language/locale for the ProgressBar element.
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
A hashtable specifying feature requirements for the ProgressBar.
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
A scriptblock that defines fallback content to display if the ProgressBar cannot be rendered
or is not supported by the host.
Should return an appropriate Adaptive Card element.

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

### -IsHidden
When specified, sets the progress bar to be hidden (isVisible = false).
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
When specified, displays a separator line above the ProgressBar to visually separate it
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

## NOTES
- When Value is not specified, the progress bar operates in indeterminate mode
- In indeterminate mode, the Color parameter has no effect (always uses accent color)
- Value must be between 0 and Max
- Progress bars are useful for showing task completion, loading states, or status indicators

## RELATED LINKS

[New-AdaptiveCard
New-CardTextBlock]()

