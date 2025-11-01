---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#columnset
schema: 2.0.0
---

# New-CardColumnSet

## SYNOPSIS
Creates a new ColumnSet element for an Adaptive Card.

## SYNTAX

```
New-CardColumnSet [-Columns] <ScriptBlock> [[-Style] <String>] [[-Id] <String>] [[-SelectAction] <Object>]
 [[-HorizontalAlignment] <String>] [[-Height] <String>] [[-MinHeight] <Int32>] [[-Spacing] <String>]
 [-Separator] [-Bleed] [[-GridArea] <String>] [[-TargetWidth] <String>] [-IsSortKey] [[-Lang] <String>]
 [[-Requires] <Hashtable>] [[-Fallback] <ScriptBlock>] [-Hidden] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardColumnSet function creates a ColumnSet element that divides a region into columns,
allowing elements to sit side-by-side.
Use New-CardColumn within the Columns scriptblock to
define individual columns with their own content and properties.

## EXAMPLES

### EXAMPLE 1
```
New-CardColumnSet -Columns {
    New-CardColumn -Width "auto" -Content {
        New-CardImage -Url "https://example.com/icon.png" -Size "Small"
    }
    New-CardColumn -Width "stretch" -Content {
        New-CardTextBlock -Text "Title" -Weight "Bolder"
        New-CardTextBlock -Text "Description text"
    }
}
```

Creates a two-column layout with an image in the first column (auto-sized) and text in the second column (stretched).

### EXAMPLE 2
```
New-CardColumnSet -Style "Emphasis" -Columns {
    New-CardColumn -Width 1 -Content {
        New-CardTextBlock -Text "Column 1"
    }
    New-CardColumn -Width 2 -Content {
        New-CardTextBlock -Text "Column 2 (twice as wide)"
    }
}
```

Creates a column set with emphasis styling where the second column is twice as wide as the first.

### EXAMPLE 3
```
New-CardColumnSet -SelectAction (New-CardActionOpenUrl -Url "https://example.com") -Columns {
    New-CardColumn -Width "auto" -Content {
        New-CardIcon -Name "Link"
    }
    New-CardColumn -Width "stretch" -Content {
        New-CardTextBlock -Text "Click anywhere to open link"
    }
}
```

Creates a clickable column set that opens a URL when tapped.

## PARAMETERS

### -Columns
A ScriptBlock containing one or more New-CardColumn commands that define the columns in the set.
Each column can have its own width, content, and styling.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Style
The visual style to apply to the column set.
Valid values are:
- Default: Standard appearance
- Emphasis: Subtle emphasis styling
- Accent: Accent color styling
- Good: Success/positive styling (typically green)
- Warning: Warning/caution styling (typically orange/yellow)
- Attention: Attention-grabbing styling (typically red)

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

### -Id
An optional unique identifier for the column set element.

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

### -SelectAction
An Action object that will be invoked when the ColumnSet is tapped or selected.
Action.ShowCard is not supported.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HorizontalAlignment
Controls how the column set should be horizontally aligned.
Valid values: Left, Center, Right.

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

### -Height
The height of the column set.
Valid values: "auto", "stretch".

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

### -MinHeight
Specifies the minimum height of the column set in pixels (e.g., 80).

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

### -Spacing
Controls the amount of space between this element and the previous one.
Valid values: None, ExtraSmall, Small, Default, Medium, Large, ExtraLarge, Padding.

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

### -Separator
When set, displays a separator line above the column set.

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

### -Bleed
When set, the column set will bleed through its parent's padding.

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

### -GridArea
The area of a Layout.AreaGrid layout in which the element should be displayed.

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

### -TargetWidth
Controls for which card width the element should be displayed.
Valid values: VeryNarrow, Narrow, Standard, Wide, atLeast:*, atMost:*.

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

### -IsSortKey
When set, the element will be used as a sort key.

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
The locale associated with the element.

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

### -Requires
A hashtable of capabilities the element requires the host application to support.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fallback
A ScriptBlock that returns an alternate element to render if this element is unsupported.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hidden
When set, the column set will not be visible.

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
### Returns a hashtable representing the ColumnSet element structure for the Adaptive Card.
## NOTES
- Column widths can be "auto", "stretch", a pixel width like "50px", or a relative number (e.g., 1, 2)
- Use New-CardColumn to define individual columns within the ColumnSet
- ColumnSets are useful for creating side-by-side layouts and responsive designs

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#columnset](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#columnset)

