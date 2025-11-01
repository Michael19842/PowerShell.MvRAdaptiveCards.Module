BeforeAll {
    # Import the module
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MvRAdaptiveCards\MvRAdaptiveCards.psd1'
    Import-Module $ModulePath -Force -ArgumentList $false, $true
}

Describe "New-CardRichTextBlock" {

    Context "Basic Functionality" {
        It "Should create a RichTextBlock with simple text" {
            $result = New-CardRichTextBlock -Text "Simple text"

            $result | Should -Not -BeNullOrEmpty
            $result | Should -BeOfType [hashtable]
            $result.type | Should -Be "RichTextBlock"
            $result.inlines | Should -Not -BeNullOrEmpty
        }

        It "Should return a hashtable" {
            $result = New-CardRichTextBlock -Text "Test"
            $result | Should -BeOfType [hashtable]
        }

        It "Should have inlines array" {
            $result = New-CardRichTextBlock -Text "Test"
            $result.inlines -is [array] | Should -Be $true
        }

        It "Should handle empty text" {
            $result = New-CardRichTextBlock -Text ""
            $result | Should -Not -BeNullOrEmpty
            $result.type | Should -Be "RichTextBlock"
        }
    }

    Context "Bold Formatting" {
        It "Should parse bold tag" {
            $result = New-CardRichTextBlock -Text "This is {{bold}}bold text{{/bold}}."

            $result.inlines | Should -HaveCount 3
            $result.inlines[1].weight | Should -Be "Bolder"
        }

        It "Should support bold alias tags" {
            @('bold', 'bolder', 'strong', 'b') | ForEach-Object {
                $result = New-CardRichTextBlock -Text "{{$_}}text{{/$_}}"
                $result.inlines[0].weight | Should -Be "Bolder"
            }
        }

        It "Should handle nested bold tags" {
            $result = New-CardRichTextBlock -Text "{{bold}}Outer {{bold}}Inner{{/bold}} text{{/bold}}"
            $result.inlines | Should -Not -BeNullOrEmpty
        }
    }

    Context "Italic Formatting" {
        It "Should parse italic tag" {
            $result = New-CardRichTextBlock -Text "This is {{italic}}italic text{{/italic}}."

            $result.inlines[1].italic | Should -Be $true
        }

        It "Should support italic alias tags" {
            @('italic', 'em', 'i') | ForEach-Object {
                $result = New-CardRichTextBlock -Text "{{$_}}text{{/$_}}"
                $result.inlines[0].italic | Should -Be $true
            }
        }
    }

    Context "Color Formatting" {
        It "Should parse color tag" {
            $result = New-CardRichTextBlock -Text "This is {{color:Good}}green text{{/color}}."

            $result.inlines[1].color | Should -Be "Good"
        }

        It "Should support all valid colors" {
            $validColors = @("Default", "Dark", "Light", "Accent", "Good", "Warning", "Attention")

            foreach ($color in $validColors) {
                $result = New-CardRichTextBlock -Text "{{color:$color}}text{{/color}}"
                $result.inlines[0].color | Should -Be $color
            }
        }

        It "Should handle nested colors correctly" {
            $result = New-CardRichTextBlock -Text "{{color:Good}}Outer {{color:Attention}}Inner{{/color}} Back{{/color}}"

            $result.inlines | Should -HaveCount 3
            $result.inlines[0].color | Should -Be "Good"
            $result.inlines[1].color | Should -Be "Attention"
            $result.inlines[2].color | Should -Be "Good"
        }
    }

    Context "Size Formatting" {
        It "Should parse size shorthand tags" {
            @{
                'small'      = 'Small'
                'medium'     = 'Medium'
                'large'      = 'Large'
                'extraLarge' = 'ExtraLarge'
            }.GetEnumerator() | ForEach-Object {
                $result = New-CardRichTextBlock -Text "{{$($_.Key)}}text{{/$($_.Key)}}"
                $result.inlines[0].size | Should -Be $_.Value
            }
        }

        It "Should parse size tag with value" {
            $result = New-CardRichTextBlock -Text "{{size:Large}}text{{/size}}"
            $result.inlines[0].size | Should -Be "Large"
        }
    }

    Context "Weight Formatting" {
        It "Should parse lighter tag" {
            $result = New-CardRichTextBlock -Text "{{lighter}}text{{/lighter}}"
            $result.inlines[0].weight | Should -Be "Lighter"
        }

        It "Should parse weight tag with value" {
            @("Lighter", "Default", "Bolder") | ForEach-Object {
                $result = New-CardRichTextBlock -Text "{{weight:$_}}text{{/weight}}"
                $result.inlines[0].weight | Should -Be $_
            }
        }
    }

    Context "Text Decoration" {
        It "Should parse strikethrough tag" {
            @('strikethrough', 'strike', 's') | ForEach-Object {
                $result = New-CardRichTextBlock -Text "{{$_}}text{{/$_}}"
                $result.inlines[0].strikethrough | Should -Be $true
            }
        }

        It "Should parse underline tag" {
            @('underline', 'u') | ForEach-Object {
                $result = New-CardRichTextBlock -Text "{{$_}}text{{/$_}}"
                $result.inlines[0].underline | Should -Be $true
            }
        }

        It "Should parse highlight tag" {
            @('highlight', 'mark') | ForEach-Object {
                $result = New-CardRichTextBlock -Text "{{$_}}text{{/$_}}"
                $result.inlines[0].highlight | Should -Be $true
            }
        }
    }

    Context "Font Type" {
        It "Should parse monospace tag" {
            @('monospace', 'mono', 'code') | ForEach-Object {
                $result = New-CardRichTextBlock -Text "{{$_}}text{{/$_}}"
                $result.inlines[0].fontType | Should -Be "Monospace"
            }
        }

        It "Should parse fontType tag with value" {
            @("Default", "Monospace") | ForEach-Object {
                $result = New-CardRichTextBlock -Text "{{fontType:$_}}text{{/fontType}}"
                $result.inlines[0].fontType | Should -Be $_
            }
        }
    }

    Context "Visibility and Subtle" {
        It "Should parse hidden tag" {
            @('hidden', 'invisible') | ForEach-Object {
                $result = New-CardRichTextBlock -Text "{{$_}}text{{/$_}}"
                $result.inlines[0].isVisible | Should -Be $false
            }
        }

        It "Should parse subtle tag" {
            @('sub', 'subtitle', 'subtle') | ForEach-Object {
                $result = New-CardRichTextBlock -Text "{{$_}}text{{/$_}}"
                $result.inlines[0].isSubtle | Should -Be $true
            }
        }
    }

    Context "Language Tag" {
        It "Should parse lang tag" {
            @('lang', 'language') | ForEach-Object {
                $result = New-CardRichTextBlock -Text "{{${_}:en-US}}text{{/$_}}"
                $result.inlines[0].lang | Should -Be "en-US"
            }
        }
    }

    Context "Combined Formatting" {
        It "Should handle multiple nested tags" {
            $result = New-CardRichTextBlock -Text "{{bold}}{{color:Good}}Bold Green{{/color}}{{/bold}}"

            $result.inlines[0].weight | Should -Be "Bolder"
            $result.inlines[0].color | Should -Be "Good"
        }

        It "Should handle complex nested formatting" {
            $text = "{{bold}}{{italic}}{{color:Accent}}Complex{{/color}}{{/italic}}{{/bold}}"
            $result = New-CardRichTextBlock -Text $text

            $result.inlines[0].weight | Should -Be "Bolder"
            $result.inlines[0].italic | Should -Be $true
            $result.inlines[0].color | Should -Be "Accent"
        }

        It "Should handle text before, between, and after tags" {
            $text = "Start {{bold}}Middle{{/bold}} End"
            $result = New-CardRichTextBlock -Text $text

            $result.inlines | Should -HaveCount 3
            $result.inlines[0].text | Should -Be "Start "
            $result.inlines[1].text | Should -Be "Middle"
            $result.inlines[1].weight | Should -Be "Bolder"
            $result.inlines[2].text | Should -Be " End"
        }
    }

    Context "Actions" {
        It "Should parse action tag with NamedSelectActions" {
            $actions = @{
                "testAction" = { New-CardActionOpenUrl -Url "https://example.com" }
            }

            $result = New-CardRichTextBlock -Text "Click {{action:testAction}}here{{/action}}" -NamedSelectActions $actions

            $result.inlines[1].selectAction | Should -Not -BeNullOrEmpty
        }

        It "Should throw error if action name not found" {
            $actions = @{
                "testAction" = { New-CardActionOpenUrl -Url "https://example.com" }
            }

            { New-CardRichTextBlock -Text "{{action:missingAction}}text{{/action}}" -NamedSelectActions $actions } | Should -Throw
        }

        It "Should validate NamedSelectActions contains scriptblocks" {
            $invalidActions = @{
                "badAction" = "not a scriptblock"
            }

            { New-CardRichTextBlock -Text "test" -NamedSelectActions $invalidActions } | Should -Throw
        }
    }

    Context "Block-Level Properties" {
        It "Should set Id parameter" {
            $result = New-CardRichTextBlock -Text "Test" -Id "myRichText"
            $result.id | Should -Be "myRichText"
        }

        It "Should set HorizontalAlignment" {
            @("Left", "Center", "Right", "Justify") | ForEach-Object {
                $result = New-CardRichTextBlock -Text "Test" -HorizontalAlignment $_
                $result.horizontalAlignment | Should -Be $_
            }
        }

        It "Should validate HorizontalAlignment values" {
            { New-CardRichTextBlock -Text "Test" -HorizontalAlignment "Invalid" } | Should -Throw
        }

        It "Should set FontType parameter" {
            @("Default", "Monospace") | ForEach-Object {
                $result = New-CardRichTextBlock -Text "Test" -FontType $_
                $result.fontType | Should -Be $_
            }
        }

        It "Should set Size parameter" {
            @("Small", "Default", "Medium", "Large", "ExtraLarge") | ForEach-Object {
                $result = New-CardRichTextBlock -Text "Test" -Size $_
                $result.size | Should -Be $_
            }
        }

        It "Should set Weight parameter" {
            @("Lighter", "Default", "Bolder") | ForEach-Object {
                $result = New-CardRichTextBlock -Text "Test" -Weight $_
                $result.weight | Should -Be $_
            }
        }

        It "Should set Separator switch" {
            $result = New-CardRichTextBlock -Text "Test" -Separator
            $result.separator | Should -Be $true
        }
    }

    Context "Template Tag Preservation" {
        It "Should preserve template tags with ! prefix" {
            $result = New-CardRichTextBlock -Text "Value: !{{TemplateName}}"

            $result.inlines[0].text | Should -Match '!\{\{TemplateName\}\}'
        }

        It "Should handle mixed template and formatting tags" {
            $result = New-CardRichTextBlock -Text "{{bold}}Name: !{{userName}}{{/bold}}"

            $result.inlines[0].weight | Should -Be "Bolder"
            $result.inlines[0].text | Should -Match '!\{\{userName\}\}'
        }
    }

    Context "Error Handling" {
        It "Should throw error for unclosed tags" {
            { New-CardRichTextBlock -Text "{{bold}}unclosed" } | Should -Throw
        }

        It "Should throw error for closing tag without opening" {
            { New-CardRichTextBlock -Text "{{/bold}}unopened" } | Should -Throw
        }

        It "Should warn on unknown tags but not throw" {
            { New-CardRichTextBlock -Text "{{unknownTag}}test{{/unknownTag}}" -WarningAction SilentlyContinue } | Should -Not -Throw
        }
    }

    Context "Integration with Adaptive Card" {
        It "Should work within New-AdaptiveCard" {
            $card = New-AdaptiveCard {
                New-CardRichTextBlock -Text "{{bold}}Bold{{/bold}} text"
            } -AsObject

            $card.body | Should -HaveCount 1
            $card.body[0].type | Should -Be "RichTextBlock"
        }

        It "Should work with multiple RichTextBlocks" {
            $card = New-AdaptiveCard {
                New-CardRichTextBlock -Text "{{color:Good}}First{{/color}}"
                New-CardRichTextBlock -Text "{{color:Attention}}Second{{/color}}"
            } -AsObject

            $card.body | Should -HaveCount 2
        }
    }

    Context "Complex Real-World Examples" {
        It "Should handle status report example" {
            $text = @"
{{size:Large}}{{bold}}System Status{{/bold}}{{/size}}
{{color:Good}}All systems operational{{/color}}
{{color:Warning}}Minor issues detected{{/color}}
"@

            $result = New-CardRichTextBlock -Text $text
            $result.inlines.Count | Should -BeGreaterThan 1
        }

        It "Should handle formatted list" {
            $text = @"
{{bold}}Features:{{/bold}}
- {{color:Good}}Fast{{/color}}
- {{color:Accent}}Reliable{{/color}}
- {{strikethrough}}Expensive{{/strikethrough}} {{color:Good}}Free! {{/color}}
"@

            $result = New-CardRichTextBlock -Text $text
            $result | Should -Not -BeNullOrEmpty
        }

        It "Should handle code formatting" {
            $text = "Code: {{monospace}}{{highlight}}Get-Process{{/highlight}}{{/monospace}}"
            $result = New-CardRichTextBlock -Text $text

            $result.inlines | Should -HaveCount 2
            $result.inlines[1].fontType | Should -Be "Monospace"
            $result.inlines[1].highlight | Should -Be $true
        }
    }

    Context "ShouldProcess Support" {
        It "Should support WhatIf" {
            $result = New-CardRichTextBlock -Text "Test" -WhatIf
            $result | Should -BeNullOrEmpty
        }
    }

    Context "Edge Cases" {
        It "Should handle empty tags" {
            $result = New-CardRichTextBlock -Text "{{bold}}{{/bold}}"
            $result.inlines | Should -BeNullOrEmpty
        }

        It "Should handle whitespace in tags" {
            $result = New-CardRichTextBlock -Text "Test {{bold}}  {{/bold}} text"
            $result.inlines | Should -HaveCount 3
        }

        It "Should handle unicode text" {
            $result = New-CardRichTextBlock -Text "{{bold}}Unicode: 你好 🎉{{/bold}}"
            $result.inlines[0].text | Should -Match "你好"
        }

        It "Should handle very long text" {
            $longText = "A" * 5000
            $result = New-CardRichTextBlock -Text "{{bold}}$longText{{/bold}}"
            $result.inlines[0].text.Length | Should -Be 5000
        }

        It "Should handle multiple consecutive tags" {
            $result = New-CardRichTextBlock -Text "{{bold}}{{italic}}{{underline}}Text{{/underline}}{{/italic}}{{/bold}}"

            $result.inlines[0].weight | Should -Be "Bolder"
            $result.inlines[0].italic | Should -Be $true
            $result.inlines[0].underline | Should -Be $true
        }

        It "Should handle special characters" {
            $result = New-CardRichTextBlock -Text "{{bold}}Special: <>&\'{{/bold}}"
            $result.inlines[0].text | Should -Match "Special:"
        }
    }

    Context "Command Metadata" {
        It "Should have correct command name" {
            $command = Get-Command New-CardRichTextBlock
            $command.Name | Should -Be "New-CardRichTextBlock"
        }

        It "Should support ShouldProcess" {
            $command = Get-Command New-CardRichTextBlock
            $command.CmdletBinding | Should -Match $true
        }

        It "Should have help documentation" {
            $help = Get-Help New-CardRichTextBlock
            $help.Synopsis | Should -Not -BeNullOrEmpty
            $help.Description | Should -Not -BeNullOrEmpty
        }

        It "Should have examples in help" {
            $help = Get-Help New-CardRichTextBlock -Full
            $help.Examples | Should -Not -BeNullOrEmpty
            $help.Examples.Example.Count | Should -BeGreaterThan 0
        }

        It "Should have parameter descriptions" {
            $help = Get-Help New-CardRichTextBlock -Full
            $help.parameters.parameter | Should -Not -BeNullOrEmpty
        }
    }
}
