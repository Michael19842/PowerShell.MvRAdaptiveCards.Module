BeforeAll {
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MvRAdaptiveCards\MvRAdaptiveCards.psd1'
    Import-Module $ModulePath -Force -ArgumentList $false, $true
}

Describe "New-CardColumn" {
    Context "Basic Functionality" {
        It "Should create a basic Column" {
            $result = New-CardColumn

            $result | Should -Not -BeNullOrEmpty
            $result.type | Should -Be "Column"
            $result.items.GetType().Name | Should -Be "ArrayList"
        }

        It "Should return a hashtable" {
            $result = New-CardColumn

            $result | Should -BeOfType [hashtable]
        }

        It "Should have correct type property" {
            $result = New-CardColumn

            $result.type | Should -Be "Column"
        }

        It "Should create Column with content" {
            $result = New-CardColumn -Content {
                New-CardTextBlock -Text "Test"
            }

            $result.items.Count | Should -Be 1
            $result.items[0].type | Should -Be "TextBlock"
        }

        It "Should create Column with multiple items" {
            $result = New-CardColumn -Content {
                New-CardTextBlock -Text "Item 1"
                New-CardTextBlock -Text "Item 2"
                New-CardTextBlock -Text "Item 3"
            }

            $result.items.Count | Should -Be 3
        }
    }

    Context "Width Parameter" {
        It "Should set width to auto" {
            $result = New-CardColumn -Width "auto"

            $result.width | Should -Be "auto"
        }

        It "Should set width to stretch" {
            $result = New-CardColumn -Width "stretch"

            $result.width | Should -Be "stretch"
        }

        It "Should set width to a number" {
            $result = New-CardColumn -Width 2

            $result.width | Should -Be 2
        }

        It "Should set width to pixel value" {
            $result = New-CardColumn -Width "50px"

            $result.width | Should -Be "50px"
        }

        It "Should handle different numeric widths" {
            $result1 = New-CardColumn -Width 1
            $result2 = New-CardColumn -Width 3
            $result3 = New-CardColumn -Width 5

            $result1.width | Should -Be 1
            $result2.width | Should -Be 3
            $result3.width | Should -Be 5
        }

        It "Should not include width property when not specified" {
            $result = New-CardColumn

            $result.ContainsKey('width') | Should -Be $false
        }
    }

    Context "Style Parameter" {
        It "Should not include style for Default" {
            $result = New-CardColumn -Style "Default"

            $result.ContainsKey('style') | Should -Be $false
        }

        It "Should set Emphasis style" {
            $result = New-CardColumn -Style "Emphasis"

            $result.style | Should -Be "emphasis"
        }

        It "Should set Accent style" {
            $result = New-CardColumn -Style "Accent"

            $result.style | Should -Be "accent"
        }

        It "Should set Good style" {
            $result = New-CardColumn -Style "Good"

            $result.style | Should -Be "good"
        }

        It "Should set Warning style" {
            $result = New-CardColumn -Style "Warning"

            $result.style | Should -Be "warning"
        }

        It "Should set Attention style" {
            $result = New-CardColumn -Style "Attention"

            $result.style | Should -Be "attention"
        }

        It "Should validate style values" {
            { New-CardColumn -Style "Invalid" } | Should -Throw
        }
    }

    Context "VerticalContentAlignment Parameter" {
        It "Should set Top alignment" {
            $result = New-CardColumn -VerticalContentAlignment "Top"

            $result.verticalContentAlignment | Should -Be "Top"
        }

        It "Should set Center alignment" {
            $result = New-CardColumn -VerticalContentAlignment "Center"

            $result.verticalContentAlignment | Should -Be "Center"
        }

        It "Should set Bottom alignment" {
            $result = New-CardColumn -VerticalContentAlignment "Bottom"

            $result.verticalContentAlignment | Should -Be "Bottom"
        }

        It "Should validate alignment values" {
            { New-CardColumn -VerticalContentAlignment "Invalid" } | Should -Throw
        }

        It "Should not include alignment when not specified" {
            $result = New-CardColumn

            $result.ContainsKey('verticalContentAlignment') | Should -Be $false
        }
    }

    Context "BackgroundImage Parameter" {
        It "Should set backgroundImage as string URL" {
            $result = New-CardColumn -BackgroundImage "https://example.com/bg.jpg"

            $result.backgroundImage | Should -Be "https://example.com/bg.jpg"
        }

        It "Should set backgroundImage as object" {
            $bgImage = @{ url = "https://example.com/bg.jpg"; fillMode = "cover" }
            $result = New-CardColumn -BackgroundImage $bgImage

            $result.backgroundImage.url | Should -Be "https://example.com/bg.jpg"
            $result.backgroundImage.fillMode | Should -Be "cover"
        }

        It "Should not include backgroundImage when not specified" {
            $result = New-CardColumn

            $result.ContainsKey('backgroundImage') | Should -Be $false
        }
    }

    Context "MinHeight Parameter" {
        It "Should set minHeight with pixel suffix" {
            $result = New-CardColumn -MinHeight 100

            $result.minHeight | Should -Be "100px"
        }

        It "Should handle different pixel values" {
            $result = New-CardColumn -MinHeight 50

            $result.minHeight | Should -Be "50px"
        }

        It "Should not include minHeight when not specified" {
            $result = New-CardColumn

            $result.ContainsKey('minHeight') | Should -Be $false
        }
    }

    Context "Spacing Parameter" {
        It "Should not include spacing for Default" {
            $result = New-CardColumn -Spacing "Default"

            $result.ContainsKey('spacing') | Should -Be $false
        }

        It "Should set None spacing" {
            $result = New-CardColumn -Spacing "None"

            $result.spacing | Should -Be "None"
        }

        It "Should set Small spacing" {
            $result = New-CardColumn -Spacing "Small"

            $result.spacing | Should -Be "Small"
        }

        It "Should set Large spacing" {
            $result = New-CardColumn -Spacing "Large"

            $result.spacing | Should -Be "Large"
        }

        It "Should set ExtraLarge spacing" {
            $result = New-CardColumn -Spacing "ExtraLarge"

            $result.spacing | Should -Be "ExtraLarge"
        }

        It "Should validate spacing values" {
            { New-CardColumn -Spacing "Invalid" } | Should -Throw
        }
    }

    Context "Switch Parameters" {
        It "Should set bleed when Bleed switch is used" {
            $result = New-CardColumn -Bleed

            $result.bleed | Should -Be $true
        }

        It "Should not include bleed property when switch is not used" {
            $result = New-CardColumn

            $result.ContainsKey('bleed') | Should -Be $false
        }

        It "Should set separator when Separator switch is used" {
            $result = New-CardColumn -Separator

            $result.separator | Should -Be $true
        }

        It "Should not include separator property when switch is not used" {
            $result = New-CardColumn

            $result.ContainsKey('separator') | Should -Be $false
        }

        It "Should set rtl when Rtl switch is used" {
            $result = New-CardColumn -Rtl

            $result.rtl | Should -Be $true
        }

        It "Should not include rtl property when switch is not used" {
            $result = New-CardColumn

            $result.ContainsKey('rtl') | Should -Be $false
        }

        It "Should set isVisible to false when Hidden switch is used" {
            $result = New-CardColumn -Hidden

            $result.isVisible | Should -Be $false
        }

        It "Should not include isVisible when Hidden is not used" {
            $result = New-CardColumn

            $result.ContainsKey('isVisible') | Should -Be $false
        }
    }

    Context "Id Parameter" {
        It "Should set Id when provided" {
            $result = New-CardColumn -Id "myColumn"

            $result.id | Should -Be "myColumn"
        }

        It "Should not include id property when not specified" {
            $result = New-CardColumn

            $result.ContainsKey('id') | Should -Be $false
        }
    }

    Context "SelectAction Parameter" {
        It "Should set SelectAction when provided" {
            $action = @{ type = "Action.OpenUrl"; url = "https://example.com" }
            $result = New-CardColumn -SelectAction $action

            $result.selectAction | Should -Not -BeNullOrEmpty
            $result.selectAction.type | Should -Be "Action.OpenUrl"
        }

        It "Should not include selectAction when not specified" {
            $result = New-CardColumn

            $result.ContainsKey('selectAction') | Should -Be $false
        }
    }

    Context "Requires Parameter" {
        It "Should set requires hashtable" {
            $requires = @{ hostCapabilities = @{ supportsInteractivity = $true } }
            $result = New-CardColumn -Requires $requires

            $result.requires | Should -Not -BeNullOrEmpty
            $result.requires.hostCapabilities | Should -Not -BeNullOrEmpty
        }

        It "Should not include requires when not specified" {
            $result = New-CardColumn

            $result.ContainsKey('requires') | Should -Be $false
        }
    }

    Context "Fallback Parameter" {
        It "Should execute fallback scriptblock" {
            $result = New-CardColumn -Fallback {
                New-CardTextBlock -Text "Fallback content"
            }

            $result.fallback | Should -Not -BeNullOrEmpty
            $result.fallback.type | Should -Be "TextBlock"
        }

        It "Should not include fallback when not specified" {
            $result = New-CardColumn

            $result.ContainsKey('fallback') | Should -Be $false
        }
    }

    Context "Complex Scenarios" {
        It "Should handle all parameters together" {
            $result = New-CardColumn -Width "stretch" -Style "Emphasis" -Id "testColumn" `
                -VerticalContentAlignment "Center" -Spacing "Large" -Separator -MinHeight 80 `
                -Content {
                New-CardTextBlock -Text "Content"
            }

            $result.type | Should -Be "Column"
            $result.width | Should -Be "stretch"
            $result.style | Should -Be "emphasis"
            $result.id | Should -Be "testColumn"
            $result.verticalContentAlignment | Should -Be "Center"
            $result.spacing | Should -Be "Large"
            $result.separator | Should -Be $true
            $result.minHeight | Should -Be "80px"
            $result.items.Count | Should -Be 1
        }

        It "Should work with background image and content" {
            $result = New-CardColumn -Width "stretch" `
                -BackgroundImage "https://example.com/bg.jpg" `
                -Content {
                New-CardTextBlock -Text "Text over background"
            }

            $result.backgroundImage | Should -Be "https://example.com/bg.jpg"
            $result.items.Count | Should -Be 1
        }

        It "Should work with SelectAction" {
            $result = New-CardColumn -SelectAction @{ type = "Action.Submit"; data = @{ column = "1" } } `
                -Content {
                New-CardTextBlock -Text "Clickable column"
            }

            $result.selectAction.type | Should -Be "Action.Submit"
            $result.selectAction.data.column | Should -Be "1"
        }
    }

    Context "Content Handling" {
        It "Should handle empty Content scriptblock" {
            $result = New-CardColumn -Content { }

            $result.items.Count | Should -Be 0
        }

        It "Should handle Content with null result" {
            $result = New-CardColumn -Content { $null }

            $result.items.Count | Should -Be 0
        }

        It "Should handle single element in Content" {
            $result = New-CardColumn -Content {
                New-CardTextBlock -Text "Single"
            }

            $result.items.Count | Should -Be 1
        }

        It "Should handle multiple elements in Content" {
            $result = New-CardColumn -Content {
                New-CardTextBlock -Text "First"
                New-CardImage -Url "https://example.com/img.png"
                New-CardTextBlock -Text "Last"
            }

            $result.items.Count | Should -Be 3
        }

        It "Should handle nested containers in Content" {
            $result = New-CardColumn -Content {
                New-CardContainer -Content {
                    New-CardTextBlock -Text "Nested"
                }
            }

            $result.items.Count | Should -Be 1
            $result.items[0].type | Should -Be "Container"
        }
    }

    Context "Integration with ColumnSet" {
        It "Should work within New-CardColumnSet" {
            $columnSet = New-CardColumnSet -Columns {
                New-CardColumn -Width "auto" -Content {
                    New-CardTextBlock -Text "Col1"
                }
                New-CardColumn -Width "stretch" -Content {
                    New-CardTextBlock -Text "Col2"
                }
            }

            $columnSet.columns.Count | Should -Be 2
            $columnSet.columns[0].type | Should -Be "Column"
            $columnSet.columns[1].type | Should -Be "Column"
        }

        It "Should support different widths in same ColumnSet" {
            $columnSet = New-CardColumnSet -Columns {
                New-CardColumn -Width "auto"
                New-CardColumn -Width 1
                New-CardColumn -Width 2
                New-CardColumn -Width "stretch"
            }

            $columnSet.columns[0].width | Should -Be "auto"
            $columnSet.columns[1].width | Should -Be 1
            $columnSet.columns[2].width | Should -Be 2
            $columnSet.columns[3].width | Should -Be "stretch"
        }

        It "Should support different styles in same ColumnSet" {
            $columnSet = New-CardColumnSet -Columns {
                New-CardColumn -Style "Good" -Content {
                    New-CardTextBlock -Text "Success"
                }
                New-CardColumn -Style "Attention" -Content {
                    New-CardTextBlock -Text "Error"
                }
            }

            $columnSet.columns[0].style | Should -Be "good"
            $columnSet.columns[1].style | Should -Be "attention"
        }
    }

    Context "Real-World Examples" {
        It "Should create image + text column" {
            $result = New-CardColumn -Width "auto" -VerticalContentAlignment "Center" -Content {
                New-CardImage -Url "https://example.com/avatar.png" -Size "Small"
            }

            $result.width | Should -Be "auto"
            $result.verticalContentAlignment | Should -Be "Center"
            $result.items[0].type | Should -Be "Image"
        }

        It "Should create info column with multiple text blocks" {
            $result = New-CardColumn -Width "stretch" -Content {
                New-CardTextBlock -Text "John Doe" -Weight "Bolder"
                New-CardTextBlock -Text "Senior Developer" -IsSubtle
                New-CardTextBlock -Text "john.doe@example.com"
            }

            $result.width | Should -Be "stretch"
            $result.items.Count | Should -Be 3
        }

        It "Should create action button column" {
            $result = New-CardColumn -Width "auto" -SelectAction @{ type = "Action.OpenUrl"; url = "https://example.com" } -Content {
                New-CardTextBlock -Text "→"
            }

            $result.width | Should -Be "auto"
            $result.selectAction | Should -Not -BeNullOrEmpty
        }

        It "Should create column with separator" {
            $result = New-CardColumn -Width 1 -Separator -Spacing "Large" -Content {
                New-CardTextBlock -Text "Separated content"
            }

            $result.separator | Should -Be $true
            $result.spacing | Should -Be "Large"
        }
    }

    Context "Edge Cases" {
        It "Should handle column with no content" {
            $result = New-CardColumn -Width "stretch"

            $result.items.Count | Should -Be 0
        }

        It "Should handle column with empty Id" {
            $result = New-CardColumn -Id ""

            $result.id | Should -Be ""
        }

        It "Should handle very small minHeight" {
            $result = New-CardColumn -MinHeight 1

            $result.minHeight | Should -Be "1px"
        }

        It "Should handle very large minHeight" {
            $result = New-CardColumn -MinHeight 1000

            $result.minHeight | Should -Be "1000px"
        }

        It "Should handle pixel width values" {
            $result = New-CardColumn -Width "150px"

            $result.width | Should -Be "150px"
        }

        It "Should handle RTL content" {
            $result = New-CardColumn -Rtl -Content {
                New-CardTextBlock -Text "مرحبا"
            }

            $result.rtl | Should -Be $true
        }
    }

    Context "ShouldProcess Support" {
        It "Should support WhatIf" {
            $result = New-CardColumn -WhatIf

            $result | Should -BeNullOrEmpty
        }

        It "Should process normally without WhatIf" {
            $result = New-CardColumn

            $result | Should -Not -BeNullOrEmpty
        }
    }

    Context "Command Metadata" {
        It "Should have correct command name" {
            $command = Get-Command New-CardColumn
            $command.Name | Should -Be "New-CardColumn"
        }

        It "Should support ShouldProcess" {
            $command = Get-Command New-CardColumn
            $command.Parameters.ContainsKey('WhatIf') | Should -Be $true
            $command.Parameters.ContainsKey('Confirm') | Should -Be $true
        }

        It "Should have help documentation" {
            $help = Get-Help New-CardColumn
            $help.Synopsis | Should -Not -BeNullOrEmpty
        }

        It "Should have examples in help" {
            $help = Get-Help New-CardColumn -Examples
            $help.examples.example.Count | Should -BeGreaterThan 0
        }
    }

    Context "Output Validation" {
        It "Should return valid Adaptive Card element structure" {
            $result = New-CardColumn

            $result.type | Should -Be "Column"
            $result.items.GetType().Name | Should -Be "ArrayList"
        }

        It "Should only include specified properties" {
            $result = New-CardColumn -Width "auto" -Id "test"

            $result.ContainsKey('type') | Should -Be $true
            $result.ContainsKey('items') | Should -Be $true
            $result.ContainsKey('width') | Should -Be $true
            $result.ContainsKey('id') | Should -Be $true
            $result.ContainsKey('style') | Should -Be $false
            $result.ContainsKey('separator') | Should -Be $false
        }

        It "Should produce JSON-serializable output" {
            $result = New-CardColumn -Width "stretch" -Content {
                New-CardTextBlock -Text "Test"
            }

            { $result | ConvertTo-Json -Depth 10 } | Should -Not -Throw
        }

        It "Should maintain proper structure when converted to JSON" {
            $result = New-CardColumn -Width "auto" -Content {
                New-CardTextBlock -Text "Test"
            }

            $json = $result | ConvertTo-Json -Depth 10
            $parsed = $json | ConvertFrom-Json

            $parsed.type | Should -Be "Column"
            $parsed.width | Should -Be "auto"
        }
    }

    Context "Parameter Combinations" {
        It "Should work with width and style" {
            $result = New-CardColumn -Width 2 -Style "Emphasis"

            $result.width | Should -Be 2
            $result.style | Should -Be "emphasis"
        }

        It "Should work with alignment and spacing" {
            $result = New-CardColumn -VerticalContentAlignment "Center" -Spacing "Large"

            $result.verticalContentAlignment | Should -Be "Center"
            $result.spacing | Should -Be "Large"
        }

        It "Should work with switches and properties" {
            $result = New-CardColumn -Separator -Bleed -Width "stretch" -MinHeight 100

            $result.separator | Should -Be $true
            $result.bleed | Should -Be $true
            $result.width | Should -Be "stretch"
            $result.minHeight | Should -Be "100px"
        }
    }
}
