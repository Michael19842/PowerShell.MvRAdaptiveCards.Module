---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version:
schema: 2.0.0
---

# New-CardCompoundButton

## SYNOPSIS
Creates a CompoundButton element for an Adaptive Card.

## SYNTAX

```
New-CardCompoundButton [[-Title] <String>] [[-Description] <String>] [[-Icon] <String>] [[-Badge] <Object>]
 [[-SelectAction] <ScriptBlock>] [[-Id] <String>] [[-Height] <String>] [[-HorizontalAlignment] <String>]
 [-Separator] [[-Spacing] <String>] [[-IsVisible] <Boolean>] [[-Requires] <Hashtable>]
 [[-Fallback] <ScriptBlock>] [[-TargetWidth] <String>] [[-GridArea] <String>] [[-Lang] <String>]
 [[-IsSortKey] <Boolean>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardCompoundButton function creates a CompoundButton element that combines a title, description,
icon, and badge into a single interactive button.
This element is useful for creating rich, informative
buttons that provide more context than standard action buttons.

## EXAMPLES

### EXAMPLE 1
```
New-CardCompoundButton -Title "Submit Report" -Description "Complete and submit your monthly report"
```

Creates a simple compound button with title and description.

### EXAMPLE 2
```
New-CardCompoundButton -Title "Open Dashboard" -Description "View analytics" -Icon (New-CardIcon -Name "ChartBar") -SelectAction (New-CardActionOpenUrl -Url "https://dashboard.example.com")
```

Creates a compound button with icon and URL action.

### EXAMPLE 3
```
New-CardCompoundButton -Title "Notifications" -Badge "5" -Description "You have unread messages" -SelectAction (New-CardActionSubmit -Title "View")
```

Creates a compound button with a badge showing notification count.

## PARAMETERS

### -Title
The title text of the button.
This is the primary text displayed on the button.

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

### -Description
The description text of the button.
This provides additional context or details below the title.

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

### -Icon
The icon to show on the button.
Should be an icon object created with New-CardIcon or a hashtable
representing an IconInfo object.

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

### -Badge
The badge to show on the button.
Can be a string or a badge object created with New-CardBadge.

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

### -SelectAction
An action that will be invoked when the button is tapped or clicked.
Should be an action object
created with functions like New-CardActionSubmit, New-CardActionOpenUrl, etc.
Note: Action.ShowCard is not supported.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
A unique identifier for the element.
Useful for referencing the element programmatically.

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

### -Height
Controls the height of the element.
Valid values: "auto", "stretch".

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

### -HorizontalAlignment
Controls how the element should be horizontally aligned.
Valid values: "Left", "Center", "Right".

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
Position: 9
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
Position: 10
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
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fallback
Alternate element or "drop" to render if this element type is unsupported.

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

### -TargetWidth
Controls for which card width the element should be displayed.
Enables responsive layouts.
Valid values: "VeryNarrow", "Narrow", "Standard", "Wide", or atLeast/atMost variants.

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

### -GridArea
The area of a Layout.AreaGrid layout in which the element should be displayed.

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

### -Lang
The locale associated with the element.

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

### -IsSortKey
Controls whether the element should be used as a sort key by elements that allow sorting.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
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
### Returns a hashtable representing the CompoundButton element with all configured properties.
## NOTES
- Introduced in Adaptive Cards version 1.5
- Action.ShowCard is not supported as a SelectAction
- Compound buttons are ideal for menu-like interfaces or action-rich cards

## RELATED LINKS

[New-AdaptiveCard]()

[New-CardIcon]()

[New-CardBadge]()

[New-CardActionSubmit]()

