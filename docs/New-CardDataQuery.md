---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version:
schema: 2.0.0
---

# New-CardDataQuery

## SYNOPSIS
Creates a new Data.Query object for dynamic data fetching in Adaptive Cards.

## SYNTAX

```
New-CardDataQuery [-Dataset] <String> [[-AssociatedInputs] <String>] [[-Count] <Int32>] [[-Skip] <Int32>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardDataQuery function creates a Data.Query object that defines how to fetch
dynamic data from a backend service or bot.
This is typically used with Input.ChoiceSet
elements to provide dynamic choices based on user input or external data sources.

Data.Query objects are commonly used in Microsoft Teams scenarios where choices
need to be populated dynamically from a bot or external API.

## EXAMPLES

### EXAMPLE 1
```
New-CardDataQuery -Dataset "products"
```

Creates a basic data query for the "products" dataset with automatic input association.

### EXAMPLE 2
```
New-CardDataQuery -Dataset "users" -AssociatedInputs "none"
```

Creates a data query that fetches from the "users" dataset without sending any input values.

### EXAMPLE 3
```
# Used with Input.ChoiceSet for dynamic choices
New-CardInputChoiceSet -Id "category" -Label "Select Category" -Choices @{
    data = New-CardDataQuery -Dataset "categories" -AssociatedInputs "auto"
}
```

### EXAMPLE 4
```
New-CardDataQuery -Dataset "searchResults" -Count 50
```

Creates a data query with a specific maximum count (typically used by clients for pagination).

## PARAMETERS

### -Dataset
The name or identifier of the dataset from which to fetch the data.
This should
correspond to a dataset that your bot or backend service can handle.

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

### -AssociatedInputs
Controls which input values are sent along with the query to enable filtering:
- "auto": All input values in the card are sent (default)
- "none": No input values are sent, query is executed independently

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Auto
Accept pipeline input: False
Accept wildcard characters: False
```

### -Count
The maximum number of data items that should be returned by the query.
Note: This is typically set by the client for pagination purposes and
Should not be specified by card authors in most cases.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Skip
The number of data items to skip (for pagination).
Note: This is typically set by the client for pagination purposes and
Should not be specified by card authors in most cases.

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
### Returns a hashtable representing the Data.Query structure for the Adaptive Card.
## NOTES
- Data.Query is primarily used in Microsoft Teams and other bot-enabled environments
- The Count and Skip parameters are usually managed by the client for pagination
- Card authors should primarily focus on Dataset and AssociatedInputs parameters
- The backend service must be configured to handle the specified dataset
- This feature requires Adaptive Cards schema version 1.5 or later

## RELATED LINKS

[New-CardInputChoiceSet
https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#dataquery]()

