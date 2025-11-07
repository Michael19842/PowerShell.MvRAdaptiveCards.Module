function Get-ACR (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]$Json) {
    Get-CardResponse -Json $Json -ViewMethod EdgeApp -AutoSize -HideHeader
}