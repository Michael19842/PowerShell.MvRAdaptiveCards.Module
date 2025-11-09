# Contributing to MvRAdaptiveCards

Thank you for your interest in contributing to the MvRAdaptiveCards PowerShell module! We welcome contributions from the community and are excited to collaborate with you.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Contributing Process](#contributing-process)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Documentation Guidelines](#documentation-guidelines)
- [Submitting Changes](#submitting-changes)
- [Release Process](#release-process)

## Code of Conduct

This project adheres to a code of conduct that we expect all contributors to follow. Please be respectful, inclusive, and constructive in all interactions.

## Getting Started

### Prerequisites

Before you begin contributing, ensure you have the following installed:

- **PowerShell 5.1 or later** (PowerShell Core 7.x recommended)
- **Git** for version control
- **Visual Studio Code** (recommended) with the PowerShell extension
- **Pester** for testing (will be installed automatically during build)
- **PSScriptAnalyzer** for code analysis (will be installed automatically during build)

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```powershell
   git clone https://github.com/your-username/PowerShell.MvRAdaptiveCards.Module.git
   cd PowerShell.MvRAdaptiveCards.Module
   ```

## Development Setup

### Initial Setup

1. **Install Dependencies**: The build script will automatically install required modules:
   ```powershell
   .\Build\Build.ps1
   ```

2. **Test the Module**: Run the test script to ensure everything works:
   ```powershell
   .\Test-Module.ps1 -Build
   ```

### Development Workflow

1. **Load the Module**: Use the test script to load the latest version:
   ```powershell
   .\Test-Module.ps1
   ```

2. **Make Changes**: Edit files in the appropriate directories
3. **Test Changes**: Run tests frequently during development
4. **Build and Test**: Use the build script to validate your changes

## Project Structure

```
PowerShell.MvRAdaptiveCards.Module/
├── MvRAdaptiveCards/           # Main module directory
│   ├── Public/                 # Public functions (exported)
│   ├── Private/                # Private/internal functions
│   ├── MvRAdaptiveCards.psd1   # Module manifest
│   └── MvRAdaptiveCards.psm1   # Module script file
├── Build/                      # Build scripts and configuration
│   ├── Build.ps1              # Main build script (PSake)
│   ├── BuildConfig.json       # Build configuration
│   └── Deploy.ps1             # Deployment script
├── Tests/                      # Pester test files
├── docs/                       # Function documentation
├── Examples/                   # Example scripts and demos
├── Demo/                       # Demo output files
└── lib/                        # External libraries
```

## Contributing Process

### Types of Contributions

We welcome several types of contributions:

- **Bug Fixes**: Fix issues in existing functionality
- **New Features**: Add new cmdlets or enhance existing ones
- **Documentation**: Improve or add documentation
- **Tests**: Add or improve test coverage
- **Examples**: Provide usage examples and demos

### Before You Start

1. **Check Existing Issues**: Look for existing issues or feature requests
2. **Create an Issue**: If none exists, create one to discuss your proposed changes
3. **Get Feedback**: Discuss your approach with maintainers before starting large changes

## Coding Standards

### PowerShell Best Practices

1. **Naming Conventions**:
   - Use approved PowerShell verbs (`Get-Verb` for list)
   - Follow Noun-Verb pattern: `New-CardTextBlock`, `Get-CardResponse`
   - Use PascalCase for function names and parameters

2. **Parameter Guidelines**:
   - Use appropriate parameter attributes (`[Parameter(Mandatory)]`, `[ValidateSet()]`)
   - Provide parameter help with `.PARAMETER` comments
   - Use consistent parameter names across similar functions

3. **Code Structure**:
   - Keep functions focused on a single responsibility
   - Use consistent indentation (4 spaces)
   - Add appropriate error handling with `try/catch` blocks
   - Use `Write-Verbose` for detailed logging

### Function Template

```powershell
function New-CardExample {
    <#
    .SYNOPSIS
    Brief description of what the function does.

    .DESCRIPTION
    Detailed description of the function's purpose and behavior.

    .PARAMETER ParameterName
    Description of the parameter.

    .EXAMPLE
    New-CardExample -ParameterName "Value"
    Description of what this example does.

    .NOTES
    Any additional notes about the function.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ParameterName
    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand.Name)"
    }

    process {
        try {
            # Function logic here

            # Return appropriate object
            return $result
        }
        catch {
            Write-Error "Error in $($MyInvocation.MyCommand.Name): $($_.Exception.Message)"
            throw
        }
    }
}
```

### PSScriptAnalyzer Rules

- Code must pass PSScriptAnalyzer with default rules
- Use `[Diagnostics.CodeAnalysis.SuppressMessageAttribute()]` sparingly and with justification
- Address all warnings and errors before submitting

## Testing Guidelines

### Test Structure

1. **Test Files**: Each public function should have a corresponding `.Tests.ps1` file in the `Tests/` directory
2. **Test Naming**: Use descriptive test names that explain what is being tested
3. **Test Coverage**: Aim for comprehensive coverage of functionality and edge cases

### Test Template

```powershell
Describe "New-CardExample" {
    BeforeAll {
        Import-Module "$PSScriptRoot\..\MvRAdaptiveCards" -Force
    }

    Context "Parameter Validation" {
        It "Should throw when required parameter is missing" {
            { New-CardExample } | Should -Throw
        }

        It "Should accept valid parameter values" {
            { New-CardExample -ParameterName "ValidValue" } | Should -Not -Throw
        }
    }

    Context "Functionality" {
        It "Should return expected object type" {
            $result = New-CardExample -ParameterName "TestValue"
            $result | Should -BeOfType [PSCustomObject]
        }

        It "Should have required properties" {
            $result = New-CardExample -ParameterName "TestValue"
            $result.type | Should -Be "ExpectedType"
        }
    }
}
```

### Running Tests

```powershell
# Run all tests
Invoke-Pester -Path .\Tests\

# Run specific test file
Invoke-Pester -Path .\Tests\New-CardExample.Tests.ps1

# Run tests with coverage
Invoke-Pester -Path .\Tests\ -CodeCoverage .\MvRAdaptiveCards\Public\*.ps1
```

## Documentation Guidelines

### Function Documentation

1. **Comment-Based Help**: All public functions must have complete comment-based help
2. **Examples**: Provide at least one working example
3. **Parameter Descriptions**: Document all parameters clearly
4. **Output**: Describe what the function returns

### External Documentation

1. **Markdown Files**: Function documentation is generated automatically in the `docs/` folder
2. **README Updates**: Update README.md when adding significant new features
3. **Examples**: Add examples to the `Examples/` directory for complex scenarios

### Documentation Generation

```powershell
# Generate documentation (part of build process)
Import-Module PlatyPS
New-MarkdownHelp -Module MvRAdaptiveCards -OutputFolder .\docs\
```

## Submitting Changes

### Pull Request Process

1. **Create a Branch**: Create a feature branch from `main`
   ```powershell
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes**: Implement your changes following the guidelines above

3. **Test Thoroughly**:
   ```powershell
   # Run the build script
   .\Build\Build.ps1

   # Run tests
   Invoke-Pester -Path .\Tests\

   # Test the module
   .\Test-Module.ps1 -Build
   ```

4. **Commit Changes**: Use clear, descriptive commit messages
   ```powershell
   git add .
   git commit -m "Add New-CardExample cmdlet for example functionality"
   ```

5. **Push and Create PR**: Push to your fork and create a pull request

### Pull Request Guidelines

1. **Clear Title**: Use a descriptive title for your PR
2. **Detailed Description**: Explain what changes you made and why
3. **Link Issues**: Reference any related issues
4. **Test Results**: Include test results in your PR description
5. **Documentation**: Ensure documentation is updated

### PR Template

```markdown
## Description
Brief description of changes made.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Test improvement

## Testing
- [ ] Tests pass locally
- [ ] New tests added for new functionality
- [ ] Manual testing completed

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes (or clearly documented)

## Related Issues
Closes #(issue number)
```

## Not appreciated changes:
- Changes that do not follow coding standards.
- Incomplete features without prior discussion.
- Obscure or unclear code. Code should be easy to read and understand.

## Release Process

The release process is handled by maintainers and follows semantic versioning:

1. **Version Updates**: Update version numbers in module manifest
2. **Release Notes**: Update `ReleaseNotes.md` with changes
3. **Testing**: Comprehensive testing across different PowerShell versions
4. **PowerShell Gallery**: Publish to PowerShell Gallery
5. **GitHub Release**: Create GitHub release with changelog

## Getting Help

If you need help with contributing:

1. **Check Documentation**: Review existing documentation and examples
2. **Create an Issue**: Ask questions by creating a GitHub issue
3. **Join Discussions**: Participate in GitHub Discussions if available
4. **Contact Maintainers**: Reach out to project maintainers

## Recognition

Contributors will be recognized in:
- Release notes for their contributions
- GitHub contributor graphs
- Special recognition for significant contributions

---

Thank you for contributing to MvRAdaptiveCards! Your contributions help make PowerShell and Adaptive Cards more accessible to everyone.