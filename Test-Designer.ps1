New-AdaptiveCard {
    New-CardImage -Url "https://images.pexels.com/photos/1563356/pexels-photo-1563356.jpeg?cs=srgb&dl=pexels-thatguycraig000-1563356.jpg&fm=jpg" -AltText "Example Image" -Id "Monkey"
    New-CardTable -Collection @(
        @{Name = "Michael"; Age = 41; EyeColor = "Blue" }, 
        @{Name = "Merel"; Age = 39; EyeColor = "Green" },
        @{Name = "Roan"; Age = 8; EyeColor = "Brown" }
    ) -NoHeader -CustomColums @(@{Name = "Name"; width = 2 }, @{Name = "Age"; width = 1 }, @{Name = "EyeColor"; width = 2 })
    New-CardActionSet -Actions {
        New-CardActionToggleVisibility -Title "Toggle Monkey Image" -TargetElements @("Monkey")
        New-CardActionShowCard -Title "show details" -Card {
            New-AdaptiveCard -AsObject -Content  { Build-CardFromTemplate -Content $Template -Tags @{
                    UserName  = 'Michael'
                    UserImage = { New-CardImage -Url "https://images.pexels.com/photos/1563356/pexels-photo-1563356.jpeg?cs=srgb&dl=pexels-thatguycraig000-1563356.jpg&fm=jpg" -AltText "Example Image" }
                }  
            } 
        }
        New-CardActionShowCard -Title "show monkeys" -Style positive -Card {
            New-AdaptiveCard -AsObject -Content  { Build-CardFromTemplate -Content $Template -Tags @{
                    UserName  = 'Michael'
                }  
            } 
        }
    }
} | Out-OnlineDesigner







New-AdaptiveCard -Content {
     New-CardContainer -Content {
         New-CardFactSet -Facts @{Michael = 'Geweldig'; Merel = 'leuk'}
     } -Style 'Good'
     New-CardImage -Url "https://images.pexels.com/photos/1563356/pexels-photo-1563356.jpeg?cs=srgb&dl=pexels-thatguycraig000-1563356.jpg&fm=jpg" -AltText "Example Image" -Id "Monkey"

     New-CardActionSet -Actions {
            New-CardActionToggleVisibility -Title "Toggle Monkey Image" -TargetElements @("Monkey")
        }

} | Out-OnlineDesigner 


$Template =  New-CardContainer -Content {
         New-CardFactSet -Facts @{Michael = '!{{Whatever}}'; Merel = 'leuk'} -Id 'Muis'
         New-CardImage -Url "https://adaptivecards.io/content/cats/1.png" -AltText "Example Image" -Id "Monkey"
         New-CardTemplateTag -TagName "Buttons"
     } -Style 'Good'


Find-CardTemplateTags -Content $Template


New-AdaptiveCard -Content {
    Build-CardFromTemplate -Content $Template -Tags @{
        Whatever = 'Fantastisch'
        Buttons  = {
            New-CardActionSet -Actions {
                New-CardActionToggleVisibility -Title "Toggle Monkey Image" -TargetElements @("Monkey")
            }
        }
    }
} | Send-CardViaClassicOutlook -To 'michael.vanrooijen@outlook.com' -Subject 'Adaptive Card Test Email'


New-AdaptiveCard -Content {
    Build-CardFromTemplate -Content $Template -Tags @{
        Whatever = 'Fantastisch'
        Buttons  = {
            New-CardActionSet -Actions {
                New-CardActionToggleVisibility -Title "Toggle Monkey Image" -TargetElements @("Monkey")
            }
        }
    }
} | Out-OnlineDesigner