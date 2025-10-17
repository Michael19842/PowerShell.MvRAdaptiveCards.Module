#A polyfill for ConvertFrom-Json -AsHashtable for PowerShell versions that do not support it natively


function ConvertFrom-JsonAsHashtable {

  [CmdletBinding()]
  param(
    [Parameter(ValueFromPipeline)]
    $InputObject
  )

    process {
        if ($PSVersionTable.PSVersion.Major -ge 7) {
        return $InputObject | ConvertFrom-Json -AsHashtable
        } else {
        $JsonObject = $InputObject | ConvertFrom-Json
        return Convert-ObjectToHashtable -Object $JsonObject
        }
    }

}
