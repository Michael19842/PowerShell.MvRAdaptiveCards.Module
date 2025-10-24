<#
.SYNOPSIS
    Sets the default Microsoft Teams webhook settings for Adaptive Card delivery.

.DESCRIPTION
    The Set-CardDefaultTeamsSettings function configures the default Teams webhook URL and related settings
    that will be used for sending Adaptive Cards to Microsoft Teams channels. The settings are stored
    in a user-specific configuration file and include context validation to ensure settings are used
    by the correct user and machine.

.PARAMETER WebhookUrl
    The Microsoft Teams webhook URL where Adaptive Cards will be sent. This should be a complete
    webhook URL obtained from a Teams channel connector configuration.

.PARAMETER ChannelName
    An optional friendly name for the Teams channel to help identify which channel the webhook points to.
    This is for reference purposes only and doesn't affect functionality.

.PARAMETER TeamName
    An optional team name for reference purposes to help identify which team the channel belongs to.

.EXAMPLE
    Set-CardDefaultTeamsSettings -WebhookUrl "https://outlook.office.com/webhook/12345..."

    Sets the default Teams webhook URL for sending Adaptive Cards.

.EXAMPLE
    Set-CardDefaultTeamsSettings -WebhookUrl "https://outlook.office.com/webhook/12345..." -ChannelName "General" -TeamName "Development Team"

    Sets the Teams webhook with additional reference information about the channel and team.

.NOTES
    - Settings are stored per user and machine for security
    - The webhook URL should be kept secure as it allows posting to the Teams channel
    - Settings are validated against the current user context when loaded
    - The configuration file is stored in the user's AppData folder

.LINK
    https://docs.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/
#>
function Set-CardDefaultTeamsSetting {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([void])]
    param (
        [Parameter(Mandatory = $true)]
        [string]$WebhookUrl,

        [Parameter(Mandatory = $false)]
        [switch]$Clear
    )

    $Settings = Get-CardSettings

    $Settings.TeamsWebhook = @{
        WebhookUrl = $WebhookUrl
    }

    if ($Clear) {
        $Settings.TeamsWebhook = $Null
    }

    if ($PSCmdlet.ShouldProcess("Setting default Teams webhook URL")) {
        Set-CardSettings -Settings $Settings
    }
}

#Add an alias for plural form (Reverse compatibility)
Set-Alias -Name Set-CardDefaultTeamsSettings -Value Set-CardDefaultTeamsSetting