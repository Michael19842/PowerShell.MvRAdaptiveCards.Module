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

.PARAMETER BackgroundColor
    The background color to render behind the image. Accepts CSS color values and host color resources.

.PARAMETER Height
    Controls the height of the image. Valid values are "auto", "stretch", or a number followed by "px".

.PARAMETER HorizontalAlignment
    Controls how the image should be horizontally aligned within its parent container.
    Valid values are: Left, Center, Right.

.PARAMETER HorizontalContentAlignment
    Controls how the image content is aligned horizontally within its bounding box when height and width are set.
    Valid values are: Left, Center, Right.

.PARAMETER VerticalContentAlignment
    Controls how the image content is aligned vertically within its bounding box when height and width are set.
    Valid values are: Top, Center, Bottom.

.PARAMETER Width
    Controls the width of the image. Valid values are "auto", "stretch", or a number followed by "px".

.PARAMETER Style
    Specifies the image style. Valid values are: Default, Person, RoundedCorners.

.PARAMETER Separator
    Adds a separator line above the image element to visually separate it from preceding content.

.PARAMETER Spacing
    Controls the amount of space between the image and the previous element.
    Valid values are: None, ExtraSmall, Small, Default, Medium, Large, ExtraLarge, Padding.

.PARAMETER AllowExpand
    When specified, allows the image to be expanded to full screen where supported.

.PARAMETER SelectAction
    A scriptblock that returns an Adaptive Card action to invoke when the image is clicked or tapped.

.PARAMETER Fallback
    A scriptblock that returns fallback content if the image cannot be rendered.

.PARAMETER Requires
    Hashtable of host capability requirements for the image element.

.PARAMETER TargetWidth
    Controls the card widths at which this image should be displayed. Supports responsive values
    such as VeryNarrow, Narrow, Standard, Wide, atLeast:<Width>, and atMost:<Width>.

.PARAMETER ThemedUrls
    Array of themed URLs for the image. Each entry should include theme-specific URLs, such as
    @{ theme = "dark"; url = "https://example.com/dark.png" }.

.PARAMETER Lang
    Specifies the locale associated with the image element.

.PARAMETER GridArea
    Sets the layout grid area in which the image should render when using Layout.AreaGrid.

.PARAMETER IsHidden
    When specified, sets isVisible to false so the image starts hidden.

.PARAMETER IsSortKey
    When specified, marks the image as usable as a sort key in sortable collections.

.PARAMETER AsBase64
    Downloads the image at the supplied Url and inlines it as a Base64 data URI.

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
        [Parameter(Mandatory = $true)]
        [string]$Url,

        [Parameter(Mandatory = $false)]
        [string]$AltText,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Cover", "Contain", "Fill")]
        [string]$FitMode,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Auto", "Stretch", "Small", "Medium", "Large")]
        [string]$Size,

        [Parameter(Mandatory = $false)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [string]$BackgroundColor,

        [Parameter(Mandatory = $false)]
        [ValidatePattern('^(auto|stretch|\d+(?:\.\d+)?px)$')]
        [string]$Height,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Left", "Center", "Right")]
        [string]$HorizontalAlignment,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Left", "Center", "Right")]
        [string]$HorizontalContentAlignment,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Top", "Center", "Bottom")]
        [string]$VerticalContentAlignment,

        [Parameter(Mandatory = $false)]
        [ValidatePattern('^(auto|stretch|\d+(?:\.\d+)?px)$')]
        [string]$Width,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Default", "Person", "RoundedCorners")]
        [string]$Style,

        [Parameter(Mandatory = $false)]
        [switch]$Separator,

        [Parameter(Mandatory = $false)]
        [ValidateSet("None", "ExtraSmall", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")]
        [string]$Spacing,

        [Parameter(Mandatory = $false)]
        [switch]$AllowExpand,

        [Parameter(Mandatory = $false)]
        [scriptblock]$SelectAction,

        [Parameter(Mandatory = $false)]
        [scriptblock]$Fallback,

        [Parameter(Mandatory = $false)]
        [hashtable]$Requires,

        [Parameter(Mandatory = $false)]
        [ValidateSet('VeryNarrow', 'Narrow', 'Standard', 'Wide',
            'atLeast:VeryNarrow', 'atMost:VeryNarrow',
            'atLeast:Narrow', 'atMost:Narrow',
            'atLeast:Standard', 'atMost:Standard',
            'atLeast:Wide', 'atMost:Wide')]
        [string]$TargetWidth,

        [Parameter(Mandatory = $false)]
        [array]$ThemedUrls,

        [Parameter(Mandatory = $false)]
        [string]$Lang,

        [Parameter(Mandatory = $false)]
        [string]$GridArea,

        [Alias('Hide')]
        [switch]$IsHidden,

        [switch]$IsSortKey,

        [switch]$AsBase64
    )

    $Image = @{
        type    = "Image"
        url     = $Url
        altText = $AltText
    }

    if ($AsBase64) {
        # Convert remote image to Base64 data URI when requested.
        $WebClient = [System.Net.WebClient]::new()
        try {
            $ImageBytes = $WebClient.DownloadData($Url)
        }
        finally {
            $WebClient.Dispose()
        }

        $Base64String = [Convert]::ToBase64String($ImageBytes)
        $Image.url = "data:image/png;base64,$Base64String"
    }

    if ($Separator) {
        $Image.separator = $true
    }

    if ($PSBoundParameters.ContainsKey('Spacing')) {
        $Image.spacing = $Spacing
    }

    if ($FitMode) {
        $Image.fitMode = $FitMode
    }

    if ($Id) {
        $Image.id = $Id
    }

    if ($PSBoundParameters.ContainsKey('BackgroundColor')) {
        $Image.backgroundColor = $BackgroundColor
    }

    if ($PSBoundParameters.ContainsKey('Height')) {
        $Image.height = $Height
    }

    if ($PSBoundParameters.ContainsKey('HorizontalAlignment')) {
        $Image.horizontalAlignment = $HorizontalAlignment
    }

    if ($PSBoundParameters.ContainsKey('HorizontalContentAlignment')) {
        $Image.horizontalContentAlignment = $HorizontalContentAlignment
    }

    if ($PSBoundParameters.ContainsKey('VerticalContentAlignment')) {
        $Image.verticalContentAlignment = $VerticalContentAlignment
    }

    if ($Size) {
        $Image.size = $Size
    }

    if ($PSBoundParameters.ContainsKey('Width')) {
        $Image.width = $Width
    }

    if ($Style) {
        $Image.style = $Style
    }

    if ($AllowExpand) {
        $Image.allowExpand = $true
    }

    if ($PSBoundParameters.ContainsKey('SelectAction')) {
        $SelectActionResult = & $SelectAction
        if ($null -ne $SelectActionResult) {
            $Image.selectAction = $SelectActionResult
        }
    }

    if ($PSBoundParameters.ContainsKey('Fallback')) {
        $FallbackContent = & $Fallback
        if ($null -ne $FallbackContent) {
            $Image.fallback = $FallbackContent
        }
    }

    if ($PSBoundParameters.ContainsKey('Requires')) {
        $Image.requires = $Requires
    }

    if ($PSBoundParameters.ContainsKey('TargetWidth')) {
        $Image.targetWidth = $TargetWidth
    }

    if ($PSBoundParameters.ContainsKey('ThemedUrls')) {
        $Image.themedUrls = @($ThemedUrls)
    }

    if ($PSBoundParameters.ContainsKey('Lang')) {
        $Image.lang = $Lang
    }

    if ($PSBoundParameters.ContainsKey('GridArea')) {
        $Image.'grid.area' = $GridArea
    }

    if ($IsHidden) {
        $Image.isVisible = -not $IsHidden.IsPresent
    }

    if ($IsSortKey) {
        $Image.isSortKey = $true
    }

    if ($PSCmdlet.ShouldProcess("Image element for '$Url'", 'Create Adaptive Card image')) {
        return $Image
    }

}

