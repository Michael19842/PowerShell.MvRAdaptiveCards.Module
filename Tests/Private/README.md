# Testing Private Functions

This document explains how to test private (internal) functions in the MvRAdaptiveCards module.

## Overview

The module contains private helper functions that are not exported by default but need to be tested. To facilitate this, we've implemented a testing infrastructure that allows tests to access these private functions.

## How It Works

### 1. Module Loading with Private Functions Exposed

When you import the module with the `-ArgumentList $true, $true` parameters, it enables the `ExposePrivateReferences` flag:

```powershell
Import-Module "$PSScriptRoot/../../MvRAdaptiveCards/MvRAdaptiveCards.psd1" -Force -ArgumentList $true, $true
```

The first `$true` is for `ExposePrivateReferences`, and the second `$true` is for `NoBanner`.

### 2. Test Helper Functions

The `Tests/TestHelpers.ps1` file provides three helper functions to access private module functions:

#### Get-PrivateFunction
Retrieves a private function reference from the module.

```powershell
$convertFunc = Get-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable'
& $convertFunc -InputObject '{"key":"value"}'
```

#### Invoke-PrivateFunction
Directly invokes a private function with parameters.

```powershell
# With named parameters
$result = Invoke-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable' -Parameters @{
    InputObject = '{"key":"value"}'
}

# With positional arguments
$result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @(
    $true,
    { 'Yes' },
    { 'No' }
)
```

#### Test-PrivateFunction
Checks if a private function exists in the module.

```powershell
$exists = Test-PrivateFunction -FunctionName 'IIF'
```

## Creating Tests for Private Functions

### Test File Structure

Place private function tests in the `Tests/Private/` directory:

```
Tests/
├── Private/
│   ├── ConvertFrom-JsonAsHashtable.Tests.ps1
│   ├── IIF.Tests.ps1
│   └── Convert-ObjectToHashtable.Tests.ps1
└── TestHelpers.ps1
```

### Example Test File Template

```powershell
BeforeAll {
    # Import the module with private functions exposed
    Import-Module "$PSScriptRoot/../../MvRAdaptiveCards/MvRAdaptiveCards.psd1" -Force -ArgumentList $true, $true

    # Import test helpers
    . "$PSScriptRoot/../TestHelpers.ps1"
}

Describe "YourPrivateFunction" {
    Context "Basic Functionality" {
        It "Should do something" {
            $result = Invoke-PrivateFunction -FunctionName 'YourPrivateFunction' -Parameters @{
                Param1 = 'value1'
                Param2 = 'value2'
            }

            $result | Should -Be 'expected value'
        }
    }
}
```

## Available Private Functions

The following private functions are available for testing:

### Helper Functions
- `IIF` - Inline If function (ternary operator)
- `ConvertFrom-JsonAsHashtable` - Converts JSON to hashtable
- `Convert-ObjectToHashtable` - Converts PSCustomObject to hashtable
- `Write-ColoredHost` - Writes colored output to host
- `Write-Banner` - Writes module banner

### Settings Functions
- `Get-CardSetting` - Retrieves module settings
- `Set-CardSetting` - Updates module settings

### Schema Functions
- `Test-CardSchema` - Validates card against schema

### Element Functions
- `New-CardTextRun` - Creates TextRun elements (internal)

## Special Considerations

### ScriptBlock Parameters

Some private functions (like `IIF`) expect scriptblock parameters. When testing these, wrap values in scriptblocks:

```powershell
# Correct
$result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @(
    $true,
    { 'TrueValue' },      # Wrapped in scriptblock
    { 'FalseValue' }      # Wrapped in scriptblock
)

# Incorrect
$result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @(
    $true,
    'TrueValue',          # Will fail - not a scriptblock
    'FalseValue'
)
```

### Module Scope

Private functions execute within the module's scope, which means:
- They have access to module-level variables (like `$_MaxDepth`, `$_MvRACSettings`)
- They can call other private functions
- They cannot access test script variables unless passed as parameters

## Running Private Function Tests

Run all private function tests:
```powershell
Invoke-Pester -Path './Tests/Private/'
```

Run a specific private function test:
```powershell
Invoke-Pester -Path './Tests/Private/IIF.Tests.ps1'
```

Include in full test suite:
```powershell
Invoke-Pester -Path './Tests/'
```

## Best Practices

1. **Test file naming**: Name test files after the function they test: `FunctionName.Tests.ps1`
2. **Organize by context**: Group related tests in `Context` blocks
3. **Document expected behavior**: Use descriptive `It` statements
4. **Test edge cases**: Include tests for error conditions, null values, empty inputs, etc.
5. **Keep tests isolated**: Each test should be independent and not rely on state from other tests
6. **Use BeforeAll**: Import the module and helpers in `BeforeAll` block, not in each test

## Example: Complete Test File

```powershell
BeforeAll {
    Import-Module "$PSScriptRoot/../../MvRAdaptiveCards/MvRAdaptiveCards.psd1" -Force -ArgumentList $true, $true
    . "$PSScriptRoot/../TestHelpers.ps1"
}

Describe "IIF" {
    Context "Basic Functionality" {
        It "Should return true value when condition is true" {
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @(
                $true,
                { 'Yes' },
                { 'No' }
            )

            $result | Should -Be 'Yes'
        }

        It "Should return false value when condition is false" {
            $result = Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList @(
                $false,
                { 'Yes' },
                { 'No' }
            )

            $result | Should -Be 'No'
        }
    }
}
```

## Troubleshooting

### "Module not loaded" Error
Ensure the module is imported with the correct path:
```powershell
Import-Module "$PSScriptRoot/../../MvRAdaptiveCards/MvRAdaptiveCards.psd1" -Force -ArgumentList $true, $true
```

### "Private function not found" Error
- Verify the function name is correct (case-sensitive)
- Ensure the function is actually defined in the Private folder
- Check that the module loaded successfully

### "Cannot convert to ScriptBlock" Error
- Wrap values in scriptblocks `{ }` when the function expects ScriptBlock parameters
- Check the function signature to verify expected parameter types

## Contributing

When adding new private functions, please:
1. Create corresponding test files in `Tests/Private/`
2. Follow the existing test file structure
3. Include comprehensive test coverage (basic, edge cases, error handling)
4. Update this README if adding new helper functions
