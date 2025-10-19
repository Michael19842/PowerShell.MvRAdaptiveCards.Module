function New-CardActionOpenUrl {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Url,

        [Parameter(Mandatory = $false)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Default", "Dark", "Light", "Accent", "Good", "Warning", "Attention")]
        [string]$Style,

        [Parameter(Mandatory = $false)]
        [string]$Id
    )

    $action = @{
        type = "Action.OpenUrl"
        url  = $Url
    }

    if ($PSBoundParameters.ContainsKey('Title')) {
        $action.title = $Title
    }

    if ($PSBoundParameters.ContainsKey('Style')) {
        $action.style = $Style
    }

    if ($PSBoundParameters.ContainsKey('Id')) {
        $action.id = $Id
    }

    if ($PSCmdlet.ShouldProcess("Creating Action.OpenUrl action to '$Url'")) {
        return $action
    }

}