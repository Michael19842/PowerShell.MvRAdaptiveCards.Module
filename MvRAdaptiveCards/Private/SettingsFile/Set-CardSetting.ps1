function Set-CardSetting {
    [system.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Settings variable used in module')]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $false)]
        [string]$Path = $_SettingsFile,

        [Parameter(Mandatory = $true)]
        [hashtable]$Settings
    )

    process {
        #If the folder does not exist, create it
        $folder = Split-Path -Path $Path
        if (-not (Test-Path -Path $folder)) {
            New-Item -ItemType Directory -Path $folder -Force | Out-Null
            Write-Verbose "Created folder: $folder"
        }

        #If the settings file does not exist, create it
        if (-not (Test-Path -Path $Path)) {
            New-Item -ItemType File -Path $Path -Force | Out-Null
            Write-Verbose "Created settings file: $Path"
        }

        if ($PSCmdlet.ShouldProcess("Setting configuration in file: $Path")) {
            #Remove any setting that is $null
            $ThisSettings = $Settings.Clone()
            foreach ($key in $ThisSettings.Keys) {
                if ($null -eq $ThisSettings[$key]) {
                    $Settings.Remove($key)
                }
            }

            # Update settings
            $Settings | ConvertTo-Json | Set-Content $Path
        }

        Set-Variable -Name "_MvRACSettings" -Value (Get-CardSetting) -Scope Script
    }
}