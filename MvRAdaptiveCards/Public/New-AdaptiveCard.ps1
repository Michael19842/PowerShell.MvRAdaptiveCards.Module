<#
.SYNOPSIS
    Creates a new Adaptive Card with the specified content and configuration options.

.DESCRIPTION
    The New-AdaptiveCard function creates an Adaptive Card JSON structure or PowerShell object with the provided content elements.
    Adaptive Cards are platform-agnostic snippets of UI that can be used in various applications like Microsoft Teams, Outlook, and more.

    This function serves as the main container for all card elements and provides options for Teams-specific formatting,
    schema validation, and output format control.

.PARAMETER Content
    A ScriptBlock containing the card elements to be included in the Adaptive Card body.
    This can include containers, text blocks, images, tables, action sets, and other supported elements.

.PARAMETER SetFullWidthForTeams
    A switch parameter that configures the card to use full width when displayed in Microsoft Teams.
    When enabled, adds the msTeams property with width set to "Full".

.PARAMETER TestSchema
    A switch parameter that enables validation of the generated card against the Adaptive Card schema.
    When enabled, the function will validate the JSON output to ensure it conforms to the schema specifications.

.PARAMETER Actions
    A ScriptBlock containing action elements to be included at the bottom of the Adaptive Card.
    Actions provide interactive functionality like buttons, submit actions, and open URL actions.

.PARAMETER Fallback
    A ScriptBlock that defines fallback content to display if the card cannot be rendered
    or is not supported by the host. Should return an appropriate alternative card or element.

.PARAMETER Layouts
    A ScriptBlock containing layout definitions for the card. Used to define custom layouts
    and grid arrangements for card elements.

.PARAMETER References
    A ScriptBlock containing reference definitions that can be used throughout the card.
    Useful for defining reusable components and templates.

.PARAMETER Id
    A unique identifier for the card. Useful for referencing the card programmatically
    or for tracking purposes in applications.

.PARAMETER GridArea
    Specifies the named grid area where the card should be placed when used in a grid layout.
    This corresponds to the CSS grid-area property.

.PARAMETER Authentication
    A hashtable containing authentication configuration for the card. Must include the keys:
    'buttons', 'connectionName', 'tokenExchangeResource', and 'text'. Used for OAuth flows
    and secure authentication scenarios.

.PARAMETER MetadataOriginatingUrl
    Specifies the originating URL metadata for the card. This is used to provide context
    about where the card originated from, useful for security and tracking purposes.

.PARAMETER verticalContentAlignment
    Controls the vertical alignment of content within the card. Valid values are:
    - Top: Aligns content to the top
    - Center: Centers content vertically
    - Bottom: Aligns content to the bottom

.PARAMETER FallbackText
    Provides plain text fallback content that will be displayed if the card cannot be rendered.
    This is simpler than the Fallback scriptblock and provides basic text-only fallback.

.PARAMETER Speak
    Specifies the text that should be spoken by screen readers or voice assistants when
    the card is presented. Improves accessibility for users with visual impairments.

.PARAMETER Refresh
    A hashtable containing refresh configuration for the card. Must include the 'action' key.
    Defines how and when the card should refresh its content automatically.

.PARAMETER Resources
    A hashtable containing localized string resources for the card. Each key should be a
    resource identifier, and the value should be a hashtable with locale codes as keys
    and localized strings as values.

.PARAMETER Style
    Specifies the visual style theme for the card. Valid values are defined in the
    AdaptiveCardStyleCollection. Common values include "default", "emphasis", etc.

.PARAMETER Language
    Specifies the language/locale for the card content. Used for proper text rendering,
    right-to-left language support, and accessibility features.

.PARAMETER ForceVersion
    Forces the card to use a specific Adaptive Card schema version instead of the default "1.5".
    Use this when you need compatibility with specific hosts or want to use newer features.

.PARAMETER BackgroundImage
    A hashtable defining a background image for the card. Should include properties like
    'url', 'fillMode', 'horizontalAlignment', and 'verticalAlignment'.

.PARAMETER SelectAction
    A ScriptBlock that defines the action to perform when the entire card is selected/clicked.
    The scriptblock should return a single Adaptive Card action element.

.PARAMETER MinimalHeightInPixels
    Specifies the minimum height of the card in pixels. The card will be at least this tall,
    even if the content doesn't require it. Useful for maintaining consistent card sizes.

.PARAMETER Requires
    A hashtable specifying feature requirements for the card. Used to declare dependencies
    on specific Adaptive Card features or host capabilities.

.PARAMETER Hidden
    A switch parameter that controls whether the card is visible. When specified, the card
    will be hidden (isVisible = false). Alias: Hide

.PARAMETER RightToLeft
    A switch parameter that enables right-to-left text rendering for languages like Arabic
    or Hebrew. Alias: RTL

.PARAMETER isSortKey
    A switch parameter that marks this card as a sort key element. Used in scenarios
    where multiple cards need to be sorted or grouped.

.PARAMETER AsObject
    A switch parameter that controls the output format. When specified, returns the card as a PowerShell hashtable object
    instead of JSON string. Useful for programmatic manipulation or nested card scenarios.

.OUTPUTS
    System.String
        By default, returns the Adaptive Card as a JSON string.

    System.Collections.Hashtable
        When -AsObject is specified, returns the card as a PowerShell hashtable object.

.EXAMPLE
    New-AdaptiveCard -Content {
        New-CardTextBlock -Text "Hello, World!" -Size "Large" -Weight "Bolder"
        New-CardImage -Url "https://example.com/image.jpg" -AltText "Example"
    }

    Creates a simple Adaptive Card with a text block and an image, returned as JSON.

.EXAMPLE
    New-AdaptiveCard -Content {
        New-CardContainer -Style "Good" -Content {
            New-CardTextBlock -Text "Success!" -Color "Good"
        }
    } -SetFullWidthForTeams

    Creates an Adaptive Card with a container and configures it for full width display in Microsoft Teams.

.EXAMPLE
    $card = New-AdaptiveCard -Content {
        New-CardTextBlock -Text "Interactive Card"
        New-CardActionSet -Actions {
            New-CardActionToggleVisibility -Title "Toggle" -TargetElements @("element1")
        }
    } -AsObject

    Creates an Adaptive Card with actions and returns it as a PowerShell object for further manipulation.

.EXAMPLE
    New-AdaptiveCard -Content {
        New-CardTextBlock -Text "Welcome" -Id "welcome-text"
    } -Actions {
        New-CardActionSubmit -Title "Submit" -Data @{ action = "submit"; value = "test" }
    } -Id "main-card" -Style "emphasis"

    Creates a card with both content and actions, using a specific style and card ID.

.EXAMPLE
    New-AdaptiveCard -Content {
        New-CardTextBlock -Text "Authenticated Content"
    } -Authentication @{
        buttons = @("signin")
        connectionName = "MyConnection"
        tokenExchangeResource = @{ id = "resource-id"; uri = "https://example.com" }
        text = "Please sign in to continue"
    }

    Creates a card that requires authentication before displaying content.

.NOTES
    - The function automatically sets the schema version to "1.5" and includes the appropriate schema reference
    - Content elements are executed in the provided ScriptBlock and added to the card body
    - Schema validation requires the Test-CardSchema function to be available in the module
    - The function supports both single elements and arrays of elements in the Content ScriptBlock
    - Authentication scenarios require proper OAuth configuration in the host application
    - Background images and styling may not be supported by all Adaptive Card hosts
    - The SetFullWidthForTeams parameter is specific to Microsoft Teams integration
    - Right-to-left layout support depends on the host application's capabilities
    - Minimum height settings help maintain consistent card layouts in collections

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/

.LINK
    https://adaptivecards.io/
#>
function New-AdaptiveCard {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([hashtable])]
    param (
        [scriptblock]$Content,
        [scriptblock]$Actions,
        [scriptblock]$Fallback,
        [scriptblock]$Layouts,
        [scriptblock]$References,
        [string]$Id,
        [string]$GridArea,

        [ValidateScript({
                $RequiredKeys = @('buttons', 'connectionName', 'tokenExchangeResource', 'text')
                foreach ($key in $RequiredKeys) {
                    if (-not $_.ContainsKey($key)) {
                        throw "Authentication hashtable must contain the key '$key'."
                    }
                }
                return $true
            })]
        [hashtable]$Authentication,

        [string]$MetadataOriginatingUrl,

        [ValidateSet("Top", "Center", "Bottom")]
        [string]$verticalContentAlignment,

        [string]$FallbackText,
        [string]$Speak,
        [ValidateScript({
                $RequiredKeys = @('action')
                foreach ($key in $RequiredKeys) {
                    if (-not $_.ContainsKey($key)) {
                        throw "Authentication hashtable must contain the key '$key'."
                    }
                }
                return $true
            })]
        [hashtable]$Refresh,

        [ValidateScript({
                foreach ($key in $_.Keys) {
                    if ($_[$key] -isnot [hashtable]) {
                        throw "Resource '$key' must be a hashtable with the locale as name and the string as localised value."
                    }
                }
                return $true
            })]
        [hashtable]$Resources,

        [ValidateScript({
                if ($_ -in $_AdaptiveCardStyleCollection) {
                    return $true
                }
                else {
                    throw "Invalid style '$_'. Valid styles are: $($_AdaptiveCardStyleCollection -join ', ')"
                }
            })]
        [string]$Style,
        [Alias("Lang")]
        [string]$Language,

        [string]$ForceVersion,

        [hashtable]$BackgroundImage,
        [scriptblock]$SelectAction,

        [int]$MinimalHeightInPixels,

        [hashtable]$Requires,

        [Alias("Hide")]
        [switch]$Hidden,
        [Alias("RTL")]
        [switch]$RightToLeft,
        [switch]$isSortKey,
        [switch]$SetFullWidthForTeams,
        [switch]$TestSchema,
        [switch]$AsObject
    )

    $BaseCard = @{
        type      = "AdaptiveCard"
        body      = [System.Collections.ArrayList]@()
        '$schema' = "http://adaptivecards.io/schemas/adaptive-card.json"
        version   = "1.5"
    }

    if ($ForceVersion) {
        Write-Verbose "Forcing Adaptive Card version to '$ForceVersion'."
        $BaseCard.version = $ForceVersion
    }

    if ($SetFullWidthForTeams) {
        $BaseCard["msTeams"] = @{
            width = "Full"
        }
    }

    $ContentResult = Invoke-Command -ScriptBlock $Content

    if ($ContentResult -is [array]) {
        [void]($BaseCard.body.AddRange($ContentResult))
    }
    else {
        [void]($BaseCard.body.Add($ContentResult))
    }

    if ($Id) {
        $BaseCard.id = $Id
    }

    if ($Actions) {
        $BaseCard.actions = Invoke-Command -ScriptBlock $Actions
    }

    if ($Fallback) {
        $BaseCard.fallback = Invoke-Command -ScriptBlock $Fallback
    }
    if ($fallbackText) {
        $BaseCard.fallbackText = $fallbackText
    }

    if ($Authentication) {
        $BaseCard.authentication = $Authentication
    }

    if ($MetadataOriginatingUrl) {
        $BaseCard.metadata = @{
            originatingUrl = $MetadataOriginatingUrl
        }
    }
    if ($Refresh) {
        $BaseCard.refresh = $Refresh
    }

    if ($References) {
        $BaseCard.references = Invoke-Command -ScriptBlock $References
    }

    if ($Resources) {
        $BaseCard.resources = $Resources
    }
    if ($Speak) {
        $BaseCard.speak = $Speak
    }
    if ($BackgroundImage) {
        $BaseCard.backgroundImage = $BackgroundImage
    }
    if ($SelectAction) {
        $BaseCard.selectAction = Invoke-Command -ScriptBlock $SelectAction

        if ($BaseCard.selectAction -isnot [hashtable]) {
            throw "The selectAction can be one action only."
        }
    }

    if ($Style) {
        $BaseCard.style = $Style
    }

    if ($RightToLeft) {
        $BaseCard.rtl = $true
    }

    if ($MinimalHeightInPixels) {
        $BaseCard.minHeight = "$($MinimalHeightInPixels)px"
    }

    if ($isSortKey) {
        $BaseCard.isSortKey = $true
    }

    if ( $Layouts) {
        $BaseCard.layouts = Invoke-Command -ScriptBlock $Layouts
    }
    if ($Language) {
        $BaseCard.lang = $Language
    }

    if ( $GridArea) {
        $BaseCard.gridArea = $GridArea
    }



    if ($Requires) {
        $BaseCard.requires = $Requires
    }

    if ($Hidden) {
        $BaseCard.isVisible = $false
    }

    if ($verticalContentAlignment) {
        $BaseCard.verticalContentAlignment = $verticalContentAlignment
    }
    #Test if the output conforms to the Adaptive Card schema
    $Json = $BaseCard | ConvertTo-Json -Depth $_MaxDepth


    if ($TestSchema) {

        # $SchemaUrl = "http://adaptivecards.io/schemas/adaptive-card.json"
        # $Schema = (Invoke-WebRequest -Uri $SchemaUrl).Content

        #The manifest schema is stored locally to avoid dependency on internet access and mitigate inconsistencies in the schema


        [void](Test-CardSchema -Json $Json -ShowErrors:$false)

    }


    if ($PSCmdlet.ShouldProcess("Returning Adaptive Card")) {
        if ($AsObject) {
            return $BaseCard
        }
        return $Json
    }
}

