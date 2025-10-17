function Build-CardFromTemplate {
    param (
        [hashtable]$Content,
        [hashtable]$Tags
    )

    $TemplateTags = Find-CardTemplateTags -Content $Content
    $ContentAsJson = $Content | ConvertTo-Json -Depth $_MaxDepth
    
    ForEach ($Key in $Tags.Keys) {
        If ($TemplateTags -contains $Key) {
            $TagValue = $Tags[$Key]
            If ($TagValue -is [scriptblock]) {
                $ResolvedValue = Invoke-Command -ScriptBlock $TagValue
            } Else {
                $ResolvedValue = $TagValue
            }
            $ResolvedValueIsString = $ResolvedValue -is [string] -or $ResolvedValue -is [int] -or $ResolvedValue -is [double] -or $ResolvedValue -is [bool]

            if ($ResolvedValueIsString) {
                $ReplaceValue = ($ResolvedValue | ConvertTo-Json -Depth $_MaxDepth -Compress).Trim('"')
                $TagPlaceholder = New-CardTemplateTag -TagName $Key 
            }
            else {
                $ReplaceValue = $ResolvedValue | ConvertTo-Json -Depth $_MaxDepth -Compress
                $TagPlaceholder = New-CardTemplateTag -TagName $Key | ConvertTo-Json -Depth $_MaxDepth -Compress
            }
            
            $ContentAsJson = $ContentAsJson -replace [regex]::Escape($TagPlaceholder), $ReplaceValue
        } Else {
            Write-Warning "Tag '$Key' not found in template."
        }
    }

    $UpdatedContent = ConvertFrom-JsonAsHashtable -InputObject $ContentAsJson

    return $UpdatedContent
}