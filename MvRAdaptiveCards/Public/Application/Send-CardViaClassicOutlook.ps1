function Send-CardViaClassicOutlook {
    param (
        [Parameter(Mandatory = $true, valueFromPipeline = $true)]
        [string]$CardJson,

        [Parameter(Mandatory = $true)]
        [string]$To,
        
        [Parameter(Mandatory = $true)]
        [string]$Subject       

    )

    # Create the Outlook Application COM object
    $outlook = New-Object -ComObject Outlook.Application
    $mail = $outlook.CreateItem(0) # 0: Mail item

    # Set email properties
    $mail.To = $To
    $mail.Subject = $Subject

    # Create the HTML body with the Adaptive Card JSON embedded
    $HtmlTemplate = Get-Content -Path "$PSScriptRoot\HtmlTemplate.html" -Raw    
    $HtmlBody= $ExecutionContext.InvokeCommand.ExpandString($HtmlTemplate)
    $mail.HTMLBody = $HtmlBody

    # Send the email
    $mail.Send()
}