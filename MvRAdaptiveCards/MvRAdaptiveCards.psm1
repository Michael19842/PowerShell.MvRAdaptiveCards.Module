[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables are used in dot-sourced scripts')]
#Requires -Version 5.1

[CmdletBinding()]
param (
    [switch]$ExposePrivateReferences,
    [switch]$NoBanner
)

#Set the maximum depth for JSON conversion
$_MaxDepth = 50

# Export-ModuleMember -Variable none
$ModuleName = 'MvRAdaptiveCards'
#Get the current module version
$ModuleVersion = (Test-ModuleManifest -Path "$PSScriptRoot\MvRAdaptiveCards.psd1").Version

foreach ($Folder in @('Private', 'Public', 'Collection', 'ArgumentCompleters')) {
    $LogicFiles = Get-ChildItem -Path $PSScriptRoot\$Folder -Filter '*.ps1' -Recurse

    Write-Verbose "Loading $($LogicFiles.Count) files from $Folder..."

    # dot source each file except tests
    $LogicFiles | Where-Object { $_.name -notlike '*.Tests.ps1' } | ForEach-Object {
        . $_.FullName
    }
}

Write-Verbose "Functions defined: $(Get-Command -Module $MyInvocation.MyCommand.Module | Select-Object -ExpandProperty Name | Where-Object {$_ -like '*-MvR*'} )"

# Export public functions
Export-ModuleMember -Function (Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -Recurse).BaseName

# Export public aliases
Export-ModuleMember -Alias (Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -Recurse | ForEach-Object {
        $Content = Get-Content -Path $_.FullName -Raw
        if ($Content) {
            $AliasMatches = [regex]::Matches($Content, 'Set-Alias\s+-Name\s+(\S+)\s+-Value\s+(\S+)', 'IgnoreCase')
            foreach ($Match in $AliasMatches) {
                $Match.Groups[1].Value
            }
        }
    })

# Export private functions when explicitly requested (for testing purposes)
if ($ExposePrivateReferences) {
    $PrivateFunctions = Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -Recurse | Where-Object { $_.Name -notlike '*.Tests.ps1' }
    Export-ModuleMember -Function $PrivateFunctions.BaseName
    Write-Verbose "Exposing $($PrivateFunctions.Count) private functions for testing"
}

##Collect the stored settings for the module from the appdata folder
$_AppDataFolder = [System.IO.Path]::Combine($env:APPDATA, "PowerShell.$ModuleName.Module")
$_SettingsFile = [System.IO.Path]::Combine($_AppDataFolder, 'settings.json')

# Grab the settings for the module
$_MvRACSettings = Get-CardSetting


# Only show when interactive (avoid in CI or non-interactive runs)


$script:LoadedViaAutoLoad = -not (
    $MyInvocation.Line -match 'Import-Module'
)
#Only show the banner if import module is run in an interactive session an it is not auto-loaded
if (-not $Host.UI.RawUI -or $NoBanner -or $Host.UI.SupportsVirtualTerminal -eq $false -or $script:LoadedViaAutoLoad) { return }
Write-Banner

