---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#factset
schema: 2.0.0
---

# New-CardFactSet

## SYNOPSIS
Creates a new FactSet element for an Adaptive Card to display key-value pairs.

## SYNTAX

### Hashtable
```
New-CardFactSet [-Facts] <Hashtable> [-Id <String>] [-Language <String>] [-TargetWidth <String>]
 [-Height <String>] [-Requires <Hashtable>] [-Fallback <ScriptBlock>] [-GridArea <String>] [-Spacing <String>]
 [-Separator] [-IsSortKey] [-IsHidden] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Object
```
New-CardFactSet [-Object] <Object> [-Id <String>] [-Language <String>] [-TargetWidth <String>]
 [-Height <String>] [-Requires <Hashtable>] [-Fallback <ScriptBlock>] [-GridArea <String>] [-Spacing <String>]
 [-EveryProperty] [-Separator] [-IsSortKey] [-IsHidden] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardFactSet function creates a FactSet element that displays information as a series of
title-value pairs in a structured format.
It supports input from hashtables or PowerShell objects,
automatically converting object properties to facts for display.

## EXAMPLES

### EXAMPLE 1
```
New-CardFactSet -Facts @{
    "Name" = "John Doe"
    "Department" = "Engineering"
    "Start Date" = "2020-01-15"
    "Employee ID" = "EMP001"
}
```

Creates a fact set from a hashtable displaying employee information.

### EXAMPLE 2
```
$process = Get-Process -Name "notepad" | Select-Object -First 1
New-CardFactSet -Object $process -Id "ProcessInfo"
```

Creates a fact set from a process object, showing its NoteProperties with an assigned ID.

### EXAMPLE 3
```
$fileInfo = Get-Item "C:\temp\file.txt"
New-CardFactSet -Object $fileInfo -EveryProperty
```

Creates a fact set from a file object, including all properties (not just NoteProperties).

### EXAMPLE 4
```
New-CardFactSet -Facts @{
    "Status" = "✅ Online"
    "Last Backup" = (Get-Date).ToString("yyyy-MM-dd HH:mm")
    "Size" = "2.5 GB"
} -Id "SystemStatus"
```

Creates a fact set with system status information, including formatted dates and emojis.

## PARAMETERS

### -Facts
A hashtable containing key-value pairs to display as facts.
Each key becomes the title
and the corresponding value becomes the fact value.
This parameter is used with the 'Hashtable' parameter set.

```yaml
Type: Hashtable
Parameter Sets: Hashtable
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Object
A PowerShell object whose properties will be converted to facts.
By default, only NoteProperties
are included unless the EveryProperty switch is specified.
This parameter is used with the 'Object' parameter set.

```yaml
Type: Object
Parameter Sets: Object
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
An optional unique identifier for the FactSet element.
Useful for referencing the element
in actions like toggle visibility or for accessibility purposes.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Language
Specifies the language/locale for the FactSet element. Used for proper text rendering
and accessibility features. Alias: Lang

```yaml
Type: String
Parameter Sets: (All)
Aliases: Lang

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetWidth
Specifies the target width for the FactSet in adaptive layouts. Valid values include:
- VeryNarrow, Narrow, Standard, Wide
- atLeast:VeryNarrow, atMost:VeryNarrow, etc.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Height
Controls the height behavior of the FactSet. Valid values are:
- Auto: Height adjusts automatically to content (default)
- Stretch: FactSet stretches to fill available vertical space

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Requires
A hashtable specifying feature requirements for the FactSet. Used to declare dependencies
on specific Adaptive Card features or host capabilities.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fallback
A scriptblock that defines fallback content to display if the FactSet cannot be rendered
or is not supported by the host. Should return an appropriate Adaptive Card element.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GridArea
Specifies the named grid area where the FactSet should be placed when used in a grid layout.
This corresponds to the CSS grid-area property.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Spacing
Controls the amount of spacing above the FactSet. Valid values are:
- None: No spacing
- Small: Small spacing
- Default: Default spacing
- Medium: Medium spacing
- Large: Large spacing
- ExtraLarge: Extra large spacing
- Padding: Adds padding around the element

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EveryProperty
A switch parameter available only when using the Object parameter.
When specified, includes all
property types from the object (not just NoteProperties) in the fact set.

```yaml
Type: SwitchParameter
Parameter Sets: Object
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Separator
When specified, adds a separator line above the FactSet to visually separate it from
preceding content.

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

### -IsSortKey
When specified, marks this FactSet as a sort key element. Used in scenarios where
multiple elements need to be sorted or grouped.

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

### -IsHidden
When specified, sets the FactSet to be hidden (isVisible = false). The element will
not be displayed but can be shown programmatically. Alias: Hide

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
### Returns a hashtable representing the FactSet element structure for the Adaptive Card.
## NOTES
- The function uses parameter sets to handle different input types (hashtable vs object)
- When using Object parameter, null values are converted to empty strings
- All values are converted to strings for display in the fact set
- The EveryProperty switch allows inclusion of all object members, not just NoteProperties
- Facts are displayed in the order they appear in the input (hashtable key order or object property order)

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#factset](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#factset)

