---
external help file: MvRAdaptiveCards-help.xml
Module Name: MvRAdaptiveCards
online version: https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#codeblock
schema: 2.0.0
---

# New-CardCodeBlock

## SYNOPSIS
Creates a new CodeBlock element for an Adaptive Card to display formatted code snippets.

## SYNTAX

```
New-CardCodeBlock [[-CodeSnippet] <String>] [[-Language] <String>] [[-Wrap] <Boolean>]
 [[-Fallback] <ScriptBlock>] [[-Id] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-CardCodeBlock function creates a CodeBlock element that displays code with syntax highlighting
in an Adaptive Card.
It supports multiple programming languages and provides options for text wrapping
and fallback content for clients that don't support code blocks.

## EXAMPLES

### EXAMPLE 1
```
New-CardCodeBlock -CodeSnippet 'Write-Host "Hello, World!"' -Language "powershell"
```

Creates a code block displaying a PowerShell command with syntax highlighting.

### EXAMPLE 2
```
$jsonCode = @'
{
"name": "John Doe",
"age": 30,
"active": true
}
'@
New-CardCodeBlock -CodeSnippet $jsonCode -Language "json" -Id "JsonExample"
```

Creates a JSON code block with an ID for reference.

### EXAMPLE 3
```
New-CardCodeBlock -Text "SELECT * FROM Users WHERE Active = 1" -Language "sql" -Wrap $false
```

Creates a SQL code block without text wrapping (using the 'Text' alias for CodeSnippet).

### EXAMPLE 4
```
New-CardCodeBlock -CodeSnippet "function hello() { console.log('Hello!'); }" -Language "javascript" -Fallback {
    New-CardTextBlock -Text "JavaScript code: function hello() { console.log('Hello!'); }"
}
```

Creates a JavaScript code block with fallback content for unsupported clients.

## PARAMETERS

### -CodeSnippet
The code content to display in the code block.
Can contain multi-line code snippets.
This parameter has an alias 'Text' for convenience.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Text

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Language
The programming language for syntax highlighting.
Supported languages include:
- plaintext (default): No syntax highlighting
- csharp: C# programming language
- cpp: C++ programming language  
- css: Cascading Style Sheets
- dockerfile: Docker configuration files
- fsharp: F# programming language
- go: Go programming language
- html: HTML markup
- ini: Configuration files
- java: Java programming language
- javascript: JavaScript
- json: JSON data format
- kotlin: Kotlin programming language
- less: LESS CSS preprocessor
- lua: Lua scripting language
- markdown: Markdown markup
- objectivec: Objective-C
- perl: Perl scripting language
- php: PHP programming language
- powershell: PowerShell scripting
- python: Python programming language
- r: R statistical language
- ruby: Ruby programming language
- rust: Rust programming language
- scss: SCSS/Sass CSS preprocessor
- shell: Shell/Bash scripts
- sql: SQL database language
- swift: Swift programming language
- typescript: TypeScript
- vb: Visual Basic
- xml: XML markup
- yaml: YAML data format
Default value is "plaintext".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Plaintext
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wrap
A boolean value that controls text wrapping within the code block.
When $true (default),
long lines will wrap to fit within the available width.
When $false, long lines may be truncated or require horizontal scrolling.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fallback
A ScriptBlock that generates fallback content for clients that don't support CodeBlock elements.
The fallback content will be displayed instead of the code block on unsupported clients.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
An optional unique identifier for the CodeBlock element.
Useful for referencing the element
in actions like toggle visibility or for accessibility purposes.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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

### System.Collections.Hashtable
### Returns a hashtable representing the CodeBlock element structure for the Adaptive Card.
## NOTES
- CodeBlock elements are supported in Adaptive Cards schema version 1.2 and later
- Syntax highlighting appearance depends on the host application's implementation
- The Fallback parameter helps ensure graceful degradation on older or limited clients
- Language detection is not automatic; the correct language must be specified for proper highlighting
- Multi-line code snippets are fully supported and recommended for better readability

## RELATED LINKS

[https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#codeblock](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#codeblock)

