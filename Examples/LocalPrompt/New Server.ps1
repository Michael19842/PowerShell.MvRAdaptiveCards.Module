#Requires -Module MvRAdaptiveCards

#This example demonstrates how to create a more complex adaptive card that allows the user to set up a new server by providing necessary details.

New-AdaptiveCard {
    New-CardContainer -Style "Emphasis" -Content {
        New-CardTextBlock -Text "New Server Setup" -Size "Large" -Weight "Bolder" -Wrap
        New-CardTextBlock -Text "Please provide the details for the new server you wish to set up." -Wrap

        New-CardInputText -Id "ServerName" -Label "Server Name" -Placeholder "Enter server name" -IsRequired $true
        New-CardInputText -Id "IPAddress" -Label "IP Address" -Placeholder "Enter IP address" -IsRequired $true
        New-CardInputChoiceSet -Id "Environment" -Label "Environment" -IsRequired $true -Choices @{
            "Development" = "dev"
            "Staging"     = "staging"
            "Production"  = "prod"
        } -Style "Compact"

        New-CardInputToggle -Id "EnableMonitoring" -Title "Enable Monitoring" -ValueOn "true" -ValueOff "false" -Value "false"
    }
    New-CardIcon -Name Info
    New-CardRichTextBlock -Text "Please fill out the form below to set up a {{bold}}new server{{/bold}}."
    New-CardActionSet -Actions {
        New-CardActionSubmit -Title "Create Server" -Data @{ Action = "CreateServer" } -Style Positive
        New-CardActionSubmit -Title "Cancel" -Data @{ Action = "Cancel" }
    }
} | Get-CardResponse -ViewMethod EdgeApp -HideHeader -ShowTitle -AutoSize -CardTitle "New Server Setup"