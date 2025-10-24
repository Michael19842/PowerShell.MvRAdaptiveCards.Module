# Release Notes

## 0.7.0.0
- Added `Set-CardDefaultResponseSetting` function to set default settings for `Get-CardResponse`. This allows users to configure default title, logo text, version display, and port number for the response server.
- Updated `Get-CardResponse` to support new default settings for title, logo text, version display, and port number.
- Refactored settings management to ensure that changes made by `Set-CardDefaultResponseSetting` are reflected in `Get-CardResponse` without needing to restart the session.
- Added `New-CardMedia` function to create media elements in adaptive cards.
- Added support for audio and video playback in adaptive cards using `New-CardMedia`. With an additional extension for media playback controls.

```PowerShell
New-AdaptiveCard {
    New-CardMedia -Sources @(
        @{ mimeType = "video/mp4"; url = "https://www.example.com/video.mp4" }
        @{ mimeType = "audio/mpeg"; url = "https://www.example.com/audio.mp3" }
    ) -AltText "Sample Media"
} -Actions {
    New-CardActionSubmit -Title "Close"
} | Get-CardResponse
```

## 0.6.14.0
- Added support for `New-CardInputRating` to create rating input elements in adaptive cards.
- Added support for `New-CardCodeBlock` to create code block elements with syntax highlighting using Prism.js.
- Added CSS styles for code blocks to improve rendering and appearance. For both preview and prompt scenarios.
- Added `New-CardCarousel` function to create carousel elements in adaptive cards.
- Added `New-CardCarouselPage` function to define individual pages within a carousel.
- Added an extension for carousel in order to render input elements within carousel pages.
- Bug fix on `New-CardInputChoiceSet` to correctly add choices when using a hashtable for the `-Choices` parameter.

## 0.6.13.0
- Updated `-Choices` parameter in `New-CardInputChoiceSet` to accept a hashtable for easier choice definition.
- Added `New-CardInputToggle` function to create toggle input elements in adaptive cards.
- Added argument completer for the `-icon` parameter in `New-CardBadge` to support icon name completion.

```PowerShell
New-AdaptiveCard {
    New-CardInputToggle -Id "AcceptTerms" -Title "I accept the terms and conditions." -Value "true" -ValueOff "false" -IsRequired $true -Label "Terms and Conditions"
    New-CardActionSet -Actions {
        New-CardActionSubmit -Title "Submit"
    }
} | Get-CardResponse
```

## 0.6.12.1
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
