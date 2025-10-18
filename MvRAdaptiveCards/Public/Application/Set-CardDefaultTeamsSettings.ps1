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
function Set-CardDefaultTeamsSettings {
    param (
        [Parameter(Mandatory = $true)]
        [string]$WebhookUrl
    )

    # Initialize global settings if not exist
    if ($null -eq $script:_MvRACSettings) {
        $script:_MvRACSettings = @{}
    }
    if ($null -eq $script:_MvRACSettings.Context) {
        $script:_MvRACSettings.Context = @{}
    }
    if ($null -eq $script:_MvRACSettings.Teams) {
        $script:_MvRACSettings.Teams = @{}
    }

    # Set Teams settings
    $script:_MvRACSettings.Teams.WebhookUrl = $WebhookUrl
    

    # Create settings file if it doesn't exist
    if (-not (Test-Path $script:_SettingsFile)) {

        $script:_MvRACSettings = @{
            Context = @{
                User = $env:USERNAME
                Host = $env:COMPUTERNAME
            }
        }

        $script:_MvRACSettingsJson = $script:_MvRACSettings | ConvertTo-Json -Depth 5
        $script:_MvRACSettingsJson | Set-Content -Path $script:_SettingsFile -Encoding UTF8
    }

    # Get the now existing settings file
    $script:_CurrentMvRACSettings = Get-Content -Path $script:_SettingsFile -Raw | ConvertFrom-JsonAsHashtable

    # If the settings were not found, initialize them
    if ($null -eq $script:_MvRACSettings) {
        $script:_MvRACSettings = @{
            Context = @{
                User = $env:USERNAME
                Host = $env:COMPUTERNAME
            }
        }
    }

    # Validate the context to ensure it matches the current user/machine
    if ($script:_CurrentMvRACSettings.Context.User -ne $env:USERNAME -or $script:_CurrentMvRACSettings.Context.Host -ne $env:COMPUTERNAME) {
        Write-Warning "The existing settings file was created for user '$($script:_CurrentMvRACSettings.Context.User)' on host '$($script:_CurrentMvRACSettings.Context.Host)'. The current user is '$env:USERNAME' on host '$env:COMPUTERNAME'. Settings will be updated to match the current context. But additional steps may be required to ensure proper operation."
        $script:_MvRACSettings.Context.User = $env:USERNAME
        $script:_MvRACSettings.Context.Host = $env:COMPUTERNAME
    }

    # Save the updated settings
    $script:_MvRACSettings | ConvertTo-Json -Depth 5 | Set-Content -Path $script:_SettingsFile -Encoding UTF8 -Force
}