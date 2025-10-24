function Get-CardSetting {
    [system.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignment', '', Justification = 'Settings variable used in module')]
    param (
        [string]$Path = $_SettingsFile
    )
    process {
        $Settings = Get-Content -Path "$PSScriptRoot\DefaultSettings.json" -Encoding utf8 -Raw | ConvertFrom-JsonAsHashtable
        if (Test-Path -Path $Path) {
            #Override default settings with user settings
            $UserSettings = Get-Content -Path $Path -Encoding utf8 -Raw | ConvertFrom-JsonAsHashtable
        }

        foreach ($key in $UserSettings.Keys) {
            $Settings[$key] = $UserSettings[$key]
        }

        return $Settings
    }

}