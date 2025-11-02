BeforeAll {
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MvRAdaptiveCards\MvRAdaptiveCards.psd1'
    Import-Module $ModulePath -Force -ArgumentList $false, $true
}

Describe "New-CardInputText" {
    Context "Basic Functionality" {
        It "Should create a basic Input.Text element" {
            $result = New-CardInputText

            $result.type | Should -Be "Input.Text"
        }

        It "Should accept an Id parameter" {
            $result = New-CardInputText -Id "testInput"

            $result.id | Should -Be "testInput"
        }

        It "Should accept a Placeholder parameter" {
            $result = New-CardInputText -Placeholder "Enter text here"

            $result.placeholder | Should -Be "Enter text here"
        }

        It "Should accept a Value parameter" {
            $result = New-CardInputText -Value "Default value"

            $result.value | Should -Be "Default value"
        }

        It "Should accept a Label parameter" {
            $result = New-CardInputText -Label "Name"

            $result.label | Should -Be "Name"
        }
    }

    Context "Style Parameter" {
        It "Should accept Text style" {
            $result = New-CardInputText -Style Text

            $result.style | Should -Be "Text"
        }

        It "Should accept Tel style" {
            $result = New-CardInputText -Style Tel

            $result.style | Should -Be "Tel"
        }

        It "Should accept Url style" {
            $result = New-CardInputText -Style Url

            $result.style | Should -Be "Url"
        }

        It "Should accept Email style" {
            $result = New-CardInputText -Style Email

            $result.style | Should -Be "Email"
        }

        It "Should accept Password style" {
            $result = New-CardInputText -Style Password

            $result.style | Should -Be "Password"
        }

        It "Should accept Number style" {
            $result = New-CardInputText -Style Number

            $result.style | Should -Be "Number"
        }

        It "Should reject invalid style values" {
            { New-CardInputText -Style "InvalidStyle" } | Should -Throw
        }
    }

    Context "Length Validation Parameters" {
        It "Should accept MaxLength parameter" {
            $result = New-CardInputText -MaxLength 100

            $result.maxLength | Should -Be 100
        }

        It "Should accept MinLength parameter" {
            $result = New-CardInputText -MinLength 5

            $result.minLength | Should -Be 5
        }

        It "Should accept both MinLength and MaxLength" {
            $result = New-CardInputText -MinLength 5 -MaxLength 100

            $result.minLength | Should -Be 5
            $result.maxLength | Should -Be 100
        }

        It "Should handle zero as MaxLength" {
            $result = New-CardInputText -MaxLength 0

            $result.maxLength | Should -Be 0
        }

        It "Should handle zero as MinLength" {
            $result = New-CardInputText -MinLength 0

            $result.minLength | Should -Be 0
        }
    }

    Context "Multiline Parameter" {
        It "Should accept IsMultiline switch" {
            $result = New-CardInputText -IsMultiline

            $result.isMultiline | Should -Be $true
        }

        It "Should not include isMultiline when switch is not set" {
            $result = New-CardInputText

            $result.ContainsKey('isMultiline') | Should -Be $false
        }

        It "Should create multiline text area with label and placeholder" {
            $result = New-CardInputText -IsMultiline -Label "Comments" -Placeholder "Enter your feedback"

            $result.isMultiline | Should -Be $true
            $result.label | Should -Be "Comments"
            $result.placeholder | Should -Be "Enter your feedback"
        }
    }

    Context "IsRequired Parameter" {
        It "Should accept IsRequired as true" {
            $result = New-CardInputText -IsRequired $true

            $result.isRequired | Should -Be $true
        }

        It "Should accept IsRequired as false" {
            $result = New-CardInputText -IsRequired $false

            $result.isRequired | Should -Be $false
        }

        It "Should not include isRequired when not specified" {
            $result = New-CardInputText

            $result.ContainsKey('isRequired') | Should -Be $false
        }
    }

    Context "Regex Validation" {
        It "Should accept Regex parameter" {
            $result = New-CardInputText -Regex "^[a-zA-Z]+$"

            $result.regex | Should -Be "^[a-zA-Z]+$"
        }

        It "Should accept email regex pattern" {
            $pattern = "^[^@]+@[^@]+\.[^@]+$"
            $result = New-CardInputText -Regex $pattern

            $result.regex | Should -Be $pattern
        }

        It "Should accept phone number regex pattern" {
            $pattern = "^\d{3}-\d{3}-\d{4}$"
            $result = New-CardInputText -Regex $pattern

            $result.regex | Should -Be $pattern
        }

        It "Should handle complex regex patterns" {
            $pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$"
            $result = New-CardInputText -Regex $pattern

            $result.regex | Should -Be $pattern
        }
    }

    Context "Combined Properties" {
        It "Should accept all parameters together" {
            $result = New-CardInputText -Id "email" `
                -Label "Email Address" `
                -Placeholder "user@example.com" `
                -Value "test@example.com" `
                -Style Email `
                -MaxLength 100 `
                -MinLength 5 `
                -IsRequired $true `
                -Regex "^[^@]+@[^@]+\.[^@]+$"

            $result.type | Should -Be "Input.Text"
            $result.id | Should -Be "email"
            $result.label | Should -Be "Email Address"
            $result.placeholder | Should -Be "user@example.com"
            $result.value | Should -Be "test@example.com"
            $result.style | Should -Be "Email"
            $result.maxLength | Should -Be 100
            $result.minLength | Should -Be 5
            $result.isRequired | Should -Be $true
            $result.regex | Should -Be "^[^@]+@[^@]+\.[^@]+$"
        }

        It "Should create password field with validation" {
            $result = New-CardInputText -Id "password" `
                -Style Password `
                -Label "Password" `
                -MinLength 8 `
                -IsRequired $true `
                -Placeholder "At least 8 characters"

            $result.type | Should -Be "Input.Text"
            $result.id | Should -Be "password"
            $result.style | Should -Be "Password"
            $result.label | Should -Be "Password"
            $result.minLength | Should -Be 8
            $result.isRequired | Should -Be $true
            $result.placeholder | Should -Be "At least 8 characters"
        }

        It "Should create phone input with Tel style" {
            $result = New-CardInputText -Id "phone" `
                -Style Tel `
                -Label "Phone Number" `
                -MaxLength 15 `
                -Regex "^\d{3}-\d{3}-\d{4}$" `
                -Placeholder "555-123-4567"

            $result.style | Should -Be "Tel"
            $result.maxLength | Should -Be 15
            $result.regex | Should -Be "^\d{3}-\d{3}-\d{4}$"
        }

        It "Should create URL input with default value" {
            $result = New-CardInputText -Id "website" `
                -Style Url `
                -Value "https://example.com" `
                -Label "Website"

            $result.style | Should -Be "Url"
            $result.value | Should -Be "https://example.com"
            $result.label | Should -Be "Website"
        }
    }

    Context "Integration with Card Functions" {
        It "Should work within New-AdaptiveCard" {
            $card = New-AdaptiveCard {
                New-CardInputText -Id "name" -Label "Name"
            } -AsObject

            $card.type | Should -Be "AdaptiveCard"
            $card.body[0].type | Should -Be "Input.Text"
            $card.body[0].id | Should -Be "name"
        }

        It "Should work within New-CardContainer" {
            $container = New-CardContainer -Content {
                New-CardInputText -Id "field1" -Placeholder "Field 1"
                New-CardInputText -Id "field2" -Placeholder "Field 2"
            }

            $container.items.Count | Should -Be 2
            $container.items[0].type | Should -Be "Input.Text"
            $container.items[1].type | Should -Be "Input.Text"
        }

        It "Should work with multiple input fields in a form" {
            $card = New-AdaptiveCard {
                New-CardTextBlock -Text "User Registration" -Weight Bolder -Size Large
                New-CardInputText -Id "username" -Label "Username" -IsRequired $true
                New-CardInputText -Id "email" -Style Email -Label "Email" -IsRequired $true
                New-CardInputText -Id "password" -Style Password -Label "Password" -MinLength 8 -IsRequired $true
                New-CardInputText -Id "bio" -IsMultiline -Label "Bio" -MaxLength 500
            } -AsObject

            $card.body.Count | Should -Be 5
            $card.body[1].id | Should -Be "username"
            $card.body[2].style | Should -Be "Email"
            $card.body[3].style | Should -Be "Password"
            $card.body[4].isMultiline | Should -Be $true
        }
    }

    Context "Real-World Scenarios" {
        It "Should create contact form inputs" {
            $nameInput = New-CardInputText -Id "fullName" `
                -Label "Full Name" `
                -IsRequired $true `
                -Placeholder "John Doe"

            $emailInput = New-CardInputText -Id "email" `
                -Style Email `
                -Label "Email" `
                -IsRequired $true `
                -Regex "^[^@]+@[^@]+\.[^@]+$"

            $phoneInput = New-CardInputText -Id "phone" `
                -Style Tel `
                -Label "Phone" `
                -Placeholder "(555) 123-4567"

            $nameInput.isRequired | Should -Be $true
            $emailInput.style | Should -Be "Email"
            $phoneInput.style | Should -Be "Tel"
        }

        It "Should create login form" {
            $usernameInput = New-CardInputText -Id "username" `
                -Label "Username" `
                -IsRequired $true `
                -MinLength 3 `
                -MaxLength 20

            $passwordInput = New-CardInputText -Id "password" `
                -Style Password `
                -Label "Password" `
                -IsRequired $true `
                -MinLength 8

            $usernameInput.minLength | Should -Be 3
            $usernameInput.maxLength | Should -Be 20
            $passwordInput.style | Should -Be "Password"
            $passwordInput.minLength | Should -Be 8
        }

        It "Should create feedback form with multiline" {
            $commentsInput = New-CardInputText -Id "comments" `
                -IsMultiline `
                -Label "Your Feedback" `
                -Placeholder "Tell us what you think..." `
                -MaxLength 1000 `
                -IsRequired $true

            $commentsInput.isMultiline | Should -Be $true
            $commentsInput.maxLength | Should -Be 1000
            $commentsInput.isRequired | Should -Be $true
        }

        It "Should handle special characters in values" {
            $result = New-CardInputText -Id "test" `
                -Value "Test & <Special> 'Chars' `"Quotes`"" `
                -Placeholder "Enter 'quoted' text" `
                -Label "Special & Characters"

            $result.value | Should -Match "Special"
            $result.placeholder | Should -Match "quoted"
            $result.label | Should -Match "Special"
        }

        It "Should create search input" {
            $result = New-CardInputText -Id "search" `
                -Placeholder "Search..." `
                -Label "Search" `
                -MaxLength 100

            $result.id | Should -Be "search"
            $result.placeholder | Should -Be "Search..."
        }
    }

    Context "Edge Cases" {
        It "Should handle empty strings" {
            $result = New-CardInputText -Id "" -Value "" -Placeholder ""

            $result.type | Should -Be "Input.Text"
        }

        It "Should handle very long strings" {
            $longText = "a" * 1000
            $result = New-CardInputText -Value $longText -MaxLength 1000

            $result.value.Length | Should -Be 1000
            $result.maxLength | Should -Be 1000
        }

        It "Should handle unicode characters" {
            $result = New-CardInputText -Id "unicode" `
                -Label "名前" `
                -Placeholder "あいうえお" `
                -Value "日本語"

            $result.label | Should -Be "名前"
            $result.placeholder | Should -Be "あいうえお"
            $result.value | Should -Be "日本語"
        }

        It "Should handle special regex characters" {
            $result = New-CardInputText -Regex "[\w\d\-_\.]+@[\w\d\-_]+\.[\w]+"

            $result.regex | Should -Match "\\w"
        }

        It "Should not add properties when parameters are omitted" {
            $result = New-CardInputText

            $result.ContainsKey('id') | Should -Be $false
            $result.ContainsKey('placeholder') | Should -Be $false
            $result.ContainsKey('value') | Should -Be $false
            $result.ContainsKey('style') | Should -Be $false
            $result.ContainsKey('maxLength') | Should -Be $false
            $result.ContainsKey('minLength') | Should -Be $false
            $result.ContainsKey('isMultiline') | Should -Be $false
            $result.ContainsKey('isRequired') | Should -Be $false
            $result.ContainsKey('regex') | Should -Be $false
            $result.ContainsKey('label') | Should -Be $false
        }

        It "Should handle negative numbers for lengths" {
            $result = New-CardInputText -MinLength -5 -MaxLength -10

            $result.minLength | Should -Be -5
            $result.maxLength | Should -Be -10
        }
    }

    Context "Command Metadata" {
        It "Should support WhatIf" {
            $result = New-CardInputText -Id "test" -WhatIf

            $result | Should -BeNullOrEmpty
        }

        It "Should have correct output type" {
            $result = New-CardInputText

            $result | Should -BeOfType [hashtable]
        }

        It "Should have SupportsShouldProcess" {
            $command = Get-Command New-CardInputText
            $command.Parameters.ContainsKey('WhatIf') | Should -Be $true
            $command.Parameters.ContainsKey('Confirm') | Should -Be $true
        }
    }

    Context "Parameter Validation" {
        It "Should validate Style parameter values" {
            $command = Get-Command New-CardInputText
            $styleParam = $command.Parameters['Style']
            $validateSet = $styleParam.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }

            $validateSet.ValidValues | Should -Contain "Text"
            $validateSet.ValidValues | Should -Contain "Tel"
            $validateSet.ValidValues | Should -Contain "Url"
            $validateSet.ValidValues | Should -Contain "Email"
            $validateSet.ValidValues | Should -Contain "Password"
            $validateSet.ValidValues | Should -Contain "Number"
            $validateSet.ValidValues.Count | Should -Be 6
        }

        It "Should have correct parameter types" {
            $command = Get-Command New-CardInputText

            $command.Parameters['Id'].ParameterType | Should -Be ([string])
            $command.Parameters['Placeholder'].ParameterType | Should -Be ([string])
            $command.Parameters['Value'].ParameterType | Should -Be ([string])
            $command.Parameters['Style'].ParameterType | Should -Be ([string])
            $command.Parameters['MaxLength'].ParameterType | Should -Be ([int])
            $command.Parameters['MinLength'].ParameterType | Should -Be ([int])
            $command.Parameters['IsMultiline'].ParameterType | Should -Be ([switch])
            $command.Parameters['IsRequired'].ParameterType | Should -Be ([bool])
            $command.Parameters['Regex'].ParameterType | Should -Be ([string])
            $command.Parameters['Label'].ParameterType | Should -Be ([string])
        }

        It "Should have all parameters as optional" {
            $command = Get-Command New-CardInputText

            $command.Parameters['Id'].Attributes.Mandatory | Should -Contain $false
            $command.Parameters['Style'].Attributes.Mandatory | Should -Contain $false
            $command.Parameters['IsRequired'].Attributes.Mandatory | Should -Contain $false
        }
    }
}
