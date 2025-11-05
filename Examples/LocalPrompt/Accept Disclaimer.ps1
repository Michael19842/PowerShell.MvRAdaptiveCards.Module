#Requires -Module MvRAdaptiveCards

#This example demonstrates how to create a simple adaptive card that prompts the user to accept a disclaimer before proceeding.
$Response = $null

$Facts = @{
    "1:" = "You accept all risks associated with using this application."
    "2:" = "You agree not to hold the developers liable for any damages."
    "3:" = "You will comply with all applicable laws and regulations."
}

$RidiculeAdditionalFacts = @{
    "4:"  = "You agree to wear a silly hat while using the application."
    "5:"  = "You promise to tell a joke every hour."
    "6:"  = "You will sing the national anthem before starting the application."
    "7:"  = "You agree to dance for at least 30 seconds after each use."
    "8:"  = "You will refer to the developers as 'Your Majesties' at all times."
    "9:"  = "You agree to host a weekly comedy night for the development team."
    "10:" = "You will wear a clown nose during all video calls with the team."
}


while ($Response.Accepted -ne $true) {
    try {
        $Response = New-AdaptiveCard {
            New-CardContainer -Style "Emphasis" -Content {
                New-CardTextBlock -Text "Disclaimer" -Size "Large" -Weight "Bolder" -Wrap
                New-CardTextBlock -Text "By proceeding, you agree to the terms and conditions outlined in this disclaimer. Please read them carefully before accepting." -Wrap
                New-CardFactSet -Facts $Facts -Spacing Medium
            }
            New-CardActionSet -Actions {
                New-CardActionSubmit -Title "Accept" -Data @{ Accepted = $true } -Style Positive
                New-CardActionSubmit -Title "Decline" -Data @{ Accepted = $false }
            }
        } | Get-CardResponse -ViewMethod EdgeApp -HideHeader -ShowTitle -AutoSize -CardTitle "Disclaimer Acceptance"

    }
    catch {
        Write-Host "The user closed the window without responding."
    }

    if ($Response.Accepted -ne $true) {
        Write-Host "You must accept the disclaimer to proceed." -ForegroundColor Red

        #Optional: Add some humor by the next additional ridiculous terms
        $AdditionalTermKey = $RidiculeAdditionalFacts.Keys | Where-Object { -not $Facts.ContainsKey($_) } | Select-Object -First 1
        if ($AdditionalTermKey) {
            $Facts[$AdditionalTermKey] = $RidiculeAdditionalFacts[$AdditionalTermKey]
        }
    }
}