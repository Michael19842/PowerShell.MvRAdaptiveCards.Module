function Send-CardViaSMTP {
    [system.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'The parameters are used in the html body')]
    [system.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidDefaultValueForMandatoryParameter', '', Justification = 'it is acceptable to have default values for mandatory parameters in this context')]
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([void])]

    param (
        [Parameter(Mandatory = $true, valueFromPipeline = $true)]
        [string]$CardJson,

        [Parameter(Mandatory = $true)]
        [string]$To,

        [Parameter(Mandatory = $true)]
        [string]$Subject = "Adaptive Card via SMTP",

        [Parameter(Mandatory = $false)]
        [string]$From = $_MvRACSettings.Smtp.From,

        [Parameter(Mandatory = $false)]
        [string]$SmtpServer = $_MvRACSettings.Smtp.Server,

        [Parameter(Mandatory = $false)]
        [int]$SmtpPort = $_MvRACSettings.Smtp.Port,

        [Parameter(Mandatory = $false)]
        [string]$SmtpUsername = $_MvRACSettings.Smtp.Username,

        [Parameter(Mandatory = $false)]
        [securestring]$SmtpPassword = ($_MvRACSettings.Smtp.Password | ConvertTo-SecureString),

        [Parameter(Mandatory = $false)]
        [bool]$UseSsl = $_MvRACSettings.Smtp.UseSsl

    )

    process {
        #If Smtp is Gmail trow a warning that script tags are not supported
        if ($SmtpServer -like 'smtp.gmail.com*') {
            Write-Warning "Gmail does not support script tags in Adaptive Cards. The card may not render correctly in Gmail clients."
        }

        #Get the HTML template
        $HtmlTemplate = Get-Content -Path "$PSScriptRoot\Templates\HtmlTemplate.html" -Raw

        $HtmlBody = $ExecutionContext.InvokeCommand.ExpandString($HtmlTemplate)

        # Create a new MailMessage object
        $mailMessage = New-Object System.Net.Mail.MailMessage
        $mailMessage.From = $From
        $mailMessage.To.Add($To)
        $mailMessage.Subject = $Subject
        $mailMessage.IsBodyHtml = $true
        $mailMessage.Headers.Add("X-AdaptiveCard-Format", "json")

        # Create a new SmtpClient object
        $smtpClient = New-Object System.Net.Mail.SmtpClient($SmtpServer, $SmtpPort)

        # Create the HTML body with the Adaptive Card JSON embedded
        $mailMessage.Body = $HtmlBody

        if ($SmtpUsername -and $SmtpPassword) {
            $smtpClient.EnableSsl = $true
            $smtpClient.Credentials = New-Object System.Net.NetworkCredential($SmtpUsername, $SmtpPassword)
        }
        # Send the email
        if ( $PSCmdlet.ShouldProcess("Send email to $To with subject '$Subject' via SMTP server $($SmtpServer):$($SmtpPort)")) {
            $smtpClient.Send($mailMessage)
        }
    }
}