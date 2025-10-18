---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#table
schema: 2.0.0
---

# New-CardTable

## SYNOPSIS
Creates a new Table element for an Adaptive Card from a collection of objects or hashtables.

## SYNTAX

```
New-CardTable [[-Collection] <Array>] [[-CustomColums] <Array>] [-NoHeader] [[-Id] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-CardTable function creates a Table element that displays tabular data in an Adaptive Card.
It automatically generates columns and rows from PowerShell objects or hashtables, with support for
custom column definitions, header control, and dynamic content including ScriptBlocks for complex cell content.

## EXAMPLES

### EXAMPLE 1
```
$data = @(
    @{Name = "John"; Age = 30; City = "New York"},
    @{Name = "Jane"; Age = 25; City = "Boston"},
    @{Name = "Bob"; Age = 35; City = "Chicago"}
)
New-CardTable -Collection $data
```

Creates a table with automatic headers (Name, Age, City) and default column widths.

### EXAMPLE 2
```
$users = Get-Process | Select-Object Name, CPU, WorkingSet -First 5
New-CardTable -Collection $users -CustomColums @(
    @{Name = "Name"; width = 2},
    @{Name = "CPU"; width = 1},
    @{Name = "WorkingSet"; width = 2}
)
```

Creates a table from process objects with custom column widths (Name and WorkingSet twice as wide as CPU).

### EXAMPLE 3
```
New-CardTable -Collection $data -NoHeader -Id "DataTable"
```

Creates a table without headers and assigns an ID for potential reference in actions.

### EXAMPLE 4
```
$complexData = @(
    @{
        Name = "User 1"
        Status = { New-CardTextBlock -Text "✅ Active" -Color "Good" }
        Details = "Regular user"
    }
)
New-CardTable -Collection $complexData
```

Creates a table where the Status column contains a ScriptBlock that generates a colored text block,
demonstrating support for complex cell content.

## PARAMETERS

### -Collection
An array of objects or hashtables that will be displayed as table rows.
The function automatically
detects the type and extracts properties or keys to create the table structure.
- For hashtables: Uses the keys from the first hashtable as column headers
- For objects: Uses the NoteProperty names from the first object as column headers

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomColums
An array of hashtables defining custom column properties.
Each hashtable can contain:
- Name: The property/key name to match (required)
- width: Relative width of the column (e.g., 1, 2, 3 for proportional sizing)
- Other column properties supported by Adaptive Cards

If not specified for a column, default width of 1 is used.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoHeader
A switch parameter that suppresses the generation of header row.
When specified,
the table will display only data rows without column headers.

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

### -Id
An optional unique identifier for the table element.
Useful for referencing the table
in actions like toggle visibility or for accessibility purposes.

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
### Returns a hashtable representing the Table element structure for the Adaptive Card.
## NOTES
- The function automatically detects whether the input is hashtables or objects
- ScriptBlocks in cell values are executed to generate dynamic content
- Custom column definitions only need to specify the properties you want to override
- The firstRowAsHeaders property is automatically set based on the NoHeader parameter
- Column widths are relative values (1, 2, 3, etc.) that determine proportional sizing

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#table](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#table)

