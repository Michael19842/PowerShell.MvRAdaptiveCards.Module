function New-CardActionShowCard {
    param (
        [Parameter(Mandatory = $true)]
        [scriptblock]$Card,
        
        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        [string]$Id,

        [parameter(Mandatory = $false)]
        [ValidateSet("default", "positive", "destructive")]
        [string]$Style

    )

    $ShowCardAction = @{
        type  = "Action.ShowCard"
        title = $Title
        card  = Invoke-Command -ScriptBlock $Card
    }

    if ($Id) {
        $ShowCardAction.id = $Id
    }

    if ($Style) {
        $ShowCardAction.style = $Style
    }

    return $ShowCardAction
}