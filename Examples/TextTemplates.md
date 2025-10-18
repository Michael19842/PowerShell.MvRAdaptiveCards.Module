# Text Replacement in Adaptive Card Templates

This document provides comprehensive examples and best practices for using the MvRAdaptiveCards template system to create dynamic, reusable Adaptive Cards with text replacement capabilities.

## Template System Overview

The MvRAdaptiveCards module provides a powerful templating system that allows you to create reusable card templates with replaceable content. The system uses three main functions:

- **`New-CardTemplateTag`** - Creates placeholder tags in the format `!{{TagName}}`
- **`Find-CardTemplateTags`** - Discovers all template tags within a card structure
- **`Build-CardFromTemplate`** - Replaces template tags with actual content

### Template Tag Format
Template tags use the format `!{{TagName}}` to avoid conflicts with other templating systems:
```powershell
New-CardTemplateTag -TagName "UserName"
# Returns: "!{{UserName}}"
```

## 📝 Basic Text Replacement

### Simple String Replacement

The most basic use case is replacing template tags with simple text values:

```powershell
# Create a template with placeholder text
$template = New-CardContainer -Content {
    New-CardTextBlock -Text (New-CardTemplateTag -TagName "WelcomeMessage") -Size "Large" -Weight "Bolder"
    New-CardTextBlock -Text "Hello, !{{UserName}}! Welcome to our application." -Wrap
    New-CardTextBlock -Text "Your role is: !{{UserRole}}" -Color "Accent"
}

# Replace template tags with actual values
$personalizedCard = Build-CardFromTemplate -Content $template -Tags @{
    WelcomeMessage = "Welcome Back!"
    UserName = "Michael"
    UserRole = "Administrator"
}

# Create the final card
New-AdaptiveCard -Content { $personalizedCard } | Out-OnlineDesigner
```

### Multiple Value Replacement

You can replace multiple occurrences of the same tag throughout a template:

```powershell
$template = New-CardContainer -Content {
    New-CardTextBlock -Text "Welcome !{{Name}}" -Size "Large"
    New-CardTextBlock -Text "Dear !{{Name}}, your account status is: !{{Status}}"
    New-CardTextBlock -Text "Thank you !{{Name}} for using our service!"
}

$card = Build-CardFromTemplate -Content $template -Tags @{
    Name = "Alice Johnson"
    Status = "Active"
}

New-AdaptiveCard -Content { $card } | Out-OnlineDesigner
```
