New-AdaptiveCard {
    New-CardBadge -Text "Basic Badge" -Appearance 'Filled' -Style Accent -Fallback {
        New-CardTextBlock -Text "Badge not supported." -Size Medium -Weight Bolder -Wrap
    }
    New-CardActionSet -Actions {
        New-CardActionSubmit -Title "Submit"
    }
} | Get-ACR