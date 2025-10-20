BeforeAll {
    # Import the module
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MvRAdaptiveCards\MvRAdaptiveCards.psd1'
    Import-Module $ModulePath -Force
}

Describe 'New-CardTextBlock' {

    Context 'Basic Functionality' {
        It 'Should create a basic TextBlock with minimal parameters' {
            $result = New-CardTextBlock -Text "Hello World"

            $result | Should -BeOfType [hashtable]
            $result.type | Should -Be "TextBlock"
            $result.text | Should -Be "Hello World"
            $result.size | Should -BeNullOrEmpty
            $result.weight | Should -Be "Default"
            $result.color | Should -Be "Default"
        }

        It 'Should create TextBlock with all basic text properties' {
            $result = New-CardTextBlock -Text "Test Text" -Size "Large" -Weight "Bolder" -Color "Good"

            $result.text | Should -Be "Test Text"
            $result.size | Should -Be "Large"
            $result.weight | Should -Be "Bolder"
            $result.color | Should -Be "Good"
        }

        It 'Should handle empty text gracefully' {
            $result = New-CardTextBlock -Text ""

            $result.type | Should -Be "TextBlock"
            $result.text | Should -Be ""
        }

        It 'Should handle null text gracefully' {
            $result = New-CardTextBlock -Text $null

            $result.type | Should -Be "TextBlock"
            $result.text | Should -BeNullOrEmpty
        }
    }

    Context 'Text Formatting Parameters' {
        It 'Should accept all valid Size values' {
            $sizes = @("Small", "Default", "Medium", "Large", "ExtraLarge")

            foreach ($size in $sizes) {
                $result = New-CardTextBlock -Text "Test" -Size $size
                $result.size | Should -Be $size
            }
        }

        It 'Should accept all valid Weight values' {
            $weights = @("Default", "Lighter", "Bolder")

            foreach ($weight in $weights) {
                $result = New-CardTextBlock -Text "Test" -Weight $weight
                $result.weight | Should -Be $weight
            }
        }

        It 'Should accept all valid Color values' {
            $colors = @("Default", "Dark", "Light", "Accent", "Good", "Warning", "Attention")

            foreach ($color in $colors) {
                $result = New-CardTextBlock -Text "Test" -Color $color
                $result.color | Should -Be $color
            }
        }

        It 'Should accept all valid FontType values' {
            $fontTypes = @("Default", "Monospace")

            foreach ($fontType in $fontTypes) {
                $result = New-CardTextBlock -Text "Test" -FontType $fontType
                $result.fontType | Should -Be $fontType
            }
        }

        It 'Should not include FontType property when not specified' {
            $result = New-CardTextBlock -Text "Test"

            $result.ContainsKey('fontType') | Should -Be $false
        }
    }

    Context 'Layout and Alignment Parameters' {
        It 'Should set horizontal alignment when specified' {
            $alignments = @("Left", "Center", "Right")

            foreach ($alignment in $alignments) {
                $result = New-CardTextBlock -Text "Test" -HorizontalAlignment $alignment
                $result.horizontalAlignment | Should -Be $alignment
            }
        }

        It 'Should set height when specified' {
            $heights = @("auto", "stretch")

            foreach ($height in $heights) {
                $result = New-CardTextBlock -Text "Test" -Height $height
                $result.height | Should -Be $height
            }
        }

        It 'Should set grid area when specified' {
            $result = New-CardTextBlock -Text "Test" -GridArea "main-content"

            $result.gridArea | Should -Be "main-content"
        }

        It 'Should set spacing when specified' {
            $spacings = @("None", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")

            foreach ($spacing in $spacings) {
                $result = New-CardTextBlock -Text "Test" -Spacing $spacing
                $result.spacing | Should -Be $spacing
            }
        }
    }

    Context 'Text Style and Behavior' {
        It 'Should accept all valid Style values' {
            $styles = @("default", "columnHeader", "heading")

            foreach ($style in $styles) {
                $result = New-CardTextBlock -Text "Test" -Style $style
                $result.style | Should -Be $style
            }
        }

        It 'Should set wrap when Wrap switch is used' {
            $result = New-CardTextBlock -Text "Long text that should wrap" -Wrap

            $result.wrap | Should -Be $true
        }

        It 'Should not include wrap property when Wrap switch is not used' {
            $result = New-CardTextBlock -Text "Test"

            $result.ContainsKey('wrap') | Should -Be $false
        }

        It 'Should set maximum lines when specified' {
            $result = New-CardTextBlock -Text "Test" -MaximumNumberOfLines 3

            $result.maxLines | Should -Be 3
        }

        It 'Should set maximum lines using MaxLines alias' {
            $result = New-CardTextBlock -Text "Test" -MaxLines 5

            $result.maxLines | Should -Be 5
        }

        It 'Should set labelFor when specified' {
            $result = New-CardTextBlock -Text "Label:" -labelFor "input-field"

            $result.labelFor | Should -Be "input-field"
        }
    }

    Context 'Identification and Metadata' {
        It 'Should set ID when specified' {
            $result = New-CardTextBlock -Text "Test" -Id "text-001"

            $result.id | Should -Be "text-001"
        }

        It 'Should set language when specified' {
            $result = New-CardTextBlock -Text "Test" -Language "en-US"

            $result.lang | Should -Be "en-US"
        }

        It 'Should set language using Lang alias' {
            $result = New-CardTextBlock -Text "Test" -Lang "fr-FR"

            $result.lang | Should -Be "fr-FR"
        }

        It 'Should set requires when specified' {
            $requires = @{ "hostCapabilities" = @{ "adaptiveCards" = "1.3" } }
            $result = New-CardTextBlock -Text "Test" -Requires $requires

            $result.requires | Should -Be $requires
        }
    }

    Context 'Switch Parameters' {
        It 'Should set separator when Separator switch is used' {
            $result = New-CardTextBlock -Text "Test" -Separator

            $result.separator | Should -Be $true
        }

        It 'Should not include separator property when switch is not used' {
            $result = New-CardTextBlock -Text "Test"

            $result.ContainsKey('separator') | Should -Be $false
        }

        It 'Should set isSortKey when IsSortKey switch is used' {
            $result = New-CardTextBlock -Text "Test" -IsSortKey

            $result.isSortKey | Should -Be $true
        }

        It 'Should set isSubtle when IsSubtle switch is used' {
            $result = New-CardTextBlock -Text "Test" -IsSubtle

            $result.isSubtle | Should -Be $true
        }

        It 'Should set isVisible to false when IsHidden switch is used' {
            $result = New-CardTextBlock -Text "Test" -IsHidden

            $result.isVisible | Should -Be $false
        }

        It 'Should set isVisible to false when Hidden alias is used' {
            $result = New-CardTextBlock -Text "Test" -Hidden

            $result.isVisible | Should -Be $false
        }

        It 'Should not include visibility property when IsHidden is not used' {
            $result = New-CardTextBlock -Text "Test"

            $result.ContainsKey('isVisible') | Should -Be $false
        }
    }

    Context 'Fallback Functionality' {
        It 'Should execute fallback scriptblock when provided' {
            $result = New-CardTextBlock -Text "Test" -Fallback {
                @{
                    type = "TextBlock"
                    text = "Fallback text"
                }
            }

            $result.fallback | Should -Not -BeNullOrEmpty
            $result.fallback.type | Should -Be "TextBlock"
            $result.fallback.text | Should -Be "Fallback text"
        }

        It 'Should not include fallback property when not specified' {
            $result = New-CardTextBlock -Text "Test"

            $result.ContainsKey('fallback') | Should -Be $false
        }

        It 'Should handle complex fallback scriptblock' {
            $result = New-CardTextBlock -Text "Test" -Fallback {
                @{
                    type  = "Container"
                    items = @(
                        @{ type = "TextBlock"; text = "Complex fallback" }
                    )
                }
            }

            $result.fallback.type | Should -Be "Container"
            $result.fallback.items[0].text | Should -Be "Complex fallback"
        }
    }

    Context 'Complex Scenarios' {
        It 'Should handle all parameters together' {
            $requires = @{ "hostCapabilities" = @{ "adaptiveCards" = "1.3" } }

            $result = New-CardTextBlock -Text "Complete Example" -Size "Large" -Weight "Bolder" -Color "Accent" -FontType "Default" -Style "heading" -Height "auto" -HorizontalAlignment "Center" -GridArea "header" -Spacing "Medium" -Language "en-US" -Id "main-heading" -labelFor "content" -MaximumNumberOfLines 2 -Requires $requires -Separator -Wrap -IsSortKey -IsSubtle -Fallback {
                @{ type = "TextBlock"; text = "Fallback" }
            }

            $result.type | Should -Be "TextBlock"
            $result.text | Should -Be "Complete Example"
            $result.size | Should -Be "Large"
            $result.weight | Should -Be "Bolder"
            $result.color | Should -Be "Accent"
            $result.fontType | Should -Be "Default"
            $result.style | Should -Be "heading"
            $result.height | Should -Be "auto"
            $result.horizontalAlignment | Should -Be "Center"
            $result.gridArea | Should -Be "header"
            $result.spacing | Should -Be "Medium"
            $result.lang | Should -Be "en-US"
            $result.id | Should -Be "main-heading"
            $result.labelFor | Should -Be "content"
            $result.maxLines | Should -Be 2
            $result.requires | Should -Be $requires
            $result.separator | Should -Be $true
            $result.wrap | Should -Be $true
            $result.isSortKey | Should -Be $true
            $result.isSubtle | Should -Be $true
            $result.fallback.text | Should -Be "Fallback"
        }

        It 'Should create proper TextBlock for different content types' {
            $scenarios = @(
                @{ text = "Regular text"; expected = "Regular text" }
                @{ text = "Text with **markdown**"; expected = "Text with **markdown**" }
                @{ text = "Line 1`nLine 2"; expected = "Line 1`nLine 2" }
                @{ text = "Text with 'quotes'"; expected = "Text with 'quotes'" }
                @{ text = "Text with numbers 123"; expected = "Text with numbers 123" }
            )

            foreach ($scenario in $scenarios) {
                $result = New-CardTextBlock -Text $scenario.text
                $result.text | Should -Be $scenario.expected
            }
        }

        It 'Should create TextBlock for accessibility scenarios' {
            $result = New-CardTextBlock -Text "Email Address:" -labelFor "email-input" -Id "email-label" -Weight "Bolder"

            $result.text | Should -Be "Email Address:"
            $result.labelFor | Should -Be "email-input"
            $result.id | Should -Be "email-label"
            $result.weight | Should -Be "Bolder"
        }
    }

    Context 'ShouldProcess Support' {
        It 'Should support WhatIf parameter' {
            $result = New-CardTextBlock -Text "Test" -WhatIf

            # WhatIf should not return anything
            $result | Should -BeNullOrEmpty
        }

        It 'Should return TextBlock when not using WhatIf' {
            $result = New-CardTextBlock -Text "Test"

            $result | Should -Not -BeNullOrEmpty
            $result.type | Should -Be "TextBlock"
        }
    }

    Context 'Parameter Validation' {
        It 'Should throw error for invalid Size values' {
            { New-CardTextBlock -Text "Test" -Size "Invalid" } | Should -Throw
        }

        It 'Should throw error for invalid Weight values' {
            { New-CardTextBlock -Text "Test" -Weight "Invalid" } | Should -Throw
        }

        It 'Should throw error for invalid Color values' {
            { New-CardTextBlock -Text "Test" -Color "Invalid" } | Should -Throw
        }

        It 'Should throw error for invalid FontType values' {
            { New-CardTextBlock -Text "Test" -FontType "Invalid" } | Should -Throw
        }

        It 'Should throw error for invalid Style values' {
            { New-CardTextBlock -Text "Test" -Style "Invalid" } | Should -Throw
        }

        It 'Should throw error for invalid Height values' {
            { New-CardTextBlock -Text "Test" -Height "Invalid" } | Should -Throw
        }

        It 'Should throw error for invalid HorizontalAlignment values' {
            { New-CardTextBlock -Text "Test" -HorizontalAlignment "Invalid" } | Should -Throw
        }

        It 'Should throw error for invalid Spacing values' {
            { New-CardTextBlock -Text "Test" -Spacing "Invalid" } | Should -Throw
        }
    }

    Context 'Edge Cases' {
        It 'Should handle very long text' {
            $longText = "A" * 1000
            $result = New-CardTextBlock -Text $longText

            $result.text | Should -Be $longText
            $result.text.Length | Should -Be 1000
        }

        It 'Should handle special characters' {
            $specialText = 'Text with special chars: !@#$%^&*()_+-=[]{}|;\'':",.<>?'
            $result = New-CardTextBlock -Text $specialText

            $result.text | Should -Be $specialText
        }

        It 'Should handle Unicode characters' {
            $unicodeText = "Unicode: 你好 🌍 🚀 ♥️"
            $result = New-CardTextBlock -Text $unicodeText

            $result.text | Should -Be $unicodeText
        }

        It 'Should handle zero as MaximumNumberOfLines' {
            $result = New-CardTextBlock -Text "Test" -MaximumNumberOfLines 0

            $result.maxLines | Should -Be 0
        }

        It 'Should handle negative numbers for MaximumNumberOfLines' {
            # This might throw an error or be handled gracefully depending on validation
            $result = New-CardTextBlock -Text "Test" -MaximumNumberOfLines -1

            $result.maxLines | Should -Be -1
        }

        It 'Should preserve text formatting and whitespace' {
            $formattedText = " Indented text `n Another line "
            $result = New-CardTextBlock -Text $formattedText

            $result.text | Should -Be $formattedText
        }
    }

    Context 'Default Values' {
        It 'Should use correct default values' {
            $result = New-CardTextBlock -Text "Test"

            $result.weight | Should -Be "Default"
            $result.color | Should -Be "Default"
            $result.ContainsKey('size') | Should -Be $false  # size is not set by default
        }

        It 'Should override default values when specified' {
            $result = New-CardTextBlock -Text "Test" -Weight "Bolder" -Color "Accent"

            $result.weight | Should -Be "Bolder"
            $result.color | Should -Be "Accent"
        }
    }
}