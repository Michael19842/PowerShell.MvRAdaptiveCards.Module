[CmdletBinding()]
param (
    [switch]$BumpMajorVersion,
    [switch]$BumpMinorVersion
)

$ModuleName = 'MvRAdaptiveCards'

$manifestPath = "$PSScriptRoot\..\$ModuleName\$ModuleName.psd1"
$publicFolder = "$PSScriptRoot\..\$ModuleName\Public"


# Step 1: Discover all function names in Public folder
$functionNames = Get-ChildItem -Path $publicFolder -Filter '*.ps1' -Recurse |
    Where-Object { $_.Name -notlike '*.Tests.ps1' } |
    ForEach-Object { $_.BaseName } | Sort-Object -Unique

# Step 2: Update manifest
$Manifest = Test-ModuleManifest -Path $manifestPath
if ($null -eq $Manifest) {
    throw "Module manifest not found or invalid at path: $manifestPath"
}

#If the manifest already exports functions, compare and update if necessary
if (($Manifest.ExportedFunctions.Keys -join '|') -ne ($functionNames -join '|') -or $BumpMajorVersion -or $BumpMinorVersion) {
    #Update version number by incrementing the build number
    Write-Host "Current module version: $($Manifest.Version.ToString())"
    
    if ($BumpMajorVersion) {
        $NewVersion = [version]::new($Manifest.Version.Major + 1, 0, 0, 0)
    }
    elseif ($BumpMinorVersion) {
        $NewVersion = [version]::new($Manifest.Version.Major, $Manifest.Version.Minor + 1, 0, 0)
    }
    else {
        $NewVersion = [version]::new($Manifest.Version.Major, $Manifest.Version.Minor, $Manifest.Version.Build + 1, 0)
    }
    Write-Host "Updating module manifest at $manifestPath with functions: $($functionNames -join ', ')"

    Write-Host "New module version: $NewVersion"
    
    Update-ModuleManifest -Path $manifestPath -FunctionsToExport $functionNames -ModuleVersion $NewVersion
} else {
    Write-Host "Module manifest at $manifestPath is already up to date."
}

#Use PlatyPS to build the documentation
Import-Module PlatyPS 

Import-Module "${PSScriptRoot}\..\$ModuleName"

$docsPath = "$PSScriptRoot\..\docs"
if (Test-Path $docsPath) {
    Update-MarkdownHelpModule -RefreshModulePage -Path $docsPath -ModulePagePath "$docsPath\$ModuleName.md" 
    Update-MarkdownHelp -Path $docsPath
}
Else{
    New-MarkdownHelp -Module $ModuleName -OutputFolder $docsPath -WithModulePage
}

