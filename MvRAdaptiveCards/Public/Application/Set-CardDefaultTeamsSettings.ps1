function Set-CardDefaultTeamsSettings {
    param (
        [string]$WebhookUrl
    )

    #Ensure AppData folder exists
    $AppDataFolder = [System.IO.Path]::Combine($env:APPDATA, "PowerShell.$Script:ModuleName.Module")
    if (-not (Test-Path $AppDataFolder)) {
        [void](New-Item -ItemType Directory -Path $AppDataFolder -Force)
    }

    $SettingsFile = [System.IO.Path]::Combine($AppDataFolder, 'settings.json')
    
    #Create settings file if it doesn't exist
    if (-not (Test-Path $SettingsFile)) {

        $Script:Settings = @{
            Context = @{
                User = $env:USERNAME
                Host = $env:COMPUTERNAME
            }
        }

        $SettingsJson = $script:Settings | ConvertTo-Json -Depth 5
        $SettingsJson | Set-Content -Path $SettingsFile -Encoding UTF8
    }

    #Get the now existing settings file
    $Script:Settings = Get-Content -Path $SettingsFile -Raw | ConvertFrom-Json

    #Validate the context to ensure it matches the current user/machine
    if ($script:Settings.Context.User -ne $env:USERNAME -or $script:Settings.Context.Host -ne $env:COMPUTERNAME) {
        Write-Warning "The existing settings file was created for user '$($script:Settings.Context.User)' on host '$($script:Settings.Context.Host)'. The current user is '$env:USERNAME' on host '$env:COMPUTERNAME'. Settings will be updated to match the current context. But additional steps may be required to ensure proper operation."
        $script:Settings.Context.User = $env:USERNAME
        $script:Settings.Context.Host = $env:COMPUTERNAME
    }

    $script:Settings.Teams.WebhookUrl = $WebhookUrl
    #Save the updated settings
    
    $SettingsJson = $script:Settings | ConvertTo-Json -Depth 5
    $SettingsJson | Set-Content -Path $SettingsFile -Encoding UTF8

}