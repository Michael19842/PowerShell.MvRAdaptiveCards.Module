---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version:
schema: 2.0.0
---

# New-CardActionOpenUrlDialog

## SYNOPSIS
Creates an Action.OpenUrlDialog action for Adaptive Cards.

## SYNTAX

```
New-CardActionOpenUrlDialog [-Url] <String> [[-Title] <String>] [[-DialogTitle] <String>]
 [[-DialogWidth] <String>] [[-DialogHeight] <String>] [[-Style] <String>] [[-Id] <String>]
 [[-IconUrl] <String>] [[-IsEnabled] <Boolean>] [[-Mode] <String>] [[-Tooltip] <String>]
 [[-MenuActions] <Array>] [[-ThemedIconUrls] <Array>] [[-Fallback] <ScriptBlock>] [[-Requires] <Hashtable>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates an action that opens a URL in a dialog/modal window within the host application,
rather than in a new browser tab.
This provides a more integrated experience.

## EXAMPLES

### EXAMPLE 1
```
New-CardActionOpenUrlDialog -Title "View Details" -Url "https://example.com/details" -DialogWidth "large" -DialogHeight "medium"
```

### EXAMPLE 2
```
New-CardActionOpenUrlDialog -Title "Help" -Url "https://docs.example.com" -DialogTitle "Help Documentation" -DialogWidth "800px" -DialogHeight "600px"
```

## PARAMETERS

### -Url
The URL to open in the dialog.

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

### -Title
The title of the action as it appears on buttons.

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

### -DialogTitle
The title to be displayed in the dialog header.

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

### -DialogWidth
The width of the dialog.
Can be "small", "medium", "large", or a pixel value like "500px".

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

### -DialogHeight
The height of the dialog.
Can be "small", "medium", "large", or a pixel value like "400px".

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

### -Style
Control the style of the action.
Valid values: default, positive, destructive.

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

### -Id
A unique identifier for the action.

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

### -IconUrl
A URL or icon name to display on the left of the action's title.

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

### -IsEnabled
Controls the enabled state of the action.
Default is true.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mode
Controls if the action is primary or secondary.
Valid values: primary, secondary.

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

### -Tooltip
The tooltip text to display when the action is hovered over.

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

### -MenuActions
The actions to display in the overflow menu of a Split action button.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThemedIconUrls
A set of theme-specific icon URLs.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fallback
An alternate action to render if this action type is unsupported.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Requires
A hashtable of capabilities the element requires the host application to support.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
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
## NOTES

## RELATED LINKS
