function IIF {
    param (
        [bool]$Condition,
        [scriptblock]$Then,
        [scriptblock]$Else
    )

    if ($Condition) {
        & $Then
    }
    else {
        & $Else
    }
}