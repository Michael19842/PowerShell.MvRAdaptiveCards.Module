---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version:
schema: 2.0.0
---

# Build-CardFromTemplate

## SYNOPSIS
Builds a complete Adaptive Card by replacing template tags with actual content.

## SYNTAX

```
Build-CardFromTemplate [[-Content] <Hashtable>] [[-Tags] <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
The Build-CardFromTemplate function takes a template-based Adaptive Card content structure
and replaces all template tag placeholders with actual data.
It supports both simple string/value
replacements and complex ScriptBlock-based dynamic content generation, enabling the creation
of reusable card templates that can be populated with different data sets.

## EXAMPLES

### EXAMPLE 1
```
$template = New-CardContainer -Content {
    New-CardTextBlock -Text (New-CardTemplateTag -TagName "Greeting")
    New-CardTextBlock -Text (New-CardTemplateTag -TagName "UserName")
}
```

$card = Build-CardFromTemplate -Content $template -Tags @{
    Greeting = "Welcome!"
    UserName = "John Doe"
}

Replaces the template tags with simple string values.

### EXAMPLE 2
```
$template = New-CardContainer -Content {
    New-CardTextBlock -Text (New-CardTemplateTag -TagName "Message")
    New-CardTemplateTag -TagName "DynamicContent"
}
```

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

### EXAMPLE 3
```
$userTemplate = New-CardContainer -Content {
    New-CardTextBlock -Text "User: !{{Name}}"
    New-CardTemplateTag -TagName "UserDetails"
} -Id (New-CardTemplateTag -TagName "ContainerID")
```

$users = @("Alice", "Bob", "Charlie")
$cards = foreach ($user in $users) {
    Build-CardFromTemplate -Content $userTemplate -Tags @{
        Name = $user
        UserDetails = { New-CardTextBlock -Text "Welcome, $user!" }
        ContainerID = "User_$user"
    }
}

Demonstrates creating multiple cards from a single template with different data.

## PARAMETERS

### -Content
A hashtable representing the Adaptive Card template content structure containing template tags
to be replaced.
This is typically created using card creation functions with New-CardTemplateTag placeholders.

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

### -Tags
A hashtable where keys are template tag names (without the !{{ }} wrapper) and values are
the replacement content.
Values can be:
- Strings, numbers, booleans: Replaced directly
- ScriptBlocks: Executed to generate dynamic content
- Objects/Arrays: Converted to JSON and inserted as structured content

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Collections.Hashtable
### Returns a hashtable representing the completed Adaptive Card content with all template tags replaced.
## NOTES
- Template tag names in the Tags hashtable should not include the !{{ }} wrapper syntax
- ScriptBlocks in tag values are executed in the current scope and can access variables
- The function performs deep replacement through the entire content structure
- Warnings are generated for tags specified in the Tags parameter but not found in the template
- String values are JSON-escaped to ensure proper integration into the card structure
- Complex objects and arrays are serialized to JSON for structured content insertion
- The function uses ConvertFrom-JsonAsHashtable for reliable JSON-to-hashtable conversion

## RELATED LINKS

[New-CardTemplateTag]()

[Find-CardTemplateTags]()

