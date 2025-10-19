---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/
schema: 2.0.0
---

# Set-CardDefaultTeamsSetting

## SYNOPSIS
Sets the default Microsoft Teams webhook settings for Adaptive Card delivery.

## SYNTAX

```
Set-CardDefaultTeamsSetting [-WebhookUrl] <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Set-CardDefaultTeamsSettings function configures the default Teams webhook URL and related settings
that will be used for sending Adaptive Cards to Microsoft Teams channels.
The settings are stored
in a user-specific configuration file and include context validation to ensure settings are used
by the correct user and machine.

## EXAMPLES

### EXAMPLE 1
```
Set-CardDefaultTeamsSettings -WebhookUrl "https://outlook.office.com/webhook/12345..."
```

Sets the default Teams webhook URL for sending Adaptive Cards.

### EXAMPLE 2
```
Set-CardDefaultTeamsSettings -WebhookUrl "https://outlook.office.com/webhook/12345..." -ChannelName "General" -TeamName "Development Team"
```

Sets the Teams webhook with additional reference information about the channel and team.

## PARAMETERS

### -WebhookUrl
The Microsoft Teams webhook URL where Adaptive Cards will be sent.
This should be a complete
webhook URL obtained from a Teams channel connector configuration.

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

### System.Void
## NOTES
- Settings are stored per user and machine for security
- The webhook URL should be kept secure as it allows posting to the Teams channel
- Settings are validated against the current user context when loaded
- The configuration file is stored in the user's AppData folder

## RELATED LINKS

[https://docs.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/](https://docs.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/)

