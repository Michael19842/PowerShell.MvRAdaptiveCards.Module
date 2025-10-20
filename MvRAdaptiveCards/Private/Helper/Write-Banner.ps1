function Write-Banner {
    param (

    )


    #Get the current module version
    $ModuleVersion = (Test-ModuleManifest -Path "$PSScriptRoot\..\..\MvRAdaptiveCards.psd1").Version

    #Expand the string now we have the version


    $Banner = @"
 {blue}┌────╗
 {blue}│ {white}>_ {blue}│ {white}MvRAdaptiveCards {gray}version $ModuleVersion
 {blue}╚────┘ {white}- {DarkCyan}PowerShell {gray}Module for creating Adaptive Cards
"@

    Write-ColoredHost -Text $Banner
    Write-ColoredHost -Text " "
}

