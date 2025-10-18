---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version:
schema: 2.0.0
---

# New-CardTemplateTag

## SYNOPSIS
Creates a template tag placeholder that can be replaced with dynamic content in Adaptive Cards.

## SYNTAX

```
New-CardTemplateTag [-TagName] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-CardTemplateTag function generates a template tag placeholder string in the format "!{{TagName}}"
that can be used within Adaptive Card templates.
These placeholders are later replaced with actual
content using the Build-CardFromTemplate function, enabling dynamic and reusable card templates.

## EXAMPLES

### EXAMPLE 1
```
New-CardTemplateTag -TagName "UserName"
```

Returns: "!{{UserName}}"

### EXAMPLE 2
```
New-CardTextBlock -Text (New-CardTemplateTag -TagName "WelcomeMessage") -Size "Large"
```

Creates a text block with a template tag that can be replaced later with dynamic content.

### EXAMPLE 3
```
$template = New-CardContainer -Content {
    New-CardTextBlock -Text (New-CardTemplateTag -TagName "Title")
    New-CardTextBlock -Text (New-CardTemplateTag -TagName "Description")
}
```

Creates a container template with two replaceable text sections.

## PARAMETERS

### -TagName
The name of the template tag to create.
This should be a unique identifier that will be used
to reference and replace the tag with actual content later.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
### Returns a template tag string in the format "!{{TagName}}".
## NOTES
- Template tags use the format "!{{TagName}}" to avoid conflicts with other templating systems
- The TagName should be descriptive and unique within the template
- Template tags can be used in any string property of Adaptive Card elements
- Tags are case-sensitive when used with Build-CardFromTemplate
- This function is typically used during template creation, not during runtime card generation

## RELATED LINKS

[Build-CardFromTemplate]()

[Find-CardTemplateTags]()

