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

.NOTES
    - The function automatically sets the schema version to "1.5" and includes the appropriate schema reference
    - Content elements are executed in the provided ScriptBlock and added to the card body
    - Schema validation requires the Test-CardSchema function to be available in the module
    - The function supports both single elements and arrays of elements in the Content ScriptBlock

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