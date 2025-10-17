---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version:
schema: 2.0.0
---

# Find-CardTemplateTags

## SYNOPSIS
Discovers all template tags within an Adaptive Card content structure.

## SYNTAX

```
Find-CardTemplateTags [[-Content] <Hashtable>]
```

## DESCRIPTION
The Find-CardTemplateTags function analyzes an Adaptive Card content hashtable and identifies
all template tag placeholders (in the format "!{{TagName}}") that can be replaced with dynamic content.
This is useful for understanding what replaceable elements exist in a template before using
Build-CardFromTemplate to populate them with actual data.

## EXAMPLES

### EXAMPLE 1
```
$template = New-CardContainer -Content {
    New-CardTextBlock -Text (New-CardTemplateTag -TagName "UserName")
    New-CardTextBlock -Text (New-CardTemplateTag -TagName "Message")
    New-CardTextBlock -Text (New-CardTemplateTag -TagName "UserName")  # Duplicate
}
```

Find-CardTemplateTags -Content $template
# Returns: @("UserName", "Message")

### EXAMPLE 2
```
$complexTemplate = New-CardContainer -Content {
    New-CardTextBlock -Text "Welcome, !{{Name}}!"
    New-CardFactSet -Facts @{
        "Department" = (New-CardTemplateTag -TagName "Dept")
        "Role" = (New-CardTemplateTag -TagName "Position")
    }
}
```

$tags = Find-CardTemplateTags -Content $complexTemplate
# Returns: @("Name", "Dept", "Position")

### EXAMPLE 3
```
$noTagsTemplate = New-CardContainer -Content {
    New-CardTextBlock -Text "Static content only"
}
```

Find-CardTemplateTags -Content $noTagsTemplate
# Returns: @() (empty array)

## PARAMETERS

### -Content
A hashtable representing the Adaptive Card content structure to search for template tags.
This is typically the output from card creation functions like New-CardContainer, New-CardTextBlock, etc.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### System.String[]
###     Returns an array of unique template tag names found within the content structure.
###     Returns an empty array if no template tags are found.
## NOTES
- The function performs a deep search through the entire content structure by converting to JSON
- Template tags must be in the exact format "!{{TagName}}" to be detected
- Duplicate tag names are automatically deduplicated in the results
- The function is case-sensitive and will treat "!{{Name}}" and "!{{name}}" as different tags
- This function is typically used for template validation and debugging purposes

## RELATED LINKS

[New-CardTemplateTag]()

[Build-CardFromTemplate]()

