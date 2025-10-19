<#
.SYNOPSIS
    Creates a new Container element for an Adaptive Card.

.DESCRIPTION
    The New-CardContainer function creates a Container element that can hold multiple card elements.
    Containers are used to group elements together and can apply styling and layout properties to their contents.
    They provide a way to organize and visually separate different sections of an Adaptive Card.

.PARAMETER Content
    A ScriptBlock containing the card elements to be included inside the container.
    This can include text blocks, images, other containers, and any other supported card elements.

.PARAMETER Style
    The visual style to apply to the container. Valid values are:
    - Default: Standard container appearance
    - Emphasis: Subtle emphasis styling
    - Attention: Attention-grabbing styling (typically orange/yellow)
    - Good: Success/positive styling (typically green)
    - Warning: Warning/caution styling (typically red)

    Default value is "Default".

.PARAMETER Id
    An optional unique identifier for the container element. Useful for referencing the container
    in actions like toggle visibility or for accessibility purposes.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the Container element structure for the Adaptive Card.

.EXAMPLE
    New-CardContainer -Content {
        New-CardTextBlock -Text "Title" -Weight "Bolder"
        New-CardTextBlock -Text "This is content inside a container"
    }

    Creates a basic container with two text blocks using the default styling.

.EXAMPLE
    New-CardContainer -Style "Good" -Content {
        New-CardTextBlock -Text "Success!" -Color "Good"
        New-CardTextBlock -Text "Operation completed successfully"
    } -Id "SuccessContainer"

    Creates a container with "Good" styling (typically green background) containing success messages,
    with an ID for potential referencing in actions.

.EXAMPLE
    New-CardContainer -Style "Attention" -Content {
        New-CardTextBlock -Text "Warning" -Weight "Bolder"
        New-CardTextBlock -Text "Please review the following information carefully"
    }

    Creates an attention-styled container (typically orange/yellow) with warning content.

.NOTES
    - Containers automatically handle both single elements and arrays of elements from the Content ScriptBlock
    - The Style parameter only adds the style property when it's not "Default" to keep the JSON clean
    - Containers can be nested within other containers for complex layouts
    - The Id parameter is optional but recommended when the container needs to be referenced by actions

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#container
#>
function New-CardContainer {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [scriptblock]$Content,

        [string]
        [ValidateSet("Default", "Emphasis", "Attention", "Good", "Warning")]
        $Style = "Default",

        [string]
        [Parameter(Mandatory = $false)]
        $Id,
        [switch]$Hidden
    )

    $Container = @{
        type  = "Container"
        items = [System.Collections.ArrayList]@()
    }

    if ($Style -ne "Default") {
        $Container.style = $Style
    }

    if ($Id) {
        $Container.id = $Id
    }
    if ($Hidden) {
        $Container.isVisible = $false
    }

    $ContentResult = Invoke-Command -ScriptBlock $Content

    if ($ContentResult -is [array]) {
        [void]($Container.items.AddRange($ContentResult))
    }
    else {
        [void]($Container.items.Add($ContentResult))
    }

    if ( $PSCmdlet.ShouldProcess("Creating Container element with style '$Style'." ) ) {
        return ($Container)
    }

}