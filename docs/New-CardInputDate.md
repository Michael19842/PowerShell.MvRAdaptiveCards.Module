---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version:
schema: 2.0.0
---

# New-CardInputDate

## SYNOPSIS
Creates an Input.Date element for date selection in an Adaptive Card.

## SYNTAX

```
New-CardInputDate [[-Id] <String>] [[-Label] <String>] [[-Value] <String>] [[-Min] <String>] [[-Max] <String>]
 [[-Placeholder] <String>] [[-IsRequired] <Boolean>] [[-ErrorMessage] <String>] [[-Height] <String>]
 [-Separator] [[-Spacing] <String>] [[-IsVisible] <Boolean>] [[-Requires] <Hashtable>] [[-Fallback] <Object>]
 [[-TargetWidth] <String>] [[-GridArea] <String>] [[-Lang] <String>] [[-IsSortKey] <Boolean>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardInputDate function creates an Input.Date element that allows users to select a date.
Supports date range constraints (min/max), default values, validation, and labels.

## EXAMPLES

### EXAMPLE 1
```
New-CardInputDate -Id "birthDate" -Label "Date of Birth" -IsRequired $true
```

Creates a required date picker for birth date.

### EXAMPLE 2
```
New-CardInputDate -Id "startDate" -Label "Start Date" -Min "2025-01-01" -Max "2025-12-31"
```

Creates a date picker limited to the year 2025.

### EXAMPLE 3
```
New-CardInputDate -Id "appointmentDate" -Value "2025-11-15" -Placeholder "Select appointment date"
```

Creates a date picker with a default value and placeholder text.

### EXAMPLE 4
```
New-CardInputDate -Id "deadline" -Label "Deadline" -Min (Get-Date -Format "yyyy-MM-dd") -IsRequired $true
```

Creates a required date picker with today as the minimum selectable date.

### EXAMPLE 5
```
New-CardInputDate -Id "eventDate" -Label "Event Date" -Spacing "Large" -Separator
```

Creates a date picker with extra spacing and a separator line above it.

## PARAMETERS

### -Id
Unique identifier for the input element.
Used to retrieve the input value when the card is submitted.

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

### -Label
Label text displayed above the date picker.
Describes the purpose of the input.

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

### -Value
Initial/default date value in YYYY-MM-DD format (e.g., "2025-11-02").

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

### -Min
Minimum selectable date in YYYY-MM-DD format.
Users cannot select dates before this.

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

### -Max
Maximum selectable date in YYYY-MM-DD format.
Users cannot select dates after this.

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

### -Placeholder
Placeholder text displayed when no date is selected.
Provides hints about expected date format.

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

### -IsRequired
Marks the date input as required.
The card cannot be submitted without selecting a date.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ErrorMessage
Custom error message displayed when the input fails validation.

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

### -Height
Controls the height of the element.
Valid values: "auto", "stretch".

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
Position: 10
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
Position: 11
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
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fallback
Alternate element or "drop" to render if this element type is unsupported.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
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
Position: 14
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
Position: 15
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
Position: 16
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
Position: 17
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
### Returns a hashtable representing the Input.Date element with all configured properties.
## NOTES
- The Id parameter is essential for retrieving submitted values
- Date values must be in YYYY-MM-DD format (ISO 8601)
- Min and Max constraints are enforced by the date picker UI
- IsRequired prevents card submission until a date is selected
- Not all hosts support all features (check host capabilities)

## RELATED LINKS

[New-AdaptiveCard]()

[New-CardInputText]()

[New-CardInputTime]()

