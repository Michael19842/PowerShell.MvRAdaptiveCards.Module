---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#icon
schema: 2.0.0
---

# New-CardIcon

## SYNOPSIS
Creates an Icon element for an Adaptive Card using Fluent UI icons.

## SYNTAX

```
New-CardIcon [-Name] <String> [[-Color] <String>] [[-Size] <String>] [[-Style] <String>] [[-Spacing] <String>]
 [[-TargetWidth] <String>] [[-SelectAction] <ScriptBlock>] [[-Fallback] <ScriptBlock>] [[-Id] <String>]
 [[-Lang] <String>] [[-HorizontalAlignment] <String>] [[-GridArea] <String>] [-IsHidden] [-isSortKey]
 [-separator] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardIcon function creates an Icon element for Adaptive Cards using the Fluent UI icon library.
Icons are visual elements that can represent actions, objects, or concepts in your card.
This function
supports customization of icon appearance including color, size, style, and layout properties.

The icon names are validated against the Fluent UI icon collection and include tab completion for ease of use.
Icons can be styled with different colors, sizes (from xxSmall to xxLarge), and styles (Regular or Filled).
You can also add interactive behavior with SelectAction and provide fallback content for unsupported scenarios.

## EXAMPLES

### EXAMPLE 1
```
New-CardIcon -Name "Calendar"
```

Creates a basic calendar icon with default settings (Standard size, Default color, Regular style).

### EXAMPLE 2
```
New-CardIcon -Name "Mail" -Color "Accent" -Size "Large"
```

Creates a mail icon with accent color and large size.

### EXAMPLE 3
```
New-CardIcon -Name "Shield" -Style "Filled" -Color "Good" -HorizontalAlignment "Center"
```

Creates a filled shield icon in good (green) color, centered horizontally.

### EXAMPLE 4
```
New-CardIcon -Name "Warning" -Color "Warning" -SelectAction {
    New-CardActionOpenUrl -Url "https://example.com/help"
}
```

Creates a warning icon that opens a URL when clicked.

### EXAMPLE 5
```
New-CardIcon -Name "Error" -Color "Attention" -Id "error-icon" -Spacing "Medium" -separator
```

Creates an error icon with attention color, medium spacing, and a separator above it.

## PARAMETERS

### -Name
The name of the Fluent UI icon to display.
This parameter supports tab completion and validation against
the available icon collection.
Examples include "Calendar", "Mail", "Shield", "Warning", "Error", etc.

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

### -Color
Specifies the color scheme for the icon.
Valid values are:
- Default: Uses the theme's default icon color
- Dark: Dark color variant
- Light: Light color variant
- Accent: Uses the theme's accent color
- Good: Green color, typically used for success or positive states
- Warning: Orange/yellow color, used for warnings
- Attention: Red color, used for errors or critical states
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

### -Size
Controls the size of the icon.
Valid values are:
- xxSmall: Extra extra small
- xSmall: Extra small
- Small: Small size
- Standard: Standard size (default)
- Medium: Medium size
- Large: Large size
- xLarge: Extra large
- xxLarge: Extra extra large
Default value is "Standard".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Standard
Accept pipeline input: False
Accept wildcard characters: False
```

### -Style
Determines the visual style of the icon.
Valid values are:
- Regular: Outline style (default)
- Filled: Solid filled style
Default value is "Regular".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Regular
Accept pipeline input: False
Accept wildcard characters: False
```

### -Spacing
Controls the amount of spacing above the icon.
Valid values are:
- None: No spacing
- Small: Small spacing
- Default: Default spacing
- Medium: Medium spacing
- Large: Large spacing
- ExtraLarge: Extra large spacing

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

### -TargetWidth
Specifies the target width for the icon in adaptive layouts.
Valid values include:
- VeryNarrow, Narrow, Standard, Wide
- atLeast:VeryNarrow, atMost:VeryNarrow, etc.

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

### -SelectAction
A scriptblock that defines the action to perform when the icon is selected/clicked.
The scriptblock should return an Adaptive Card action element.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fallback
A scriptblock that defines fallback content to display if the icon cannot be rendered
or is not supported by the host.
Should return an appropriate Adaptive Card element.

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

### -Id
A unique identifier for the icon element.
Useful for referencing the element programmatically.

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
Specifies the language/locale for the icon element.

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

### -HorizontalAlignment
Controls the horizontal alignment of the icon within its container.
Valid values are:
- Left: Aligns the icon to the left side
- Center: Centers the icon horizontally
- Right: Aligns the icon to the right side

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

### -GridArea
Specifies the named grid area where the icon should be placed when used in a grid layout.
This corresponds to the CSS grid-area property.

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

### -IsHidden
{{ Fill IsHidden Description }}

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

### -isSortKey
When specified, marks this icon as a sort key element.

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

### -separator
When specified, adds a separator line above the icon.

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

### System.Collections.Hashtable
### Returns a hashtable representing the Icon element that can be used in an Adaptive Card.
## NOTES
This function is part of the MvRAdaptiveCards module for creating Adaptive Cards in PowerShell.
The icon names correspond to the Fluent UI icon library.

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#icon](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#icon)

