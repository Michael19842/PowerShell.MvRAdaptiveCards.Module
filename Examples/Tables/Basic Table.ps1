#Requires -Module MvRAdaptiveCards

#Use a sample collection of objects
$AnyCollection = @(
    [PSCustomObject]@{ Name = "John Doe"; Age = 29; Occupation = "Engineer" }
    [PSCustomObject]@{ Name = "Jane Smith"; Age = 34; Occupation = "Designer" }
    [PSCustomObject]@{ Name = "Sam Brown"; Age = 42; Occupation = "Manager" }
)

#This demo shows a basic table in an adaptive card
New-AdaptiveCard {
    New-CardContainer {
        New-CardTextBlock -Text "Basic Table Example" -Weight "Bolder" -Size "Medium" -Spacing "Large"
        New-CardTable -Collection $AnyCollection
    }
} | Get-CardResponse -ViewMethod EdgeApp -AutoSize


#Or use a any other collection, for example the PSVersionTable or a list of services
$AnyCollection = $PSVersionTable

#This demo shows a basic table in an adaptive card
New-AdaptiveCard {
    New-CardContainer {
        New-CardTextBlock -Text "PowerShell Version Table Example" -Weight "Bolder" -Size "Medium" -Spacing "Large"
        New-CardTable -Collection $AnyCollection
    }
} | Get-CardResponse -ViewMethod EdgeApp -AutoSize