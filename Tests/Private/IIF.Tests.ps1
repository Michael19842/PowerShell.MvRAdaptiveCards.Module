BeforeAll {
    # Import the module with private functions exposed
    Import-Module "$PSScriptRoot/../../MvRAdaptiveCards/MvRAdaptiveCards.psd1" -Force -ArgumentList $true, $true

    # Import test helpers
    . "$PSScriptRoot/../TestHelpers.ps1"
}

Describe "IIF (Inline If)" {
    Context "Basic Functionality" {
        It "Should return true value when condition is true" {
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @($true, { 'Yes' }, { 'No' })

            $result | Should -Be 'Yes'
        }

        It "Should return false value when condition is false" {
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @($false, { 'Yes' }, { 'No' })

            $result | Should -Be 'No'
        }

        It "Should work with numeric values" {
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @($true, { 42 }, { 0 })

            $result | Should -Be 42
        }

        It "Should work with boolean return values" {
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @($true, { $true }, { $false })

            $result | Should -Be $true
        }
    }

    Context "Complex Conditions" {
        It "Should evaluate comparison expressions" {
            $a = 5
            $b = 10
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @(($a -lt $b), { 'Less' }, { 'Greater' })

            $result | Should -Be 'Less'
        }

        It "Should work with null condition (treated as false)" {
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @(($null -eq $null), { 'Yes' }, { 'No' })

            $result | Should -Be 'Yes'
        }

        It "Should work with empty string condition (evaluated as boolean)" {
            $emptyString = ''
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @(([string]::IsNullOrEmpty($emptyString)), { 'Empty' }, { 'Not Empty' })

            $result | Should -Be 'Empty'
        }

        It "Should work with zero condition (treated as false)" {
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @(0, { 'Yes' }, { 'No' })

            $result | Should -Be 'No'
        }

        It "Should work with non-zero number condition (treated as true)" {
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @(1, { 'Yes' }, { 'No' })

            $result | Should -Be 'Yes'
        }

        It "Should work with non-empty string condition (evaluated as boolean)" {
            $text = 'text'
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @((-not [string]::IsNullOrEmpty($text)), { 'Yes' }, { 'No' })

            $result | Should -Be 'Yes'
        }
    }

    Context "Return Value Types" {
        It "Should return hashtable values" {
            $hashTrue = @{ key = 'value1' }
            $hashFalse = @{ key = 'value2' }
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @($true, { $hashTrue }, { $hashFalse })

            $result.key | Should -Be 'value1'
        }

        It "Should return array values" {
            $arrayTrue = @(1, 2, 3)
            $arrayFalse = @(4, 5, 6)
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @($true, { $arrayTrue }, { $arrayFalse })

            $result.Count | Should -Be 3
            $result[0] | Should -Be 1
        }

        It "Should return null values" {
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @($true, { $null }, { 'value' })

            $result | Should -BeNullOrEmpty
        }

        It "Should return PSCustomObject values" {
            $obj = [PSCustomObject]@{ Name = 'Test' }
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @($true, { $obj }, { $null })

            $result.Name | Should -Be 'Test'
        }
    }

    Context "Real-World Usage Scenarios" {
        It "Should select property based on condition" {
            $isVisible = $true
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @($isVisible, { 'visible' }, { 'hidden' })

            $result | Should -Be 'visible'
        }

        It "Should select size based on condition" {
            $isLarge = $false
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @($isLarge, { 'Large' }, { 'Small' })

            $result | Should -Be 'Small'
        }

        It "Should select style based on condition" {
            $isError = $true
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @($isError, { 'Attention' }, { 'Default' })

            $result | Should -Be 'Attention'
        }

        It "Should work in nested conditions" {
            $condition1 = $true
            $condition2 = $false
            $result1 = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @($condition1, { 'A' }, { 'B' })
            $result2 = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @($condition2, { $result1 }, { 'C' })

            $result2 | Should -Be 'C'
        }
    }

    Context "Edge Cases" {
        It "Should handle identical true and false values" {
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @($true, { 'Same' }, { 'Same' })

            $result | Should -Be 'Same'
        }

        It "Should handle complex object conditions (converted to boolean)" {
            $obj = @{ prop = 'value' }
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @(($null -ne $obj), { 'Yes' }, { 'No' })

            $result | Should -Be 'Yes'
        }

        It "Should handle array as condition (evaluated for emptiness)" {
            $arr = @(1, 2, 3)
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @(($arr.Count -gt 0), { 'Yes' }, { 'No' })

            $result | Should -Be 'Yes'
        }

        It "Should handle empty array as condition (evaluated for emptiness)" {
            $arr = @()
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @(($arr.Count -gt 0), { 'Yes' }, { 'No' })

            $result | Should -Be 'No'
        }
    }
}
