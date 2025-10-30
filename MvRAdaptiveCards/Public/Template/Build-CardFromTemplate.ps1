<#
.SYNOPSIS
    Builds a complete Adaptive Card by replacing template tags with actual content.

.DESCRIPTION
    The Build-CardFromTemplate function takes a template-based Adaptive Card content structure
    and replaces all template tag placeholders with actual data. It supports both simple string/value
    replacements and complex ScriptBlock-based dynamic content generation, enabling the creation
    of reusable card templates that can be populated with different data sets.

.PARAMETER Content
    A hashtable representing the Adaptive Card template content structure containing template tags
    to be replaced. This is typically created using card creation functions with New-CardTemplateTag placeholders.

.PARAMETER Tags
    A hashtable where keys are template tag names (without the !{{ }} wrapper) and values are
    the replacement content. Values can be:
    - Strings, numbers, booleans: Replaced directly
    - ScriptBlocks: Executed to generate dynamic content
    - Objects/Arrays: Converted to JSON and inserted as structured content

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the completed Adaptive Card content with all template tags replaced.

.EXAMPLE
    $template = New-CardContainer -Content {
        New-CardTextBlock -Text (New-CardTemplateTag -TagName "Greeting")
        New-CardTextBlock -Text (New-CardTemplateTag -TagName "UserName")
    }

    $card = Build-CardFromTemplate -Content $template -Tags @{
        Greeting = "Welcome!"
        UserName = "John Doe"
    }

    Replaces the template tags with simple string values.

.EXAMPLE
    $template = New-CardContainer -Content {
        New-CardTextBlock -Text (New-CardTemplateTag -TagName "Message")
        New-CardTemplateTag -TagName "DynamicContent"
    }

    $card = Build-CardFromTemplate -Content $template -Tags @{
        Message = "Current Status:"
        DynamicContent = {
            New-CardFactSet -Facts @{
                "Time" = (Get-Date).ToString("HH:mm")
                "Status" = "Online"
            }
        }
    }

    Combines string replacement with dynamic content generation using ScriptBlocks.

.EXAMPLE
    $userTemplate = New-CardContainer -Content {
        New-CardTextBlock -Text "User: !{{Name}}"
        New-CardTemplateTag -TagName "UserDetails"
    } -Id (New-CardTemplateTag -TagName "ContainerID")

    $users = @("Alice", "Bob", "Charlie")
    $cards = foreach ($user in $users) {
        Build-CardFromTemplate -Content $userTemplate -Tags @{
            Name = $user
            UserDetails = { New-CardTextBlock -Text "Welcome, $user!" }
            ContainerID = "User_$user"
        }
    }

    Demonstrates creating multiple cards from a single template with different data.

.NOTES
    - Template tag names in the Tags hashtable should not include the !{{ }} wrapper syntax
    - ScriptBlocks in tag values are executed in the current scope and can access variables
    - The function performs deep replacement through the entire content structure
    - Warnings are generated for tags specified in the Tags parameter but not found in the template
    - String values are JSON-escaped to ensure proper integration into the card structure
    - Complex objects and arrays are serialized to JSON for structured content insertion
    - The function uses ConvertFrom-JsonAsHashtable for reliable JSON-to-hashtable conversion

.LINK
    New-CardTemplateTag

.LINK
    Find-CardTemplateTags
#>
function Build-CardFromTemplate {
    param (
        [hashtable]$Content,
        [hashtable]$Tags
    )

    $TemplateTags = Find-CardTemplateTag -Content $Content
    $ContentAsJson = $Content | ConvertTo-Json -Depth $_MaxDepth -Compress

    foreach ($Key in $Tags.Keys) {
        if ($TemplateTags -contains $Key) {
            $TagValue = $Tags[$Key]
            if ($TagValue -is [scriptblock]) {
                $ResolvedValue = Invoke-Command -ScriptBlock $TagValue
            }
            else {
                $ResolvedValue = $TagValue
            }

            # Strings are replaced inline (quotes removed), primitives/objects keep JSON structure
            if ($ResolvedValue -is [string]) {
                $jsonValue = $ResolvedValue | ConvertTo-Json -Depth $_MaxDepth -Compress
                # Remove exactly one quote from each end (strings are quoted in JSON)
                $ReplaceValue = $jsonValue.Substring(1, $jsonValue.Length - 2)
                $TagPlaceholder = New-CardTemplateTag -TagName $Key
            }
            elseif ($ResolvedValue -is [int] -or $ResolvedValue -is [double] -or $ResolvedValue -is [bool]) {
                # Numbers and booleans: convert to JSON but keep as-is (no quotes to remove)
                $ReplaceValue = ($ResolvedValue | ConvertTo-Json -Depth $_MaxDepth -Compress).ToLower()
                $TagPlaceholder = New-CardTemplateTag -TagName $Key
            }
            else {
                # Complex objects/arrays: replace the placeholder including its quotes
                $ReplaceValue = $ResolvedValue | ConvertTo-Json -Depth $_MaxDepth -Compress
                $TagPlaceholder = New-CardTemplateTag -TagName $Key | ConvertTo-Json -Depth $_MaxDepth -Compress
            }

            # Use literal string replacement - ConvertTo-Json already handles all JSON escaping
            $ContentAsJson = $ContentAsJson.Replace($TagPlaceholder, $ReplaceValue)
        }
        else {
            Write-Warning "Tag '$Key' not found in template."
        }
    }

    $UpdatedContent = ConvertFrom-JsonAsHashtable -InputObject $ContentAsJson

    return $UpdatedContent
}