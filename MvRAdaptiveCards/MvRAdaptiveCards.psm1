#Requires -Version 5.1

[CmdletBinding()]
param (
    [switch]$ExposePrivateFunctions
)

#Set the maximum depth for JSON conversion
$_MaxDepth = 40

# Export-ModuleMember -Variable none
$ModuleName = 'MvRAdaptiveCards'

##Collect the stored settings for the module from the appdata folder
$AppDataFolder = [System.IO.Path]::Combine($env:APPDATA, "PowerShell.$ModuleName.Module")
$SettingsFile = [System.IO.Path]::Combine($AppDataFolder, 'settings.json')

if (Test-Path $SettingsFile) {
    $Settings = Get-Content -Path $SettingsFile -Raw | ConvertFrom-Json
} else {
    $Settings = $null
}

foreach ($Folder in @('Private', 'Public')) {
    $LogicFiles = Get-ChildItem -Path $PSScriptRoot\$Folder -Filter '*.ps1' -Recurse

    # dot source each file except tests
    $LogicFiles | Where-Object { $_.name -NotLike '*.Tests.ps1' } | ForEach-Object { 
        . $_.FullName 
    }
}
Write-Verbose "Functions defined: $(Get-Command -Module $MyInvocation.MyCommand.Module | Select-Object -ExpandProperty Name | where {$_ -like '*-MvR*'} )"

Export-ModuleMember -Function (Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -Recurse).BaseName

if ($ExposePrivateFunctions) {
    Export-ModuleMember -Function (Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -Recurse).BaseName
}


