# Release Notes

# 0.6.12.1
- Fixed race condition in `Get-CardResponse` when handling responses. This would sometimes cause fetch errors.
- Switched to port 8081 for local response server in `Get-CardResponse` to avoid conflicts with other services. (i will make this configurable in a future release)

## 0.6.12.0
- Started with release notes!
- Added `-Layouts` parameter to `New-CardContainer` to support layout containers.
- Added CSS styles for layout containers to improve rendering.
- Added functions for creating layout areas `New-CardLayoutAreaGrid`, `New-CardLayoutAreaFlow`, and `New-CardLayoutAreaWrap`.
- Added Style support for Badges `-style`, `-appearances` parameter in `New-CardBadge`.
- Added icon support for Badges `-icon` parameter in `New-CardBadge`.

See the demo of badges and layout containers in the updated PromptCard template.

```PowerShell
New-AdaptiveCard {
    #Generate a list of all badge styles filled and tint
    $BadgeAppearances = @("Filled", "Tint")
    $BadgeStyles = @("Default", "Subtle", "Informative", "Accent", "Good", "Attention", "Warning")

    foreach ($Appearance in $BadgeAppearances) {
        New-CardContainer {
            foreach ($Style in $BadgeStyles) {
                New-CardBadge -Text "$Appearance - $Style" -Style $Style -Appearance $Appearance
            }
        } -Layouts { New-CardLayoutFlow -HorizontalItemsAlignment Left -ColumnSpacing Medium }
    }
} -Actions {
    New-CardActionSubmit -Title "Close"
} |  Get-CardResponse
```
