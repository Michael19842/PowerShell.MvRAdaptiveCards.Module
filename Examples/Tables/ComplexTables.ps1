#Requires -Module MvRAdaptiveCards

#This demo shows a complex table in an adaptive cards where cells contain scriptblocks to create more complex content

$MyComplexTable = @(
    [PSCustomObject]@{
        Name       = { New-CardTextBlock -Text "John Doe" -Weight "Bolder" }
        Age        = { New-CardTextBlock -Text "29" }
        Occupation = {
            New-CardContainer -Content {
                New-CardTextBlock -Text "Engineer"
                New-CardImage -Url "https://adaptivecards.io/content/cats/1.png" -Size "Small" -Spacing "Small"
            }
        }
    }
    [PSCustomObject]@{
        Name       = { New-CardTextBlock -Text "Jane Smith" -Weight "Bolder" }
        Age        = { New-CardTextBlock -Text "34" }
        Occupation = {
            New-CardContainer -Content {
                New-CardTextBlock -Text "Designer"
                New-CardImage -Url "https://adaptivecards.io/content/cats/2.png" -Size "Small" -Spacing "Small"
            }
        }
    }
    [PSCustomObject]@{
        Name       = { New-CardTextBlock -Text "Sam Brown" -Weight "Bolder" }
        Age        = { New-CardTextBlock -Text "42" }
        Occupation = {
            New-CardContainer -Content {
                New-CardTextBlock -Text "Manager"
                New-CardImage -Url "https://adaptivecards.io/content/cats/3.png" -Size "Small" -Spacing "Small"
            }
        }
    }
)

#This demo shows a complex table in an adaptive card
New-AdaptiveCard {
    New-CardContainer {
        New-CardTextBlock -Text "Complex Table Example" -Weight "Bolder" -Size "Medium" -Spacing "Large"
        New-CardTable -Collection $MyComplexTable
    }
} | Get-CardResponse -ViewMethod EdgeApp -AutoSize