---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/
schema: 2.0.0
---

# New-AdaptiveCard

## SYNOPSIS
Creates a new Adaptive Card with the specified content and configuration options.

## SYNTAX

```
New-AdaptiveCard [[-Content] <ScriptBlock>] [-SetFullWidthForTeams] [-TestSchema] [-AsObject]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-AdaptiveCard function creates an Adaptive Card JSON structure or PowerShell object with the provided content elements. 
Adaptive Cards are platform-agnostic snippets of UI that can be used in various applications like Microsoft Teams, Outlook, and more.

This function serves as the main container for all card elements and provides options for Teams-specific formatting,
schema validation, and output format control.

## EXAMPLES

### EXAMPLE 1
```
New-AdaptiveCard -Content {
    New-CardTextBlock -Text "Hello, World!" -Size "Large" -Weight "Bolder"
    New-CardImage -Url "https://example.com/image.jpg" -AltText "Example"
}
```

Creates a simple Adaptive Card with a text block and an image, returned as JSON.

### EXAMPLE 2
```
New-AdaptiveCard -Content {
    New-CardContainer -Style "Good" -Content {
        New-CardTextBlock -Text "Success!" -Color "Good"
    }
} -SetFullWidthForTeams
```

Creates an Adaptive Card with a container and configures it for full width display in Microsoft Teams.

### EXAMPLE 3
```
$card = New-AdaptiveCard -Content {
    New-CardTextBlock -Text "Interactive Card"
    New-CardActionSet -Actions {
        New-CardActionToggleVisibility -Title "Toggle" -TargetElements @("element1")
    }
} -AsObject
```

Creates an Adaptive Card with actions and returns it as a PowerShell object for further manipulation.

## PARAMETERS

### -Content
A ScriptBlock containing the card elements to be included in the Adaptive Card body. 
This can include containers, text blocks, images, tables, action sets, and other supported elements.

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

### -SetFullWidthForTeams
A switch parameter that configures the card to use full width when displayed in Microsoft Teams.
When enabled, adds the msTeams property with width set to "Full".

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

### -TestSchema
A switch parameter that enables validation of the generated card against the Adaptive Card schema.
When enabled, the function will validate the JSON output to ensure it conforms to the schema specifications.

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

### -AsObject
A switch parameter that controls the output format.
When specified, returns the card as a PowerShell hashtable object
instead of JSON string.
Useful for programmatic manipulation or nested card scenarios.

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

### System.String
### By default, returns the Adaptive Card as a JSON string.
### System.Collections.Hashtable
### When -AsObject is specified, returns the card as a PowerShell hashtable object.
## NOTES
- The function automatically sets the schema version to "1.5" and includes the appropriate schema reference
- Content elements are executed in the provided ScriptBlock and added to the card body
- Schema validation requires the Test-CardSchema function to be available in the module
- The function supports both single elements and arrays of elements in the Content ScriptBlock

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/](https://docs.microsoft.com/en-us/adaptive-cards/)

[https://adaptivecards.io/](https://adaptivecards.io/)

