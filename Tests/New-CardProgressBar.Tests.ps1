BeforeAll {
    # Import the module
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MvRAdaptiveCards\MvRAdaptiveCards.psd1'
    Import-Module $ModulePath -Force -ArgumentList $True, $true
}

Describe "New-CardProgressBar" {

    Context "Basic Functionality" {
        It "Should create a progress bar without parameters (indeterminate mode)" {
            $result = New-CardProgressBar

            $result | Should -Not -BeNullOrEmpty
            $result | Should -BeOfType [hashtable]
            $result.type | Should -Be "ProgressBar"
        }

        It "Should return a hashtable" {
            $result = New-CardProgressBar -Value 50
            $result | Should -BeOfType [hashtable]
        }

        It "Should have required type property" {
            $result = New-CardProgressBar
            $result.type | Should -Be "ProgressBar"
        }

        It "Should create determinate progress bar with Value" {
            $result = New-CardProgressBar -Value 75
            $result.value | Should -Be 75
        }

        It "Should not include value property in indeterminate mode" {
            $result = New-CardProgressBar
            $result.ContainsKey("value") | Should -Be $false
        }
    }

    Context "Value Parameter" {
        It "Should set value to 0" {
            $result = New-CardProgressBar -Value 0
            $result.value | Should -Be 0
        }

        It "Should set value to 50" {
            $result = New-CardProgressBar -Value 50
            $result.value | Should -Be 50
        }

        It "Should set value to 100" {
            $result = New-CardProgressBar -Value 100
            $result.value | Should -Be 100
        }

        It "Should accept decimal values" {
            $result = New-CardProgressBar -Value 33.33
            $result.value | Should -Be 33.33
        }

        It "Should accept large values" {
            $result = New-CardProgressBar -Value 1000 -Max 5000
            $result.value | Should -Be 1000
        }

        It "Should reject negative values" {
            { New-CardProgressBar -Value -10 } | Should -Throw
        }

        It "Should warn when value exceeds max" {
            $result = New-CardProgressBar -Value 150 -Max 100 -WarningAction SilentlyContinue
            $result.value | Should -Be 150
            $result.max | Should -Be 100
        }
    }

    Context "Max Parameter" {
        It "Should set max value" {
            $result = New-CardProgressBar -Max 200
            $result.max | Should -Be 200
        }

        It "Should not include max property when not specified" {
            $result = New-CardProgressBar -Value 50
            $result.ContainsKey("max") | Should -Be $false
        }

        It "Should accept large max values" {
            $result = New-CardProgressBar -Max 10000
            $result.max | Should -Be 10000
        }

        It "Should accept decimal max values" {
            $result = New-CardProgressBar -Max 100.5
            $result.max | Should -Be 100.5
        }

        It "Should reject zero as max value" {
            { New-CardProgressBar -Max 0 } | Should -Throw
        }

        It "Should reject negative max values" {
            { New-CardProgressBar -Max -100 } | Should -Throw
        }

        It "Should work with custom max and value" {
            $result = New-CardProgressBar -Value 25 -Max 50
            $result.value | Should -Be 25
            $result.max | Should -Be 50
        }
    }

    Context "Color Property" {
        It "Should set Accent color" {
            $result = New-CardProgressBar -Value 50 -Color "Accent"
            $result.color | Should -Be "Accent"
        }

        It "Should set Good color" {
            $result = New-CardProgressBar -Value 80 -Color "Good"
            $result.color | Should -Be "Good"
        }

        It "Should set Warning color" {
            $result = New-CardProgressBar -Value 60 -Color "Warning"
            $result.color | Should -Be "Warning"
        }

        It "Should set Attention color" {
            $result = New-CardProgressBar -Value 20 -Color "Attention"
            $result.color | Should -Be "Attention"
        }

        It "Should not include color property when not specified" {
            $result = New-CardProgressBar -Value 50
            $result.ContainsKey("color") | Should -Be $false
        }

        It "Should validate color values" {
            { New-CardProgressBar -Value 50 -Color "InvalidColor" } | Should -Throw
        }

        It "Should accept color in indeterminate mode (though it has no effect)" {
            $result = New-CardProgressBar -Color "Good"
            $result.color | Should -Be "Good"
        }
    }

    Context "Id Parameter" {
        It "Should set id property" {
            $result = New-CardProgressBar -Value 50 -Id "progress1"
            $result.id | Should -Be "progress1"
        }

        It "Should not include id property when not specified" {
            $result = New-CardProgressBar -Value 50
            $result.ContainsKey("id") | Should -Be $false
        }

        It "Should accept various id formats" {
            $ids = @("progressBar1", "upload-progress", "download_status", "Progress123")
            foreach ($id in $ids) {
                $result = New-CardProgressBar -Value 50 -Id $id
                $result.id | Should -Be $id
            }
        }
    }

    Context "Height Parameter" {
        It "Should set height to auto" {
            $result = New-CardProgressBar -Value 50 -Height "auto"
            $result.height | Should -Be "auto"
        }

        It "Should set height to stretch" {
            $result = New-CardProgressBar -Value 50 -Height "stretch"
            $result.height | Should -Be "stretch"
        }

        It "Should not include height property when not specified" {
            $result = New-CardProgressBar -Value 50
            $result.ContainsKey("height") | Should -Be $false
        }

        It "Should validate height values" {
            { New-CardProgressBar -Value 50 -Height "invalid" } | Should -Throw
        }
    }

    Context "HorizontalAlignment Parameter" {
        It "Should set horizontalAlignment to Left" {
            $result = New-CardProgressBar -Value 50 -HorizontalAlignment "Left"
            $result.horizontalAlignment | Should -Be "Left"
        }

        It "Should set horizontalAlignment to Center" {
            $result = New-CardProgressBar -Value 50 -HorizontalAlignment "Center"
            $result.horizontalAlignment | Should -Be "Center"
        }

        It "Should set horizontalAlignment to Right" {
            $result = New-CardProgressBar -Value 50 -HorizontalAlignment "Right"
            $result.horizontalAlignment | Should -Be "Right"
        }

        It "Should not include horizontalAlignment property when not specified" {
            $result = New-CardProgressBar -Value 50
            $result.ContainsKey("horizontalAlignment") | Should -Be $false
        }

        It "Should validate horizontalAlignment values" {
            { New-CardProgressBar -Value 50 -HorizontalAlignment "Top" } | Should -Throw
        }
    }

    Context "GridArea Parameter" {
        It "Should set grid.area property" {
            $result = New-CardProgressBar -Value 50 -GridArea "mainContent"
            $result."grid.area" | Should -Be "mainContent"
        }

        It "Should not include grid.area property when not specified" {
            $result = New-CardProgressBar -Value 50
            $result.ContainsKey("grid.area") | Should -Be $false
        }

        It "Should accept various grid area names" {
            $areas = @("header", "content", "sidebar", "footer", "area-1")
            foreach ($area in $areas) {
                $result = New-CardProgressBar -Value 50 -GridArea $area
                $result."grid.area" | Should -Be $area
            }
        }
    }

    Context "Spacing Parameter" {
        It "Should set spacing to None" {
            $result = New-CardProgressBar -Value 50 -Spacing "None"
            $result.spacing | Should -Be "None"
        }

        It "Should set spacing to ExtraSmall" {
            $result = New-CardProgressBar -Value 50 -Spacing "ExtraSmall"
            $result.spacing | Should -Be "ExtraSmall"
        }

        It "Should set spacing to Small" {
            $result = New-CardProgressBar -Value 50 -Spacing "Small"
            $result.spacing | Should -Be "Small"
        }

        It "Should set spacing to Default" {
            $result = New-CardProgressBar -Value 50 -Spacing "Default"
            $result.spacing | Should -Be "Default"
        }

        It "Should set spacing to Medium" {
            $result = New-CardProgressBar -Value 50 -Spacing "Medium"
            $result.spacing | Should -Be "Medium"
        }

        It "Should set spacing to Large" {
            $result = New-CardProgressBar -Value 50 -Spacing "Large"
            $result.spacing | Should -Be "Large"
        }

        It "Should set spacing to ExtraLarge" {
            $result = New-CardProgressBar -Value 50 -Spacing "ExtraLarge"
            $result.spacing | Should -Be "ExtraLarge"
        }

        It "Should set spacing to Padding" {
            $result = New-CardProgressBar -Value 50 -Spacing "Padding"
            $result.spacing | Should -Be "Padding"
        }

        It "Should not include spacing property when not specified" {
            $result = New-CardProgressBar -Value 50
            $result.ContainsKey("spacing") | Should -Be $false
        }

        It "Should validate spacing values" {
            { New-CardProgressBar -Value 50 -Spacing "Invalid" } | Should -Throw
        }
    }

    Context "TargetWidth Parameter" {
        It "Should set targetWidth to VeryNarrow" {
            $result = New-CardProgressBar -Value 50 -TargetWidth "VeryNarrow"
            $result.targetWidth | Should -Be "VeryNarrow"
        }

        It "Should set targetWidth to Narrow" {
            $result = New-CardProgressBar -Value 50 -TargetWidth "Narrow"
            $result.targetWidth | Should -Be "Narrow"
        }

        It "Should set targetWidth to Standard" {
            $result = New-CardProgressBar -Value 50 -TargetWidth "Standard"
            $result.targetWidth | Should -Be "Standard"
        }

        It "Should set targetWidth to Wide" {
            $result = New-CardProgressBar -Value 50 -TargetWidth "Wide"
            $result.targetWidth | Should -Be "Wide"
        }

        It "Should set targetWidth to atLeast:Narrow" {
            $result = New-CardProgressBar -Value 50 -TargetWidth "atLeast:Narrow"
            $result.targetWidth | Should -Be "atLeast:Narrow"
        }

        It "Should set targetWidth to atMost:Wide" {
            $result = New-CardProgressBar -Value 50 -TargetWidth "atMost:Wide"
            $result.targetWidth | Should -Be "atMost:Wide"
        }

        It "Should not include targetWidth property when not specified" {
            $result = New-CardProgressBar -Value 50
            $result.ContainsKey("targetWidth") | Should -Be $false
        }

        It "Should validate targetWidth values" {
            { New-CardProgressBar -Value 50 -TargetWidth "Invalid" } | Should -Throw
        }
    }

    Context "Lang Parameter" {
        It "Should set lang property" {
            $result = New-CardProgressBar -Value 50 -Lang "en-US"
            $result.lang | Should -Be "en-US"
        }

        It "Should accept various locale formats" {
            $locales = @("en-US", "de-DE", "fr-FR", "ja-JP", "es-ES")
            foreach ($locale in $locales) {
                $result = New-CardProgressBar -Value 50 -Lang $locale
                $result.lang | Should -Be $locale
            }
        }

        It "Should not include lang property when not specified" {
            $result = New-CardProgressBar -Value 50
            $result.ContainsKey("lang") | Should -Be $false
        }
    }

    Context "Requires Parameter" {
        It "Should set requires property" {
            $requires = @{ hostCapabilities = @{ version = "1.5" } }
            $result = New-CardProgressBar -Value 50 -Requires $requires
            $result.requires | Should -Not -BeNullOrEmpty
            $result.requires.hostCapabilities.version | Should -Be "1.5"
        }

        It "Should not include requires property when not specified" {
            $result = New-CardProgressBar -Value 50
            $result.ContainsKey("requires") | Should -Be $false
        }

        It "Should accept complex requires objects" {
            $requires = @{
                hostCapabilities = @{
                    version  = "1.5"
                    features = @("progressBar", "customColors")
                }
            }
            $result = New-CardProgressBar -Value 50 -Requires $requires
            $result.requires.hostCapabilities.version | Should -Be "1.5"
            $result.requires.hostCapabilities.features.Count | Should -Be 2
        }
    }

    Context "Fallback Parameter" {
        It "Should set fallback property with scriptblock" {
            $result = New-CardProgressBar -Value 50 -Fallback {
                New-CardTextBlock -Text "Progress: 50%"
            }
            $result.fallback | Should -Not -BeNullOrEmpty
            $result.fallback.type | Should -Be "TextBlock"
        }

        It "Should not include fallback property when not specified" {
            $result = New-CardProgressBar -Value 50
            $result.ContainsKey("fallback") | Should -Be $false
        }

        It "Should execute fallback scriptblock" {
            $result = New-CardProgressBar -Value 75 -Fallback {
                @{
                    type = "TextBlock"
                    text = "Loading..."
                }
            }
            $result.fallback.type | Should -Be "TextBlock"
            $result.fallback.text | Should -Be "Loading..."
        }
    }

    Context "Switch Parameters" {
        It "Should set isVisible to false when IsHidden is specified" {
            $result = New-CardProgressBar -Value 50 -IsHidden
            $result.isVisible | Should -Be $false
        }

        It "Should not include isVisible property when IsHidden is not specified" {
            $result = New-CardProgressBar -Value 50
            $result.ContainsKey("isVisible") | Should -Be $false
        }

        It "Should set isSortKey to true when specified" {
            $result = New-CardProgressBar -Value 50 -IsSortKey
            $result.isSortKey | Should -Be $true
        }

        It "Should not include isSortKey property when not specified" {
            $result = New-CardProgressBar -Value 50
            $result.ContainsKey("isSortKey") | Should -Be $false
        }

        It "Should set separator to true when specified" {
            $result = New-CardProgressBar -Value 50 -Separator
            $result.separator | Should -Be $true
        }

        It "Should not include separator property when not specified" {
            $result = New-CardProgressBar -Value 50
            $result.ContainsKey("separator") | Should -Be $false
        }

        It "Should handle multiple switch parameters together" {
            $result = New-CardProgressBar -Value 50 -Separator -IsSortKey -IsHidden
            $result.separator | Should -Be $true
            $result.isSortKey | Should -Be $true
            $result.isVisible | Should -Be $false
        }

        It "Should support Hide alias for IsHidden" {
            $result = New-CardProgressBar -Value 50 -Hide
            $result.isVisible | Should -Be $false
        }
    }

    Context "Complex Scenarios" {
        It "Should create progress bar with all parameters" {
            $result = New-CardProgressBar `
                -Value 65 `
                -Max 100 `
                -Color "Good" `
                -Id "mainProgress" `
                -Height "stretch" `
                -HorizontalAlignment "Center" `
                -GridArea "progressArea" `
                -Spacing "Medium" `
                -TargetWidth "Standard" `
                -Lang "en-US" `
                -Separator `
                -IsSortKey

            $result.type | Should -Be "ProgressBar"
            $result.value | Should -Be 65
            $result.max | Should -Be 100
            $result.color | Should -Be "Good"
            $result.id | Should -Be "mainProgress"
            $result.height | Should -Be "stretch"
            $result.horizontalAlignment | Should -Be "Center"
            $result."grid.area" | Should -Be "progressArea"
            $result.spacing | Should -Be "Medium"
            $result.targetWidth | Should -Be "Standard"
            $result.lang | Should -Be "en-US"
            $result.separator | Should -Be $true
            $result.isSortKey | Should -Be $true
        }

        It "Should create indeterminate progress bar with styling" {
            $result = New-CardProgressBar `
                -Color "Accent" `
                -HorizontalAlignment "Center" `
                -Spacing "Large"

            $result.type | Should -Be "ProgressBar"
            $result.ContainsKey("value") | Should -Be $false
            $result.color | Should -Be "Accent"
            $result.horizontalAlignment | Should -Be "Center"
            $result.spacing | Should -Be "Large"
        }

        It "Should create progress bar with custom max value" {
            $result = New-CardProgressBar -Value 150 -Max 300 -Color "Warning"
            $result.value | Should -Be 150
            $result.max | Should -Be 300
            $result.color | Should -Be "Warning"
        }

        It "Should work with decimal percentages" {
            $result = New-CardProgressBar -Value 33.33 -Max 100
            $result.value | Should -Be 33.33
            $result.max | Should -Be 100
        }
    }

    Context "Integration with AdaptiveCard" {
        It "Should work within an AdaptiveCard body" {
            $result = New-AdaptiveCard -Content {
                New-CardProgressBar -Value 75 -Color "Good"
            }

            $card = $result | ConvertFrom-Json
            $card.type | Should -Be "AdaptiveCard"
            $card.body[0].type | Should -Be "ProgressBar"
            $card.body[0].value | Should -Be 75
        }

        It "Should work with other card elements" {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Download Progress"
                New-CardProgressBar -Value 45 -Max 100 -Id "downloadProgress"
                New-CardTextBlock -Text "45% Complete"
            }

            $card = $result | ConvertFrom-Json
            $card.body.Count | Should -Be 3
            $card.body[1].type | Should -Be "ProgressBar"
            $card.body[1].value | Should -Be 45
            $card.body[1].id | Should -Be "downloadProgress"
        }

        It "Should work in Container elements" {
            $result = New-AdaptiveCard -Content {
                New-CardContainer -Content {
                    New-CardTextBlock -Text "Status"
                    New-CardProgressBar -Value 80 -Color "Good"
                }
            }

            $card = $result | ConvertFrom-Json
            $card.body[0].type | Should -Be "Container"
            $card.body[0].items[1].type | Should -Be "ProgressBar"
            $card.body[0].items[1].value | Should -Be 80
        }
    }

    Context "Real-World Examples" {
        It "Should create file upload progress indicator" {
            $result = New-CardProgressBar `
                -Value 3 `
                -Max 10 `
                -Color "Accent" `
                -Id "uploadProgress" `
                -HorizontalAlignment "Center"

            $result.value | Should -Be 3
            $result.max | Should -Be 10
            $result.color | Should -Be "Accent"
        }

        It "Should create task completion progress bar" {
            $result = New-CardProgressBar `
                -Value 8 `
                -Max 12 `
                -Color "Good" `
                -Spacing "Medium"

            $result.value | Should -Be 8
            $result.max | Should -Be 12
            $result.color | Should -Be "Good"
        }

        It "Should create low storage warning indicator" {
            $result = New-CardProgressBar `
                -Value 92 `
                -Max 100 `
                -Color "Attention" `
                -Id "storageUsage"

            $result.value | Should -Be 92
            $result.color | Should -Be "Attention"
        }

        It "Should create loading spinner alternative (indeterminate)" {
            $result = New-CardProgressBar `
                -Color "Accent" `
                -HorizontalAlignment "Center" `
                -Id "loadingIndicator"

            $result.type | Should -Be "ProgressBar"
            $result.ContainsKey("value") | Should -Be $false
            $result.horizontalAlignment | Should -Be "Center"
        }
    }

    Context "Edge Cases" {
        It "Should handle zero value" {
            $result = New-CardProgressBar -Value 0 -Max 100
            $result.value | Should -Be 0
        }

        It "Should handle value equal to max" {
            $result = New-CardProgressBar -Value 100 -Max 100
            $result.value | Should -Be 100
            $result.max | Should -Be 100
        }

        It "Should handle very small decimal values" {
            $result = New-CardProgressBar -Value 0.01 -Max 1
            $result.value | Should -Be 0.01
        }

        It "Should handle large values" {
            $result = New-CardProgressBar -Value 5000 -Max 10000
            $result.value | Should -Be 5000
            $result.max | Should -Be 10000
        }

        It "Should handle empty string for Id" {
            $result = New-CardProgressBar -Value 50 -Id ""
            $result.id | Should -Be ""
        }

        It "Should handle multiple responsive targetWidth values" {
            $targets = @("atLeast:VeryNarrow", "atMost:Wide", "Standard")
            foreach ($target in $targets) {
                $result = New-CardProgressBar -Value 50 -TargetWidth $target
                $result.targetWidth | Should -Be $target
            }
        }
    }

    Context "ShouldProcess Support" {
        It "Should support WhatIf parameter" {
            $result = New-CardProgressBar -Value 50 -WhatIf
            $result | Should -BeNullOrEmpty
        }

        It "Should support WhatIf with all parameters" {
            $result = New-CardProgressBar -Value 75 -Max 100 -Color "Good" -WhatIf
            $result | Should -BeNullOrEmpty
        }

        It "Should support WhatIf in indeterminate mode" {
            $result = New-CardProgressBar -Color "Accent" -WhatIf
            $result | Should -BeNullOrEmpty
        }
    }

    Context "Command Metadata" {
        It "Should have correct command name" {
            $command = Get-Command -Name New-CardProgressBar
            $command.Name | Should -Be "New-CardProgressBar"
        }

        It "Should support ShouldProcess" {
            $command = Get-Command -Name New-CardProgressBar
            $command.Parameters.ContainsKey("WhatIf") | Should -Be $true
            $command.Parameters.ContainsKey("Confirm") | Should -Be $true
        }

        It "Should have help documentation" {
            $help = Get-Help -Name New-CardProgressBar
            $help.Synopsis | Should -Not -BeNullOrEmpty
            $help.Description | Should -Not -BeNullOrEmpty
        }

        It "Should have parameter documentation" {
            $help = Get-Help -Name New-CardProgressBar -Full
            $help.parameters.parameter.Count | Should -BeGreaterThan 5
        }

        It "Should have examples in help" {
            $help = Get-Help -Name New-CardProgressBar -Examples
            $help.examples.example.Count | Should -BeGreaterThan 0
        }
    }

    Context "Output Validation" {
        It "Should produce valid JSON when serialized" {
            $result = New-CardProgressBar -Value 50 -Color "Good"
            $json = $result | ConvertTo-Json -Depth 10
            $json | Should -Not -BeNullOrEmpty

            $parsed = $json | ConvertFrom-Json
            $parsed.type | Should -Be "ProgressBar"
        }

        It "Should maintain property types" {
            $result = New-CardProgressBar -Value 50 -Max 100
            $result.value.GetType().Name | Should -BeIn @("Double", "Int32")
            $result.max.GetType().Name | Should -BeIn @("Double", "Int32")
        }

        It "Should have consistent property structure" {
            $result = New-CardProgressBar -Value 75 -Color "Good" -Id "test"
            $result.Keys.Count | Should -BeGreaterThan 2
            $result.ContainsKey("type") | Should -Be $true
        }

        It "Should serialize complex progress bar correctly" {
            $result = New-CardProgressBar `
                -Value 85 `
                -Max 100 `
                -Color "Good" `
                -Id "complexProgress" `
                -Spacing "Large"

            $json = $result | ConvertTo-Json -Depth 10
            $parsed = $json | ConvertFrom-Json

            $parsed.type | Should -Be "ProgressBar"
            $parsed.value | Should -Be 85
            $parsed.max | Should -Be 100
            $parsed.color | Should -Be "Good"
            $parsed.id | Should -Be "complexProgress"
            $parsed.spacing | Should -Be "Large"
        }
    }

    Context "Parameter Combinations" {
        It "Should work with Value and Color only" {
            $result = New-CardProgressBar -Value 60 -Color "Warning"
            $result.value | Should -Be 60
            $result.color | Should -Be "Warning"
        }

        It "Should work with Value, Max, and alignment" {
            $result = New-CardProgressBar -Value 40 -Max 80 -HorizontalAlignment "Center"
            $result.value | Should -Be 40
            $result.max | Should -Be 80
            $result.horizontalAlignment | Should -Be "Center"
        }

        It "Should work with layout parameters only" {
            $result = New-CardProgressBar -GridArea "status" -Spacing "Medium" -Height "stretch"
            $result."grid.area" | Should -Be "status"
            $result.spacing | Should -Be "Medium"
            $result.height | Should -Be "stretch"
        }

        It "Should work with responsive and visibility parameters" {
            $result = New-CardProgressBar -Value 50 -TargetWidth "atLeast:Narrow" -Separator
            $result.value | Should -Be 50
            $result.targetWidth | Should -Be "atLeast:Narrow"
            $result.separator | Should -Be $true
        }
    }
}
