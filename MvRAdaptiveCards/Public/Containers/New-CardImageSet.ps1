<#
.SYNOPSIS
    Creates an ImageSet element for an Adaptive Card to display a collection of images.

.DESCRIPTION
    The New-CardImageSet function creates an ImageSet element for Adaptive Cards that displays a collection of images
    in a compact layout. ImageSets are useful for showing galleries, thumbnails, or related images together.
    This function supports customization of image size, spacing, alignment, and other layout properties.

    The Images parameter accepts a scriptblock that should return one or more image elements created with New-CardImage.
    All images in the set will be displayed with the same size as specified by the ImageSize parameter.

.PARAMETER Images
    A scriptblock containing the image elements to be included in the ImageSet. The scriptblock should return
    one or more New-CardImage elements. All images will be displayed with uniform sizing.

.PARAMETER ImageSize
    Controls the size of all images in the set. Valid values are:
    - Small: Small image size
    - Medium: Medium image size (typically default)
    - Large: Large image size
    All images in the set will use this uniform size.

.PARAMETER Fallback
    A scriptblock that defines fallback content to display if the ImageSet cannot be rendered
    or is not supported by the host. Should return an appropriate Adaptive Card element.

.PARAMETER GridArea
    Specifies the named grid area where the ImageSet should be placed when used in a grid layout.
    This corresponds to the CSS grid-area property.

.PARAMETER Height
    Controls the height behavior of the ImageSet. Valid values are:
    - Auto: Height adjusts automatically to content (default)
    - Stretch: ImageSet stretches to fill available vertical space

.PARAMETER HorizontalAlignment
    Controls the horizontal alignment of the ImageSet within its container. Valid values are:
    - Left: Aligns the ImageSet to the left side
    - Center: Centers the ImageSet horizontally
    - Right: Aligns the ImageSet to the right side

.PARAMETER Id
    A unique identifier for the ImageSet element. Useful for referencing the element programmatically
    or for styling purposes.

.PARAMETER BackgroundColor
    Specifies the background color for the ImageSet. Valid values are:
    - Default: Uses the theme's default background color
    - Dark: Dark background color
    - Light: Light background color
    - Accent: Uses the theme's accent background color
    - Good: Green background, typically used for success states
    - Warning: Orange/yellow background, used for warnings
    - Attention: Red background, used for errors or critical states

.PARAMETER Spacing
    Controls the amount of spacing above the ImageSet. Valid values are:
    - None: No spacing
    - Small: Small spacing
    - Default: Default spacing
    - Medium: Medium spacing
    - Large: Large spacing
    - ExtraLarge: Extra large spacing
    - Padding: Adds padding around the element

.PARAMETER Language
    Specifies the language/locale for the ImageSet element. Used for proper text rendering
    and accessibility features. Alias: Lang

.PARAMETER Separator
    When specified, adds a separator line above the ImageSet to visually separate it from
    preceding content.

.PARAMETER IsSortKey
    When specified, marks this ImageSet as a sort key element. Used in scenarios where
    multiple elements need to be sorted or grouped.

.PARAMETER IsHidden
    When specified, sets the ImageSet to be hidden (isVisible = false). The element will
    not be displayed but can be shown programmatically. Alias: Hide

.OUTPUTS
    System.Collections.Hashtable
    Returns a hashtable representing the ImageSet element that can be used in an Adaptive Card.

.EXAMPLE
    New-CardImageSet -Images {
        New-CardImage -Url "https://example.com/image1.jpg" -AltText "Image 1"
        New-CardImage -Url "https://example.com/image2.jpg" -AltText "Image 2"
        New-CardImage -Url "https://example.com/image3.jpg" -AltText "Image 3"
    } -ImageSize "Medium"

    Creates an ImageSet with three images, all displayed at medium size.

.EXAMPLE
    New-CardImageSet -Images {
        New-CardImage -Url "https://example.com/thumb1.jpg" -AltText "Thumbnail 1"
        New-CardImage -Url "https://example.com/thumb2.jpg" -AltText "Thumbnail 2"
    } -ImageSize "Small" -HorizontalAlignment "Center" -Spacing "Medium"

    Creates a centered ImageSet with small thumbnails and medium spacing above it.

.EXAMPLE
    New-CardImageSet -Images {
        New-CardImage -Url "https://example.com/gallery1.jpg" -AltText "Gallery Image 1"
        New-CardImage -Url "https://example.com/gallery2.jpg" -AltText "Gallery Image 2"
    } -ImageSize "Large" -BackgroundColor "Light" -Id "photo-gallery" -Separator

    Creates a large ImageSet with light background, separator, and a custom ID for reference.

.EXAMPLE
    New-CardImageSet -Images {
        New-CardImage -Url "https://example.com/product1.jpg" -AltText "Product 1"
        New-CardImage -Url "https://example.com/product2.jpg" -AltText "Product 2"
    } -Fallback {
        New-CardTextBlock -Text "Product images not available"
    } -Height "Stretch"

    Creates an ImageSet with fallback content and stretch height behavior.

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#imageset

.NOTES
    This function is part of the MvRAdaptiveCards module for creating Adaptive Cards in PowerShell.
    ImageSets are ideal for displaying multiple related images in a compact, uniform layout.
    All images in the set will be displayed with the same size regardless of their original dimensions.
    Consider using individual Image elements if you need different sizes for different images.
#>
function New-CardImageSet {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [scriptblock]$Images,

        [parameter(Mandatory = $false)]
        [ValidateSet("Small", "Medium", "Large")]
        [string]$ImageSize,

        [parameter(Mandatory = $false)]
        [scriptblock]$Fallback,

        [Parameter(Mandatory = $false)]
        [string]
        $GridArea,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Auto", "Stretch")]
        [string] $Height,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Left", "Center", "Right")]
        [string] $HorizontalAlignment,

        [Parameter(Mandatory = $false)]
        [string] $Id,

        [parameter(Mandatory = $false)]
        [ValidateSet("Default", "Dark", "Light", "Accent", "Good", "Warning", "Attention")]
        [string]$BackgroundColor,

        [parameter(Mandatory = $false)]
        [ValidateSet("None", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")]
        $Spacing,

        [Parameter(Mandatory = $false)]
        [Alias("Lang")]
        [string]$Language,

        [switch]$Separator,

        [switch]$IsSortKey,

        [Alias("Hide")]
        [switch]$IsHidden

    )
    $ImageSet = @{
        type = "ImageSet"
    }

    if ($Images) {
        $ImageSet.images = Invoke-Command -ScriptBlock $Images
    }

    if ($ImageSize) {
        $ImageSet.imageSize = $ImageSize
    }
    if ($BackgroundColor) {
        $ImageSet.backgroundColor = $BackgroundColor
    }
    if ($Spacing) {
        $ImageSet.spacing = $Spacing
    }
    if ($HorizontalAlignment) {
        $ImageSet.horizontalAlignment = $HorizontalAlignment
    }
    if ($Height) {
        $ImageSet.height = $Height
    }
    if ($Id) {
        $ImageSet.id = $Id
    }
    if ($GridArea) {
        $ImageSet.gridArea = $GridArea
    }
    if ($Separator) {
        $ImageSet.separator = $true
    }
    if ($IsSortKey) {
        $ImageSet.isSortKey = $true
    }
    if ($IsHidden) {
        $ImageSet.isVisible = $false
    }
    if ($Fallback) {
        $ImageSet.fallback = Invoke-Command -ScriptBlock $Fallback
    }

    if ($Language) {
        $ImageSet.lang = $Language
    }

    if ($PSCmdlet.ShouldProcess("Returning ImageSet with $($ImageSet.images.Count) images")) {
        return $ImageSet
    }
}