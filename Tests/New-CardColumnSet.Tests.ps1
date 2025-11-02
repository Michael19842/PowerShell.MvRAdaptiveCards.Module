BeforeAll {
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MvRAdaptiveCards\MvRAdaptiveCards.psd1'
    Import-Module $ModulePath -Force -ArgumentList $false, $true
}

Describe "New-CardColumnSet" {
    Context "Basic Functionality" {
        It "Should create a basic ColumnSet with required parameters" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn -Width "auto" -Content {
                    New-CardTextBlock -Text "Test"
                }
            }

            $result | Should -Not -BeNullOrEmpty
            $result.type | Should -Be "ColumnSet"
            $result.columns | Should -Not -BeNullOrEmpty
        }

        It "Should return a hashtable" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn -Width "stretch"
            }

            $result | Should -BeOfType [hashtable]
        }

        It "Should have correct type property" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn
            }

            $result.type | Should -Be "ColumnSet"
        }

        It "Should create ColumnSet with multiple columns" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn -Width "auto"
                New-CardColumn -Width "stretch"
                New-CardColumn -Width 1
            }

            $result.columns.Count | Should -Be 3
        }
    }

    Context "Style Parameter" {
        It "Should set Default style" {
            $result = New-CardColumnSet -Style "Default" -Columns {
                New-CardColumn
            }

            $result.style | Should -BeNullOrEmpty
        }

        It "Should set Emphasis style" {
            $result = New-CardColumnSet -Style "Emphasis" -Columns {
                New-CardColumn
            }

            $result.style | Should -Be "emphasis"
        }

        It "Should set Accent style" {
            $result = New-CardColumnSet -Style "Accent" -Columns {
                New-CardColumn
            }

            $result.style | Should -Be "accent"
        }

        It "Should set Good style" {
            $result = New-CardColumnSet -Style "Good" -Columns {
                New-CardColumn
            }

            $result.style | Should -Be "good"
        }

        It "Should set Warning style" {
            $result = New-CardColumnSet -Style "Warning" -Columns {
                New-CardColumn
            }

            $result.style | Should -Be "warning"
        }

        It "Should set Attention style" {
            $result = New-CardColumnSet -Style "Attention" -Columns {
                New-CardColumn
            }

            $result.style | Should -Be "attention"
        }

        It "Should validate style values" {
            { New-CardColumnSet -Style "Invalid" -Columns { New-CardColumn } } | Should -Throw
        }
    }

    Context "Id Parameter" {
        It "Should set Id when provided" {
            $result = New-CardColumnSet -Id "myColumnSet" -Columns {
                New-CardColumn
            }

            $result.id | Should -Be "myColumnSet"
        }

        It "Should not include id property when not specified" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn
            }

            $result.ContainsKey('id') | Should -Be $false
        }
    }

    Context "SelectAction Parameter" {
        It "Should set SelectAction when provided" {
            $action = @{ type = "Action.OpenUrl"; url = "https://example.com" }
            $result = New-CardColumnSet -SelectAction $action -Columns {
                New-CardColumn
            }

            $result.selectAction | Should -Not -BeNullOrEmpty
            $result.selectAction.type | Should -Be "Action.OpenUrl"
        }

        It "Should not include selectAction when not specified" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn
            }

            $result.ContainsKey('selectAction') | Should -Be $false
        }
    }

    Context "HorizontalAlignment Parameter" {
        It "Should set Left alignment" {
            $result = New-CardColumnSet -HorizontalAlignment "Left" -Columns {
                New-CardColumn
            }

            $result.horizontalAlignment | Should -Be "Left"
        }

        It "Should set Center alignment" {
            $result = New-CardColumnSet -HorizontalAlignment "Center" -Columns {
                New-CardColumn
            }

            $result.horizontalAlignment | Should -Be "Center"
        }

        It "Should set Right alignment" {
            $result = New-CardColumnSet -HorizontalAlignment "Right" -Columns {
                New-CardColumn
            }

            $result.horizontalAlignment | Should -Be "Right"
        }

        It "Should validate alignment values" {
            { New-CardColumnSet -HorizontalAlignment "Invalid" -Columns { New-CardColumn } } | Should -Throw
        }
    }

    Context "Height Parameter" {
        It "Should set height to auto" {
            $result = New-CardColumnSet -Height "auto" -Columns {
                New-CardColumn
            }

            $result.height | Should -Be "auto"
        }

        It "Should set height to stretch" {
            $result = New-CardColumnSet -Height "stretch" -Columns {
                New-CardColumn
            }

            $result.height | Should -Be "stretch"
        }

        It "Should validate height values" {
            { New-CardColumnSet -Height "Invalid" -Columns { New-CardColumn } } | Should -Throw
        }
    }

    Context "MinHeight Parameter" {
        It "Should set minHeight with pixel suffix" {
            $result = New-CardColumnSet -MinHeight 100 -Columns {
                New-CardColumn
            }

            $result.minHeight | Should -Be "100px"
        }

        It "Should handle different pixel values" {
            $result = New-CardColumnSet -MinHeight 50 -Columns {
                New-CardColumn
            }

            $result.minHeight | Should -Be "50px"
        }
    }

    Context "Spacing Parameter" {
        It "Should not include spacing for Default" {
            $result = New-CardColumnSet -Spacing "Default" -Columns {
                New-CardColumn
            }

            $result.ContainsKey('spacing') | Should -Be $false
        }

        It "Should set None spacing" {
            $result = New-CardColumnSet -Spacing "None" -Columns {
                New-CardColumn
            }

            $result.spacing | Should -Be "None"
        }

        It "Should set Small spacing" {
            $result = New-CardColumnSet -Spacing "Small" -Columns {
                New-CardColumn
            }

            $result.spacing | Should -Be "Small"
        }

        It "Should set Large spacing" {
            $result = New-CardColumnSet -Spacing "Large" -Columns {
                New-CardColumn
            }

            $result.spacing | Should -Be "Large"
        }

        It "Should validate spacing values" {
            { New-CardColumnSet -Spacing "Invalid" -Columns { New-CardColumn } } | Should -Throw
        }
    }

    Context "Switch Parameters" {
        It "Should set separator when Separator switch is used" {
            $result = New-CardColumnSet -Separator -Columns {
                New-CardColumn
            }

            $result.separator | Should -Be $true
        }

        It "Should not include separator property when switch is not used" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn
            }

            $result.ContainsKey('separator') | Should -Be $false
        }

        It "Should set bleed when Bleed switch is used" {
            $result = New-CardColumnSet -Bleed -Columns {
                New-CardColumn
            }

            $result.bleed | Should -Be $true
        }

        It "Should set isSortKey when IsSortKey switch is used" {
            $result = New-CardColumnSet -IsSortKey -Columns {
                New-CardColumn
            }

            $result.isSortKey | Should -Be $true
        }

        It "Should set isVisible to false when Hidden switch is used" {
            $result = New-CardColumnSet -Hidden -Columns {
                New-CardColumn
            }

            $result.isVisible | Should -Be $false
        }

        It "Should not include visibility property when Hidden is not used" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn
            }

            $result.ContainsKey('isVisible') | Should -Be $false
        }
    }

    Context "GridArea Parameter" {
        It "Should set grid.area property" {
            $result = New-CardColumnSet -GridArea "mainContent" -Columns {
                New-CardColumn
            }

            $result.'grid.area' | Should -Be "mainContent"
        }

        It "Should not include grid.area when not specified" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn
            }

            $result.ContainsKey('grid.area') | Should -Be $false
        }
    }

    Context "TargetWidth Parameter" {
        It "Should set targetWidth to VeryNarrow" {
            $result = New-CardColumnSet -TargetWidth "VeryNarrow" -Columns {
                New-CardColumn
            }

            $result.targetWidth | Should -Be "VeryNarrow"
        }

        It "Should set targetWidth with atLeast modifier" {
            $result = New-CardColumnSet -TargetWidth "atLeast:Standard" -Columns {
                New-CardColumn
            }

            $result.targetWidth | Should -Be "atLeast:Standard"
        }

        It "Should set targetWidth with atMost modifier" {
            $result = New-CardColumnSet -TargetWidth "atMost:Wide" -Columns {
                New-CardColumn
            }

            $result.targetWidth | Should -Be "atMost:Wide"
        }

        It "Should validate targetWidth values" {
            { New-CardColumnSet -TargetWidth "Invalid" -Columns { New-CardColumn } } | Should -Throw
        }
    }

    Context "Lang Parameter" {
        It "Should set lang property" {
            $result = New-CardColumnSet -Lang "en-US" -Columns {
                New-CardColumn
            }

            $result.lang | Should -Be "en-US"
        }

        It "Should handle different language codes" {
            $result = New-CardColumnSet -Lang "fr-FR" -Columns {
                New-CardColumn
            }

            $result.lang | Should -Be "fr-FR"
        }
    }

    Context "Requires Parameter" {
        It "Should set requires hashtable" {
            $requires = @{ hostCapabilities = @{ supportsInteractivity = $true } }
            $result = New-CardColumnSet -Requires $requires -Columns {
                New-CardColumn
            }

            $result.requires | Should -Not -BeNullOrEmpty
            $result.requires.hostCapabilities | Should -Not -BeNullOrEmpty
        }

        It "Should not include requires when not specified" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn
            }

            $result.ContainsKey('requires') | Should -Be $false
        }
    }

    Context "Fallback Parameter" {
        It "Should execute fallback scriptblock" {
            $result = New-CardColumnSet -Fallback {
                New-CardTextBlock -Text "Fallback content"
            } -Columns {
                New-CardColumn
            }

            $result.fallback | Should -Not -BeNullOrEmpty
            $result.fallback.type | Should -Be "TextBlock"
        }

        It "Should not include fallback when not specified" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn
            }

            $result.ContainsKey('fallback') | Should -Be $false
        }
    }

    Context "Complex Scenarios" {
        It "Should handle all parameters together" {
            $result = New-CardColumnSet -Style "Emphasis" -Id "testSet" -HorizontalAlignment "Center" `
                -Spacing "Large" -Separator -MinHeight 80 -Columns {
                New-CardColumn -Width "auto" -Content {
                    New-CardTextBlock -Text "Col1"
                }
                New-CardColumn -Width "stretch" -Content {
                    New-CardTextBlock -Text "Col2"
                }
            }

            $result.type | Should -Be "ColumnSet"
            $result.style | Should -Be "emphasis"
            $result.id | Should -Be "testSet"
            $result.horizontalAlignment | Should -Be "Center"
            $result.spacing | Should -Be "Large"
            $result.separator | Should -Be $true
            $result.minHeight | Should -Be "80px"
            $result.columns.Count | Should -Be 2
        }

        It "Should create responsive layout with different column widths" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn -Width "auto"
                New-CardColumn -Width 2
                New-CardColumn -Width 1
                New-CardColumn -Width "stretch"
            }

            $result.columns.Count | Should -Be 4
            $result.columns[0].width | Should -Be "auto"
            $result.columns[1].width | Should -Be 2
            $result.columns[2].width | Should -Be 1
            $result.columns[3].width | Should -Be "stretch"
        }

        It "Should work with SelectAction" {
            $result = New-CardColumnSet -SelectAction @{ type = "Action.Submit"; data = @{ action = "click" } } -Columns {
                New-CardColumn -Content {
                    New-CardTextBlock -Text "Click me"
                }
            }

            $result.selectAction.type | Should -Be "Action.Submit"
            $result.selectAction.data.action | Should -Be "click"
        }
    }

    Context "Integration with Adaptive Card" {
        It "Should work within New-AdaptiveCard" {
            $card = New-AdaptiveCard -Content {
                New-CardColumnSet -Columns {
                    New-CardColumn -Width "auto" -Content {
                        New-CardTextBlock -Text "Left"
                    }
                    New-CardColumn -Width "stretch" -Content {
                        New-CardTextBlock -Text "Right"
                    }
                }
            } -AsObject

            $card.body[0].type | Should -Be "ColumnSet"
            $card.body[0].columns.Count | Should -Be 2
        }

        It "Should work with nested containers" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn -Content {
                    New-CardContainer -Content {
                        New-CardTextBlock -Text "Nested"
                    }
                }
            }

            $result.columns[0].items[0].type | Should -Be "Container"
        }
    }

    Context "Real-World Examples" {
        It "Should create card header layout" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn -Width "auto" -Content {
                    New-CardImage -Url "https://example.com/logo.png" -Size "Small"
                }
                New-CardColumn -Width "stretch" -Content {
                    New-CardTextBlock -Text "Company Name" -Weight "Bolder"
                    New-CardTextBlock -Text "Tagline" -IsSubtle
                }
            }

            $result.columns.Count | Should -Be 2
            $result.columns[0].width | Should -Be "auto"
            $result.columns[1].width | Should -Be "stretch"
        }

        It "Should create equal-width layout" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn -Width 1 -Content {
                    New-CardTextBlock -Text "Column 1"
                }
                New-CardColumn -Width 1 -Content {
                    New-CardTextBlock -Text "Column 2"
                }
                New-CardColumn -Width 1 -Content {
                    New-CardTextBlock -Text "Column 3"
                }
            }

            $result.columns.Count | Should -Be 3
            $result.columns | ForEach-Object { $_.width | Should -Be 1 }
        }

        It "Should create status indicator layout" {
            $result = New-CardColumnSet -Style "Good" -Columns {
                New-CardColumn -Width "auto" -Content {
                    New-CardTextBlock -Text "✓" -Size "Large" -Color "Good"
                }
                New-CardColumn -Width "stretch" -Content {
                    New-CardTextBlock -Text "Operation Successful"
                }
            }

            $result.style | Should -Be "good"
            $result.columns.Count | Should -Be 2
        }
    }

    Context "Edge Cases" {
        It "Should handle empty column" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn
            }

            $result.columns.Count | Should -Be 1
            $result.columns[0].items.Count | Should -Be 0
        }

        It "Should handle single column" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn -Width "stretch" -Content {
                    New-CardTextBlock -Text "Single column"
                }
            }

            $result.columns.Count | Should -Be 1
        }

        It "Should handle many columns" {
            $result = New-CardColumnSet -Columns {
                1..10 | ForEach-Object {
                    New-CardColumn -Width 1
                }
            }

            $result.columns.Count | Should -Be 10
        }

        It "Should handle pixel width in columns" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn -Width "50px"
                New-CardColumn -Width "100px"
            }

            $result.columns[0].width | Should -Be "50px"
            $result.columns[1].width | Should -Be "100px"
        }
    }

    Context "ShouldProcess Support" {
        It "Should support WhatIf" {
            $result = New-CardColumnSet -WhatIf -Columns {
                New-CardColumn
            }

            $result | Should -BeNullOrEmpty
        }

        It "Should process normally without WhatIf" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn
            }

            $result | Should -Not -BeNullOrEmpty
        }
    }

    Context "Command Metadata" {
        It "Should have correct command name" {
            $command = Get-Command New-CardColumnSet
            $command.Name | Should -Be "New-CardColumnSet"
        }

        It "Should support ShouldProcess" {
            $command = Get-Command New-CardColumnSet
            $command.Parameters.ContainsKey('WhatIf') | Should -Be $true
            $command.Parameters.ContainsKey('Confirm') | Should -Be $true
        }

        It "Should have help documentation" {
            $help = Get-Help New-CardColumnSet
            $help.Synopsis | Should -Not -BeNullOrEmpty
        }

        It "Should have examples in help" {
            $help = Get-Help New-CardColumnSet -Examples
            $help.examples.example.Count | Should -BeGreaterThan 0
        }
    }

    Context "Output Validation" {
        It "Should return valid Adaptive Card element structure" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn
            }

            $result.type | Should -Be "ColumnSet"
            $result.columns.GetType().Name | Should -Be "ArrayList"
        }

        It "Should only include specified properties" {
            $result = New-CardColumnSet -Id "test" -Columns {
                New-CardColumn
            }

            $result.ContainsKey('type') | Should -Be $true
            $result.ContainsKey('columns') | Should -Be $true
            $result.ContainsKey('id') | Should -Be $true
            $result.ContainsKey('style') | Should -Be $false
        }

        It "Should produce JSON-serializable output" {
            $result = New-CardColumnSet -Columns {
                New-CardColumn -Content {
                    New-CardTextBlock -Text "Test"
                }
            }

            { $result | ConvertTo-Json -Depth 10 } | Should -Not -Throw
        }
    }
}
