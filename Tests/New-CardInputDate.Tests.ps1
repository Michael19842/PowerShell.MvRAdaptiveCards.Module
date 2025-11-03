BeforeAll {
    # Import the module
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MvRAdaptiveCards\MvRAdaptiveCards.psd1'
    Import-Module $ModulePath -Force -ArgumentList $false, $true
}

Describe "New-CardInputDate" {
    Context "Basic Functionality" {
        It "Should create a basic Input.Date element" {
            $result = New-CardInputDate
            $result | Should -Not -BeNullOrEmpty
            $result.type | Should -Be "Input.Date"
        }

        It "Should return a hashtable" {
            $result = New-CardInputDate
            $result | Should -BeOfType [hashtable]
        }

        It "Should only include type property when no parameters are provided" {
            $result = New-CardInputDate
            $result.Keys.Count | Should -Be 1
            $result.Keys | Should -Contain 'type'
        }
    }

    Context "Parameter: Id" {
        It "Should set id when Id parameter is provided" {
            $result = New-CardInputDate -Id "dateInput1"
            $result.id | Should -Be "dateInput1"
        }

        It "Should not include id when Id parameter is not provided" {
            $result = New-CardInputDate
            $result.Keys | Should -Not -Contain 'id'
        }
    }

    Context "Parameter: Label" {
        It "Should set label when Label parameter is provided" {
            $result = New-CardInputDate -Label "Select Date"
            $result.label | Should -Be "Select Date"
        }

        It "Should not include label when Label parameter is not provided" {
            $result = New-CardInputDate
            $result.Keys | Should -Not -Contain 'label'
        }
    }

    Context "Parameter: Value" {
        It "Should set value when Value parameter is provided" {
            $result = New-CardInputDate -Value "2025-11-02"
            $result.value | Should -Be "2025-11-02"
        }

        It "Should accept valid ISO 8601 date format" {
            $result = New-CardInputDate -Value "2024-01-15"
            $result.value | Should -Be "2024-01-15"
        }

        It "Should not include value when Value parameter is not provided" {
            $result = New-CardInputDate
            $result.Keys | Should -Not -Contain 'value'
        }
    }

    Context "Parameter: Min" {
        It "Should set min when Min parameter is provided" {
            $result = New-CardInputDate -Min "2025-01-01"
            $result.min | Should -Be "2025-01-01"
        }

        It "Should not include min when Min parameter is not provided" {
            $result = New-CardInputDate
            $result.Keys | Should -Not -Contain 'min'
        }
    }

    Context "Parameter: Max" {
        It "Should set max when Max parameter is provided" {
            $result = New-CardInputDate -Max "2025-12-31"
            $result.max | Should -Be "2025-12-31"
        }

        It "Should not include max when Max parameter is not provided" {
            $result = New-CardInputDate
            $result.Keys | Should -Not -Contain 'max'
        }
    }

    Context "Parameter: Placeholder" {
        It "Should set placeholder when Placeholder parameter is provided" {
            $result = New-CardInputDate -Placeholder "Select a date"
            $result.placeholder | Should -Be "Select a date"
        }

        It "Should not include placeholder when Placeholder parameter is not provided" {
            $result = New-CardInputDate
            $result.Keys | Should -Not -Contain 'placeholder'
        }
    }

    Context "Parameter: IsRequired" {
        It "Should set isRequired to true when IsRequired is true" {
            $result = New-CardInputDate -IsRequired $true
            $result.isRequired | Should -Be $true
        }

        It "Should set isRequired to false when IsRequired is false" {
            $result = New-CardInputDate -IsRequired $false
            $result.isRequired | Should -Be $false
        }

        It "Should not include isRequired when IsRequired parameter is not provided" {
            $result = New-CardInputDate
            $result.Keys | Should -Not -Contain 'isRequired'
        }
    }

    Context "Parameter: ErrorMessage" {
        It "Should set errorMessage when ErrorMessage parameter is provided" {
            $result = New-CardInputDate -ErrorMessage "Date is required"
            $result.errorMessage | Should -Be "Date is required"
        }

        It "Should not include errorMessage when ErrorMessage parameter is not provided" {
            $result = New-CardInputDate
            $result.Keys | Should -Not -Contain 'errorMessage'
        }
    }

    Context "Parameter: Height" {
        It "Should set height to 'auto'" {
            $result = New-CardInputDate -Height "auto"
            $result.height | Should -Be "auto"
        }

        It "Should set height to 'stretch'" {
            $result = New-CardInputDate -Height "stretch"
            $result.height | Should -Be "stretch"
        }

        It "Should not include height when Height parameter is not provided" {
            $result = New-CardInputDate
            $result.Keys | Should -Not -Contain 'height'
        }
    }

    Context "Parameter: Separator" {
        It "Should set separator to true when Separator switch is used" {
            $result = New-CardInputDate -Separator
            $result.separator | Should -Be $true
        }

        It "Should not include separator when Separator switch is not used" {
            $result = New-CardInputDate
            $result.Keys | Should -Not -Contain 'separator'
        }
    }

    Context "Parameter: Spacing" {
        It "Should set spacing to 'None'" {
            $result = New-CardInputDate -Spacing "None"
            $result.spacing | Should -Be "None"
        }

        It "Should set spacing to 'Small'" {
            $result = New-CardInputDate -Spacing "Small"
            $result.spacing | Should -Be "Small"
        }

        It "Should set spacing to 'Default'" {
            $result = New-CardInputDate -Spacing "Default"
            $result.spacing | Should -Be "Default"
        }

        It "Should set spacing to 'Medium'" {
            $result = New-CardInputDate -Spacing "Medium"
            $result.spacing | Should -Be "Medium"
        }

        It "Should set spacing to 'Large'" {
            $result = New-CardInputDate -Spacing "Large"
            $result.spacing | Should -Be "Large"
        }

        It "Should set spacing to 'ExtraLarge'" {
            $result = New-CardInputDate -Spacing "ExtraLarge"
            $result.spacing | Should -Be "ExtraLarge"
        }

        It "Should not include spacing when Spacing parameter is not provided" {
            $result = New-CardInputDate
            $result.Keys | Should -Not -Contain 'spacing'
        }
    }

    Context "Parameter: IsVisible" {
        It "Should set isVisible to true when IsVisible is true" {
            $result = New-CardInputDate -IsVisible $true
            $result.isVisible | Should -Be $true
        }

        It "Should set isVisible to false when IsVisible is false" {
            $result = New-CardInputDate -IsVisible $false
            $result.isVisible | Should -Be $false
        }

        It "Should not include isVisible when IsVisible parameter is not provided" {
            $result = New-CardInputDate
            $result.Keys | Should -Not -Contain 'isVisible'
        }
    }

    Context "Parameter: Requires" {
        It "Should set requires when Requires parameter is provided" {
            $requires = @{ hostCapabilities = @{ capabilities = "adaptiveCards" } }
            $result = New-CardInputDate -Requires $requires
            $result.requires | Should -Not -BeNullOrEmpty
            $result.requires | Should -BeOfType [hashtable]
        }

        It "Should not include requires when Requires parameter is not provided" {
            $result = New-CardInputDate
            $result.Keys | Should -Not -Contain 'requires'
        }
    }

    Context "Parameter: Fallback" {
        It "Should set fallback to 'drop'" {
            $result = New-CardInputDate -Fallback "drop"
            $result.fallback | Should -Be "drop"
        }

        It "Should set fallback to an object" {
            $fallbackElement = @{ type = "TextBlock"; text = "Fallback text" }
            $result = New-CardInputDate -Fallback $fallbackElement
            $result.fallback | Should -BeOfType [hashtable]
            $result.fallback.type | Should -Be "TextBlock"
        }

        It "Should not include fallback when Fallback parameter is not provided" {
            $result = New-CardInputDate
            $result.Keys | Should -Not -Contain 'fallback'
        }
    }

    Context "Parameter: TargetWidth" {
        It "Should set targetWidth to 'VeryNarrow'" {
            $result = New-CardInputDate -TargetWidth "VeryNarrow"
            $result.targetWidth | Should -Be "VeryNarrow"
        }

        It "Should set targetWidth to 'Narrow'" {
            $result = New-CardInputDate -TargetWidth "Narrow"
            $result.targetWidth | Should -Be "Narrow"
        }

        It "Should set targetWidth to 'Standard'" {
            $result = New-CardInputDate -TargetWidth "Standard"
            $result.targetWidth | Should -Be "Standard"
        }

        It "Should set targetWidth to 'Wide'" {
            $result = New-CardInputDate -TargetWidth "Wide"
            $result.targetWidth | Should -Be "Wide"
        }

        It "Should set targetWidth to 'atLeast:Narrow'" {
            $result = New-CardInputDate -TargetWidth "atLeast:Narrow"
            $result.targetWidth | Should -Be "atLeast:Narrow"
        }

        It "Should not include targetWidth when TargetWidth parameter is not provided" {
            $result = New-CardInputDate
            $result.Keys | Should -Not -Contain 'targetWidth'
        }
    }

    Context "Parameter: GridArea" {
        It "Should set grid.area when GridArea parameter is provided" {
            $result = New-CardInputDate -GridArea "area1"
            $result.'grid.area' | Should -Be "area1"
        }

        It "Should not include grid.area when GridArea parameter is not provided" {
            $result = New-CardInputDate
            $result.Keys | Should -Not -Contain 'grid.area'
        }
    }

    Context "Parameter: Lang" {
        It "Should set lang when Lang parameter is provided" {
            $result = New-CardInputDate -Lang "en-US"
            $result.lang | Should -Be "en-US"
        }

        It "Should not include lang when Lang parameter is not provided" {
            $result = New-CardInputDate
            $result.Keys | Should -Not -Contain 'lang'
        }
    }

    Context "Parameter: IsSortKey" {
        It "Should set isSortKey to true when IsSortKey is true" {
            $result = New-CardInputDate -IsSortKey $true
            $result.isSortKey | Should -Be $true
        }

        It "Should set isSortKey to false when IsSortKey is false" {
            $result = New-CardInputDate -IsSortKey $false
            $result.isSortKey | Should -Be $false
        }

        It "Should not include isSortKey when IsSortKey parameter is not provided" {
            $result = New-CardInputDate
            $result.Keys | Should -Not -Contain 'isSortKey'
        }
    }

    Context "Integration Tests" {
        It "Should create a complete date input with all common properties" {
            $result = New-CardInputDate -Id "eventDate" -Label "Event Date" -Value "2025-11-15" `
                -Min "2025-01-01" -Max "2025-12-31" -Placeholder "Select event date" `
                -IsRequired $true -ErrorMessage "Please select a valid date" `
                -Spacing "Medium" -Separator

            $result.type | Should -Be "Input.Date"
            $result.id | Should -Be "eventDate"
            $result.label | Should -Be "Event Date"
            $result.value | Should -Be "2025-11-15"
            $result.min | Should -Be "2025-01-01"
            $result.max | Should -Be "2025-12-31"
            $result.placeholder | Should -Be "Select event date"
            $result.isRequired | Should -Be $true
            $result.errorMessage | Should -Be "Please select a valid date"
            $result.spacing | Should -Be "Medium"
            $result.separator | Should -Be $true
        }

        It "Should work in an Adaptive Card context" {
            $card = New-AdaptiveCard -Content {
                New-CardInputDate -Id "birthDate" -Label "Date of Birth" -IsRequired $true
            }

            $cardObj = $card | ConvertFrom-Json

            $cardObj.body | Should -Not -BeNullOrEmpty
            $cardObj.body[0].type | Should -Be "Input.Date"
            $cardObj.body[0].id | Should -Be "birthDate"
            $cardObj.body[0].label | Should -Be "Date of Birth"
            $cardObj.body[0].isRequired | Should -Be $true
        }

        It "Should work with multiple date inputs in a card" {
            $card = New-AdaptiveCard -Content {
                New-CardInputDate -Id "startDate" -Label "Start Date"
                New-CardInputDate -Id "endDate" -Label "End Date"
            }

            $cardObj = $card | ConvertFrom-Json

            $cardObj.body.Count | Should -Be 2
            $cardObj.body[0].id | Should -Be "startDate"
            $cardObj.body[1].id | Should -Be "endDate"
        }
    }

    Context "Real-World Scenarios" {
        It "Should create a birth date input with validation" {
            $result = New-CardInputDate -Id "birthDate" -Label "Date of Birth" `
                -Max (Get-Date -Format "yyyy-MM-dd") -IsRequired $true `
                -ErrorMessage "Please enter a valid birth date"

            $result.type | Should -Be "Input.Date"
            $result.id | Should -Be "birthDate"
            $result.label | Should -Be "Date of Birth"
            $result.max | Should -Match '^\d{4}-\d{2}-\d{2}$'
            $result.isRequired | Should -Be $true
            $result.errorMessage | Should -Be "Please enter a valid birth date"
        }

        It "Should create an appointment date picker with future dates only" {
            $today = Get-Date -Format "yyyy-MM-dd"
            $result = New-CardInputDate -Id "appointmentDate" -Label "Appointment Date" `
                -Min $today -Placeholder "Select your appointment date" -IsRequired $true

            $result.id | Should -Be "appointmentDate"
            $result.min | Should -Be $today
            $result.isRequired | Should -Be $true
        }

        It "Should create a date range selector for travel dates" {
            $card = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Travel Dates" -Weight Bolder
                New-CardInputDate -Id "departureDate" -Label "Departure Date" `
                    -Min (Get-Date -Format "yyyy-MM-dd") -IsRequired $true
                New-CardInputDate -Id "returnDate" -Label "Return Date" `
                    -Min (Get-Date -Format "yyyy-MM-dd") -IsRequired $true
            }

            $cardObj = $card | ConvertFrom-Json

            $cardObj.body.Count | Should -Be 3
            $cardObj.body[1].type | Should -Be "Input.Date"
            $cardObj.body[2].type | Should -Be "Input.Date"
        }

        It "Should create a date input with responsive layout" {
            $result = New-CardInputDate -Id "meetingDate" -Label "Meeting Date" `
                -TargetWidth "atLeast:Standard" -Spacing "Medium"

            $result.targetWidth | Should -Be "atLeast:Standard"
            $result.spacing | Should -Be "Medium"
        }

        It "Should create an optional date input without required flag" {
            $result = New-CardInputDate -Id "optionalDate" -Label "Optional Date" `
                -Placeholder "Leave blank if not applicable"

            $result.Keys | Should -Not -Contain 'isRequired'
            $result.placeholder | Should -Be "Leave blank if not applicable"
        }
    }

    Context "Edge Cases" {
        It "Should handle empty string for Id" {
            $result = New-CardInputDate -Id ""
            $result.id | Should -Be ""
        }

        It "Should handle special characters in Label" {
            $result = New-CardInputDate -Label "Date & Time (2024-2025)"
            $result.label | Should -Be "Date & Time (2024-2025)"
        }

        It "Should handle min date equal to max date" {
            $result = New-CardInputDate -Min "2025-11-02" -Max "2025-11-02"
            $result.min | Should -Be "2025-11-02"
            $result.max | Should -Be "2025-11-02"
        }

        It "Should handle very long placeholder text" {
            $longText = "A" * 200
            $result = New-CardInputDate -Placeholder $longText
            $result.placeholder | Should -Be $longText
            $result.placeholder.Length | Should -Be 200
        }

        It "Should handle GridArea with special naming" {
            $result = New-CardInputDate -GridArea "date-input-area-1"
            $result.'grid.area' | Should -Be "date-input-area-1"
        }
    }

    Context "ShouldProcess Support" {
        It "Should support WhatIf" {
            $result = New-CardInputDate -Id "testDate" -WhatIf
            $result | Should -BeNullOrEmpty
        }

        It "Should process when not using WhatIf" {
            $result = New-CardInputDate -Id "testDate"
            $result | Should -Not -BeNullOrEmpty
            $result.id | Should -Be "testDate"
        }
    }

    Context "Type Validation" {
        It "Should accept hashtable for Requires parameter" {
            $requires = @{ capability = "test" }
            $result = New-CardInputDate -Requires $requires
            $result.requires | Should -BeOfType [hashtable]
        }

        It "Should accept object for Fallback parameter" {
            $fallback = @{ type = "TextBlock"; text = "Fallback" }
            $result = New-CardInputDate -Fallback $fallback
            $result.fallback | Should -BeOfType [hashtable]
        }

        It "Should accept string for Fallback parameter" {
            $result = New-CardInputDate -Fallback "drop"
            $result.fallback | Should -BeOfType [string]
            $result.fallback | Should -Be "drop"
        }
    }

    Context "JSON Serialization" {
        It "Should serialize to valid JSON" {
            $result = New-CardInputDate -Id "testDate" -Label "Test" -IsRequired $true
            $json = $result | ConvertTo-Json -Depth 10
            $json | Should -Not -BeNullOrEmpty

            $deserialized = $json | ConvertFrom-Json
            $deserialized.type | Should -Be "Input.Date"
            $deserialized.id | Should -Be "testDate"
        }

        It "Should maintain data types after JSON round-trip" {
            $result = New-CardInputDate -Id "date1" -IsRequired $true -IsVisible $false
            $json = $result | ConvertTo-Json -Depth 10
            $deserialized = $json | ConvertFrom-Json

            $deserialized.isRequired | Should -BeOfType [bool]
            $deserialized.isVisible | Should -BeOfType [bool]
            $deserialized.isRequired | Should -Be $true
            $deserialized.isVisible | Should -Be $false
        }
    }

    Context "Pipeline Support" {
        It "Should work when piped to ConvertTo-Json" {
            $json = New-CardInputDate -Id "pipeTest" | ConvertTo-Json
            $json | Should -Not -BeNullOrEmpty
            $json | Should -Match '"type":\s*"Input.Date"'
        }

        It "Should work in pipeline with other card elements" {
            $elements = @(
                (New-CardTextBlock -Text "Select a date:"),
                (New-CardInputDate -Id "date1" -Label "Date")
            )

            $elements.Count | Should -Be 2
            $elements[1].type | Should -Be "Input.Date"
        }
    }

    Context "Metadata and Function Info" {
        It "Should have CmdletBinding attribute" {
            $command = Get-Command New-CardInputDate
            $command.CmdletBinding | Should -Be $true
        }

        It "Should support ShouldProcess" {
            $command = Get-Command New-CardInputDate
            $command.Parameters.ContainsKey('WhatIf') | Should -Be $true
            $command.Parameters.ContainsKey('Confirm') | Should -Be $true
        }

        It "Should have OutputType defined" {
            $command = Get-Command New-CardInputDate
            $command.OutputType.Name | Should -Contain 'System.Collections.Hashtable'
        }

        It "Should have help content" {
            $help = Get-Help New-CardInputDate
            $help.Synopsis | Should -Not -BeNullOrEmpty
            $help.Description | Should -Not -BeNullOrEmpty
        }

        It "Should have parameter help" {
            $help = Get-Help New-CardInputDate -Parameter Id
            $help.description | Should -Not -BeNullOrEmpty
        }

        It "Should have examples in help" {
            $help = Get-Help New-CardInputDate
            $help.examples | Should -Not -BeNullOrEmpty
            $help.examples.example.Count | Should -BeGreaterThan 0
        }
    }
}
