function Set-CardDefaultSmtpSettings {
    param (
        [string]$From,
        [string]$Server,
        [int]$Port,
        [string]$Username,
        [securestring]$Password
    )

    if ($null -eq $_MvRACSettings) {
        $_MvRACSettings = @{}
    }
    if ($null -eq $_MvRACSettings.Context) {
        $_MvRACSettings.Context = @{}
    }
    if ($null -eq $_MvRACSettings.Smtp) {
        $_MvRACSettings.Smtp = @{}
    }

    $_MvRACSettings.Smtp.From = $From
    $_MvRACSettings.Smtp.Server = $SmtpServer
    $_MvRACSettings.Smtp.Port = $SmtpPort
    
    if($SmtpUsername) {
        $_MvRACSettings.Smtp.Username = $SmtpUsername
    }
    else {
        $_MvRACSettings.Smtp.Username = $null
    }
    
    if($null -ne $SmtpPassword) {
        #Since the securestring is strictly bound to the current user/machine, we can store it as plain text
        $_MvRACSettings.Smtp.Password = ConvertFrom-SecureString $SmtpPassword
    }
    else {
        $_MvRACSettings.Smtp.Password = $null
    }


    
    #Create settings file if it doesn't exist
    if (-not (Test-Path $_SettingsFile)) {

        $_MvRACSettings = @{
            Context = @{
                User = $env:USERNAME
                Host = $env:COMPUTERNAME
            }
        }

        $_MvRACSettingsJson = $_MvRACSettings| ConvertTo-Json -Depth 5
        $_MvRACSettingsJson | Set-Content -Path $_SettingsFile -Encoding UTF8
    }

    #Get the now existing settings file
    $_CurrentMvRACSettings = Get-Content -Path $_SettingsFile -Raw | ConvertFrom-JsonAsHashtable

    # If the settings were not found, initialize them
    if ($null -eq $_MvRACSettings) {
        $_MvRACSettings = @{
            Context = @{
                User = $env:USERNAME
                Host = $env:COMPUTERNAME
            }
        }
    }

    #Validate the context to ensure it matches the current user/machine
    if ($_CurrentMvRACSettings.Context.User -ne $env:USERNAME -or $_CurrentMvRACSettings.Context.Host -ne $env:COMPUTERNAME) {
        Write-Warning "The existing settings file was created for user '$($_CurrentMvRACSettings.Context.User)' on host '$($_CurrentMvRACSettings.Context.Host)'. The current user is '$env:USERNAME' on host '$env:COMPUTERNAME'. Settings will be updated to match the current context. But additional steps may be required to ensure proper operation."
        $_MvRACSettings.Context.User = $env:USERNAME
        $_MvRACSettings.Context.Host = $env:COMPUTERNAME
    }

    #Save the updated settings
    $_MvRACSettings | ConvertTo-Json -Depth 5 | Set-Content -Path $_SettingsFile -Encoding UTF8 -Force
}
