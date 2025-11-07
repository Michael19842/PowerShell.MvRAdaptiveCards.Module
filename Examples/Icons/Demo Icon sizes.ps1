#Requires -Modules MvRAdaptiveCards

#This demo shows the different icon sizes available in Adaptive Cards
$iconSizes = @("xxSmall", "xSmall", "Small", "Standard", "Medium", "Large", "xLarge", "xxLarge")

New-AdaptiveCard {
    New-CardContainer  {
        foreach ($size in $iconSizes) {
            New-CardIcon -Name HomeHeart -Size $size -Color "Accent" -Spacing "Small"
        }
    }
} | Get-CardResponse -ViewMethod EdgeApp -AutoSize