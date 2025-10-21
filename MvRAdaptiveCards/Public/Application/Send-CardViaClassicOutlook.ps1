function Send-CardViaClassicOutlook {
    [system.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'The parameters are used in the html body')]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true, valueFromPipeline = $true)]
        [string]$CardJson,

        [Parameter(Mandatory = $true)]
        [string]$To,

        [Parameter(Mandatory = $true)]
        [string]$Subject

    )

    process {

        # Create the Outlook Application COM object
        $outlook = New-Object -ComObject Outlook.Application
        $mail = $outlook.CreateItem(0) # 0: Mail item

        # Set email properties
        $mail.To = $To
        $mail.Subject = $Subject

        # Create the HTML body with the Adaptive Card JSON embedded
        $HtmlTemplate = Get-Content -Path "$PSScriptRoot\Templates\HtmlTemplate.html" -Raw
        $HtmlBody = $ExecutionContext.InvokeCommand.ExpandString($HtmlTemplate)
        $mail.HTMLBody = $HtmlBody

        # Send the email
        if ($PSCmdlet.ShouldProcess("Send email to $To with subject '$Subject'")) {
            $mail.Send()
        }
    }
}