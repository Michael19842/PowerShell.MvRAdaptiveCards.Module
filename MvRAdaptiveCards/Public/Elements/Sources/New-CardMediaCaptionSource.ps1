<#
.SYNOPSIS
    Creates a caption source object for use with Media elements in Adaptive Cards.

.DESCRIPTION
    The New-CardMediaCaptionSource function creates a caption source object that defines
    subtitles or captions for video content in Media elements. Each caption source specifies
    a URL to a caption file (typically WebVTT format) and optional label and MIME type.

.PARAMETER Url
    The URL of the caption file. Typically points to a WebVTT (.vtt) file.

.PARAMETER MimeType
    The MIME type of the caption file. Common value: "text/vtt" for WebVTT files.

.PARAMETER Label
    The label for this caption source, typically the language name (e.g., "English", "Spanish").
    This label is shown to users when selecting captions.

.EXAMPLE
    New-CardMediaCaptionSource -Url "https://example.com/captions-en.vtt" -MimeType "text/vtt" -Label "English"

.EXAMPLE
    # Multiple caption sources
    $captions = @(
        New-CardMediaCaptionSource -Url "https://example.com/captions-en.vtt" -MimeType "text/vtt" -Label "English"
        New-CardMediaCaptionSource -Url "https://example.com/captions-es.vtt" -MimeType "text/vtt" -Label "Spanish"
        New-CardMediaCaptionSource -Url "https://example.com/captions-fr.vtt" -MimeType "text/vtt" -Label "French"
    )
    New-CardMedia -Sources @{...} -CaptionSources $captions

.NOTES
    Caption sources are not used for YouTube, Dailymotion, or Vimeo videos.
    WebVTT (Web Video Text Tracks) is the standard format for captions.
#>
function New-CardMediaCaptionSource {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Url,

        [Parameter(Mandatory = $false)]
        [string]$MimeType = "text/vtt",

        [Parameter(Mandatory = $false)]
        [string]$Label
    )

    $CaptionSource = @{
        url      = $Url
        mimeType = $MimeType
    }

    if ($PSBoundParameters.ContainsKey('Label')) {
        $CaptionSource.label = $Label
    }

    if ($PSCmdlet.ShouldProcess("Creating Media Caption Source for URL: $Url")) {
        return $CaptionSource
    }

}