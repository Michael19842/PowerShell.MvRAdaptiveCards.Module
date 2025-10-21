<#
.SYNOPSIS
    Renders and displays an Adaptive Card in a local HTML preview window using the AdaptiveCards JavaScript library.

.DESCRIPTION
    The Out-CardPreview function takes an Adaptive Card JSON string and renders it using the Microsoft
    AdaptiveCards JavaScript library in a local HTML preview. This provides an immediate visual
    representation of how the card will appear when rendered, complete with interactive functionality
    testing. The function creates a temporary HTML file with embedded card data and opens it in the
    default web browser for instant preview.

    The preview includes:
    - Full card rendering with proper styling
    - Interactive element testing (buttons, inputs, actions)
    - Professional module branding with logo and version information
    - Responsive design that works across different screen sizes
    - Error handling for malformed JSON or rendering issues

.PARAMETER Json
    The Adaptive Card JSON string to render and display. This parameter accepts pipeline input,
    making it seamless to chain with card creation functions like New-AdaptiveCard. The JSON must
    be a valid Adaptive Card structure that conforms to the Microsoft Adaptive Cards schema.

.OUTPUTS
    None
        This function doesn't return any output. It generates a temporary HTML preview file and
        opens it in the default web browser for immediate visual feedback.

.EXAMPLE
    New-AdaptiveCard -Content {
        New-CardTextBlock -Text "Welcome to AdaptiveCards!" -Size "Large" -Weight "Bolder"
        New-CardImage -Url "https://example.com/banner.jpg" -AltText "Welcome Banner"
    } | Out-CardPreview

    Creates a simple Adaptive Card with text and image, then immediately opens it in a local HTML preview.

.EXAMPLE
    $card = New-AdaptiveCard -Content {
        New-CardContainer -Style "Emphasis" -Content {
            New-CardTextBlock -Text "Interactive Card Demo" -Size "Medium" -Weight "Bolder"
            New-CardFactSet -Facts @(
                @{ title = "Status"; value = "Active" }
                @{ title = "Priority"; value = "High" }
            )
            New-CardActionSet -Actions {
                New-CardActionSubmit -Title "Approve" -Data @{ action = "approve"; id = "123" }
                New-CardActionOpenUrl -Title "View Details" -Url "https://example.com/details"
            }
        }
    }
    $card | Out-CardPreview

    Creates an interactive card with actions and data submission, then previews it to test functionality.

.EXAMPLE
    # Test multiple card variations quickly
    $variations = @(
        (New-AdaptiveCard { New-CardTextBlock -Text "Version 1" -Color "Good" }),
        (New-AdaptiveCard { New-CardTextBlock -Text "Version 2" -Color "Warning" }),
        (New-AdaptiveCard { New-CardTextBlock -Text "Version 3" -Color "Attention" })
    )

    # Preview each variation
    $variations[0] | Out-CardPreview
    Start-Sleep 2
    $variations[1] | Out-CardPreview

    Demonstrates testing multiple card variations by generating separate preview windows.

.NOTES
    - Creates a temporary HTML file in the user's %TEMP% directory named 'AdaptiveCardDesigner.html'
    - Uses the official Microsoft AdaptiveCards JavaScript library loaded from CDN
    - Includes Office UI Fabric CSS for consistent Microsoft styling
    - Features embedded base64 module logo and professional branding
    - Supports markdown rendering within card text elements
    - Requires internet connection for loading external CSS/JS libraries
    - The temporary HTML file persists after execution for manual re-opening
    - Interactive elements (buttons, inputs) are fully functional in the preview
    - Supports all Adaptive Card schema elements and actions
    - Automatic error handling displays helpful messages for invalid JSON

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/

.LINK
    New-AdaptiveCard

.LINK
    Out-OnlineDesigner
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
        if ($null -eq $Json ) {
            $Json = ''
        }
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