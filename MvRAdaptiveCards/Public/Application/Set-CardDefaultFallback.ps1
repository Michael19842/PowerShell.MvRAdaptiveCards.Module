function Set-CardDefaultFallback {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low ')]
    param (
        [parameter(Mandatory = $false)]
        [ScriptBlock]$FallbackContent,

        [switch]$Clear
    )

    # Store the fallback content in a global variable for use in other functions


    $CurrentSettings = Get-CardSetting
    if ($Clear) {
        $CurrentSettings.General.DefaultFallback = ''
    }
    else {
        $CurrentSettings.General.DefaultFallback = $FallbackContent.ToString()
    }

    # Save the updated settings
    if ($PSCmdlet.ShouldProcess("Updating default fallback settings")) {
        Set-CardSetting -Settings $CurrentSettings
    }
}

