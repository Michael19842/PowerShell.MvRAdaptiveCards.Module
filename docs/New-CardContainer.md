---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#container
schema: 2.0.0
---

# New-CardContainer

## SYNOPSIS
Creates a new Container element for an Adaptive Card.

## SYNTAX

```
New-CardContainer [[-Content] <ScriptBlock>] [[-Style] <String>] [[-BackgroundImage] <Object>]
 [[-MinHeight] <Int32>] [[-MaxHeight] <Int32>] [[-Id] <String>] [[-VerticalContentAlignment] <String>] [-Bleed]
 [[-Fallback] <ScriptBlock>] [[-GridArea] <String>] [[-Height] <String>] [[-HorizontalAlignment] <String>]
 [[-IsSortKey] <Boolean>] [[-Lang] <String>] [[-Layouts] <ScriptBlock>] [[-Requires] <Hashtable>]
 [-RoundedCorners] [-Rtl] [[-SelectAction] <Object>] [-Separator] [-ShowBorder] [[-Spacing] <String>]
 [[-TargetWidth] <String>] [-Hidden] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The New-CardContainer function creates a Container element that can hold multiple card elements.
Containers are used to group elements together and can apply styling and layout properties to their contents.
They provide a way to organize and visually separate different sections of an Adaptive Card.

## EXAMPLES

### EXAMPLE 1
```
New-CardContainer -Content {
    New-CardTextBlock -Text "Title" -Weight "Bolder"
    New-CardTextBlock -Text "This is content inside a container"
}
```

Creates a basic container with two text blocks using the default styling.

### EXAMPLE 2
```
New-CardContainer -Style "Good" -Content {
    New-CardTextBlock -Text "Success!" -Color "Good"
    New-CardTextBlock -Text "Operation completed successfully"
} -Id "SuccessContainer"
```

Creates a container with "Good" styling (typically green background) containing success messages,
with an ID for potential referencing in actions.

### EXAMPLE 3
```
New-CardContainer -Style "Attention" -Content {
    New-CardTextBlock -Text "⚠️ Warning" -Weight "Bolder"
    New-CardTextBlock -Text "Please review the following information carefully"
}
```

Creates an attention-styled container (typically orange/yellow) with warning content.

## PARAMETERS

### -Content
A ScriptBlock containing the card elements to be included inside the container.
This can include text blocks, images, other containers, and any other supported card elements.

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

### -Style
The visual style to apply to the container.
Valid values are:
- Default: Standard container appearance
- Emphasis: Subtle emphasis styling
- Attention: Attention-grabbing styling (typically orange/yellow)
- Good: Success/positive styling (typically green)
- Warning: Warning/caution styling (typically red)

Default value is "Default".

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

### -BackgroundImage
{{ Fill BackgroundImage Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinHeight
{{ Fill MinHeight Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxHeight
{{ Fill MaxHeight Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
An optional unique identifier for the container element.
Useful for referencing the container
in actions like toggle visibility or for accessibility purposes.

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

### -VerticalContentAlignment
{{ Fill VerticalContentAlignment Description }}

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

### -Bleed
{{ Fill Bleed Description }}

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
{{ Fill Fallback Description }}

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GridArea
{{ Fill GridArea Description }}

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

### -Height
{{ Fill Height Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: Auto
Accept pipeline input: False
Accept wildcard characters: False
```

### -HorizontalAlignment
{{ Fill HorizontalAlignment Description }}

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

### -IsSortKey
{{ Fill IsSortKey Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Lang
{{ Fill Lang Description }}

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

### -Layouts
{{ Fill Layouts Description }}

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Requires
{{ Fill Requires Description }}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RoundedCorners
{{ Fill RoundedCorners Description }}

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

### -Rtl
{{ Fill Rtl Description }}

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
{{ Fill SelectAction Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Separator
{{ Fill Separator Description }}

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

### -ShowBorder
{{ Fill ShowBorder Description }}

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
{{ Fill Spacing Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetWidth
{{ Fill TargetWidth Description }}

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

### -Hidden
{{ Fill Hidden Description }}

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
### Returns a hashtable representing the Container element structure for the Adaptive Card.
## NOTES
- Containers automatically handle both single elements and arrays of elements from the Content ScriptBlock
- The Style parameter only adds the style property when it's not "Default" to keep the JSON clean
- Containers can be nested within other containers for complex layouts
- The Id parameter is optional but recommended when the container needs to be referenced by actions

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#container](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#container)

