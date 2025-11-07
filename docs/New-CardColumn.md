---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#column
schema: 2.0.0
---

# New-CardColumn

## SYNOPSIS
Creates a new Column element for use within a ColumnSet.

## SYNTAX

```
New-CardColumn [[-Content] <ScriptBlock>] [[-Width] <Object>] [[-Style] <String>]
 [[-VerticalContentAlignment] <String>] [[-BackgroundImage] <Object>] [-Bleed] [[-MinHeight] <Int32>]
 [[-Spacing] <String>] [-Separator] [[-SelectAction] <Object>] [[-Id] <String>] [-Rtl]
 [[-Fallback] <ScriptBlock>] [[-Requires] <Hashtable>] [-Hidden] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardColumn function creates a Column element that defines a single column within a ColumnSet.
Columns can contain card elements and can be sized using various width options.

## EXAMPLES

### EXAMPLE 1
```
New-CardColumn -Width "auto" -Content {
    New-CardImage -Url "https://example.com/avatar.png" -Size "Small"
}
```

Creates a column that auto-sizes to fit an image.

### EXAMPLE 2
```
New-CardColumn -Width 2 -VerticalContentAlignment "Center" -Content {
    New-CardTextBlock -Text "Centered content in a column that's twice as wide"
}
```

Creates a column with relative width of 2 and centered content.

### EXAMPLE 3
```
New-CardColumn -Width "stretch" -Style "Emphasis" -Content {
    New-CardTextBlock -Text "Title" -Weight "Bolder"
    New-CardTextBlock -Text "Description"
}
```

Creates a column that stretches to fill available space with emphasis styling.

## PARAMETERS

### -Content
A ScriptBlock containing the card elements to be included inside the column.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases: Items

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Width
The width of the column.
Can be:
- "auto": Column width fits the content
- "stretch": Column takes remaining space
- A number (1, 2, etc.): Relative width compared to other columns
- A pixel value: Specific width like "50px"

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Style
The visual style to apply to the column.
Valid values: Default, Emphasis, Accent, Good, Warning, Attention.

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

### -VerticalContentAlignment
Defines how content should be aligned vertically within the column.
Valid values: Top, Center, Bottom.

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

### -BackgroundImage
Specifies the background image for the column.
Can be a URL or a BackgroundImage object.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Bleed
When set, the column will bleed through its parent's padding.

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

### -MinHeight
Specifies the minimum height of the column in pixels.

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

### -Spacing
Controls the amount of space between this column and the preceding column.
Valid values: None, ExtraSmall, Small, Default, Medium, Large, ExtraLarge, Padding.

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
When set, draws a separating line between this column and the previous column.

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
An Action object that will be invoked when the Column is tapped or selected.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
An optional unique identifier for the column element.

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

### -Rtl
When set, content in this column should be presented right to left.

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

### -Fallback
A ScriptBlock that returns an alternate element to render if this column is unsupported.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Requires
A hashtable of capabilities the column requires the host application to support.

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

### -Hidden
When set, the column will not be visible.

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
### Returns a hashtable representing the Column element structure.
## NOTES
- Columns must be used within a ColumnSet (New-CardColumnSet)
- Width values determine how space is distributed among columns
- Relative widths (numbers) are proportional to each other

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#column](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#column)

