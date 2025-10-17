function New-CardTemplateTag {
    param (
        [Parameter(Mandatory = $true)]
        [string]$TagName
    )

    $Tag = "!{{$TagName}}"

    return $Tag
}