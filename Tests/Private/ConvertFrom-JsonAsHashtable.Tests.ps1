BeforeAll {
    # Import the module with private functions exposed
    Import-Module "$PSScriptRoot/../../MvRAdaptiveCards/MvRAdaptiveCards.psd1" -Force -ArgumentList $true, $true

    # Import test helpers
    . "$PSScriptRoot/../TestHelpers.ps1"
}

Describe "ConvertFrom-JsonAsHashtable" {
    Context "Basic Functionality" {
        It "Should convert simple JSON to hashtable" {
            $json = '{"name":"John","age":30}'
            $result = Invoke-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable' -Parameters @{ InputObject = $json }

            $result | Should -BeOfType [hashtable]
            $result.name | Should -Be "John"
            $result.age | Should -Be 30
        }

        It "Should handle nested objects" {
            $json = '{"person":{"name":"John","age":30},"active":true}'
            $result = Invoke-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable' -Parameters @{ InputObject = $json }

            $result.person | Should -BeOfType [hashtable]
            $result.person.name | Should -Be "John"
            $result.active | Should -Be $true
        }

        It "Should handle arrays" {
            $json = '{"items":[1,2,3]}'
            $result = Invoke-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable' -Parameters @{ InputObject = $json }

            $result.items -is [array] | Should -Be $true
            $result.items.Count | Should -Be 3
            $result.items[0] | Should -Be 1
        }

        It "Should handle arrays of objects" {
            $json = '{"users":[{"name":"John"},{"name":"Jane"}]}'
            $result = Invoke-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable' -Parameters @{ InputObject = $json }

            $result.users -is [array] | Should -Be $true
            $result.users.Count | Should -Be 2
            $result.users[0] | Should -BeOfType [hashtable]
            $result.users[0].name | Should -Be "John"
        }
    }

    Context "Special Characters and Values" {
        It "Should handle escaped quotes" {
            $json = '{"text":"He said \"Hello\""}'
            $result = Invoke-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable' -Parameters @{ InputObject = $json }

            $result.text | Should -Be 'He said "Hello"'
        }

        It "Should handle unicode characters" {
            $json = '{"text":"日本語"}'
            $result = Invoke-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable' -Parameters @{ InputObject = $json }

            $result.text | Should -Be "日本語"
        }

        It "Should handle null values" {
            $json = '{"value":null}'
            $result = Invoke-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable' -Parameters @{ InputObject = $json }

            $result.value | Should -BeNullOrEmpty
        }

        It "Should handle boolean values" {
            $json = '{"isTrue":true,"isFalse":false}'
            $result = Invoke-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable' -Parameters @{ InputObject = $json }

            $result.isTrue | Should -Be $true
            $result.isFalse | Should -Be $false
        }

        It "Should handle numbers" {
            $json = '{"integer":42,"decimal":3.14,"negative":-10}'
            $result = Invoke-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable' -Parameters @{ InputObject = $json }

            $result.integer | Should -Be 42
            $result.decimal | Should -Be 3.14
            $result.negative | Should -Be -10
        }
    }

    Context "Edge Cases" {
        It "Should handle empty object" {
            $json = '{}'
            $result = Invoke-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable' -Parameters @{ InputObject = $json }

            $result | Should -BeOfType [hashtable]
            $result.Count | Should -Be 0
        }

        It "Should handle empty array" {
            $json = '{"items":[]}'
            $result = Invoke-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable' -Parameters @{ InputObject = $json }

            $result.items -is [array] | Should -Be $true
            $result.items.Count | Should -Be 0
        }

        It "Should handle deeply nested structures" {
            $json = '{"a":{"b":{"c":{"d":"value"}}}}'
            $result = Invoke-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable' -Parameters @{ InputObject = $json }

            $result.a.b.c.d | Should -Be "value"
        }

        It "Should handle whitespace in JSON" {
            $json = @'
{
    "name": "John",
    "age": 30
}
'@
            $result = Invoke-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable' -Parameters @{ InputObject = $json }

            $result.name | Should -Be "John"
            $result.age | Should -Be 30
        }
    }

    Context "Error Handling" {
        It "Should throw on invalid JSON" {
            $json = '{invalid json}'
            { Invoke-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable' -Parameters @{ InputObject = $json } } | Should -Throw
        }

        It "Should return null on empty string" {
            $result = Invoke-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable' -Parameters @{ InputObject = '' }
            $result | Should -Be $null
        }
    }

    Context "Real-World Adaptive Card JSON" {
        It "Should convert Adaptive Card JSON structure" {
            $json = @'
{
    "type": "AdaptiveCard",
    "version": "1.5",
    "body": [
        {
            "type": "TextBlock",
            "text": "Hello World"
        }
    ]
}
'@
            $result = Invoke-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable' -Parameters @{ InputObject = $json }

            $result | Should -BeOfType [hashtable]
            $result.type | Should -Be "AdaptiveCard"
            $result.version | Should -Be "1.5"
            $result.body -is [array] | Should -Be $true
            $result.body[0].type | Should -Be "TextBlock"
            $result.body[0].text | Should -Be "Hello World"
        }
    }
}
