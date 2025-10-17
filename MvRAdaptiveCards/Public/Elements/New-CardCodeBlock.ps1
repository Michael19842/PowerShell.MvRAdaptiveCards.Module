

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