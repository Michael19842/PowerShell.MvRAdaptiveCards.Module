# Release Notes

## 0.8.7
- Added `New-CardChartGauge` function to create gauge chart elements in adaptive cards.
- Added `Chart.Gauge` extension to support rendering of gauge charts using `Chart.js` within adaptive cards.

```PowerShell
## 0.8.6
- Added `New-CardCompoundButton` function to create compound button elements in adaptive cards.
- Added `CompoundButton` extension to support rendering of compound buttons within adaptive cards.
```PowerShell
New-AdaptiveCard {
    New-CardCompoundButton -Id "CompoundButton1" -Title "Compound Button" -Icon CallInbound -Description "This is a description for the compound button." -SelectAction { New-CardActionSubmit -Title "Confirm" } -Fallback {
        New-CardTextBlock -Text "Compound button not supported." -Size Medium -Weight Bolder -Wrap
    }
    New-CardActionSet -Actions {
        New-CardActionSubmit -Title "Submit"
    }
}  | Get-CardResponse -ViewMethod EdgeApp -AutoSize
```
- Removed Windows Forms view method from `Get-CardResponse` to streamline the module and focus on more modern rendering options. Users are encouraged to use the Browser or EdgeApp view methods for better compatibility and user experience. It was not implemented yet and it was not adding any value.
- Added `New-CardInputTime` function to create time input elements in adaptive cards.
- Added `New-CardInputNumber` function to create number input elements in adaptive cards.
- Added `New-CardInputDate` function to create date input elements in adaptive cards.
- Bugfix in `Get-CardResponse` to remove the `ResponseGuid` property from the returned response object. This property was intended for internal tracking and is not relevant to the end user.
- Added `-HideHeader` parameter to `Get-CardResponse` to allow users to hide the header section of the response window. This provides a cleaner look for certain use cases where the header is not needed.

```PowerShell
New-AdaptiveCard {
    New-CardTextBlock -Text "Hello, World!" -Size "Large"
} | Get-CardResponse -ViewMethod EdgeApp -AutoSize -HideHeader
```

## 0.8.5
- Improved the AutoSize functionality in `Get-CardResponse` to better handle dynamic content changes. The response window will now adjust its size more accurately when the content of the adaptive card changes after initial rendering.
- Refactored the `Get-CardResponse` function to enhance code readability and maintainability. This includes breaking down complex logic into smaller, more manageable functions and improving variable naming for clarity.

## 0.8.4
- Added a check in `Get-CardResponse` to ensure that the specified port is available before starting the local server. If the port is already in use, the function will now provide a clear error message and suggest using a different port.
- Added a mechanism in `Get-CardResponse` to test if the caller is the local machine. If the caller is not local, the function will respond with an error message indicating invalid request.
- Added logic to ignore any POST requests that do not contain valid JSON payloads in `Get-CardResponse`. This assures that only the intended requests are processed, enhancing security and stability.

## 0.8.3
- Bugfix in `Get-CardResponse` to properly release and close the TCP listener after handling a response. This prevents port conflicts on subsequent calls to the function.
- Improved Edge app window detection by implementing a polling mechanism to reliably find the correct Edge window associated with the adaptive card. This enhances the user experience when using the Edge app view method.
- Added check in `Get-CardResponse` to monitor the Edge app process status. If the Edge app window is closed by the user, the function will now gracefully handle the closure and terminate the waiting for a response.
- Added Autosize support form `Get-CardResponse` to allow the response window to automatically adjust its size based on the content of the adaptive card. This improves the visual presentation and usability of the response card.
    > Note: This feature is currently supported only in the Edge app view method.
    > Note: autosize uses JavaScript to dynamically adjust the window size which can result in slight delays when resizing the window initially. if you want to avoid this, you can set a fixed width and height using the `-Width` and `-Height` parameters.


## 0.8.2
- Moved to a 3 digit versioning scheme to align with industry standards. The version number now follows the Major.Minor.Patch format. (Build numbers will no longer be used because they were usually 0 and did not add any value).
- Added `FileList` and `CompatiblePSEditions` to the module manifest for better compatibility and module management.
- Fixed existing tests to not show a banner when running.

## 0.8.1.0
- Fixed issue with `Get-CardResponse` not closing the response window in certain scenarios. The window will now attempt to close itself after submission, and if embedded in an iframe, it will notify the parent window to close it.

## 0.8.0.0
- Added `New-CardProgressBar` function to create progress bar elements in adaptive cards.
- Added `Progress.Bar` extension to support rendering of progress bars within adaptive cards.

```PowerShell
New-AdaptiveCard {
    New-CardProgressBar -Value 70 -Max 100 -Title "Task Progress" -Color "Accent"
} -Actions {
    New-CardActionSubmit -Title "Close"
} | Get-CardResponse
```

- Added `-ViewMethod` parameter to `Get-CardResponse` to allow users to specify how the response card is displayed. Options include "Browser", "EdgeApp". The edge app provides a more integrated experience on Windows systems.
```PowerShell
New-AdaptiveCard {
    New-CardTextBlock -Text "Hello, World!" -Size "Large"
} | Get-CardResponse -ViewMethod EdgeApp
```

- Added `New-CardColumnSet` function to create column set elements in adaptive cards.
- Added `New-CardColumn` function to define individual columns within a column set.
- Added diverse tests raising code coverage to 55%. (I will keep working on this in future releases)


## 0.7.3.0
- Added addition tests for diverse functions to improve code coverage and ensure stability.
- Added `New-CardChartDonut` function to create donut chart elements in adaptive cards.
- Added `Chart.Donut` extension to support rendering of donut charts using `Chart.js` within adaptive cards.

```PowerShell
New-AdaptiveCard {
    New-CardChartDonut -Data @(
        @{ label = "Product A"; value = 40; color = "#4CAF50" }
        @{ label = "Product B"; value = 30; color = "#FF9800" }
        @{ label = "Product C"; value = 20; color = "#F44336" }
        @{ label = "Product D"; value = 10; color = "#2196F3" }
    ) -Title "Sales Distribution"
} -Actions {
    New-CardActionSubmit -Title "Close"
} | Get-CardResponse
```

## 0.7.1.0
- Fixed the issue where VSCode kept treating variables as errors in CSS blocks.
- Fixed `New-CardInputRating` to correctly handle the `-Max` parameter for setting the maximum rating value.
- Added a default fallback to the settings file to create a fallback for each element if no settings are found.
- Updated the loading of the module to detect if it was auto-loaded or explicitly imported. The banner will only show when explicitly imported in an interactive session. (Its a nice banner, but can negatively impact the user experience if it shows up all the time when auto-loaded). You can still suppress it with the `-NoBanner` parameter. If you want to see the banner, import the module with using `Import-Module MvRAdaptiveCards -NoBanner:$false`.
- Added codecoverage reporting to the build process. The build script now runs Pester with code coverage enabled and generates a code coverage summary report after tests are executed. (currently at 44%)
- Updated documentation for `Set-CardDefaultFallback` to include information about the new default fallback settings.
- Added tests for functions to improve sollution stability and reliability.
- Added bugfix for `New-CardRichTextBlock` to throw an error when a closing tag is missing in the input text.

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
- Added default fallback support in `New-AdaptiveCard` to use a default fallback defined in settings if no fallback is provided for elements.

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
