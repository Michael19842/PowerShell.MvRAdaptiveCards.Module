---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version:
schema: 2.0.0
---

# New-CardInputTime

## SYNOPSIS
Creates an Input.Time element for time selection in an Adaptive Card.

## SYNTAX

```
New-CardInputTime [[-Id] <String>] [[-Label] <String>] [[-Value] <String>] [[-Min] <String>] [[-Max] <String>]
 [[-Placeholder] <String>] [[-IsRequired] <Boolean>] [[-ErrorMessage] <String>] [[-Height] <String>]
 [-Separator] [[-Spacing] <String>] [[-IsVisible] <Boolean>] [[-Requires] <Hashtable>] [[-Fallback] <Object>]
 [[-TargetWidth] <String>] [[-GridArea] <String>] [[-Lang] <String>] [[-IsSortKey] <Boolean>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-CardInputTime function creates an Input.Time element that allows users to select a time.
Supports time range constraints (min/max), default values, validation, and labels.

## EXAMPLES

### EXAMPLE 1
```
New-CardInputTime -Id "meetingTime" -Label "Meeting Time" -IsRequired $true
```

Creates a required time picker for meeting time.

### EXAMPLE 2
```
New-CardInputTime -Id "startTime" -Label "Start Time" -Min "09:00" -Max "17:00"
```

Creates a time picker limited to business hours (9 AM to 5 PM).

### EXAMPLE 3
```
New-CardInputTime -Id "appointmentTime" -Value "14:30" -Placeholder "Select appointment time"
```

Creates a time picker with a default value of 2:30 PM and placeholder text.

### EXAMPLE 4
```
New-CardInputTime -Id "reminderTime" -Label "Reminder Time" -Value "08:00" -IsRequired $true
```

Creates a required time picker with 8:00 AM as the default value.

### EXAMPLE 5
```
New-CardInputTime -Id "eventTime" -Label "Event Time" -Spacing "Large" -Separator
```

Creates a time picker with extra spacing and a separator line above it.

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
Label text displayed above the time picker.
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
Initial/default time value in HH:MM format (e.g., "14:30" for 2:30 PM).

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
Minimum selectable time in HH:MM format.
Users cannot select times before this.

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
Maximum selectable time in HH:MM format.
Users cannot select times after this.

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
Placeholder text displayed when no time is selected.
Provides hints about expected time format.

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
Marks the time input as required.
The card cannot be submitted without selecting a time.

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
### Returns a hashtable representing the Input.Time element with all configured properties.
## NOTES
- The Id parameter is essential for retrieving submitted values
- Time values must be in HH:MM format (24-hour format)
- Min and Max constraints are enforced by the time picker UI
- IsRequired prevents card submission until a time is selected
- Not all hosts support all features (check host capabilities)

## RELATED LINKS

[New-AdaptiveCard]()

[New-CardInputDate]()

[New-CardInputText]()

