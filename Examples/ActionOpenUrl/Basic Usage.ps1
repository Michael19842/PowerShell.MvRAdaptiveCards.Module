#Test Open url action with fallback
New-AdaptiveCard {
    New-CardTextBlock -Text "Open URL Dialog Action Test" -Size Large -Weight Bolder -Wrap
    New-CardActionSet -Actions {
        New-CardActionOpenUrl -Title "Open url" -Url "https://adaptivecards.io" -Fallback {
            New-CardTextBlock -Text "Open url action not supported." -Size Medium -Weight Bolder -Wrap
        }
        New-CardActionSubmit -Title "Close"
    }
} | Get-CardResponse -ViewMethod EdgeApp -AutoSize