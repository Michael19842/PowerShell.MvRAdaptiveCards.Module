function New-CardActionSet {
    param (
        [Parameter(Mandatory = $true)]
        [scriptblock[]]$Actions,
        
        [Parameter(Mandatory = $false)]
        [scriptblock]$Fallback,

        [string]
        [Parameter(Mandatory = $false)]
        $Id

    )

    $ActionSet = @{
        type  = "ActionSet"
        actions = @()   
    }

    if ($Id) {
        $ActionSet.id = $Id
    }

    if ($Fallback) {
        $ActionSet.fallback = Invoke-Command -ScriptBlock $Fallback
    }

    foreach ($Action in $Actions) {
        $ActionSet.actions += Invoke-Command -ScriptBlock $Action
    }

    return $ActionSet
}