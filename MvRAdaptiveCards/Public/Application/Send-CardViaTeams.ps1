function Send-CardViaTeams {
    [system.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Teams is always plural')]
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([void])]
    param (
        [Parameter(Mandatory = $true)]
        [string]$CardJson,

        [Parameter(Mandatory = $false)]
        [string]$WebhookUrl = 'default'
    )

    #If the WebhookUrl is set to default, check for module settings
    if ($WebhookUrl -eq 'default' -and $script:Settings.Teams.WebhookUrl) {
        $WebhookUrl = $script:Settings.Teams.WebhookUrl
    }
    elseif ($WebhookUrl -eq 'default' -and -not $script:Settings.Teams.WebhookUrl) {
        throw "No WebhookUrl provided and no default found in module settings."
    }

    # Create the payload for the Teams message
    $Payload = @{
        type        = "message"
        attachments = @(
            @{
                contentType = "application/vnd.microsoft.card.adaptive"
                content     = $CardJson
            }
        )
    }

    # Send the message to the Teams webhook
    if ($PSCmdlet.ShouldProcess("Send message to Teams webhook at $WebhookUrl")) {
        Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body ($Payload | ConvertTo-Json -Depth 5) -ContentType "application/json"
    }
}