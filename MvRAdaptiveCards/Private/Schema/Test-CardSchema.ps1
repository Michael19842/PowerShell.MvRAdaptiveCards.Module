function Test-CardSchema {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true)]
        [string]$Json,
        [string]$SchemaPath = "$PSScriptRoot\..\..\schemas\AdaptiveCard.json",
        [switch]$ShowErrors
    )

    IF($ShowErrors) {
        $FunctionErrorActionPreference = 'Continue'
    } ELSE {
        $FunctionErrorActionPreference = 'SilentlyContinue'
    }

    $Schema = Get-Content -Path $SchemaPath -Raw
    $LocalValidationResult = Test-Json -Json ($Json -join '') -Schema $Schema -ErrorAction $FunctionErrorActionPreference

    # Optional: Validate against the online schema as well
    $SchemaUrl = "http://adaptivecards.io/schemas/adaptive-card.json"
    $OnlineSchema = (Invoke-WebRequest -Uri $SchemaUrl).Content
    $OnlineValidationResult = Test-Json -Json ($Json -join '') -Schema $OnlineSchema -ErrorAction $FunctionErrorActionPreference

    
    if ($LocalValidationResult -and $OnlineValidationResult) {
        Write-ColoredHost -Text "{white}[{green}V{white}] JSON is valid against both local and online schema."
    } elseif (-not $LocalValidationResult) {
        Write-ColoredHost -Text "{white}[{red}X{white}] JSON is NOT valid against the local schema."
    } elseif (-not $OnlineValidationResult) {
        Write-ColoredHost -Text "{white}[{red}X{white}] JSON is NOT valid against the online schema. Which is not necessarily a problem. The current online schema has been proven to be incompatible with some valid cards."
    }
    return $LocalValidationResult
}