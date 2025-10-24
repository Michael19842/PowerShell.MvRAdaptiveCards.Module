
<#
.SYNOPSIS
Creates a Carousel container for Adaptive Cards.

.DESCRIPTION
Creates a carousel that displays multiple pages of content that users can navigate through.

.PARAMETER Pages
A scriptblock that generates the carousel pages. Use New-CardCarouselPage to create pages.

.PARAMETER Id
A unique identifier for the carousel element.

.PARAMETER Timer
The time in milliseconds to automatically advance to the next page. If not specified, auto-advance is disabled.

.PARAMETER InitialPage
The index (0-based) of the page to display initially. Defaults to 0.

.PARAMETER Loop
Controls whether the carousel should loop back to the first page after the last page.

.PARAMETER HeightInPixels
The height of the carousel in pixels.

.PARAMETER IsVisible
Controls the visibility of the element. Defaults to true.

.PARAMETER Separator
Controls whether a separator line should be displayed above the element.

.PARAMETER Spacing
Controls the amount of space between this element and the previous one.

.PARAMETER Height
The height of the element. Valid values: auto, stretch

.PARAMETER TargetWidth
Controls for which card width the element should be displayed.

.PARAMETER GridArea
The area of a Layout.AreaGrid layout in which the element should be displayed.

.PARAMETER Fallback
An alternate element to render if this type is unsupported.

.PARAMETER Requires
A hashtable of capabilities the element requires the host application to support.

.EXAMPLE
New-CardCarousel -Pages {
    New-CardCarouselPage {
        New-CardTextBlock -Text "Page 1" -Size Large
    }
    New-CardCarouselPage {
        New-CardTextBlock -Text "Page 2" -Size Large
    }
}

.EXAMPLE
New-CardCarousel -Timer 3000 -Loop -Pages {
    New-CardCarouselPage {
        New-CardImage -Url "https://example.com/image1.jpg"
    }
    New-CardCarouselPage {
        New-CardImage -Url "https://example.com/image2.jpg"
    }
}
#>
function New-CardCarousel {
    [CmdletBinding(supportsShouldProcess = $true, ConfirmImpact = 'none')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [scriptblock]$Pages,

        [Parameter(Mandatory = $false)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [int]$Timer,

        [Parameter(Mandatory = $false)]
        [int]$InitialPage = 0,

        [Parameter(Mandatory = $false)]
        [switch]$Loop,

        [Parameter(Mandatory = $false)]
        [int]$HeightInPixels,

        [Parameter(Mandatory = $false)]
        [bool]$IsVisible = $true,

        [Parameter(Mandatory = $false)]
        [switch]$Separator,

        [Parameter(Mandatory = $false)]
        [ValidateSet('None', 'ExtraSmall', 'Small', 'Default', 'Medium', 'Large', 'ExtraLarge', 'Padding')]
        [string]$Spacing = 'Default',

        [Parameter(Mandatory = $false)]
        [ValidateSet('auto', 'stretch')]
        [string]$Height,

        [Parameter(Mandatory = $false)]
        [ValidateSet('VeryNarrow', 'Narrow', 'Standard', 'Wide',
            'atLeast:VeryNarrow', 'atMost:VeryNarrow',
            'atLeast:Narrow', 'atMost:Narrow',
            'atLeast:Standard', 'atMost:Standard',
            'atLeast:Wide', 'atMost:Wide')]
        [string]$TargetWidth,

        [Parameter(Mandatory = $false)]
        [string]$GridArea,

        [Parameter(Mandatory = $false)]
        [object]$Fallback,

        [Parameter(Mandatory = $false)]
        [hashtable]$Requires
    )

    $Carousel = @{
        type  = "Carousel"
        pages = @(Invoke-Command -ScriptBlock $Pages)
    }

    if ($PSBoundParameters.ContainsKey('Id')) {
        $Carousel.id = $Id
    }

    if ($PSBoundParameters.ContainsKey('Timer')) {
        $Carousel.timer = $Timer
    }

    if ($PSBoundParameters.ContainsKey('InitialPage')) {
        $Carousel.initialPage = $InitialPage
    }

    if ($Loop) {
        $Carousel.loop = $true
    }

    if ($PSBoundParameters.ContainsKey('HeightInPixels')) {
        $Carousel.heightInPixels = $HeightInPixels
    }

    if ($PSBoundParameters.ContainsKey('IsVisible')) {
        $Carousel.isVisible = $IsVisible
    }

    if ($Separator) {
        $Carousel.separator = $true
    }

    if ($PSBoundParameters.ContainsKey('Spacing')) {
        $Carousel.spacing = $Spacing
    }

    if ($PSBoundParameters.ContainsKey('Height')) {
        $Carousel.height = $Height
    }

    if ($PSBoundParameters.ContainsKey('TargetWidth')) {
        $Carousel.targetWidth = $TargetWidth
    }

    if ($PSBoundParameters.ContainsKey('GridArea')) {
        $Carousel['grid.area'] = $GridArea
    }

    if ($PSBoundParameters.ContainsKey('Fallback')) {
        $Carousel.fallback = $Fallback
    }

    if ($PSBoundParameters.ContainsKey('Requires')) {
        $Carousel.requires = $Requires
    }
    if ( $PSCmdlet.ShouldProcess("Creating Carousel with ID '$Id'")) {
        return $Carousel
    }


}