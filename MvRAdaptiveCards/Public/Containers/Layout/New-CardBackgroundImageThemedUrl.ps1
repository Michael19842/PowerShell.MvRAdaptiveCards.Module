<#
.SYNOPSIS
    Creates a ThemedUrl object for Adaptive Card background images.

.DESCRIPTION
    Generates the hashtable structure required by the Adaptive Card schema to supply
    theme-specific background image URLs. Intended to be used from the ThemedUrls
    ScriptBlock parameter of New-CardBackgroundImage.

.PARAMETER Theme
    Name of the theme this URL applies to (for example, "dark" or "highContrast").

.PARAMETER Url
    Image URL or Data URI that should be applied when the referenced theme is active.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing a ThemedUrl object.

.EXAMPLE
    New-CardBackgroundImage -Url "https://contoso.com/default.png" -ThemedUrls {
        New-CardBackgroundImageThemedUrl -Theme "dark" -Url "https://contoso.com/dark.png"
    }

    Adds a dark-mode background image override in addition to the default URL.

.LINK
    https://learn.microsoft.com/adaptive-cards/authoring-cards/card-schema#backgroundimage
#>
function New-CardBackgroundImageThemedUrl {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Light", "Dark")]
        [string]
        $Theme,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Url
    )

    $themedUrl = @{
        theme = $Theme
        url   = $Url
    }

    if ($PSCmdlet.ShouldProcess("Creating themed background image for theme '$Theme'")) {
        return $themedUrl
    }
}