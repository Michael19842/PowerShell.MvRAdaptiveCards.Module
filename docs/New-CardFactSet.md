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
New-CardFactSet -Facts <Hashtable> [-Id <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Object
```
New-CardFactSet -Object <Object> [-Id <String>] [-EveryProperty] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
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
Position: Named
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
Position: Named
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

