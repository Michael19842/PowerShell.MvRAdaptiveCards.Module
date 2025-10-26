BeforeAll {
    # Import the module
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MvRAdaptiveCards\MvRAdaptiveCards.psd1'
    Import-Module $ModulePath -Force -ArgumentList $false, $true
}

Describe "New-CardInputToggle" {

    Context "Basic Functionality" {
        It "Should create a toggle with required Id" {
            $result = New-CardInputToggle -Id "toggle1"

            $result | Should -Not -BeNullOrEmpty
            $result | Should -BeOfType [hashtable]
            $result.type | Should -Be "Input.Toggle"
            $result.id | Should -Be "toggle1"
        }

        It "Should throw error when Id is missing" {
            { New-CardInputToggle -Id $null } | Should -Throw
        }

        It "Should return a hashtable" {
            $result = New-CardInputToggle -Id "toggle1"
            $result | Should -BeOfType [hashtable]
        }
    }

    Context "Title Property" {
        It "Should set title when provided" {
            $result = New-CardInputToggle -Id "toggle1" -Title "Accept Terms"
            $result.title | Should -Be "Accept Terms"
        }

        It "Should not have title key when not provided" {
            $result = New-CardInputToggle -Id "toggle1"
            $result.ContainsKey('title') | Should -Be $false
        }
    }

    Context "Value Properties" {
        It "Should set default value" {
            $result = New-CardInputToggle -Id "toggle1" -Value $True
            $result.value | Should -Be $True
        }

        It "Should set valueOn" {
            $result = New-CardInputToggle -Id "toggle1" -ValueOn "yes"
            $result.valueOn | Should -Be "yes"
        }

        It "Should set valueOff" {
            $result = New-CardInputToggle -Id "toggle1" -ValueOff "no"
            $result.valueOff | Should -Be "no"
        }

        It "Should set custom on/off values" {
            $result = New-CardInputToggle -Id "darkMode" -ValueOn "dark" -ValueOff "light" -Value "light"

            $result.value | Should -Be "light"
            $result.valueOn | Should -Be "dark"
            $result.valueOff | Should -Be "light"
        }

        It "Should have default value of 'false' when not specified" {
            $result = New-CardInputToggle -Id "toggle1"
            $result.value | Should -Be "false"
        }
    }

    Context "Label and Required Properties" {
        It "Should set label" {
            $result = New-CardInputToggle -Id "toggle1" -Label "Terms Checkbox"
            $result.label | Should -Be "Terms Checkbox"
        }

        It "Should set isRequired to true" {
            $result = New-CardInputToggle -Id "toggle1" -IsRequired
            $result.isRequired | Should -Be $true
        }

        It "Should not have isRequired key when not required" {
            $result = New-CardInputToggle -Id "toggle1"
            $result.ContainsKey('isRequired') | Should -Be $false
        }

        It "Should set errorMessage" {
            $result = New-CardInputToggle -Id "toggle1" -ErrorMessage "You must accept the terms"
            $result.errorMessage | Should -Be "You must accept the terms"
        }
    }

    Context "Layout Properties" {
        It "Should set wrap to true by default" {
            $result = New-CardInputToggle -Id "toggle1" -Wrap $true
            $result.wrap | Should -Be $true
        }

        It "Should set wrap to false" {
            $result = New-CardInputToggle -Id "toggle1" -Wrap $false
            $result.wrap | Should -Be $false
        }

        It "Should set isVisible" {
            $result = New-CardInputToggle -Id "toggle1" -IsVisible $false
            $result.isVisible | Should -Be $false
        }

        It "Should set separator" {
            $result = New-CardInputToggle -Id "toggle1" -Separator
            $result.separator | Should -Be $true
        }

        It "Should set spacing" {
            $result = New-CardInputToggle -Id "toggle1" -Spacing "Large"
            $result.spacing | Should -Be "Large"
        }

        It "Should validate spacing values" {
            { New-CardInputToggle -Id "toggle1" -Spacing "Invalid" } | Should -Throw
        }

        It "Should set height" {
            $result = New-CardInputToggle -Id "toggle1" -Height "stretch"
            $result.height | Should -Be "stretch"
        }

        It "Should validate height values" {
            { New-CardInputToggle -Id "toggle1" -Height "invalid" } | Should -Throw
        }
    }

    Context "Advanced Properties" {
        It "Should set targetWidth" {
            $result = New-CardInputToggle -Id "toggle1" -TargetWidth "Wide"
            $result.targetWidth | Should -Be "Wide"
        }

        It "Should set targetWidth with atLeast prefix" {
            $result = New-CardInputToggle -Id "toggle1" -TargetWidth "atLeast:Narrow"
            $result.targetWidth | Should -Be "atLeast:Narrow"
        }

        It "Should validate targetWidth values" {
            { New-CardInputToggle -Id "toggle1" -TargetWidth "InvalidWidth" } | Should -Throw
        }

        It "Should set grid.area" {
            $result = New-CardInputToggle -Id "toggle1" -GridArea "main-content"
            $result.'grid.area' | Should -Be "main-content"
        }

        It "Should set isSortKey" {
            $result = New-CardInputToggle -Id "toggle1" -IsSortKey
            $result.isSortKey | Should -Be $true
        }

        It "Should set lang" {
            $result = New-CardInputToggle -Id "toggle1" -Lang "en-US"
            $result.lang | Should -Be "en-US"
        }

        It "Should set requires" {
            $requires = @{ "capabilities" = "1.3" }
            $result = New-CardInputToggle -Id "toggle1" -Requires $requires
            $result.requires | Should -Be $requires
        }

        It "Should set fallback" {
            $fallback = @{ type = "TextBlock"; text = "Fallback text" }
            $result = New-CardInputToggle -Id "toggle1" -Fallback $fallback
            $result.fallback | Should -Be $fallback
        }

        It "Should set valueChangedAction" {
            $action = @{ type = "Action.Submit"; title = "Submit" }
            $result = New-CardInputToggle -Id "toggle1" -ValueChangedAction $action
            $result.valueChangedAction | Should -Be $action
        }
    }

    Context "Complete Example" {
        It "Should create a complete toggle with all properties" {
            $result = New-CardInputToggle `
                -Id "acceptTerms" `
                -Title "I accept the terms and conditions" `
                -Value "false" `
                -ValueOn "accepted" `
                -ValueOff "declined" `
                -Label "Terms Acceptance" `
                -IsRequired `
                -ErrorMessage "You must accept to continue" `
                -Wrap $true `
                -Separator `
                -Spacing "Medium" `
                -GridArea "footer"

            $result.type | Should -Be "Input.Toggle"
            $result.id | Should -Be "acceptTerms"
            $result.title | Should -Be "I accept the terms and conditions"
            $result.value | Should -Be "false"
            $result.valueOn | Should -Be "accepted"
            $result.valueOff | Should -Be "declined"
            $result.label | Should -Be "Terms Acceptance"
            $result.isRequired | Should -Be $true
            $result.errorMessage | Should -Be "You must accept to continue"
            $result.wrap | Should -Be $true
            $result.separator | Should -Be $true
            $result.spacing | Should -Be "Medium"
            $result.'grid.area' | Should -Be "footer"
        }
    }

    Context "Integration with Adaptive Card" {
        It "Should work within New-AdaptiveCard" {
            $card = New-AdaptiveCard {
                New-CardInputToggle -Id "notifications" -Title "Enable notifications"
            } -AsObject

            $card.body | Should -HaveCount 1
            $card.body[0].type | Should -Be "Input.Toggle"
            $card.body[0].id | Should -Be "notifications"
        }

        It "Should create multiple toggles in a card" {
            $card = New-AdaptiveCard {
                New-CardInputToggle -Id "toggle1" -Title "Option 1"
                New-CardInputToggle -Id "toggle2" -Title "Option 2"
                New-CardInputToggle -Id "toggle3" -Title "Option 3"
            } -AsObject

            $card.body | Should -HaveCount 3
            $card.body[0].id | Should -Be "toggle1"
            $card.body[1].id | Should -Be "toggle2"
            $card.body[2].id | Should -Be "toggle3"
        }
    }

    Context "ShouldProcess Support" {
        It "Should support WhatIf" {
            $result = New-CardInputToggle -Id "toggle1" -WhatIf
            # WhatIf should not return a result
            $result | Should -BeNullOrEmpty
        }
    }

    Context "Edge Cases" {
        It "Should handle empty string title" {
            $result = New-CardInputToggle -Id "toggle1" -Title ""
            $result.title | Should -Be ""
        }

        It "Should handle special characters in Id" {
            $result = New-CardInputToggle -Id "toggle-1_test"
            $result.id | Should -Be "toggle-1_test"
        }

        It "Should handle unicode in title" {
            $result = New-CardInputToggle -Id "toggle1" -Title "✓ Agree 同意"
            $result.title | Should -Be "✓ Agree 同意"
        }

        It "Should handle very long title" {
            $longTitle = "A" * 1000
            $result = New-CardInputToggle -Id "toggle1" -Title $longTitle
            $result.title.Length | Should -Be 1000
        }
    }
}
