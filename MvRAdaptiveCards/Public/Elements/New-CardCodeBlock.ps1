

<#
.SYNOPSIS
    Creates a new CodeBlock element for an Adaptive Card to display formatted code snippets.

.DESCRIPTION
    The New-CardCodeBlock function creates a CodeBlock element that displays code with syntax highlighting
    in an Adaptive Card. It supports multiple programming languages and provides options for text wrapping
    and fallback content for clients that don't support code blocks.

.PARAMETER CodeSnippet
    The code content to display in the code block. Can contain multi-line code snippets.
    This parameter has an alias 'Text' for convenience.

.PARAMETER Language
    The programming language for syntax highlighting. Supported languages include:
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

.PARAMETER Wrap
    A boolean value that controls text wrapping within the code block. When $true (default),
    long lines will wrap to fit within the available width. When $false, long lines may be truncated or require horizontal scrolling.

.PARAMETER Fallback
    A ScriptBlock that generates fallback content for clients that don't support CodeBlock elements.
    The fallback content will be displayed instead of the code block on unsupported clients.

.PARAMETER Id
    An optional unique identifier for the CodeBlock element. Useful for referencing the element
    in actions like toggle visibility or for accessibility purposes.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the CodeBlock element structure for the Adaptive Card.

.EXAMPLE
    New-CardCodeBlock -CodeSnippet 'Write-Host "Hello, World!"' -Language "powershell"
    
    Creates a code block displaying a PowerShell command with syntax highlighting.

.EXAMPLE
    $jsonCode = @'
{
    "name": "John Doe",
    "age": 30,
    "active": true
}
'@
    New-CardCodeBlock -CodeSnippet $jsonCode -Language "json" -Id "JsonExample"
    
    Creates a JSON code block with an ID for reference.

.EXAMPLE
    New-CardCodeBlock -Text "SELECT * FROM Users WHERE Active = 1" -Language "sql" -Wrap $false
    
    Creates a SQL code block without text wrapping (using the 'Text' alias for CodeSnippet).

.EXAMPLE
    New-CardCodeBlock -CodeSnippet "function hello() { console.log('Hello!'); }" -Language "javascript" -Fallback {
        New-CardTextBlock -Text "JavaScript code: function hello() { console.log('Hello!'); }"
    }
    
    Creates a JavaScript code block with fallback content for unsupported clients.

.NOTES
    - CodeBlock elements are supported in Adaptive Cards schema version 1.2 and later
    - Syntax highlighting appearance depends on the host application's implementation
    - The Fallback parameter helps ensure graceful degradation on older or limited clients
    - Language detection is not automatic; the correct language must be specified for proper highlighting
    - Multi-line code snippets are fully supported and recommended for better readability

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#codeblock
#>
function New-CardCodeBlock {
    param (
        [Alias('Text')][string]$CodeSnippet,
        [ValidateSet("plaintext", "csharp", "cpp", "css", "dockerfile", "fsharp", "go", "html", "ini",
    "java", "javascript", "json", "kotlin", "less", "lua", "markdown", "objectivec",
    "perl", "php", "powershell", "python", "r", "ruby", "rust", "scss", "shell",
    "sql", "swift", "typescript", "vb", "xml", "yaml")]
        [string]
        $Language = "plaintext",
        [bool]
        $Wrap = $true,
        [scriptblock]
        $Fallback,
        [string]
        [Parameter(Mandatory = $false)]
        $Id
    )

    $CodeBlock = @{
        type = "CodeBlock"
        codeSnippet = $CodeSnippet
        language = $Language
        wrap = $Wrap
    }

    if ($Fallback) {
        $CodeBlock.fallback = Invoke-Command -ScriptBlock $Fallback
    }

    if ($Id) {
        $CodeBlock.id = $Id
    }

    Return ($CodeBlock)

}