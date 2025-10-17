function Find-CardTemplateTags {
    param (
        [hashtable]$Content
    )

    $TemplateAsJson = $Content | ConvertTo-Json -Depth 10
    $TagPattern = '!{{(.*?)}}'
    $Matches = [regex]::Matches($TemplateAsJson, $TagPattern)

    if($Matches.Count -eq 0) {
        return @()
    }

    return $Matches | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique
}