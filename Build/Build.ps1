#Requires -Version 5.1

Properties {
    $ModuleName = 'MvRAdaptiveCards'

    #Shared variables
    $manifestPath = "$PSScriptRoot\..\$ModuleName\$ModuleName.psd1"
    $publicFolder = "$PSScriptRoot\..\$ModuleName\Public"

    #Define the variable so that it can be used in the tasks
    $Manifest = $null
}

task prepare {
    $requiredModules = @('Pester', 'PlatyPS', 'PsScriptAnalyzer', 'PSake')
    #Install the required modules if they are not already installed
    foreach ($module in $requiredModules) {
        if (-not (Get-Module -ListAvailable -Name $module)) {
            Install-Module -Name $module -Scope CurrentUser -Force -AllowClobber
        }
    }
}

task updateManifest -Depends prepare -PreAction {
    #Grab the current version from the manifest
    $Manifest = Test-ModuleManifest -Path $manifestPath

    Write-Debug "Current module version: $($Manifest.Version.ToString())"
} -Action {
    # Step 1: Discover all function names in Public folder
    $functionNames = Get-ChildItem -Path $publicFolder -Filter '*.ps1' -Recurse |
    Where-Object { $_.Name -notlike '*.Tests.ps1' } |
    ForEach-Object { $_.BaseName } | Sort-Object -Unique

    if (($Manifest.ExportedFunctions.Keys -join '|') -ne ($functionNames -join '|') -or $BumpMajorVersion -or $BumpMinorVersion) {
        #Update version number by incrementing the build number
        $NewVersion = [version]::new($Manifest.Version.Major, $Manifest.Version.Minor, $Manifest.Version.Build + 1, 0)

        Write-Debug "Updating module manifest at $manifestPath with functions: $($functionNames -join ', ')"
        #Save the updated manifest
        Update-ModuleManifest -Path $manifestPath -FunctionsToExport $functionNames -ModuleVersion $NewVersion
    }
}

task test -Action {
    Invoke-Pester -Path ".\..\tests\"
}

task analyse -Action {
    #Run script analysis to determine if any breaking changes were made
    $AnalysisResults = Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\$ModuleName" -Recurse

    #Output the analysis results as an aggregated summary
    $AnalysisResults | Group-Object Severity | ForEach-Object {
        [PSCustomObject]@{
            Severity = $_.Name
            Count    = $_.Count
        }
    } | Format-Table -AutoSize

    #Throw an error if any errors were found
    $ErrorCount = ($AnalysisResults | Where-Object { $_.Severity -eq 'Error' }).Count

    if ($ErrorCount -gt 0) {
        throw "$ErrorCount script analysis errors found. Please fix them before proceeding."
    }
}


task buildDocumentation -RequiredVariables 'ModuleName' -PreAction {
    Import-Module "$PSScriptRoot\..\$ModuleName" -Global
    Import-Module PlatyPS
} -Action {
    Write-Host "Building documentation for module $ModuleName in path $PSScriptRoot\..\$ModuleName"
    $docsPath = "$PSScriptRoot\..\docs"
    if (Test-Path $docsPath) {
        [void](Update-MarkdownHelpModule -RefreshModulePage -Path $docsPath -ModulePagePath "$docsPath\$ModuleName.md")
        [void](Update-MarkdownHelp -Path $docsPath)
    }
    else {
        [void](New-MarkdownHelp -Module $ModuleName -OutputFolder $docsPath -WithModulePage)
    }
}


task default -Depends prepare, updateManifest, test, analyse, buildDocumentation





