#Requires -Module MvRAdaptiveCards

#Test Open url dialog action with fallback
New-AdaptiveCard {
    New-CardTextBlock -Text "Open URL Dialog Action Test" -Size Large -Weight Bolder -Wrap
    New-CardActionSet -Actions {
        New-CardActionOpenUrlDialog -Title "Open Dialog" -Url "https://adaptivecards.io" -DialogTitle "Dialog Test" -Fallback {
            New-CardTextBlock -Text "OpenUrlDialog action not supported." -Size Medium -Weight Bolder -Wrap
        }
        New-CardActionSubmit -Title "Close"
    }
} | Get-CardResponse -ViewMethod EdgeApp -AutoSize


New-AdaptiveCard {
    New-CardActionSet -Actions {
        New-CardActionOpenUrlDialog -Url "https://www.example.com" -Title "Open Example.com" -Fallback {
            New-CardTextBlock -Text "This action is not supported." -Size Medium -Weight Bolder -Wrap
        }
    }
    New-CardActionSet -Actions {
        New-CardActionSubmit -Title "Close"
    }
} | Get-CardResponse


