function New-CardActionSubmit {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        [string]$Id,

        [parameter(Mandatory = $false)]
        [ValidateSet("default", "positive", "destructive")]
        [string]$Style,

        [parameter(Mandatory = $false)]
        [scriptblock]
        $Fallback,

        $Data
    )
    $Action = @{
        type  = "Action.Submit"
        title = $Title
    }
    if ($Id) {
        $Action.id = $Id
    }
    if ($Style) {
        $Action.style = $Style
    }

    if ($PSCmdlet.ShouldProcess("Creating Action.Submit with title '$Title'")) {
        return $Action
    }

    if ($Data) {
        if ( $Data -is [scriptblock] ) {
            $Action.data = Invoke-Command -ScriptBlock $Data
        }
        else {
            $Action.data = $Data
        }
    }

    if ($Fallback) {
        $Action.fallback = Invoke-Command -ScriptBlock $Fallback
    }

    if ($PSCmdlet.ShouldProcess("Returning Action.Submit with title '$Title'")) {
        return $Action
    }

}