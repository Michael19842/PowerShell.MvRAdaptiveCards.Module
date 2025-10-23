---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#layoutareagrid
schema: 2.0.0
---

# New-CardLayoutAreaGrid

## SYNOPSIS
Creates a new AreaGrid layout for an Adaptive Card container.

## SYNTAX

```
New-CardLayoutAreaGrid [[-Areas] <ScriptBlock>] [[-Columns] <Array>] [[-ColumnSpacing] <String>]
 [[-RowSpacing] <String>] [[-TargetWidth] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The New-CardLayoutAreaGrid function creates a Layout.AreaGrid object that enables
CSS Grid-like layout capabilities for Adaptive Card containers.
This layout allows
precise control over element positioning using named grid areas, similar to
CSS Grid Template Areas.
This layout is available in Teams (version 1.5+).

## EXAMPLES

### EXAMPLE 1
```
$areas = @(
    New-CardGridArea -Name "header" -Row 1 -Column 1 -ColumnSpan 2
    New-CardGridArea -Name "sidebar" -Row 2 -Column 1
    New-CardGridArea -Name "content" -Row 2 -Column 2
)
New-CardLayoutAreaGrid -Areas $areas -Columns @(30, 70) -RowSpacing "Medium"
```

Creates a grid layout with a header spanning two columns and a sidebar/content layout below.

### EXAMPLE 2
```
New-CardLayoutAreaGrid -Columns @("200px", "1fr", "200px") -ColumnSpacing "Large"
```

Creates a three-column grid with fixed 200px sidebars and flexible center column.

### EXAMPLE 3
```
$areas = @(
    @{ name = "nav"; row = 1; column = 1 }
    @{ name = "main"; row = 1; column = 2; rowSpan = 2 }
    @{ name = "footer"; row = 2; column = 1 }
)
New-CardLayoutAreaGrid -Areas $areas -Columns @(25, 75) -TargetWidth "atLeast:Standard"
```

Creates a responsive grid that only applies when the card is Standard width or larger.

## PARAMETERS

### -Areas
An array of GridArea objects that define the named areas in the grid layout.
Each area can span multiple rows and columns.
Use New-CardGridArea to create
these area definitions.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Columns
An array defining the columns in the grid layout.
Each column can be defined as:
- A percentage of available width (e.g., 50 for 50%)
- A pixel value (specify as integer, will be converted to "Npx" format)
- A string with explicit format (e.g., "200px", "33.33%")

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ColumnSpacing
The space between columns.
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
Position: 3
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -RowSpacing
The space between rows.
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
Position: 4
Default value: Default
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
Position: 5
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

### System.Collections.Hashtable
### Returns a hashtable representing the Layout.AreaGrid structure.
## NOTES
- This is a Teams-specific layout (version 1.5+)
- Areas define named regions that elements can be assigned to using the grid.area property
- Columns can be defined as percentages, pixels, or fractional units
- Elements reference grid areas using the grid.area parameter
- Similar to CSS Grid Template Areas for familiar web layout patterns

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#layoutareagrid](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#layoutareagrid)

