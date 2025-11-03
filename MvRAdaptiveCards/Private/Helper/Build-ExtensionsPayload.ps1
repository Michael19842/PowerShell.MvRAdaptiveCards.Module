function Build-ExtensionsPayload {
    param(
        [string]$Json,
        [string]$ScriptsPath,
        [string]$StylesPath,
        [switch]$EncapsulateStyles
    )

    # Get all available extensions by scanning the ScriptsPath for .js files
    $AvailableExtensions = (Get-ChildItem -Path $ScriptsPath -Filter *.js | ForEach-Object { $_.BaseName })

    # An empty array to hold the extensions that need to be loaded
    $ExtensionsToLoad = [System.Collections.ArrayList]@()

    # Test each available extension to see if it's referenced in the JSON by its element type
    foreach ($Extension in $AvailableExtensions) {
        if ($Json -match [regex]::escape($Extension)) {
            [void]($ExtensionsToLoad.Add($Extension))
        }
    }

    $ReturnPayload = @{
        Scripts = ''
        Styles  = ''
    }

    foreach ($Extension in $ExtensionsToLoad) {
        #Get the file content
        $ExtensionPath = "$ScriptsPath\$Extension.js"

        # Add the script content to the payload
        if (Test-Path -Path $ExtensionPath) {
            $ExtensionContent = Get-Content -Path $ExtensionPath -Raw
            $ReturnPayload.Scripts += "`n`n// Extension: $Extension`n" + $ExtensionContent
        }

        # Add the CSS content to the payload
        $ExtensionCssPath = "$StylesPath\$Extension.css"
        if (Test-Path -Path $ExtensionCssPath) {
            $ExtensionCssContent = Get-Content -Path $ExtensionCssPath -Raw
            $ReturnPayload.Styles += "`n/* Extension: $Extension */`n" + $ExtensionCssContent
        }
    }

    if ($EncapsulateStyles) {
        $ReturnPayload.Styles = "<style type='text/css'>$($ReturnPayload.Styles)</style>"
    }

    return $ReturnPayload
}