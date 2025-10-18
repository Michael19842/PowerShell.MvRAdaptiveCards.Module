function Send-CardViaEmail {

    param (
        [Parameter(Mandatory = $true)]
        [string]$To,
        
        [Parameter(Mandatory = $true)]
        [string]$Subject,

        [Parameter(Mandatory = $true)]
        [string]$CardJson,
        
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
    if ($SmtpServer -eq 'default' -and $script:Settings.Email.SmtpServer) {
        $SmtpServer = $script:Settings.Email.SmtpServer
        $SmtpPort = $script:Settings.Email.SmtpPort

        if ($script:Settings.Email.From -and -not $From) {
            $From = $script:Settings.Email.From
        }

        if ($script:Settings.Email.SmtpUsername) {  
            $SmtpUsername = $script:Settings.Email.SmtpUsername
        }
        if ($script:Settings.Email.SmtpPassword) {
            $SmtpPassword = $script:Settings.Email.SmtpPassword
        }
    }

    #Get the HTML template
    $HtmlTemplatePath = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath 'HtmlTemplate.html'
    $HtmlTemplate = Get-Content -Path $HtmlTemplatePath -Raw    

    $HtmlTemplate = $ExecutionContext.InvokeCommand.ExpandString($HtmlTemplate)
    
    # Create a new MailMessage object
    $mailMessage = New-Object System.Net.Mail.MailMessage
    $mailMessage.From = $From
    $mailMessage.To.Add($To)
    $mailMessage.Subject = $Subject
    $mailMessage.IsBodyHtml = $true

    # Create a new SmtpClient object
    $smtpClient = New-Object System.Net.Mail.SmtpClient($SmtpServer, $SmtpPort) 

    # Create the HTML body with the Adaptive Card JSON embedded
    $mailMessage.Body = $HtmlTemplate

    if ($SmtpUsername -and $SmtpPassword) {
        $smtpClient.Credentials = New-Object System.Net.NetworkCredential($SmtpUsername, $SmtpPassword)
    }
    # Send the email
    $smtpClient.Send($mailMessage)
    
}