function Send-CardViaSMTP {

    param (
        [Parameter(Mandatory = $true, valueFromPipeline = $true)]
        [string]$CardJson,

        [Parameter(Mandatory = $true)]
        [string]$To,
        
        [Parameter(Mandatory = $true)]
        [string]$Subject,
        
        [Parameter(Mandatory = $false)]
        [string]$From,

        [Parameter(Mandatory = $false)]
        [string]$SmtpServer = 'default',

        [Parameter(Mandatory = $false)]
        [int]$SmtpPort = 25,

        [Parameter(Mandatory = $false)]
        [string]$SmtpUsername,

        [Parameter(Mandatory = $false)]
        [securestring]$SmtpPassword

    )

    #If the SMTPServer is set to default, check for module settings
    if ($SmtpServer -eq 'default' -and $_MvRACSettings.Smtp.Server) {
        $SmtpServer = $_MvRACSettings.Smtp.Server
        $SmtpPort = $_MvRACSettings.Smtp.Port

        if ($_MvRACSettings.Smtp.From -and -not $From) {
            $From = $_MvRACSettings.Smtp.From
        }

        if ($_MvRACSettings.Smtp.Username) {
            $SmtpUsername = $_MvRACSettings.Smtp.Username
        }
        if ($_MvRACSettings.Smtp.Password) {
            $SmtpPassword = ConvertTo-SecureString -String $_MvRACSettings.Smtp.Password
        }
    }

    #If Smtp is Gmail trow a warning that script tags are not supported
    if ($SmtpServer -like 'smtp.gmail.com*') {
        Write-Warning "Gmail does not support script tags in Adaptive Cards. The card may not render correctly in Gmail clients."
    }

    #Get the HTML template
    $HtmlTemplate = Get-Content -Path "$PSScriptRoot\HtmlTemplate.html" -Raw    

    $HtmlBody= $ExecutionContext.InvokeCommand.ExpandString($HtmlTemplate)
    
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
    $smtpClient.Send($mailMessage)
    
}