<#
.SYNOPSIS
    Sets the default fallback content for Adaptive Card elements.

.DESCRIPTION
    The Set-CardDefaultFallback function configures a default fallback element that will be
    automatically applied to Adaptive Cards when no explicit fallback is provided. This is
    useful for providing consistent fallback behavior across all cards in your application.

    The fallback content is stored in the module's settings file and will be applied to cards
    created with New-AdaptiveCard when the -Fallback parameter is not specified.

.PARAMETER FallbackContent
    A ScriptBlock that generates the fallback content. This should contain calls to card
    element functions (like New-CardTextBlock, New-CardContainer, etc.) that create the
    fallback structure you want to display when an element is not supported.

.PARAMETER Clear
    If specified, clears the default fallback setting, removing any previously configured
    fallback content.

.EXAMPLE
    Set-CardDefaultFallback -FallbackContent {
        New-CardTextBlock -Text "This element is not supported." -Wrap
    }

    Sets a simple text fallback message.

.EXAMPLE
    Set-CardDefaultFallback -FallbackContent {
        New-CardContainer -Content {
            New-CardTextBlock -Text "This element is not supported in your current host." -Size Large -Weight Bolder -Wrap
        } -Style 'Warning'
    }

    Sets a styled container as the default fallback with a warning appearance.

.EXAMPLE
    Set-CardDefaultFallback -Clear

    Clears the default fallback setting.

.EXAMPLE
    # Set fallback with multiple elements
    Set-CardDefaultFallback -FallbackContent {
        New-CardTextBlock -Text "Feature Not Available" -Size Large -Weight Bolder
        New-CardTextBlock -Text "Please update your application to view this content." -Wrap -IsSubtle
    }

.NOTES
    The fallback content is stored as a string representation of the ScriptBlock in the
    module's settings file. When a card is created without an explicit fallback, the stored
    ScriptBlock is converted back and executed to generate the fallback elements.

    This setting is persisted across PowerShell sessions.

.LINK
    New-AdaptiveCard
    Get-CardSetting
    Set-CardSetting
#>
function Set-CardDefaultFallback {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low ')]
    param (
        [parameter(Mandatory = $false)]
        [ScriptBlock]$FallbackContent,

        [switch]$Clear
    )

    # Store the fallback content in a global variable for use in other functions


    $CurrentSettings = Get-CardSetting
    if ($Clear) {
        $CurrentSettings.General.DefaultFallback = ''
    }
    else {
        $CurrentSettings.General.DefaultFallback = $FallbackContent.ToString()
    }

    # Save the updated settings
    if ($PSCmdlet.ShouldProcess("Updating default fallback settings")) {
        Set-CardSetting -Settings $CurrentSettings
    }
}

