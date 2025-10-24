<#
.SYNOPSIS
    Creates a Media element for Adaptive Cards that can play audio or video content.

.DESCRIPTION
    The New-CardMedia function creates a Media element that displays audio or video content
    in an Adaptive Card. Supports multiple sources and formats, including YouTube, Vimeo, and Dailymotion.

.PARAMETER Sources
    Array of media sources. Each source should be a hashtable with 'mimeType' and 'url' properties.

.PARAMETER Poster
    URL of the poster image to display before the media is played.

.PARAMETER AltText
    Alternate text for accessibility purposes.

.PARAMETER CaptionSources
    Array of caption sources. Each should be a hashtable with 'mimeType', 'url', and optional 'label' properties.
    Note: Caption sources are not used for YouTube, Dailymotion, or Vimeo sources.

.PARAMETER Id
    Unique identifier for the element.

.PARAMETER Height
    The height of the element. Valid values: "auto", "stretch"

.PARAMETER Separator
    If true, draw a separating line at the top of the element.

.PARAMETER Spacing
    Controls the amount of spacing between this element and the preceding element.

.PARAMETER IsVisible
    If false, this item will be removed from the visual tree.

.PARAMETER Requires
    A series of key/value pairs indicating features that the item requires with corresponding minimum version.

.PARAMETER Fallback
    ScriptBlock that generates fallback content if Media is not supported.

.PARAMETER TargetWidth
    Controls for which card width the element should be displayed.

.PARAMETER Lang
    The locale associated with the element.

.PARAMETER GridArea
    The area of a Layout.AreaGrid layout in which the element should be displayed.

.PARAMETER IsSortKey
    Controls whether the element should be used as a sort key.

.EXAMPLE
    New-CardMedia -Sources @(
        @{ mimeType = "video/mp4"; url = "https://example.com/video.mp4" }
    ) -Poster "https://example.com/poster.jpg" -AltText "Demo Video"

.EXAMPLE
    # YouTube video
    New-CardMedia -Sources @(
        @{ mimeType = "video/youtube"; url = "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }
    ) -AltText "YouTube Video"

.EXAMPLE
    # With captions
    New-CardMedia -Sources @(
        @{ mimeType = "video/mp4"; url = "https://example.com/video.mp4" }
    ) -CaptionSources @(
        @{ mimeType = "text/vtt"; url = "https://example.com/captions-en.vtt"; label = "English" },
        @{ mimeType = "text/vtt"; url = "https://example.com/captions-es.vtt"; label = "Spanish" }
    ) -AltText "Video with Captions"
#>
function New-CardMedia {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Sources,

        [Parameter(Mandatory = $false)]
        [string]$Poster,

        [Parameter(Mandatory = $false)]
        [string]$AltText,

        [Parameter(Mandatory = $false)]
        [array]$CaptionSources,

        [Parameter(Mandatory = $false)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [ValidateSet('auto', 'stretch')]
        [string]$Height,

        [Parameter(Mandatory = $false)]
        [switch]$Separator,

        [Parameter(Mandatory = $false)]
        [ValidateSet('None', 'ExtraSmall', 'Small', 'Default', 'Medium', 'Large', 'ExtraLarge', 'Padding')]
        [string]$Spacing,

        [Alias('Hide')]
        [switch]$IsHidden,

        [Parameter(Mandatory = $false)]
        [hashtable]$Requires,

        [Parameter(Mandatory = $false)]
        [scriptblock]$Fallback,

        [Parameter(Mandatory = $false)]
        [ValidateSet('VeryNarrow', 'Narrow', 'Standard', 'Wide',
            'atLeast:VeryNarrow', 'atMost:VeryNarrow',
            'atLeast:Narrow', 'atMost:Narrow',
            'atLeast:Standard', 'atMost:Standard',
            'atLeast:Wide', 'atMost:Wide')]
        [string]$TargetWidth,

        [Parameter(Mandatory = $false)]
        [string]$Lang,

        [Parameter(Mandatory = $false)]
        [string]$GridArea,

        [Parameter(Mandatory = $false)]
        [switch]$IsSortKey
    )

    $Element = @{
        type = 'Media'
    }

    # Required: sources
    if ($Sources) {
        $Element.sources = @()
        foreach ($Key in $Sources.Keys) {
            $Element.sources += @{
                mimeType = $Sources[$Key]
                url      = $Key
            }
        }
    }

    # Optional properties
    if ($PSBoundParameters.ContainsKey('Poster')) {
        $Element.poster = $Poster
    }

    if ($PSBoundParameters.ContainsKey('AltText')) {
        $Element.altText = $AltText
    }

    if ($PSBoundParameters.ContainsKey('CaptionSources')) {
        $Element.captionSources = @($CaptionSources)
    }

    if ($PSBoundParameters.ContainsKey('Id')) {
        $Element.id = $Id
    }

    if ($PSBoundParameters.ContainsKey('Height')) {
        $Element.height = $Height
    }

    if ($Separator) {
        $Element.separator = $true
    }

    if ($PSBoundParameters.ContainsKey('Spacing')) {
        $Element.spacing = $Spacing
    }

    if ($IsHidden) {
        $Element.isVisible = -not $IsHidden.IsPresent
    }

    if ($PSBoundParameters.ContainsKey('Requires')) {
        $Element.requires = $Requires
    }

    if ($PSBoundParameters.ContainsKey('Fallback')) {
        $FallbackContent = & $Fallback
        if ($FallbackContent) {
            $Element.fallback = $FallbackContent
        }
    }

    if ($PSBoundParameters.ContainsKey('TargetWidth')) {
        $Element.targetWidth = $TargetWidth
    }

    if ($PSBoundParameters.ContainsKey('Lang')) {
        $Element.lang = $Lang
    }

    if ($PSBoundParameters.ContainsKey('GridArea')) {
        $Element.'grid.area' = $GridArea
    }

    if ($IsSortKey) {
        $Element.isSortKey = $true
    }

    if ( $PSCmdlet.ShouldProcess("Creating Media element with ID '$Id'")) {
        return $Element
    }
}