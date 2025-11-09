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


        #if there are more settings in the default file than in the user file add them to the user settings
        if ($null -ne $UserSettings) {
            foreach ($key in $Settings.Keys) {
                if ($Settings[$key] -is [hashtable]) {
                    if (-not $UserSettings.ContainsKey($key)) {
                        $UserSettings[$key] = @{}
                    }
                    foreach ($subkey in $Settings[$key].Keys) {
                        if (-not $UserSettings[$key].ContainsKey($subkey)) {
                            $UserSettings[$key][$subkey] = $Settings[$key][$subkey]
                        }
                    }
                }
            }

            foreach ($key in $UserSettings.Keys) {
                $Settings[$key] = $UserSettings[$key]
            }

            return $Settings
        }
        else {
            return $Settings
        }

    }
}