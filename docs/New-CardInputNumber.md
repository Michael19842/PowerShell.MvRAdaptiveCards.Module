---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version:
schema: 2.0.0
---

# New-CardInputNumber

## SYNOPSIS
Creates an Input.Number element for numeric input in an Adaptive Card.

## SYNTAX

```
New-CardInputNumber [[-Id] <String>] [[-Label] <String>] [[-Value] <Double>] [[-Min] <Double>]
 [[-Max] <Double>] [[-Placeholder] <String>] [[-IsRequired] <Boolean>] [[-ErrorMessage] <String>]
 [[-Height] <String>] [-Separator] [[-Spacing] <String>] [[-IsVisible] <Boolean>] [[-Requires] <Hashtable>]
 [[-Fallback] <Object>] [[-TargetWidth] <String>] [[-GridArea] <String>] [[-Lang] <String>]
 [[-IsSortKey] <Boolean>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardInputNumber function creates an Input.Number element that allows users to enter numeric values.
Supports number range constraints (min/max), default values, validation, and labels.

## EXAMPLES

### EXAMPLE 1
```
New-CardInputNumber -Id "age" -Label "Age" -Min 0 -Max 120 -IsRequired $true
```

Creates a required number input for age with range constraints.

### EXAMPLE 2
```
New-CardInputNumber -Id "quantity" -Label "Quantity" -Value 1 -Min 1 -Max 100
```

Creates a number input for quantity with default value of 1 and range limits.

### EXAMPLE 3
```
New-CardInputNumber -Id "price" -Label "Price" -Placeholder "Enter amount" -Value 0
```

Creates a number input for price with placeholder text and default value.

### EXAMPLE 4
```
New-CardInputNumber -Id "rating" -Label "Rating" -Min 1 -Max 5 -IsRequired $true
```

Creates a required rating input limited to values between 1 and 5.

### EXAMPLE 5
```
New-CardInputNumber -Id "score" -Label "Score" -Spacing "Large" -Separator
```

Creates a number input with extra spacing and a separator line above it.

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
Label text displayed above the number input.
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
Initial/default numeric value for the input field.

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Min
Minimum numeric value that can be entered.
Users cannot enter numbers below this.

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Max
Maximum numeric value that can be entered.
Users cannot enter numbers above this.

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Placeholder
Placeholder text displayed when no value is entered.
Provides hints about expected numeric format.

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
Marks the number input as required.
The card cannot be submitted without entering a value.

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
### Returns a hashtable representing the Input.Number element with all configured properties.
## NOTES
- The Id parameter is essential for retrieving submitted values
- Min and Max constraints are enforced by the input UI
- IsRequired prevents card submission until a value is entered
- Not all hosts support all features (check host capabilities)
- Value, Min, and Max parameters accept numeric types (int, double, etc.)

## RELATED LINKS

[New-AdaptiveCard]()

[New-CardInputText]()

[New-CardInputDate]()

