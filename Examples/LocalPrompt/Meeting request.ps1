#requires -Module MvRAdaptiveCards

# Prompt the user with a meeting request adaptive card and capture their response
$MeetingResponse = New-AdaptiveCard {
    New-CardContainer -Content {
        New-CardTextBlock -Text "Meeting Request" -Size ExtraLarge -Weight Bolder -Wrap
        New-CardTextBlock -Text "You are invited to the Annual Company Meeting." -Wrap -Spacing Small
        New-CardFactSet -Facts @{
            "Date"     = "November 4, 2023"
            "Time"     = "10:00 AM - 2:00 PM"
            "Location" = "Main Conference Hall"
        } -Spacing Medium
    }
    New-CardActionSet -Actions {
        New-CardActionShowCard -Title "Attend" -Style Positive -Card {
            New-AdaptiveCard {
                New-CardInputText -Id "name" -Placeholder "Enter your full name" -Label "Name" -IsRequired $true
                New-CardInputText -Id "email" -Placeholder "Enter your email address" -Label "Email address" -IsRequired $true
                New-CardActionSet -Actions {
                    New-CardActionSubmit -Title "Submit" -Style Positive
                }
            } -AsObject
        }
        New-CardActionSubmit -Title "Decline" -Style Destructive -Data @{ response = "decline" }

    }
} | Get-CardResponse -ViewMethod EdgeApp -AutoSize -HideHeader


#Output the meeting response
Write-Host "Meeting Response:"

if ($MeetingResponse.Response -eq 'Decline') {
    Write-Host "No response received."
}
else {
    Write-Host "$($MeetingResponse.name) has accepted the meeting invitation with email $($MeetingResponse.email)."
}