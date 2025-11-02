BeforeAll {
    # Import the module
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MvRAdaptiveCards\MvRAdaptiveCards.psd1'
    Import-Module $ModulePath -Force -ArgumentList $false, $true
}

Describe "New-CardChartDonut" {

    Context "Basic Functionality" {
        It "Should create a donut chart with required Data parameter" {
            $data = @(
                @{ label = "Product A"; value = 35 }
                @{ label = "Product B"; value = 25 }
            )

            $result = New-CardChartDonut -Data $data

            $result | Should -Not -BeNullOrEmpty
            $result | Should -BeOfType [hashtable]
            $result.type | Should -Be "Chart.Donut"
            $result.data | Should -HaveCount 2
        }

        It "Should return a hashtable" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data

            $result | Should -BeOfType [hashtable]
        }

        It "Should have correct type property" {
            $data = @(@{ label = "Test"; value = 50 })
            $result = New-CardChartDonut -Data $data

            $result.type | Should -Be "Chart.Donut"
        }

        It "Should throw error when Data parameter is missing" {
            { New-CardChartDonut -Data $null } | Should -Throw
        }
    }

    Context "Data Parameter Validation" {
        It "Should accept valid data array with label and value" {
            $data = @(
                @{ label = "Item 1"; value = 50 }
                @{ label = "Item 2"; value = 30 }
                @{ label = "Item 3"; value = 20 }
            )

            { New-CardChartDonut -Data $data } | Should -Not -Throw
        }

        It "Should throw error when data item is not a hashtable" {
            { New-CardChartDonut -Data @("not a hashtable") } | Should -Throw "*hashtable*"
        }

        It "Should throw error when data item missing label property" {
            $data = @(@{ value = 100 })
            { New-CardChartDonut -Data $data } | Should -Throw "*'label' and 'value'*"
        }

        It "Should throw error when data item missing value property" {
            $data = @(@{ label = "Test" })
            { New-CardChartDonut -Data $data } | Should -Throw "*'label' and 'value'*"
        }

        It "Should throw error when value is not numeric" {
            $data = @(@{ label = "Test"; value = "not a number" })
            { New-CardChartDonut -Data $data } | Should -Throw "*numeric*"
        }

        It "Should accept integer values" {
            $data = @(@{ label = "Test"; value = 100 })
            { New-CardChartDonut -Data $data } | Should -Not -Throw
        }

        It "Should accept double values" {
            $data = @(@{ label = "Test"; value = 99.5 })
            { New-CardChartDonut -Data $data } | Should -Not -Throw
        }

        It "Should accept data with optional color property" {
            $data = @(
                @{ label = "Item 1"; value = 50; color = "#FF0000" }
                @{ label = "Item 2"; value = 50; color = "#00FF00" }
            )

            $result = New-CardChartDonut -Data $data
            $result.data[0].color | Should -Be "#FF0000"
            $result.data[1].color | Should -Be "#00FF00"
        }

        It "Should handle data without color property" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data

            $result.data[0].ContainsKey('color') | Should -Be $false
        }

        It "Should accept multiple data items" {
            $data = @(
                @{ label = "A"; value = 25 }
                @{ label = "B"; value = 25 }
                @{ label = "C"; value = 25 }
                @{ label = "D"; value = 25 }
            )

            $result = New-CardChartDonut -Data $data
            $result.data | Should -HaveCount 4
        }
    }

    Context "Title Parameter" {
        It "Should set title when provided" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -Title "My Chart"

            $result.title | Should -Be "My Chart"
        }

        It "Should not include title when not provided" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data

            $result.ContainsKey('title') | Should -Be $false
        }

        It "Should handle empty title string" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -Title ""

            $result.ContainsKey('title') | Should -Be $false
        }
    }

    Context "ColorSet Parameter" {
        It "Should set colorSet to categorical" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -ColorSet "categorical"

            $result.colorSet | Should -Be "categorical"
        }

        It "Should set colorSet to sequential" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -ColorSet "sequential"

            $result.colorSet | Should -Be "sequential"
        }

        It "Should set colorSet to diverging" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -ColorSet "diverging"

            $result.colorSet | Should -Be "diverging"
        }

        It "Should not include colorSet when not provided" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data

            $result.ContainsKey('colorSet') | Should -Be $false
        }

        It "Should validate colorSet values" {
            $data = @(@{ label = "Test"; value = 100 })
            { New-CardChartDonut -Data $data -ColorSet "invalid" } | Should -Throw
        }
    }

    Context "Layout Properties" {
        It "Should set Id parameter" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -Id "chart1"

            $result.id | Should -Be "chart1"
        }

        It "Should set Height to auto" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -Height "auto"

            $result.height | Should -Be "auto"
        }

        It "Should set Height to stretch" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -Height "stretch"

            $result.height | Should -Be "stretch"
        }

        It "Should validate Height values" {
            $data = @(@{ label = "Test"; value = 100 })
            { New-CardChartDonut -Data $data -Height "invalid" } | Should -Throw
        }

        It "Should set HorizontalAlignment Left" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -HorizontalAlignment "Left"

            $result.horizontalAlignment | Should -Be "Left"
        }

        It "Should set HorizontalAlignment Center" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -HorizontalAlignment "Center"

            $result.horizontalAlignment | Should -Be "Center"
        }

        It "Should set HorizontalAlignment Right" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -HorizontalAlignment "Right"

            $result.horizontalAlignment | Should -Be "Right"
        }

        It "Should handle all Spacing values" {
            $data = @(@{ label = "Test"; value = 100 })
            $spacingValues = @("None", "ExtraSmall", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")

            foreach ($spacing in $spacingValues) {
                $result = New-CardChartDonut -Data $data -Spacing $spacing
                $result.spacing | Should -Be $spacing
            }
        }

        It "Should set separator switch" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -Separator

            $result.separator | Should -Be $true
        }

        It "Should not include separator when not specified" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data

            $result.ContainsKey('separator') | Should -Be $false
        }

        It "Should set GridArea" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -GridArea "header"

            $result.'grid.area' | Should -Be "header"
        }

        It "Should set TargetWidth with simple value" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -TargetWidth "Standard"

            $result.targetWidth | Should -Be "Standard"
        }

        It "Should set TargetWidth with atLeast modifier" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -TargetWidth "atLeast:Wide"

            $result.targetWidth | Should -Be "atLeast:Wide"
        }

        It "Should set TargetWidth with atMost modifier" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -TargetWidth "atMost:Narrow"

            $result.targetWidth | Should -Be "atMost:Narrow"
        }

        It "Should validate TargetWidth pattern" {
            $data = @(@{ label = "Test"; value = 100 })
            { New-CardChartDonut -Data $data -TargetWidth "invalid:value" } | Should -Throw
        }
    }

    Context "Visibility Properties" {
        It "Should set IsVisible to true" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -IsVisible $true

            $result.isVisible | Should -Be $true
        }

        It "Should set IsVisible to false" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -IsVisible $false

            $result.isVisible | Should -Be $false
        }

        It "Should not include isVisible when not specified" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data

            $result.ContainsKey('isVisible') | Should -Be $false
        }

        It "Should set isSortKey switch" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -isSortKey

            $result.isSortKey | Should -Be $true
        }

        It "Should not include isSortKey when not specified" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data

            $result.ContainsKey('isSortKey') | Should -Be $false
        }
    }

    Context "Localization" {
        It "Should set Lang property" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -Lang "en-US"

            $result.lang | Should -Be "en-US"
        }

        It "Should handle different language codes" {
            $data = @(@{ label = "Test"; value = 100 })
            $languages = @("en-US", "fr-FR", "de-DE", "es-ES", "ja-JP")

            foreach ($lang in $languages) {
                $result = New-CardChartDonut -Data $data -Lang $lang
                $result.lang | Should -Be $lang
            }
        }

        It "Should not include lang when not specified" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data

            $result.ContainsKey('lang') | Should -Be $false
        }
    }

    Context "Fallback Property" {
        It "Should set Fallback from scriptblock" {
            $data = @(@{ label = "Test"; value = 100 })
            $fallback = { New-CardTextBlock -Text "Chart not supported" }
            $result = New-CardChartDonut -Data $data -Fallback $fallback

            $result.fallback | Should -Not -BeNullOrEmpty
            $result.fallback.type | Should -Be "TextBlock"
        }

        It "Should execute Fallback scriptblock" {
            $data = @(@{ label = "Test"; value = 100 })
            $fallback = {
                @{
                    type = "TextBlock"
                    text = "Fallback content"
                }
            }
            $result = New-CardChartDonut -Data $data -Fallback $fallback

            $result.fallback.text | Should -Be "Fallback content"
        }

        It "Should not include fallback when not specified" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data

            $result.ContainsKey('fallback') | Should -Be $false
        }
    }

    Context "Requires Property" {
        It "Should set Requires hashtable" {
            $data = @(@{ label = "Test"; value = 100 })
            $requires = @{ "hostCapabilities" = "charts" }
            $result = New-CardChartDonut -Data $data -Requires $requires

            $result.requires | Should -Not -BeNullOrEmpty
            $result.requires.hostCapabilities | Should -Be "charts"
        }

        It "Should not include requires when not specified" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data

            $result.ContainsKey('requires') | Should -Be $false
        }
    }

    Context "Combined Properties" {
        It "Should set multiple properties together" {
            $data = @(
                @{ label = "A"; value = 40; color = "#FF0000" }
                @{ label = "B"; value = 60; color = "#00FF00" }
            )

            $result = New-CardChartDonut -Data $data -Title "Test Chart" -ColorSet "categorical" -Id "chart1"

            $result.title | Should -Be "Test Chart"
            $result.colorSet | Should -Be "categorical"
            $result.id | Should -Be "chart1"
            $result.data | Should -HaveCount 2
        }

        It "Should handle comprehensive configuration" {
            $data = @(
                @{ label = "Product A"; value = 35 }
                @{ label = "Product B"; value = 25 }
                @{ label = "Product C"; value = 20 }
                @{ label = "Product D"; value = 20 }
            )

            $result = New-CardChartDonut -Data $data -Title "Sales Distribution" `
                -ColorSet "diverging" -Id "sales-chart" -HorizontalAlignment "Center" `
                -Spacing "Medium" -Separator -Lang "en-US"

            $result.title | Should -Be "Sales Distribution"
            $result.colorSet | Should -Be "diverging"
            $result.id | Should -Be "sales-chart"
            $result.horizontalAlignment | Should -Be "Center"
            $result.spacing | Should -Be "Medium"
            $result.separator | Should -Be $true
            $result.lang | Should -Be "en-US"
        }
    }

    Context "Integration with Adaptive Card" {
        It "Should work within New-AdaptiveCard" {
            $data = @(@{ label = "Test"; value = 100 })
            $card = New-AdaptiveCard {
                New-CardChartDonut -Data $data -Title "Test Chart"
            } -AsObject

            $card.body | Should -HaveCount 1
            $card.body[0].type | Should -Be "Chart.Donut"
            $card.body[0].title | Should -Be "Test Chart"
        }

        It "Should work with multiple elements" {
            $data = @(@{ label = "Test"; value = 100 })
            $card = New-AdaptiveCard {
                New-CardTextBlock -Text "Chart Title" -Weight "Bolder"
                New-CardChartDonut -Data $data
                New-CardTextBlock -Text "Chart Description"
            } -AsObject

            $card.body | Should -HaveCount 3
            $card.body[1].type | Should -Be "Chart.Donut"
        }

        It "Should work in containers" {
            $data = @(@{ label = "Test"; value = 100 })
            $card = New-AdaptiveCard {
                New-CardContainer {
                    New-CardChartDonut -Data $data -Title "Container Chart"
                }
            } -AsObject

            $card.body[0].items | Should -HaveCount 1
            $card.body[0].items[0].type | Should -Be "Chart.Donut"
        }
    }

    Context "Real-World Examples" {
        It "Should create budget allocation chart" {
            $data = @(
                @{ label = "Development"; value = 45; color = "#0078D4" }
                @{ label = "Marketing"; value = 25; color = "#00CC6A" }
                @{ label = "Operations"; value = 20; color = "#FFB900" }
                @{ label = "Other"; value = 10; color = "#E74856" }
            )

            $result = New-CardChartDonut -Data $data -Title "Budget Allocation" -HorizontalAlignment "Center"

            $result.title | Should -Be "Budget Allocation"
            $result.data | Should -HaveCount 4
            $result.data[0].color | Should -Be "#0078D4"
        }

        It "Should create task completion chart" {
            $data = @(
                @{ label = "Completed"; value = 75 }
                @{ label = "In Progress"; value = 15 }
                @{ label = "Not Started"; value = 10 }
            )

            $result = New-CardChartDonut -Data $data -Title "Task Completion" -ColorSet "sequential"

            $result.title | Should -Be "Task Completion"
            $result.colorSet | Should -Be "sequential"
            $result.data | Should -HaveCount 3
        }

        It "Should create sales distribution chart" {
            $data = @(
                @{ label = "North"; value = 30 }
                @{ label = "South"; value = 25 }
                @{ label = "East"; value = 25 }
                @{ label = "West"; value = 20 }
            )

            $result = New-CardChartDonut -Data $data -Title "Regional Sales" -Separator

            $result.separator | Should -Be $true
            $result.data.Count | Should -Be 4
        }
    }

    Context "Edge Cases" {
        It "Should handle single data item" {
            $data = @(@{ label = "Single"; value = 100 })
            $result = New-CardChartDonut -Data $data

            $result.data | Should -HaveCount 1
        }

        It "Should handle large number of data items" {
            $data = 1..20 | ForEach-Object {
                @{ label = "Item $_"; value = 5 }
            }

            $result = New-CardChartDonut -Data $data
            $result.data | Should -HaveCount 20
        }

        It "Should handle zero values" {
            $data = @(
                @{ label = "A"; value = 0 }
                @{ label = "B"; value = 100 }
            )

            { New-CardChartDonut -Data $data } | Should -Not -Throw
        }

        It "Should handle negative values" {
            $data = @(@{ label = "Test"; value = -50 })
            { New-CardChartDonut -Data $data } | Should -Not -Throw
        }

        It "Should handle decimal values" {
            $data = @(
                @{ label = "A"; value = 33.33 }
                @{ label = "B"; value = 33.33 }
                @{ label = "C"; value = 33.34 }
            )

            $result = New-CardChartDonut -Data $data
            $result.data[0].value | Should -Be 33.33
        }

        It "Should handle very large values" {
            $data = @(@{ label = "Large"; value = 999999999 })
            { New-CardChartDonut -Data $data } | Should -Not -Throw
        }

        It "Should handle special characters in labels" {
            $data = @(@{ label = "Test & <Special> 'Chars'"; value = 100 })
            $result = New-CardChartDonut -Data $data

            $result.data[0].label | Should -Be "Test & <Special> 'Chars'"
        }

        It "Should handle unicode in labels" {
            $data = @(@{ label = "产品 A"; value = 50 })
            $result = New-CardChartDonut -Data $data

            $result.data[0].label | Should -Match "产品"
        }
    }

    Context "ShouldProcess Support" {
        It "Should support WhatIf" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -WhatIf

            $result | Should -BeNullOrEmpty
        }

        It "Should process normally without WhatIf" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data

            $result | Should -Not -BeNullOrEmpty
        }
    }

    Context "Command Metadata" {
        It "Should have correct command name" {
            $command = Get-Command New-CardChartDonut
            $command.Name | Should -Be "New-CardChartDonut"
        }

        It "Should support ShouldProcess" {
            $command = Get-Command New-CardChartDonut
            $command.Parameters.ContainsKey('WhatIf') | Should -Be $true
            $command.Parameters.ContainsKey('Confirm') | Should -Be $true
        }

        It "Should have help documentation" {
            $help = Get-Help New-CardChartDonut
            $help.Synopsis | Should -Not -BeNullOrEmpty
            $help.Description | Should -Not -BeNullOrEmpty
        }

        It "Should have examples in help" {
            $help = Get-Help New-CardChartDonut -Full
            $help.Examples | Should -Not -BeNullOrEmpty
            $help.Examples.Example.Count | Should -BeGreaterThan 0
        }

        It "Should have parameter descriptions" {
            $help = Get-Help New-CardChartDonut -Full
            $help.parameters.parameter | Should -Not -BeNullOrEmpty
        }
    }

    Context "Output Validation" {
        It "Should return valid Adaptive Card element structure" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data

            $result | Should -BeOfType [hashtable]
            $result.type | Should -Be "Chart.Donut"
            $result.data | Should -Not -BeNullOrEmpty
        }

        It "Should only include specified properties" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -Title "Test"

            $result.ContainsKey("type") | Should -Be $true
            $result.ContainsKey("data") | Should -Be $true
            $result.ContainsKey("title") | Should -Be $true
            $result.ContainsKey("colorSet") | Should -Be $false
        }

        It "Should produce JSON-serializable output" {
            $data = @(@{ label = "Test"; value = 100 })
            $result = New-CardChartDonut -Data $data -Title "Test Chart"

            { $result | ConvertTo-Json -Depth 10 } | Should -Not -Throw
        }

        It "Should maintain data integrity" {
            $data = @(
                @{ label = "A"; value = 25; color = "#FF0000" }
                @{ label = "B"; value = 75; color = "#00FF00" }
            )

            $result = New-CardChartDonut -Data $data

            $result.data[0].label | Should -Be "A"
            $result.data[0].value | Should -Be 25
            $result.data[0].color | Should -Be "#FF0000"
            $result.data[1].label | Should -Be "B"
            $result.data[1].value | Should -Be 75
            $result.data[1].color | Should -Be "#00FF00"
        }
    }
}
