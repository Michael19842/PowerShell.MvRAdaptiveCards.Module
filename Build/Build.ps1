#Requires -Version 5.1
#ignore PSAvoidUsingWriteHost
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'write-host used for build progress indication')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables are used in tasks')]
param()
Properties {
    $ModuleName = 'MvRAdaptiveCards'

    #Shared variables
    $manifestPath = "$PSScriptRoot\..\$ModuleName\$ModuleName.psd1"
    $publicFolder = "$PSScriptRoot\..\$ModuleName\Public"

    #Define the variable so that it can be used in the tasks
    $Manifest = Test-ModuleManifest -Path $manifestPath

}

Task prepare {
    $requiredModules = @('Pester', 'PlatyPS', 'PsScriptAnalyzer', 'PSake')
    #Install the required modules if they are not already installed
    foreach ($module in $requiredModules) {
        if (-not (Get-Module -ListAvailable -Name $module)) {
            Install-Module -Name $module -Scope CurrentUser -Force -AllowClobber
        }
    }
}

Task updateManifest -RequiredVariables 'Manifest' -Depends prepare -Action {
    # Step 1: Discover all function names in Public folder
    $functionNames = Get-ChildItem -Path $publicFolder -Filter '*.ps1' -Recurse |
    Where-Object { $_.Name -notlike '*.Tests.ps1' } |
    ForEach-Object { $_.BaseName } | Sort-Object -Unique

    if (($Manifest.ExportedFunctions.Keys -join '|') -ne ($functionNames -join '|') -or $BumpMajorVersion -or $BumpMinorVersion) {
        #Update version number by incrementing the build number
        $NewVersion = [version]::new($Manifest.Version.Major, $Manifest.Version.Minor, $Manifest.Version.Build + 1)

        Write-Debug "Updating module manifest at $manifestPath with functions: $($functionNames -join ', ')"
        #Save the updated manifest
        #Update the modules filelist variable
        $moduleRoot = Resolve-Path "$PSScriptRoot\..\$ModuleName"
        $script:ModuleFileList = Get-ChildItem -Path $moduleRoot -Recurse -File | ForEach-Object {
            # Get the path relative to the module root
            $fullPath = $_.FullName
            if ($fullPath.StartsWith($moduleRoot.Path)) {
                $relativePath = $fullPath.Substring($moduleRoot.Path.Length).TrimStart('\', '/')
                $relativePath -replace '\\', '/'
            }
        } | Where-Object { $_ } # Filter out nulls

        # Update manifest
        Update-ModuleManifest -Path $manifestPath -FunctionsToExport $functionNames -ModuleVersion $NewVersion -FileList $script:ModuleFileList


        Update-ModuleManifest -Path $manifestPath -FunctionsToExport $functionNames -ModuleVersion $NewVersion -FileList $script:ModuleFileList

        #Correct the formatting of the manifest file (Update-ModuleManifest messes up the formatting) "Line has trailing whitespace"
        $manifestContent = Get-Content -Path $manifestPath
        $formattedContent = $manifestContent | ForEach-Object { $_.TrimEnd() }
        #Correct the spaces as tabindents
        $formattedContent = $formattedContent -replace '^( {4})', "`t"
        $formattedContent | Set-Content -Path $manifestPath -Encoding UTF8
    }



}

Task test -Action {
    #Configure Pester settings
    $config = New-PesterConfiguration
    $config.CodeCoverage.Enabled = $true

    $config.Run.Path = ".\..\Tests"
    $config.CodeCoverage.Path = ".\..\$ModuleName"
    $config.CodeCoverage.RecursePaths = $true
    $config.Run.ExcludePath = @("..\$ModuleName\Public\Application\Get-CardResponse.ps1", "..\$ModuleName\Public\Application\Out-CardPreview.ps1")


    Invoke-Pester -Configuration $config
}

Task analyse -Action {
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


Task buildDocumentation -RequiredVariables 'ModuleName' -PreAction {
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

Task displayCodeCoverage -Action {

    # Load XML
    [xml]$Doc = Get-Content -Path "$PSScriptRoot\coverage.xml" -Raw

    # Find all class counters
    $classNodes = $doc.SelectNodes("//class")

    if (-not $classNodes) {
        Write-Error "No <class> nodes found — is the file JaCoCo format?"
        exit 1
    }

    $results = foreach ($class in $classNodes) {

        # filename from sourcefilename=""
        $file = $class.sourcefilename
        if (-not $file) { continue }

        # find LINE-type counter
        $lineCounter = $class.counter | Where-Object { $_.type -eq "LINE" }

        if (-not $lineCounter) { continue }

        $missed = [int]$lineCounter.missed
        $covered = [int]$lineCounter.covered
        $total = $missed + $covered

        if ($total -eq 0) { continue }

        $pct = [math]::Round(($covered / $total) * 100, 2)

        [pscustomobject]@{
            File     = $file
            Lines    = $total
            Covered  = $covered
            Missed   = $missed
            Coverage = (“{0:N2}%%” -f $pct)
        }
    }

    $results | Sort-Object { [double]($_.Coverage -replace '%', '') } -Descending |
    Format-Table -AutoSize

}

Task default -Depends prepare, updateManifest, test, displayCodeCoverage, analyse, buildDocumentation





