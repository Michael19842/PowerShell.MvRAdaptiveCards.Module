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

    # dot source each file except tests
    $LogicFiles | Where-Object { $_.name -notlike '*.Tests.ps1' } | ForEach-Object {
        . $_.FullName
    }
}

Write-Verbose "Functions defined: $(Get-Command -Module $MyInvocation.MyCommand.Module | Select-Object -ExpandProperty Name | Where-Object {$_ -like '*-MvR*'} )"

Export-ModuleMember -Function (Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -Recurse).BaseName
Export-ModuleMember -Alias (Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -Recurse | ForEach-Object {
        $Content = Get-Content -Path $_.FullName -Raw
        $AliasMatches = [regex]::Matches($Content, 'Set-Alias\s+-Name\s+(\S+)\s+-Value\s+(\S+)', 'IgnoreCase')
        foreach ($Match in $AliasMatches) {
            $Match.Groups[1].Value
        }
    })

if ($ExposePrivateReferences) {
    Export-ModuleMember -Function (Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -Recurse).BaseName
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

