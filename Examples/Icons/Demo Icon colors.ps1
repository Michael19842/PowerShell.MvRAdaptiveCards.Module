#This demo shows the different icon colors available in Adaptive Cards
#Requires -Modules MvRAdaptiveCards

$iconColors = @("Default", "Dark", "Light", "Accent", "Good", "Warning", "Attention")

New-AdaptiveCard {
    New-CardContainer {
        foreach ($color in $iconColors) {
            New-CardColumnSet -Columns {
                New-CardColumn -Width "Auto" -Content {
                    New-CardIcon -Name HomeHeart -Color $color -Size "Standard" -Spacing "Small"
                }
                New-CardColumn -Width "Stretch" -Content {
                    New-CardTextBlock -Text $color -Weight "Bolder" -Size "Medium" -Spacing "Medium"
                } -Spacing "Medium" -verticalContentAlignment "Center"
            } -Spacing "Small"
        }
    }
} | Get-CardResponse -ViewMethod EdgeApp -AutoSize