# In this example, we create a basic Adaptive Card with a text block. Hello, World!

Import-Module MvRAdaptiveCards

New-AdaptiveCard {
    New-CardTextBlock -Text "Hello, World!"
}

#We can view this example card in the online designer using the Out-OnlineDesigner function

New-AdaptiveCard {
    New-CardTextBlock -Text "Hello, World!"
} | Out-OnlineDesigner

# Be aware that any additions in the designer will not be reflected in the PowerShell code.



