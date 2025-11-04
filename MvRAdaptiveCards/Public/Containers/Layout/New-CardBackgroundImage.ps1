<#
.SYNOPSIS
	Creates a backgroundImage object for use on Adaptive Card containers and layouts.

.DESCRIPTION
	The New-CardBackgroundImage function produces the hashtable structure expected by the Adaptive Card
	schema for the backgroundImage property. It supports configuring fill behavior, alignment, and optional
	theme-specific image URLs.

.PARAMETER Url
	The image URL or Data URI to use as the background. This is a required value.

.PARAMETER FillMode
	Controls how the image should fill the available area. Defaults to "Cover". Other valid values include
	"RepeatHorizontally", "RepeatVertically", and "Repeat".

.PARAMETER HorizontalAlignment
	Determines the horizontal alignment when the image needs to be cropped or repeated. Defaults to "Left".

.PARAMETER VerticalAlignment
	Determines the vertical alignment when the image needs to be cropped or repeated. Defaults to "Top".

.PARAMETER ThemedUrls
	Optional ScriptBlock that should emit one or more ThemedUrl objects to support theme-specific background
	imagery. Each emitted object must already match the Adaptive Card schema for ThemedUrl.

.OUTPUTS
	System.Collections.Hashtable
		Returns a hashtable representing the backgroundImage structure.

.EXAMPLE
	New-CardBackgroundImage -Url "https://contoso.com/background.png"

	Creates a simple background image definition using the default fill and alignment.

.EXAMPLE
	New-CardBackgroundImage -Url "https://contoso.com/pattern.svg" -FillMode Repeat -HorizontalAlignment Center

	Produces a repeating background centered horizontally.

.EXAMPLE
	New-CardBackgroundImage -Url "https://contoso.com/day.png" -ThemedUrls {
		@{
			theme = "dark"
			url   = "https://contoso.com/night.png"
		}
	}

	Creates a background image with a fallback URL plus a dark theme override.

.NOTES
	- Properties are omitted from the output when their values match the Adaptive Card defaults
	- The ThemedUrls scriptblock may return a single object or an array
	- Consumers such as New-CardContainer can pipe the resulting hashtable into the backgroundImage property

.LINK
	https://learn.microsoft.com/adaptive-cards/authoring-cards/card-schema#backgroundimage
#>
function New-CardBackgroundImage {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Url,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Cover", "RepeatHorizontally", "RepeatVertically", "Repeat")]
        [string]
        $FillMode = "Cover",

        [Parameter(Mandatory = $false)]
        [ValidateSet("Left", "Center", "Right")]
        [string]
        $HorizontalAlignment = "Left",

        [Parameter(Mandatory = $false)]
        [ValidateSet("Top", "Center", "Bottom")]
        [string]
        $VerticalAlignment = "Top",

        [Parameter(Mandatory = $false)]
        [scriptblock]
        $ThemedUrls
    )

    $backgroundImage = @{
        url = $Url
    }

    if ($FillMode -ne "Cover") {
        $backgroundImage.fillMode = $FillMode
    }

    if ($HorizontalAlignment -ne "Left") {
        $backgroundImage.horizontalAlignment = $HorizontalAlignment
    }

    if ($VerticalAlignment -ne "Top") {
        $backgroundImage.verticalAlignment = $VerticalAlignment
    }

    if ($ThemedUrls) {
        $backgroundImage.themedUrls = [System.Collections.ArrayList]@()

        $themedResults = Invoke-Command -ScriptBlock $ThemedUrls

        if ($null -ne $themedResults) {
            if ($themedResults -is [array]) {
                [void]$backgroundImage.themedUrls.AddRange($themedResults)
            }
            else {
                [void]$backgroundImage.themedUrls.Add($themedResults)
            }
        }

        if ($backgroundImage.themedUrls.Count -eq 0) {
            $backgroundImage.Remove('themedUrls') | Out-Null
        }
    }

    if ($PSCmdlet.ShouldProcess("Creating backgroundImage for '$Url'")) {
        return $backgroundImage
    }
}