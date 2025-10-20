[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables are used in dot-sourced scripts')]
#Requires -Version 5.1

[CmdletBinding()]
param (
    [switch]$ExposePrivateFunctions
)

#Set the maximum depth for JSON conversion
$_MaxDepth = 40

# Export-ModuleMember -Variable none
$ModuleName = 'MvRAdaptiveCards'


foreach ($Folder in @('Private', 'Public', 'Collection', 'ArgumentCompleters')) {
    $LogicFiles = Get-ChildItem -Path $PSScriptRoot\$Folder -Filter '*.ps1' -Recurse

    # dot source each file except tests
    $LogicFiles | Where-Object { $_.name -notlike '*.Tests.ps1' } | ForEach-Object {
        . $_.FullName
    }
}

Write-Verbose "Functions defined: $(Get-Command -Module $MyInvocation.MyCommand.Module | Select-Object -ExpandProperty Name | Where-Object {$_ -like '*-MvR*'} )"

Export-ModuleMember -Function (Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -Recurse).BaseName

if ($ExposePrivateFunctions) {
    Export-ModuleMember -Function (Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -Recurse).BaseName
}

##Collect the stored settings for the module from the appdata folder
$_AppDataFolder = [System.IO.Path]::Combine($env:APPDATA, "PowerShell.$ModuleName.Module")
$_SettingsFile = [System.IO.Path]::Combine($_AppDataFolder, 'settings.json')


# Load existing settings if the settings file exists
if (Test-Path $_SettingsFile) {
    $_MvRACSettings = Get-Content -Path $_SettingsFile -Raw | ConvertFrom-JsonAsHashtable
}
else {
    $_MvRACSettings = $null
}
