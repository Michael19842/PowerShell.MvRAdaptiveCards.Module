BeforeAll {
    # Import the module
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MvRAdaptiveCards\MvRAdaptiveCards.psd1'
    Import-Module $ModulePath -Force -ArgumentList $false, $true
}

Describe "New-CardInputNumber" {
    Context "Basic Functionality" {
        It "Should create a basic Input.Number element" {
            $result = New-CardInputNumber
            $result | Should -Not -BeNullOrEmpty
            $result.type | Should -Be "Input.Number"
        }

        It "Should return a hashtable" {
            $result = New-CardInputNumber
            $result | Should -BeOfType [hashtable]
        }

        It "Should only include type property when no parameters are provided" {
            $result = New-CardInputNumber
            $result.Keys.Count | Should -Be 1
            $result.Keys | Should -Contain 'type'
        }
    }

    Context "Parameter: Id" {
        It "Should set id when Id parameter is provided" {
            $result = New-CardInputNumber -Id "numberInput1"
            $result.id | Should -Be "numberInput1"
        }

        It "Should not include id when Id parameter is not provided" {
            $result = New-CardInputNumber
            $result.Keys | Should -Not -Contain 'id'
        }

        It "Should handle empty string for Id" {
            $result = New-CardInputNumber -Id ""
            $result.id | Should -Be ""
        }
    }

    Context "Parameter: Label" {
        It "Should set label when Label parameter is provided" {
            $result = New-CardInputNumber -Label "Enter Quantity"
            $result.label | Should -Be "Enter Quantity"
        }

        It "Should not include label when Label parameter is not provided" {
            $result = New-CardInputNumber
            $result.Keys | Should -Not -Contain 'label'
        }

        It "Should handle empty string for Label" {
            $result = New-CardInputNumber -Label ""
            $result.label | Should -Be ""
        }
    }

    Context "Parameter: Value" {
        It "Should set value when Value parameter is provided with integer" {
            $result = New-CardInputNumber -Value 10
            $result.value | Should -Be 10
        }

        It "Should set value when Value parameter is provided with decimal" {
            $result = New-CardInputNumber -Value 19.99
            $result.value | Should -Be 19.99
        }

        It "Should accept zero as value" {
            $result = New-CardInputNumber -Value 0
            $result.value | Should -Be 0
        }

        It "Should accept negative numbers" {
            $result = New-CardInputNumber -Value -5
            $result.value | Should -Be -5
        }

        It "Should accept large numbers" {
            $result = New-CardInputNumber -Value 1000000
            $result.value | Should -Be 1000000
        }

        It "Should not include value when Value parameter is not provided" {
            $result = New-CardInputNumber
            $result.Keys | Should -Not -Contain 'value'
        }
    }

    Context "Parameter: Min" {
        It "Should set min when Min parameter is provided" {
            $result = New-CardInputNumber -Min 1
            $result.min | Should -Be 1
        }

        It "Should accept zero as minimum" {
            $result = New-CardInputNumber -Min 0
            $result.min | Should -Be 0
        }

        It "Should accept negative minimum" {
            $result = New-CardInputNumber -Min -10
            $result.min | Should -Be -10
        }

        It "Should accept decimal minimum" {
            $result = New-CardInputNumber -Min 0.5
            $result.min | Should -Be 0.5
        }

        It "Should not include min when Min parameter is not provided" {
            $result = New-CardInputNumber
            $result.Keys | Should -Not -Contain 'min'
        }
    }

    Context "Parameter: Max" {
        It "Should set max when Max parameter is provided" {
            $result = New-CardInputNumber -Max 100
            $result.max | Should -Be 100
        }

        It "Should accept decimal maximum" {
            $result = New-CardInputNumber -Max 99.99
            $result.max | Should -Be 99.99
        }

        It "Should accept large maximum" {
            $result = New-CardInputNumber -Max 999999
            $result.max | Should -Be 999999
        }

        It "Should not include max when Max parameter is not provided" {
            $result = New-CardInputNumber
            $result.Keys | Should -Not -Contain 'max'
        }
    }

    Context "Parameter: Placeholder" {
        It "Should set placeholder when Placeholder parameter is provided" {
            $result = New-CardInputNumber -Placeholder "Enter a number"
            $result.placeholder | Should -Be "Enter a number"
        }

        It "Should not include placeholder when Placeholder parameter is not provided" {
            $result = New-CardInputNumber
            $result.Keys | Should -Not -Contain 'placeholder'
        }

        It "Should handle empty string for Placeholder" {
            $result = New-CardInputNumber -Placeholder ""
            $result.placeholder | Should -Be ""
        }
    }

    Context "Parameter: IsRequired" {
        It "Should set isRequired to true when IsRequired is true" {
            $result = New-CardInputNumber -IsRequired $true
            $result.isRequired | Should -Be $true
        }

        It "Should set isRequired to false when IsRequired is false" {
            $result = New-CardInputNumber -IsRequired $false
            $result.isRequired | Should -Be $false
        }

        It "Should not include isRequired when IsRequired parameter is not provided" {
            $result = New-CardInputNumber
            $result.Keys | Should -Not -Contain 'isRequired'
        }
    }

    Context "Parameter: ErrorMessage" {
        It "Should set errorMessage when ErrorMessage parameter is provided" {
            $result = New-CardInputNumber -ErrorMessage "Number is required"
            $result.errorMessage | Should -Be "Number is required"
        }

        It "Should not include errorMessage when ErrorMessage parameter is not provided" {
            $result = New-CardInputNumber
            $result.Keys | Should -Not -Contain 'errorMessage'
        }

        It "Should handle empty string for ErrorMessage" {
            $result = New-CardInputNumber -ErrorMessage ""
            $result.errorMessage | Should -Be ""
        }
    }

    Context "Parameter: Height" {
        It "Should set height to 'auto'" {
            $result = New-CardInputNumber -Height "auto"
            $result.height | Should -Be "auto"
        }

        It "Should set height to 'stretch'" {
            $result = New-CardInputNumber -Height "stretch"
            $result.height | Should -Be "stretch"
        }

        It "Should not include height when Height parameter is not provided" {
            $result = New-CardInputNumber
            $result.Keys | Should -Not -Contain 'height'
        }
    }

    Context "Parameter: Separator" {
        It "Should set separator to true when Separator switch is used" {
            $result = New-CardInputNumber -Separator
            $result.separator | Should -Be $true
        }

        It "Should not include separator when Separator switch is not used" {
            $result = New-CardInputNumber
            $result.Keys | Should -Not -Contain 'separator'
        }
    }

    Context "Parameter: Spacing" {
        It "Should set spacing to 'None'" {
            $result = New-CardInputNumber -Spacing "None"
            $result.spacing | Should -Be "None"
        }

        It "Should set spacing to 'Small'" {
            $result = New-CardInputNumber -Spacing "Small"
            $result.spacing | Should -Be "Small"
        }

        It "Should set spacing to 'Default'" {
            $result = New-CardInputNumber -Spacing "Default"
            $result.spacing | Should -Be "Default"
        }

        It "Should set spacing to 'Medium'" {
            $result = New-CardInputNumber -Spacing "Medium"
            $result.spacing | Should -Be "Medium"
        }

        It "Should set spacing to 'Large'" {
            $result = New-CardInputNumber -Spacing "Large"
            $result.spacing | Should -Be "Large"
        }

        It "Should set spacing to 'ExtraLarge'" {
            $result = New-CardInputNumber -Spacing "ExtraLarge"
            $result.spacing | Should -Be "ExtraLarge"
        }

        It "Should set spacing to 'Padding'" {
            $result = New-CardInputNumber -Spacing "Padding"
            $result.spacing | Should -Be "Padding"
        }

        It "Should not include spacing when Spacing parameter is not provided" {
            $result = New-CardInputNumber
            $result.Keys | Should -Not -Contain 'spacing'
        }
    }

    Context "Parameter: IsVisible" {
        It "Should set isVisible to true when IsVisible is true" {
            $result = New-CardInputNumber -IsVisible $true
            $result.isVisible | Should -Be $true
        }

        It "Should set isVisible to false when IsVisible is false" {
            $result = New-CardInputNumber -IsVisible $false
            $result.isVisible | Should -Be $false
        }

        It "Should not include isVisible when IsVisible parameter is not provided" {
            $result = New-CardInputNumber
            $result.Keys | Should -Not -Contain 'isVisible'
        }
    }

    Context "Parameter: Requires" {
        It "Should set requires when Requires parameter is provided" {
            $requires = @{ hostCapabilities = @{ capabilities = "adaptiveCards" } }
            $result = New-CardInputNumber -Requires $requires
            $result.requires | Should -Be $requires
        }

        It "Should not include requires when Requires parameter is not provided" {
            $result = New-CardInputNumber
            $result.Keys | Should -Not -Contain 'requires'
        }
    }

    Context "Parameter: Fallback" {
        It "Should set fallback to 'drop'" {
            $result = New-CardInputNumber -Fallback "drop"
            $result.fallback | Should -Be "drop"
        }

        It "Should set fallback to element object" {
            $fallbackElement = @{ type = "TextBlock"; text = "Number input not supported" }
            $result = New-CardInputNumber -Fallback $fallbackElement
            $result.fallback | Should -Be $fallbackElement
        }

        It "Should not include fallback when Fallback parameter is not provided" {
            $result = New-CardInputNumber
            $result.Keys | Should -Not -Contain 'fallback'
        }
    }

    Context "Parameter: TargetWidth" {
        It "Should set targetWidth to 'VeryNarrow'" {
            $result = New-CardInputNumber -TargetWidth "VeryNarrow"
            $result.targetWidth | Should -Be "VeryNarrow"
        }

        It "Should set targetWidth to 'Narrow'" {
            $result = New-CardInputNumber -TargetWidth "Narrow"
            $result.targetWidth | Should -Be "Narrow"
        }

        It "Should set targetWidth to 'Standard'" {
            $result = New-CardInputNumber -TargetWidth "Standard"
            $result.targetWidth | Should -Be "Standard"
        }

        It "Should set targetWidth to 'Wide'" {
            $result = New-CardInputNumber -TargetWidth "Wide"
            $result.targetWidth | Should -Be "Wide"
        }

        It "Should set targetWidth to 'atLeast:Narrow'" {
            $result = New-CardInputNumber -TargetWidth "atLeast:Narrow"
            $result.targetWidth | Should -Be "atLeast:Narrow"
        }

        It "Should not include targetWidth when TargetWidth parameter is not provided" {
            $result = New-CardInputNumber
            $result.Keys | Should -Not -Contain 'targetWidth'
        }
    }

    Context "Parameter: GridArea" {
        It "Should set grid.area when GridArea parameter is provided" {
            $result = New-CardInputNumber -GridArea "numberArea"
            $result.'grid.area' | Should -Be "numberArea"
        }

        It "Should not include grid.area when GridArea parameter is not provided" {
            $result = New-CardInputNumber
            $result.Keys | Should -Not -Contain 'grid.area'
        }

        It "Should handle empty string for GridArea" {
            $result = New-CardInputNumber -GridArea ""
            $result.'grid.area' | Should -Be ""
        }
    }

    Context "Parameter: Lang" {
        It "Should set lang when Lang parameter is provided" {
            $result = New-CardInputNumber -Lang "en-US"
            $result.lang | Should -Be "en-US"
        }

        It "Should not include lang when Lang parameter is not provided" {
            $result = New-CardInputNumber
            $result.Keys | Should -Not -Contain 'lang'
        }

        It "Should handle empty string for Lang" {
            $result = New-CardInputNumber -Lang ""
            $result.lang | Should -Be ""
        }
    }

    Context "Parameter: IsSortKey" {
        It "Should set isSortKey to true when IsSortKey is true" {
            $result = New-CardInputNumber -IsSortKey $true
            $result.isSortKey | Should -Be $true
        }

        It "Should set isSortKey to false when IsSortKey is false" {
            $result = New-CardInputNumber -IsSortKey $false
            $result.isSortKey | Should -Be $false
        }

        It "Should not include isSortKey when IsSortKey parameter is not provided" {
            $result = New-CardInputNumber
            $result.Keys | Should -Not -Contain 'isSortKey'
        }
    }

    Context "Combined Parameters" {
        It "Should handle multiple parameters together" {
            $result = New-CardInputNumber -Id "quantity" -Label "Quantity" -Value 5 -Min 1 -Max 100 -IsRequired $true
            $result.type | Should -Be "Input.Number"
            $result.id | Should -Be "quantity"
            $result.label | Should -Be "Quantity"
            $result.value | Should -Be 5
            $result.min | Should -Be 1
            $result.max | Should -Be 100
            $result.isRequired | Should -Be $true
        }

        It "Should handle all visual parameters together" {
            $result = New-CardInputNumber -Id "num1" -Height "auto" -Separator -Spacing "Large" -IsVisible $true
            $result.height | Should -Be "auto"
            $result.separator | Should -Be $true
            $result.spacing | Should -Be "Large"
            $result.isVisible | Should -Be $true
        }

        It "Should work within an Adaptive Card" {
            $cardJson = New-AdaptiveCard {
                New-CardInputNumber -Id "age" -Label "Age" -IsRequired $true
            }
            $card = $cardJson | ConvertFrom-Json
            $card | Should -Not -BeNullOrEmpty
            $card.type | Should -Be "AdaptiveCard"
            $card.body | Should -Not -BeNullOrEmpty
            $card.body[0].type | Should -Be "Input.Number"
            $card.body[0].id | Should -Be "age"
        }
    }

    Context "Number Range Scenarios" {
        It "Should handle age input range" {
            $result = New-CardInputNumber -Id "age" -Min 0 -Max 120 -Value 25
            $result.min | Should -Be 0
            $result.max | Should -Be 120
            $result.value | Should -Be 25
        }

        It "Should handle rating scale" {
            $result = New-CardInputNumber -Id "rating" -Min 1 -Max 5 -Value 3
            $result.min | Should -Be 1
            $result.max | Should -Be 5
            $result.value | Should -Be 3
        }

        It "Should handle quantity with range" {
            $result = New-CardInputNumber -Id "items" -Min 1 -Max 999 -Value 1
            $result.min | Should -Be 1
            $result.max | Should -Be 999
            $result.value | Should -Be 1
        }

        It "Should handle price with decimals" {
            $result = New-CardInputNumber -Id "price" -Min 0 -Max 10000 -Value 99.99
            $result.min | Should -Be 0
            $result.max | Should -Be 10000
            $result.value | Should -Be 99.99
        }
    }

    Context "Decimal Value Scenarios" {
        It "Should handle decimal with two places" {
            $result = New-CardInputNumber -Value 12.34
            $result.value | Should -Be 12.34
        }

        It "Should handle decimal with multiple places" {
            $result = New-CardInputNumber -Value 3.14159
            $result.value | Should -Be 3.14159
        }

        It "Should handle small decimal" {
            $result = New-CardInputNumber -Value 0.01
            $result.value | Should -Be 0.01
        }
    }

    Context "Edge Cases" {
        It "Should handle zero value explicitly" {
            $result = New-CardInputNumber -Value 0
            $result.value | Should -Be 0
            $result.Keys | Should -Contain 'value'
        }

        It "Should handle negative value explicitly" {
            $result = New-CardInputNumber -Value -10
            $result.value | Should -Be -10
            $result.Keys | Should -Contain 'value'
        }

        It "Should create valid JSON when converted" {
            $cardJson = New-AdaptiveCard {
                New-CardInputNumber -Id "num1" -Label "Test Number" -Value 42
            }
            $cardJson | Should -Not -BeNullOrEmpty
            { $cardJson | ConvertFrom-Json } | Should -Not -Throw
        }

        It "Should handle min equal to max" {
            $result = New-CardInputNumber -Min 5 -Max 5 -Value 5
            $result.min | Should -Be 5
            $result.max | Should -Be 5
            $result.value | Should -Be 5
        }
    }

    Context "Practical Use Cases" {
        It "Should create temperature input" {
            $result = New-CardInputNumber -Id "temp" -Label "Temperature (°C)" -Min -50 -Max 50 -Value 20
            $result.id | Should -Be "temp"
            $result.min | Should -Be -50
            $result.max | Should -Be 50
            $result.value | Should -Be 20
        }

        It "Should create percentage input" {
            $result = New-CardInputNumber -Id "percent" -Label "Completion %" -Min 0 -Max 100 -Value 75
            $result.id | Should -Be "percent"
            $result.min | Should -Be 0
            $result.max | Should -Be 100
            $result.value | Should -Be 75
        }

        It "Should create monetary input" {
            $result = New-CardInputNumber -Id "amount" -Label "Amount ($)" -Min 0 -Max 999999.99 -Placeholder "0.00"
            $result.id | Should -Be "amount"
            $result.min | Should -Be 0
            $result.max | Should -Be 999999.99
            $result.placeholder | Should -Be "0.00"
        }
    }
}
