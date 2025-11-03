BeforeAll {
    # Import the module
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MvRAdaptiveCards\MvRAdaptiveCards.psd1'
    Import-Module $ModulePath -Force -ArgumentList $false, $true
}

Describe "New-CardInputTime" {
    Context "Basic Functionality" {
        It "Should create a basic Input.Time element" {
            $result = New-CardInputTime
            $result | Should -Not -BeNullOrEmpty
            $result.type | Should -Be "Input.Time"
        }

        It "Should return a hashtable" {
            $result = New-CardInputTime
            $result | Should -BeOfType [hashtable]
        }

        It "Should only include type property when no parameters are provided" {
            $result = New-CardInputTime
            $result.Keys.Count | Should -Be 1
            $result.Keys | Should -Contain 'type'
        }
    }

    Context "Parameter: Id" {
        It "Should set id when Id parameter is provided" {
            $result = New-CardInputTime -Id "timeInput1"
            $result.id | Should -Be "timeInput1"
        }

        It "Should not include id when Id parameter is not provided" {
            $result = New-CardInputTime
            $result.Keys | Should -Not -Contain 'id'
        }

        It "Should handle empty string for Id" {
            $result = New-CardInputTime -Id ""
            $result.id | Should -Be ""
        }
    }

    Context "Parameter: Label" {
        It "Should set label when Label parameter is provided" {
            $result = New-CardInputTime -Label "Select Time"
            $result.label | Should -Be "Select Time"
        }

        It "Should not include label when Label parameter is not provided" {
            $result = New-CardInputTime
            $result.Keys | Should -Not -Contain 'label'
        }

        It "Should handle empty string for Label" {
            $result = New-CardInputTime -Label ""
            $result.label | Should -Be ""
        }
    }

    Context "Parameter: Value" {
        It "Should set value when Value parameter is provided" {
            $result = New-CardInputTime -Value "14:30"
            $result.value | Should -Be "14:30"
        }

        It "Should accept valid HH:MM format" {
            $result = New-CardInputTime -Value "09:00"
            $result.value | Should -Be "09:00"
        }

        It "Should accept midnight time" {
            $result = New-CardInputTime -Value "00:00"
            $result.value | Should -Be "00:00"
        }

        It "Should accept end of day time" {
            $result = New-CardInputTime -Value "23:59"
            $result.value | Should -Be "23:59"
        }

        It "Should not include value when Value parameter is not provided" {
            $result = New-CardInputTime
            $result.Keys | Should -Not -Contain 'value'
        }

        It "Should handle empty string for Value" {
            $result = New-CardInputTime -Value ""
            $result.value | Should -Be ""
        }
    }

    Context "Parameter: Min" {
        It "Should set min when Min parameter is provided" {
            $result = New-CardInputTime -Min "09:00"
            $result.min | Should -Be "09:00"
        }

        It "Should not include min when Min parameter is not provided" {
            $result = New-CardInputTime
            $result.Keys | Should -Not -Contain 'min'
        }

        It "Should handle empty string for Min" {
            $result = New-CardInputTime -Min ""
            $result.min | Should -Be ""
        }
    }

    Context "Parameter: Max" {
        It "Should set max when Max parameter is provided" {
            $result = New-CardInputTime -Max "17:00"
            $result.max | Should -Be "17:00"
        }

        It "Should not include max when Max parameter is not provided" {
            $result = New-CardInputTime
            $result.Keys | Should -Not -Contain 'max'
        }

        It "Should handle empty string for Max" {
            $result = New-CardInputTime -Max ""
            $result.max | Should -Be ""
        }
    }

    Context "Parameter: Placeholder" {
        It "Should set placeholder when Placeholder parameter is provided" {
            $result = New-CardInputTime -Placeholder "Select a time"
            $result.placeholder | Should -Be "Select a time"
        }

        It "Should not include placeholder when Placeholder parameter is not provided" {
            $result = New-CardInputTime
            $result.Keys | Should -Not -Contain 'placeholder'
        }

        It "Should handle empty string for Placeholder" {
            $result = New-CardInputTime -Placeholder ""
            $result.placeholder | Should -Be ""
        }
    }

    Context "Parameter: IsRequired" {
        It "Should set isRequired to true when IsRequired is true" {
            $result = New-CardInputTime -IsRequired $true
            $result.isRequired | Should -Be $true
        }

        It "Should set isRequired to false when IsRequired is false" {
            $result = New-CardInputTime -IsRequired $false
            $result.isRequired | Should -Be $false
        }

        It "Should not include isRequired when IsRequired parameter is not provided" {
            $result = New-CardInputTime
            $result.Keys | Should -Not -Contain 'isRequired'
        }
    }

    Context "Parameter: ErrorMessage" {
        It "Should set errorMessage when ErrorMessage parameter is provided" {
            $result = New-CardInputTime -ErrorMessage "Time is required"
            $result.errorMessage | Should -Be "Time is required"
        }

        It "Should not include errorMessage when ErrorMessage parameter is not provided" {
            $result = New-CardInputTime
            $result.Keys | Should -Not -Contain 'errorMessage'
        }

        It "Should handle empty string for ErrorMessage" {
            $result = New-CardInputTime -ErrorMessage ""
            $result.errorMessage | Should -Be ""
        }
    }

    Context "Parameter: Height" {
        It "Should set height to 'auto'" {
            $result = New-CardInputTime -Height "auto"
            $result.height | Should -Be "auto"
        }

        It "Should set height to 'stretch'" {
            $result = New-CardInputTime -Height "stretch"
            $result.height | Should -Be "stretch"
        }

        It "Should not include height when Height parameter is not provided" {
            $result = New-CardInputTime
            $result.Keys | Should -Not -Contain 'height'
        }
    }

    Context "Parameter: Separator" {
        It "Should set separator to true when Separator switch is used" {
            $result = New-CardInputTime -Separator
            $result.separator | Should -Be $true
        }

        It "Should not include separator when Separator switch is not used" {
            $result = New-CardInputTime
            $result.Keys | Should -Not -Contain 'separator'
        }
    }

    Context "Parameter: Spacing" {
        It "Should set spacing to 'None'" {
            $result = New-CardInputTime -Spacing "None"
            $result.spacing | Should -Be "None"
        }

        It "Should set spacing to 'Small'" {
            $result = New-CardInputTime -Spacing "Small"
            $result.spacing | Should -Be "Small"
        }

        It "Should set spacing to 'Default'" {
            $result = New-CardInputTime -Spacing "Default"
            $result.spacing | Should -Be "Default"
        }

        It "Should set spacing to 'Medium'" {
            $result = New-CardInputTime -Spacing "Medium"
            $result.spacing | Should -Be "Medium"
        }

        It "Should set spacing to 'Large'" {
            $result = New-CardInputTime -Spacing "Large"
            $result.spacing | Should -Be "Large"
        }

        It "Should set spacing to 'ExtraLarge'" {
            $result = New-CardInputTime -Spacing "ExtraLarge"
            $result.spacing | Should -Be "ExtraLarge"
        }

        It "Should set spacing to 'Padding'" {
            $result = New-CardInputTime -Spacing "Padding"
            $result.spacing | Should -Be "Padding"
        }

        It "Should not include spacing when Spacing parameter is not provided" {
            $result = New-CardInputTime
            $result.Keys | Should -Not -Contain 'spacing'
        }
    }

    Context "Parameter: IsVisible" {
        It "Should set isVisible to true when IsVisible is true" {
            $result = New-CardInputTime -IsVisible $true
            $result.isVisible | Should -Be $true
        }

        It "Should set isVisible to false when IsVisible is false" {
            $result = New-CardInputTime -IsVisible $false
            $result.isVisible | Should -Be $false
        }

        It "Should not include isVisible when IsVisible parameter is not provided" {
            $result = New-CardInputTime
            $result.Keys | Should -Not -Contain 'isVisible'
        }
    }

    Context "Parameter: Requires" {
        It "Should set requires when Requires parameter is provided" {
            $requires = @{ hostCapabilities = @{ capabilities = "adaptiveCards" } }
            $result = New-CardInputTime -Requires $requires
            $result.requires | Should -Be $requires
        }

        It "Should not include requires when Requires parameter is not provided" {
            $result = New-CardInputTime
            $result.Keys | Should -Not -Contain 'requires'
        }
    }

    Context "Parameter: Fallback" {
        It "Should set fallback to 'drop'" {
            $result = New-CardInputTime -Fallback "drop"
            $result.fallback | Should -Be "drop"
        }

        It "Should set fallback to element object" {
            $fallbackElement = @{ type = "TextBlock"; text = "Time input not supported" }
            $result = New-CardInputTime -Fallback $fallbackElement
            $result.fallback | Should -Be $fallbackElement
        }

        It "Should not include fallback when Fallback parameter is not provided" {
            $result = New-CardInputTime
            $result.Keys | Should -Not -Contain 'fallback'
        }
    }

    Context "Parameter: TargetWidth" {
        It "Should set targetWidth to 'VeryNarrow'" {
            $result = New-CardInputTime -TargetWidth "VeryNarrow"
            $result.targetWidth | Should -Be "VeryNarrow"
        }

        It "Should set targetWidth to 'Narrow'" {
            $result = New-CardInputTime -TargetWidth "Narrow"
            $result.targetWidth | Should -Be "Narrow"
        }

        It "Should set targetWidth to 'Standard'" {
            $result = New-CardInputTime -TargetWidth "Standard"
            $result.targetWidth | Should -Be "Standard"
        }

        It "Should set targetWidth to 'Wide'" {
            $result = New-CardInputTime -TargetWidth "Wide"
            $result.targetWidth | Should -Be "Wide"
        }

        It "Should set targetWidth to 'atLeast:Narrow'" {
            $result = New-CardInputTime -TargetWidth "atLeast:Narrow"
            $result.targetWidth | Should -Be "atLeast:Narrow"
        }

        It "Should not include targetWidth when TargetWidth parameter is not provided" {
            $result = New-CardInputTime
            $result.Keys | Should -Not -Contain 'targetWidth'
        }
    }

    Context "Parameter: GridArea" {
        It "Should set grid.area when GridArea parameter is provided" {
            $result = New-CardInputTime -GridArea "timeArea"
            $result.'grid.area' | Should -Be "timeArea"
        }

        It "Should not include grid.area when GridArea parameter is not provided" {
            $result = New-CardInputTime
            $result.Keys | Should -Not -Contain 'grid.area'
        }

        It "Should handle empty string for GridArea" {
            $result = New-CardInputTime -GridArea ""
            $result.'grid.area' | Should -Be ""
        }
    }

    Context "Parameter: Lang" {
        It "Should set lang when Lang parameter is provided" {
            $result = New-CardInputTime -Lang "en-US"
            $result.lang | Should -Be "en-US"
        }

        It "Should not include lang when Lang parameter is not provided" {
            $result = New-CardInputTime
            $result.Keys | Should -Not -Contain 'lang'
        }

        It "Should handle empty string for Lang" {
            $result = New-CardInputTime -Lang ""
            $result.lang | Should -Be ""
        }
    }

    Context "Parameter: IsSortKey" {
        It "Should set isSortKey to true when IsSortKey is true" {
            $result = New-CardInputTime -IsSortKey $true
            $result.isSortKey | Should -Be $true
        }

        It "Should set isSortKey to false when IsSortKey is false" {
            $result = New-CardInputTime -IsSortKey $false
            $result.isSortKey | Should -Be $false
        }

        It "Should not include isSortKey when IsSortKey parameter is not provided" {
            $result = New-CardInputTime
            $result.Keys | Should -Not -Contain 'isSortKey'
        }
    }

    Context "Combined Parameters" {
        It "Should handle multiple parameters together" {
            $result = New-CardInputTime -Id "meetingTime" -Label "Meeting Time" -Value "14:00" -Min "09:00" -Max "17:00" -IsRequired $true
            $result.type | Should -Be "Input.Time"
            $result.id | Should -Be "meetingTime"
            $result.label | Should -Be "Meeting Time"
            $result.value | Should -Be "14:00"
            $result.min | Should -Be "09:00"
            $result.max | Should -Be "17:00"
            $result.isRequired | Should -Be $true
        }

        It "Should handle all visual parameters together" {
            $result = New-CardInputTime -Id "time1" -Height "auto" -Separator -Spacing "Large" -IsVisible $true
            $result.height | Should -Be "auto"
            $result.separator | Should -Be $true
            $result.spacing | Should -Be "Large"
            $result.isVisible | Should -Be $true
        }

        It "Should work within an Adaptive Card" {
            $cardJson = New-AdaptiveCard {
                New-CardInputTime -Id "eventTime" -Label "Event Time" -IsRequired $true
            }
            $card = $cardJson | ConvertFrom-Json
            $card | Should -Not -BeNullOrEmpty
            $card.type | Should -Be "AdaptiveCard"
            $card.body | Should -Not -BeNullOrEmpty
            $card.body[0].type | Should -Be "Input.Time"
            $card.body[0].id | Should -Be "eventTime"
        }
    }

    Context "Time Format Scenarios" {
        It "Should handle business hours time range" {
            $result = New-CardInputTime -Id "workTime" -Min "09:00" -Max "17:00" -Value "12:00"
            $result.min | Should -Be "09:00"
            $result.max | Should -Be "17:00"
            $result.value | Should -Be "12:00"
        }

        It "Should handle early morning times" {
            $result = New-CardInputTime -Value "06:30"
            $result.value | Should -Be "06:30"
        }

        It "Should handle late evening times" {
            $result = New-CardInputTime -Value "22:45"
            $result.value | Should -Be "22:45"
        }
    }

    Context "Edge Cases" {
        It "Should handle time with leading zeros" {
            $result = New-CardInputTime -Value "08:05"
            $result.value | Should -Be "08:05"
        }

        It "Should create valid JSON when converted" {
            $cardJson = New-AdaptiveCard {
                New-CardInputTime -Id "time1" -Label "Test Time" -Value "10:30"
            }
            $cardJson | Should -Not -BeNullOrEmpty
            { $cardJson | ConvertFrom-Json } | Should -Not -Throw
        }
    }
}
