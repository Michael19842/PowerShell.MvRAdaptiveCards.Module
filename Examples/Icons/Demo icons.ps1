#Requires -Module MvRAdaptiveCards

# This example demonstrates icons available in MvRAdaptiveCards by creating a set of icons with different names, colors, sizes, and styles.


New-AdaptiveCard {
    New-CardTextBlock -Text "Demo Icons" -Size "Large" -Weight "Bolder" -Wrap
    New-CardTextBlock -Text "This example showcases various Fluent UI icons available
    in MvRAdaptiveCards with different colors, sizes, and styles." -Wrap

    New-CardContainer -Style "Emphasis" -Layouts { New-CardLayoutFlow } -Content {

        $IconNames = @(
            "BookClock", "TextboxAlignTop"
        )

        $Colors = @("Default", "Light", "Accent", "Good", "Warning", "Attention")
        $Styles = @("Regular", "Filled")

        foreach ($iconName in $IconNames) {
            foreach ($color in $Colors) {
                foreach ($style in $Styles) {
                    New-CardIcon -Name $iconName -Color $color -Style $style -Spacing "Small"
                }
            }
        }
    }
} | Get-CardResponse -ViewMethod EdgeApp -AutoSize