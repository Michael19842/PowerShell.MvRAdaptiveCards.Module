#This example replicate the example listed on the Adaptive Cards documentation for collapsible designs

New-AdaptiveCard {
    New-CardContainer -Bleed -BackgroundImage {
        New-CardBackgroundImage -Url "https://raw.githubusercontent.com/OfficeDev/Microsoft-Teams-Adaptive-Card-Samples/refs/heads/Suz-StarterCardsSetThree/samples/simple-event/assets/eventHero.png" -VerticalAlignment Center
    } -MinHeight 200 -VerticalContentAlignment Bottom -Content {
        New-CardTextBlock -Text "NOVEMBER" -Size Large -Color Light -Wrap
        New-CardTextBlock -Text "04" -Size ExtraLarge -Color Light -Wrap -Weight Bolder
    } -TargetWidth atleast:Narrow

    New-CardContainer -Content {
        New-CardTextBlock -Text "Annual Company Meeting" -Size ExtraLarge -Weight Bolder -Wrap
        New-CardTextBlock -Text "Join us for our annual company meeting where we will discuss the year's achievements and future plans." -Wrap -Spacing Small

        New-CardFactSet -Facts @{
            "Date"     = "November 4, 2023"
            "Time"     = "10:00 AM - 2:00 PM"
            "Location" = "Main Conference Hall"
        } -Spacing Medium

        New-CardActionSet -Actions {
            New-CardActionShowCard -Title "Reserve a seat" -Style Positive -Card {
                New-AdaptiveCard {
                    New-CardInputText -Id "name" -Placeholder "Enter your full name" -Label "Name" -IsRequired
                    New-CardInputText -Id "email" -Placeholder "Enter your email address" -Label "Email address" -IsRequired
                    New-CardActionSet -Actions {
                        New-CardActionSubmit -Title "Submit" -Style Positive
                    }
                } -AsObject
            }
        }
    }
}  |  Get-CardResponse -ViewMethod EdgeApp -AutoSize -HideHeader

#Test online designer

New-AdaptiveCard {
    New-CardContainer -Content {
        New-CardTextBlock -Text "Hello, Adaptive Cards!" -Size Large -Weight Bolder
        New-CardImageSet -Images {
            New-CardImage -Url "https://adaptivecards.io/content/cats/1.png" -AltText "Cat 1"
            New-CardImage -Url "https://adaptivecards.io/content/cats/2.png" -AltText "Cat 2"
            New-CardImage -Url "https://adaptivecards.io/content/cats/3.png" -AltText "Cat 3"
        } -ImageSize Medium -Spacing Medium
    }
} | Send-CardViaTeams


New-AdaptiveCard {
    New-CardContainer -Bleed -BackgroundImage {
        New-CardBackgroundImage -Url "https://raw.githubusercontent.com/OfficeDev/Microsoft-Teams-Adaptive-Card-Samples/refs/heads/Suz-StarterCardsSetThree/samples/simple-event/assets/eventHero.png" -VerticalAlignment Center
    } -MinHeight 200 -VerticalContentAlignment Bottom -Content {
        New-CardTextBlock -Text "NOVEMBER" -Size Large -Color Light -Wrap
        New-CardTextBlock -Text "04" -Size ExtraLarge -Color Light -Wrap -Weight Bolder
    } -TargetWidth atleast:Narrow

    New-CardContainer -Content {
        New-CardTextBlock -Text "Annual Company Meeting" -Size ExtraLarge -Weight Bolder -Wrap
        New-CardTextBlock -Text "Join us for our annual company meeting where we will discuss the year's achievements and future plans." -Wrap -Spacing Small

        New-CardFactSet -Facts @{
            "Date"     = "November 4, 2023"
            "Time"     = "10:00 AM - 2:00 PM"
            "Location" = "Main Conference Hall"
        } -Spacing Medium

        New-CardActionSet -Actions {
            New-CardActionShowCard -Title "Reserve a seat" -Style Positive -Card {
                New-AdaptiveCard {
                    New-CardInputText -Id "name" -Placeholder "Enter your full name" -Label "Name" -IsRequired
                    New-CardInputText -Id "email" -Placeholder "Enter your email address" -Label "Email address" -IsRequired
                    New-CardActionSet -Actions {
                        New-CardActionSubmit -Title "Submit" -Style Positive
                    }
                } -AsObject
            }
        }
    }
} | Send-CardViaTeams