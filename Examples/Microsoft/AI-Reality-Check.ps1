#This example replicate the example listed on the Adaptive Cards documentation for collapsible designs

New-AdaptiveCard {
    New-CardContainer -Bleed -BackgroundImage {
        New-CardBackgroundImage -Url "https://raw.githubusercontent.com/OfficeDev/Microsoft-Teams-Adaptive-Card-Samples/refs/heads/Suz-StarterCardsSetThree/samples/simple-event/assets/eventHero.png" -VerticalAlignment Center
    } -MinHeight 200 -VerticalContentAlignment Bottom -Content {
        New-CardTextBlock -Text "NOVEMBER" -Size Large -Color Light -Wrap
        New-CardTextBlock -Text "04" -Size ExtraLarge -Color Light -Wrap -Weight Bolder
    } -TargetWidth Narrow
    New-CardContainer -Bleed -BackgroundImage {
        New-CardBackgroundImage -Url "https://raw.githubusercontent.com/OfficeDev/Microsoft-Teams-Adaptive-Card-Samples/refs/heads/Suz-StarterCardsSetThree/samples/simple-event/assets/eventHero.png" -VerticalAlignment Center
    } -MinHeight 200 -VerticalContentAlignment Bottom -Content {
        New-CardTextBlock -Text "NOVEMBER" -Size Large -Color Light -Wrap
        New-CardTextBlock -Text "04" -Size ExtraLarge -Color Light -Wrap -Weight Bolder
    } -TargetWidth VeryNarrow
} | Get-CardResponse -ViewMethod EdgeApp -AutoSize -HideHeader





<#            "type": "ActionSet",
            "actions": [
                {
                    "type": "Action.ShowCard",
                    "card": {
                        "type": "AdaptiveCard",
                        "body": [
                            {
                                "type": "Input.Text",
                                "id": "name",
                                "placeholder": "Enter your full name",
                                "label": "Name",
                                "isRequired": true,
                                "errorMessage": "A name is required"
                            },
                            {
                                "type": "Input.Text",
                                "id": "email",
                                "placeholder": "Enter your email address",
                                "label": "Email address",
                                "isRequired": true,
                                "errorMessage": "An email is required"
                            },
                            {
                                "type": "ActionSet",
                                "actions": [
                                    {
                                        "type": "Action.Submit",
                                        "title": "Submit",
                                        "style": "positive"
                                    }
                                ]
                            }
                        ],
                        "$schema": "https://adaptivecards.io/schemas/adaptive-card.json",
                        "version": "1.5"
                    },
                    "title": "Reserve a seat",
                    "style": "positive"
                }
            ]
        }#>