<#
.SYNOPSIS
    Opens an Adaptive Card in the online Adaptive Cards Designer for visualization and testing.

.DESCRIPTION
    The Out-OnlineDesigner function takes an Adaptive Card JSON string and opens it in the
    Microsoft Adaptive Cards Designer web application. This provides a visual preview of how
    the card will appear and allows for interactive testing of the card's functionality.
    The function creates a temporary HTML file that embeds the card data and automatically
    opens it in the default web browser.

.PARAMETER Json
    The Adaptive Card JSON string to display in the designer. This parameter accepts pipeline input,
    making it easy to chain with card creation functions. The JSON should be a valid Adaptive Card
    structure that conforms to the Adaptive Cards schema.

.OUTPUTS
    None
        This function doesn't return any output. It creates a temporary HTML file and opens it in the browser.

.EXAMPLE
    New-AdaptiveCard -Content {
        New-CardTextBlock -Text "Hello, World!" -Size "Large"
        New-CardImage -Url "https://example.com/image.jpg" -AltText "Example"
    } | Out-OnlineDesigner

    Creates an Adaptive Card and immediately opens it in the online designer for preview.

.EXAMPLE
    $card = New-AdaptiveCard -Content {
        New-CardContainer -Style "Good" -Content {
            New-CardTextBlock -Text "Success!" -Color "Good"
            New-CardActionSet -Actions {
                New-CardActionToggleVisibility -Title "Show Details" -TargetElements @("details")
            }
        }
    }
    $card | Out-OnlineDesigner

    Creates a card with actions and opens it in the designer to test interactive functionality.

.EXAMPLE
    # Multiple cards can be tested by storing JSON and opening each
    $cards = @(
        (New-AdaptiveCard { New-CardTextBlock -Text "Card 1" }),
        (New-AdaptiveCard { New-CardTextBlock -Text "Card 2" })
    )
    $cards[0] | Out-OnlineDesigner

    Opens the first card in the designer. Each card requires a separate call to the function.

.NOTES
    - The function creates a temporary HTML file in the user's %TEMP% directory
    - The HTML file automatically loads the Adaptive Cards Designer from adaptivecards.microsoft.com
    - The card data is embedded in the HTML and sent to the designer via postMessage API
    - An active internet connection is required for the designer to load properly
    - The temporary HTML file remains after execution and can be manually opened again
    - The function uses Start-Process to open the default web browser
    - JSON data is escaped for safe embedding in HTML/JavaScript

.LINK
    https://adaptivecards.microsoft.com/designer

.LINK
    New-AdaptiveCard
#>
function Out-CardPreview {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Variable used in template')]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([void])]
    param (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Json
    )
    process {

        # Escape JSON for embedding in HTML/JS

        # Generate HTML with iframe and postMessage handling
        $html = Get-Content -Path "$PSScriptRoot\Templates\PreviewCard.html" -Raw

        $html = $ExecutionContext.InvokeCommand.ExpandString($html)

        $path = "$env:TEMP\AdaptiveCardDesigner.html"
        $html | Set-Content -Path $path -Encoding UTF8

        # Open HTML in default browser
        if ( $PSCmdlet.ShouldProcess("Opening Adaptive Card in Online Designer using a temporary HTML file $path") ) {
            Start-Process $path
        }
    }
}