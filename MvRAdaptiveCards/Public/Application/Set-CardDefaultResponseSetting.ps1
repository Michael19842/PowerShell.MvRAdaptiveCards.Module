function Set-CardDefaultResponseSetting {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'low')]
    param(
        [string]$CardTitle = $_MvRACSettings.'Get-Response'.CardTitle,
        [string]$LogoUrl = $_MvRACSettings.'Get-Response'.LogoUrl,
        [string]$LogoHeaderText = $_MvRACSettings.'Get-Response'.LogoHeader,
        [Bool]$ShowVersion = $_MvRACSettings.'Get-Response'.ShowVersion ,
        [int]$PortNumber = $_MvRACSettings.'Get-Response'.PortNumber,
        [switch]$clear
    )
    if ($PSCmdlet.ShouldProcess("Set-CardDefaultResponseSetting")) {
        $CurrentSettings = Get-CardSetting

        $CurrentSettings.'Get-Response'.CardTitle = $CardTitle
        $CurrentSettings.'Get-Response'.LogoUrl = $LogoUrl
        $CurrentSettings.'Get-Response'.LogoHeader = $LogoHeaderText
        $CurrentSettings.'Get-Response'.ShowVersion = $ShowVersion
        $CurrentSettings.'Get-Response'.PortNumber = $PortNumber

        if ($clear) {
            $CurrentSettings.'Get-Response' = $null
        }

        Write-Verbose "Default Get-CardResponse settings updated."
        Set-CardSetting -Settings $CurrentSettings
    }

}

