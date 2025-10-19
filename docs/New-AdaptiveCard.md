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
New-AdaptiveCard [[-Content] <ScriptBlock>] [[-Actions] <ScriptBlock>] [[-Fallback] <ScriptBlock>]
 [[-Layouts] <ScriptBlock>] [[-References] <ScriptBlock>] [[-Id] <String>] [[-GridArea] <String>]
 [[-Authentication] <Hashtable>] [[-MetadataOriginatingUrl] <String>] [[-verticalContentAlignment] <String>]
 [[-FallbackText] <String>] [[-Speak] <String>] [[-Refresh] <Hashtable>] [[-Resources] <Hashtable>]
 [[-Style] <String>] [[-Language] <String>] [[-ForceVersion] <String>] [[-BackgroundImage] <Hashtable>]
 [[-SelectAction] <ScriptBlock>] [[-MinimalHeightInPixels] <Int32>] [[-Requires] <Hashtable>] [-Hidden]
 [-RightToLeft] [-isSortKey] [-SetFullWidthForTeams] [-TestSchema] [-AsObject]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
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

### -Actions
A ScriptBlock containing action elements to be included at the bottom of the Adaptive Card.
Actions provide interactive functionality like buttons, submit actions, and open URL actions.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fallback
A ScriptBlock that defines fallback content to display if the card cannot be rendered
or is not supported by the host. Should return an appropriate alternative card or element.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Layouts
A ScriptBlock containing layout definitions for the card. Used to define custom layouts
and grid arrangements for card elements.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -References
A ScriptBlock containing reference definitions that can be used throughout the card.
Useful for defining reusable components and templates.

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
A unique identifier for the card. Useful for referencing the card programmatically
or for tracking purposes in applications.

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

### -GridArea
Specifies the named grid area where the card should be placed when used in a grid layout.
This corresponds to the CSS grid-area property.

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

### -Authentication
A hashtable containing authentication configuration for the card. Must include the keys:
'buttons', 'connectionName', 'tokenExchangeResource', and 'text'. Used for OAuth flows
and secure authentication scenarios.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MetadataOriginatingUrl
Specifies the originating URL metadata for the card. This is used to provide context
about where the card originated from, useful for security and tracking purposes.

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

### -verticalContentAlignment
Controls the vertical alignment of content within the card. Valid values are:
- Top: Aligns content to the top
- Center: Centers content vertically
- Bottom: Aligns content to the bottom

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

### -FallbackText
Provides plain text fallback content that will be displayed if the card cannot be rendered.
This is simpler than the Fallback scriptblock and provides basic text-only fallback.

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

### -Speak
Specifies the text that should be spoken by screen readers or voice assistants when
the card is presented. Improves accessibility for users with visual impairments.

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

### -Refresh
A hashtable containing refresh configuration for the card. Must include the 'action' key.
Defines how and when the card should refresh its content automatically.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Resources
A hashtable containing localized string resources for the card. Each key should be a
resource identifier, and the value should be a hashtable with locale codes as keys
and localized strings as values.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Style
Specifies the visual style theme for the card. Valid values are defined in the
AdaptiveCardStyleCollection. Common values include "default", "emphasis", etc.

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

### -Language
Specifies the language/locale for the card content. Used for proper text rendering,
right-to-left language support, and accessibility features.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Lang

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ForceVersion
Forces the card to use a specific Adaptive Card schema version instead of the default "1.5".
Use this when you need compatibility with specific hosts or want to use newer features.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackgroundImage
A hashtable defining a background image for the card. Should include properties like
'url', 'fillMode', 'horizontalAlignment', and 'verticalAlignment'.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SelectAction
A ScriptBlock that defines the action to perform when the entire card is selected/clicked.
The scriptblock should return a single Adaptive Card action element.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinimalHeightInPixels
Specifies the minimum height of the card in pixels. The card will be at least this tall,
even if the content doesn't require it. Useful for maintaining consistent card sizes.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 20
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Requires
A hashtable specifying feature requirements for the card. Used to declare dependencies
on specific Adaptive Card features or host capabilities.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 21
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hidden
A switch parameter that controls whether the card is visible. When specified, the card
will be hidden (isVisible = false). Alias: Hide

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

### -RightToLeft
A switch parameter that enables right-to-left text rendering for languages like Arabic
or Hebrew. Alias: RTL

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: RTL

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -isSortKey
A switch parameter that marks this card as a sort key element. Used in scenarios
where multiple cards need to be sorted or grouped.

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

