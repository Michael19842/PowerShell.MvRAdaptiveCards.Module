#Requires -Module MvRAdaptiveCards

#Itterate through the available badge styles and color combinations to display examples of each.
$BadgeStyles = @("Default", "Subtle", "Informative", "Accent", "Good", "Attention", "Warning")
$BadgeAppearances = @("Filled", "Tint")


New-AdaptiveCard {
    New-CardContainer -Style "Emphasis" -Content {
        New-CardTextBlock -Text "Badge Styles Example" -Size "Large" -Weight "Bolder" -Wrap
        New-CardTextBlock -Text "This example showcases various badge styles and color combinations available in MvRAdaptiveCards." -Wrap

        foreach ($style in $BadgeStyles) {
            foreach ($appearance in $BadgeAppearances) {
                New-CardContainer -Style "Default" -Content {
                    New-CardTextBlock -Text "Style: $style, Tint: $appearance" -Weight "Bolder" -Size "Small" -Wrap
                    New-CardBadge -Text "$style - $appearance" -Style $style -Appearance $appearance
                    New-CardBadge -Text "$style - $appearance" -Style $style -Appearance $appearance -Shape Square
                    #Get a random icon from the available icons for demonstration
                    $Icons = @(
                        "PanelTop", "Search", "SearchInfo", "SearchSettings", "SearchShield", "SearchSquare", "SearchVisual", "Settings", "SettingsChatVideo", "SettingsCogMultiple", "SidebarSearchLtr", "SidebarSearchRtl", "Slide", "SlideAdd", "SlideArrowRight", "SlideDesign", "SlideErase", "SlideGrid", "SlideHide", "SlideLayout", "SlideMicrophone", "SlideMultiple", "SlideMultipleArrowRight", "SlideMultipleSearch", "SlideRecord", "SlideSearch", "SlideSettings", "SlideSize", "SlideText", "SlideTransition", "Tab", "TabAdd", "TabArrowLeft", "TabDesktop", "TabDesktopArrowClockwise", "TabDesktopArrowCounterClockwise", "TabDesktopBottom", "TabDesktopClock", "TabDesktopCopy", "TabDesktopImage", "TabDesktopMultiple", "TabDesktopMultipleBottom", "TabDesktopNewPage", "TabInPrivate", "TabInprivateAccount", "TabNew", "TabProhibited", "TabSweep", "TabTrackingPrevention", "Target", "TargetArrow", "TargetEdit", "WindowAd", "WindowAdOff", "WindowAdPerson", "WindowApps", "WindowArrowUp"
                    )
                    $RandomIcon = Get-Random -InputObject $Icons
                    New-CardBadge -Text "$style - $appearance with Icon" -Style $style -Appearance $appearance -Icon $RandomIcon

                } -Spacing "Medium"
            }
        }
    }
} | Get-CardResponse -ViewMethod EdgeApp -AutoSize