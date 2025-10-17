function New-CardActionToggleVisibility {

    param (
        [Parameter(Mandatory = $true)]
        [string[]]$TargetElements,

        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        [ValidateSet("default", "positive", "destructive")]
        [string]$Style,
        
        [Parameter(Mandatory = $false)]
        [string]$Id

    )

    $ToggleVisibilityAction = @{
        type  = "Action.ToggleVisibility"
        title = $Title
    }

    If ($TargetElements) {
       $ToggleVisibilityAction.targetElements = $TargetElements
    }


    if ($Id) {
        $ToggleVisibilityAction.id = $Id
    }

    return $ToggleVisibilityAction
}