<#
.SYNOPSIS
    Creates a new Image element for an Adaptive Card.

.DESCRIPTION
    The New-CardImage function creates an Image element that displays images in an Adaptive Card.
    It supports various sizing options, fit modes, and accessibility features to ensure proper
    image display across different devices and platforms.

.PARAMETER Url
    The URL of the image to display. Supports both HTTP/HTTPS URLs and data URLs.
    The image should be accessible by the client application displaying the Adaptive Card.

.PARAMETER AltText
    Alternative text for the image, used for accessibility purposes. This text is read by
    screen readers and displayed when the image cannot be loaded. Should describe the content
    or purpose of the image.

.PARAMETER FitMode
    Specifies how the image should be fitted within its allocated space. Valid values are:
    - Cover: Scale the image to cover the entire area, may crop parts of the image
    - Contain: Scale the image to fit completely within the area, may leave empty space
    - Fill: Stretch the image to fill the entire area, may distort the image proportions

.PARAMETER Size
    The size of the image. Valid values are:
    - Auto: Automatic sizing based on the image's natural dimensions
    - Stretch: Stretch to fill available width
    - Small: Small fixed size
    - Medium: Medium fixed size
    - Large: Large fixed size

.PARAMETER Id
    An optional unique identifier for the Image element. Useful for referencing the image
    in actions like toggle visibility or for accessibility purposes.

.PARAMETER Separator
    A switch parameter that adds a separator line above the image element. Useful for
    visually separating the image from preceding elements.

.PARAMETER AllowExpand
    A switch parameter that allows the image to be expanded when clicked/tapped.
    When enabled, users can interact with the image to view it in a larger format.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the Image element structure for the Adaptive Card.

.EXAMPLE
    New-CardImage -Url "https://example.com/logo.png" -AltText "Company Logo"

    Creates a basic image element with a URL and alt text.

.EXAMPLE
    New-CardImage -Url "https://example.com/photo.jpg" -AltText "Team Photo" -Size "Large" -FitMode "Cover"

    Creates a large image that covers its allocated space, potentially cropping parts of the image.

.EXAMPLE
    New-CardImage -Url "https://example.com/chart.png" -AltText "Sales Chart" -Id "SalesChart" -AllowExpand -Separator

    Creates an expandable image with a separator line above it and an ID for reference in actions.

.EXAMPLE
    New-CardImage -Url "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==" -AltText "Red pixel" -Size "Small"

    Creates a small image using a data URL (base64 encoded image).

.NOTES
    - The Url parameter should point to an accessible image resource
    - AltText is crucial for accessibility and should meaningfully describe the image
    - FitMode and Size parameters work together to control image appearance
    - AllowExpand provides interactive image viewing capabilities
    - The Separator parameter helps with visual organization of card elements
    - Data URLs are supported for embedding small images directly in the card

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#image
#>
function New-CardImage {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param(
        [string]$Url,
        [string]$AltText,
        [ValidateSet("Cover", "Contain", "Fill")]
        [string]$FitMode,
        [ValidateSet("Auto", "Stretch", "Small", "Medium", "Large")]
        [string]$Size,
        [string]
        [Parameter(Mandatory = $false)]
        $Id,
        [switch]$Separator,
        [switch]$AllowExpand,
        [switch]$AsBase64

    )

    $Image = @{
        type    = "Image"
        url     = $Url
        altText = $AltText
    }

    if ( $AsBase64 ) {
        #Download the image and convert to base64
        $WebClient = New-Object System.Net.WebClient
        $ImageBytes = $WebClient.DownloadData($Url)
        $Base64String = [Convert]::ToBase64String($ImageBytes)

        $Image.url = "data:image/png;base64,$Base64String"
    }

    if ($Separator) {
        $Image.separator = $true
    }

    if ($FitMode) {
        $Image.fitMode = $FitMode
    }

    if ($Id) {
        $Image.id = $Id
    }

    if ($Size) {
        $Image.size = $Size
    }

    if ($AllowExpand) {
        $Image.allowExpand = $true
    }
    if ( $PSCmdlet.ShouldProcess("Creating Image element with URL '$Url'." ) ) {
        return $Image
    }

}