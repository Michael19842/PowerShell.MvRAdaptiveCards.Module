function Set-CardDefaultSmtpSetting {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([void])]
    param (
        [string]$From,
        [string]$Server,
        [int]$Port,
        [string]$Username,
        [securestring]$Password,
        [switch]$ClearSetting
    )
    process {
        $Settings = Get-CardSetting

        if (-not $Settings) {
            $Settings = @{}
        }

        if (-not $Settings.DefaultSmtpSettings) {
            $Settings.DefaultSmtpSettings = @{}
        }

        if ($From) {
            $Settings.DefaultSmtpSettings.From = $From
        }
        if ($Server) {
            $Settings.DefaultSmtpSettings.Server = $Server
        }
        if ($Port) {
            $Settings.DefaultSmtpSettings.Port = $Port
        }
        if ($Username) {
            $Settings.DefaultSmtpSettings.Username = $Username
        }
        if ($Password) {
            $Settings.DefaultSmtpSettings.Password = $Password | ConvertFrom-SecureString
        }

        if ($ClearSetting) {
            $Settings.DefaultSmtpSettings = @{}
        }

        if ($PSCmdlet.ShouldProcess("Updating default SMTP settings")) {
            Set-SettingsFile -Settings $Settings
        }
    }
}

# Add an alias for plural form (Reverse compatibility)
Set-Alias -Name Set-CardDefaultSmtpSettings -Value Set-CardDefaultSmtpSetting
