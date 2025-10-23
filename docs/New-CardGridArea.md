---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#gridarea
schema: 2.0.0
---

# New-CardGridArea

## SYNOPSIS
Creates a new GridArea definition for use in Layout.AreaGrid layouts.

## SYNTAX

```
New-CardGridArea [-Name] <String> [[-Row] <Int32>] [[-Column] <Int32>] [[-RowSpan] <Int32>]
 [[-ColumnSpan] <Int32>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardGridArea function creates a GridArea object that defines a named region
within an AreaGrid layout.
Elements can then be placed into these named areas using
the grid.area property.
This is similar to CSS Grid Template Areas, allowing precise
control over element positioning in a grid layout.

## EXAMPLES

### EXAMPLE 1
```
New-CardGridArea -Name "header" -Row 1 -Column 1 -ColumnSpan 2
```

Creates a grid area named "header" in the first row spanning two columns.

### EXAMPLE 2
```
New-CardGridArea -Name "sidebar" -Row 2 -Column 1 -RowSpan 3
```

Creates a grid area named "sidebar" starting at row 2, column 1, spanning 3 rows.

### EXAMPLE 3
```
$areas = @(
    New-CardGridArea -Name "header" -Row 1 -Column 1 -ColumnSpan 3
    New-CardGridArea -Name "nav" -Row 2 -Column 1
    New-CardGridArea -Name "main" -Row 2 -Column 2 -RowSpan 2
    New-CardGridArea -Name "sidebar" -Row 2 -Column 3 -RowSpan 2
    New-CardGridArea -Name "footer" -Row 3 -Column 1
)
New-CardLayoutAreaGrid -Areas $areas -Columns @(20, 60, 20)
```

Creates a complete grid layout with header, navigation, main content, sidebar, and footer areas.

### EXAMPLE 4
```
# Create area and use it in a container
$area = New-CardGridArea -Name "content" -Row 1 -Column 1
New-CardTextBlock -Text "Hello" -GridArea "content"
```

Creates a grid area and places a text block in it.

## PARAMETERS

### -Name
The name of the grid area.
Elements reference this name using their grid.area property
to be placed in this area.
Required parameter.

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

### -Row
The start row index of the area.
Row indices start at 1.
Default is 1.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Column
The start column index of the area.
Column indices start at 1.
Default is 1.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -RowSpan
Defines how many rows the area should span.
Default is 1 (single row).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -ColumnSpan
Defines how many columns the area should span.
Default is 1 (single column).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 1
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
### Returns a hashtable representing the GridArea structure.
## NOTES
- This is a Teams-specific feature (version 1.5+)
- Row and column indices are 1-based (start at 1, not 0)
- Areas can overlap if needed, though this is generally avoided in practice
- Elements reference areas using the grid.area property
- The Name parameter is required as elements need it to reference the area

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#gridarea](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#gridarea)

[New-CardLayoutAreaGrid]()

