<#
.SYNOPSIS
    Creates a template tag placeholder that can be replaced with dynamic content in Adaptive Cards.

.DESCRIPTION
    The New-CardTemplateTag function generates a template tag placeholder string in the format "!{{TagName}}"
    that can be used within Adaptive Card templates. These placeholders are later replaced with actual
    content using the Build-CardFromTemplate function, enabling dynamic and reusable card templates.

.PARAMETER TagName
    The name of the template tag to create. This should be a unique identifier that will be used
    to reference and replace the tag with actual content later.

.OUTPUTS
    System.String
        Returns a template tag string in the format "!{{TagName}}".

.EXAMPLE
    New-CardTemplateTag -TagName "UserName"
    
    Returns: "!{{UserName}}"

.EXAMPLE
    New-CardTextBlock -Text (New-CardTemplateTag -TagName "WelcomeMessage") -Size "Large"
    
    Creates a text block with a template tag that can be replaced later with dynamic content.

.EXAMPLE
    $template = New-CardContainer -Content {
        New-CardTextBlock -Text (New-CardTemplateTag -TagName "Title")
        New-CardTextBlock -Text (New-CardTemplateTag -TagName "Description")
    }
    
    Creates a container template with two replaceable text sections.

.NOTES
    - Template tags use the format "!{{TagName}}" to avoid conflicts with other templating systems
    - The TagName should be descriptive and unique within the template
    - Template tags can be used in any string property of Adaptive Card elements
    - Tags are case-sensitive when used with Build-CardFromTemplate
    - This function is typically used during template creation, not during runtime card generation

.LINK
    Build-CardFromTemplate
    
.LINK
    Find-CardTemplateTags
#>
function New-CardTemplateTag {
    param (
        [Parameter(Mandatory = $true)]
        [string]$TagName
    )

    $Tag = "!{{$TagName}}"

    return $Tag
}