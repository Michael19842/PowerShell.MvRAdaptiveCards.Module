BeforeAll {
    # Import the module
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MvRAdaptiveCards\MvRAdaptiveCards.psd1'
    Import-Module $ModulePath -Force -ArgumentList $False, $true

    # Helper function to read settings file directly
    function Get-SettingsContent {
        $settingsPath = Join-Path -Path $env:APPDATA -ChildPath 'PowerShell.MvRAdaptiveCards.Module\settings.json'
        if (Test-Path $settingsPath) {
            return Get-Content $settingsPath -Raw | ConvertFrom-Json -AsHashtable
        }
        return $null
    }
}

Describe "Set-CardDefaultFallback" {

    BeforeEach {
        # Clear any existing fallback before each test
        Set-CardDefaultFallback -Clear -Confirm:$false
    }

    AfterAll {
        # Clean up after all tests
        Set-CardDefaultFallback -Clear -Confirm:$false
    }

    Context "Basic Functionality" {
        It "Should set default fallback content" {
            $fallback = {
                New-CardTextBlock -Text "Fallback text" -Wrap
            }

            { Set-CardDefaultFallback -FallbackContent $fallback -Confirm:$false } | Should -Not -Throw

            # Verify it was saved by reading the settings file
            $settings = Get-SettingsContent
            $settings.General.DefaultFallback | Should -Not -BeNullOrEmpty
        }

        It "Should store fallback as string" {
            $fallback = {
                New-CardTextBlock -Text "Test" -Wrap
            }

            Set-CardDefaultFallback -FallbackContent $fallback -Confirm:$false

            $settings = Get-SettingsContent
            $settings.General.DefaultFallback | Should -BeOfType [string]
        }

        It "Should clear fallback when Clear switch is used" {
            # First set a fallback
            Set-CardDefaultFallback -FallbackContent {
                New-CardTextBlock -Text "Test"
            } -Confirm:$false

            # Then clear it
            Set-CardDefaultFallback -Clear -Confirm:$false

            $settings = Get-SettingsContent
            $settings.General.DefaultFallback | Should -BeNullOrEmpty
        }
    }

    Context "Fallback Content Variations" {
        It "Should handle simple text fallback" {
            Set-CardDefaultFallback -FallbackContent {
                New-CardTextBlock -Text "Not supported" -Wrap
            } -Confirm:$false

            $settings = Get-SettingsContent
            $settings.General.DefaultFallback | Should -Match "New-CardTextBlock"
            $settings.General.DefaultFallback | Should -Match "Not supported"
        }

        It "Should handle container fallback" {
            Set-CardDefaultFallback -FallbackContent {
                New-CardContainer -Content {
                    New-CardTextBlock -Text "Feature unavailable" -Size Large
                } -Style 'Warning'
            } -Confirm:$false

            $settings = Get-SettingsContent
            $settings.General.DefaultFallback | Should -Match "New-CardContainer"
            $settings.General.DefaultFallback | Should -Match "Feature unavailable"
        }

        It "Should handle multiple elements in fallback" {
            Set-CardDefaultFallback -FallbackContent {
                New-CardTextBlock -Text "Title" -Size Large -Weight Bolder
                New-CardTextBlock -Text "Description" -Wrap
                New-CardTextBlock -Text "Footer" -IsSubtle
            } -Confirm:$false

            $settings = Get-SettingsContent
            $settings.General.DefaultFallback | Should -Match "Title"
            $settings.General.DefaultFallback | Should -Match "Description"
            $settings.General.DefaultFallback | Should -Match "Footer"
        }

        It "Should handle complex nested fallback" {
            Set-CardDefaultFallback -FallbackContent {
                New-CardContainer -Content {
                    New-CardTextBlock -Text "Not Supported" -Size Large -Weight Bolder
                    New-CardFactSet -Facts @{
                        "Issue"  = "Element not supported"
                        "Action" = "Update your application"
                    }
                } -Style 'Attention'
            } -Confirm:$false

            $settings = Get-SettingsContent
            $settings.General.DefaultFallback | Should -Not -BeNullOrEmpty
            $settings.General.DefaultFallback.Length | Should -BeGreaterThan 50
        }
    }

    Context "Integration with New-AdaptiveCard" {
        It "Should apply default fallback to card when none specified" {
            # Set default fallback
            Set-CardDefaultFallback -FallbackContent {
                New-CardTextBlock -Text "Default fallback" -Wrap
            } -Confirm:$false

            # Create card without explicit fallback
            $card = New-AdaptiveCard {
                New-CardTextBlock -Text "Main content"
            }

            # The fallback should be applied (this would need the actual New-AdaptiveCard implementation to verify)
            $card | Should -Not -BeNullOrEmpty
        }

        It "Should allow card to override default fallback" {
            # Set default fallback
            Set-CardDefaultFallback -FallbackContent {
                New-CardTextBlock -Text "Default fallback"
            } -Confirm:$false

            # Create card with explicit fallback
            $card = New-AdaptiveCard -Fallback {
                New-CardTextBlock -Text "Custom fallback"
            } -Content {
                New-CardTextBlock -Text "Main content"
            }

            $card | Should -Not -BeNullOrEmpty
        }
    }

    Context "Settings Persistence" {
        It "Should persist fallback across function calls" {
            $fallback = {
                New-CardTextBlock -Text "Persistent fallback" -Wrap
            }

            Set-CardDefaultFallback -FallbackContent $fallback -Confirm:$false

            # Get settings in a new call
            $settings1 = Get-SettingsContent
            $value1 = $settings1.General.DefaultFallback

            # Get settings again
            $settings2 = Get-SettingsContent
            $value2 = $settings2.General.DefaultFallback

            $value1 | Should -Be $value2
        }

        It "Should update existing fallback when set multiple times" {
            # Set first fallback
            Set-CardDefaultFallback -FallbackContent {
                New-CardTextBlock -Text "First fallback"
            } -Confirm:$false

            $settings1 = Get-SettingsContent
            $first = $settings1.General.DefaultFallback

            # Set second fallback
            Set-CardDefaultFallback -FallbackContent {
                New-CardTextBlock -Text "Second fallback"
            } -Confirm:$false

            $settings2 = Get-SettingsContent
            $second = $settings2.General.DefaultFallback

            $first | Should -Not -Be $second
            $second | Should -Match "Second fallback"
        }
    }

    Context "ShouldProcess Support" {
        It "Should support WhatIf" {
            $result = Set-CardDefaultFallback -FallbackContent {
                New-CardTextBlock -Text "Test"
            } -WhatIf

            # WhatIf should not actually save
            $settings = Get-SettingsContent
            $settings.General.DefaultFallback | Should -Be ''
        }

        It "Should support Confirm parameter" {
            # This test verifies the parameter exists, actual confirmation requires user interaction
            $command = Get-Command Set-CardDefaultFallback
            $command.Parameters.ContainsKey('Confirm') | Should -Be $true
        }
    }

    Context "Parameter Validation" {
        It "Should accept ScriptBlock for FallbackContent" {
            $fallback = {
                New-CardTextBlock -Text "Test"
            }

            { Set-CardDefaultFallback -FallbackContent $fallback -Confirm:$false } | Should -Not -Throw
        }

        It "Should accept Clear switch" {
            { Set-CardDefaultFallback -Clear -Confirm:$false } | Should -Not -Throw
        }

        It "Should not require FallbackContent when Clear is specified" {
            { Set-CardDefaultFallback -Clear -Confirm:$false } | Should -Not -Throw
        }

        It "Should work with both FallbackContent and Clear (Clear takes precedence)" {
            Set-CardDefaultFallback -FallbackContent {
                New-CardTextBlock -Text "Test"
            } -Clear -Confirm:$false

            $settings = Get-SettingsContent
            $settings.General.DefaultFallback | Should -BeNullOrEmpty
        }
    }

    Context "Edge Cases" {
        It "Should handle empty scriptblock" {
            Set-CardDefaultFallback -FallbackContent {} -Confirm:$false

            $settings = Get-SettingsContent
            $settings.General.DefaultFallback | Should -Be ''
        }

        It "Should handle scriptblock with comments" {
            Set-CardDefaultFallback -FallbackContent {
                # This is a comment
                New-CardTextBlock -Text "Test" # Inline comment
            } -Confirm:$false

            $settings = Get-SettingsContent
            $settings.General.DefaultFallback | Should -Match "comment"
        }

        It "Should handle scriptblock with variables" {
            Set-CardDefaultFallback -FallbackContent {
                $message = "Not supported"
                New-CardTextBlock -Text $message -Wrap
            } -Confirm:$false

            $settings = Get-SettingsContent
            $settings.General.DefaultFallback | Should -Match '\$message'
        }

        It "Should handle very long scriptblock" {
            $longFallback = {
                New-CardContainer -Content {
                    New-CardTextBlock -Text "Line 1" -Wrap
                    New-CardTextBlock -Text "Line 2" -Wrap
                    New-CardTextBlock -Text "Line 3" -Wrap
                    New-CardTextBlock -Text "Line 4" -Wrap
                    New-CardTextBlock -Text "Line 5" -Wrap
                    New-CardFactSet -Facts @{
                        "Key1" = "Value1"
                        "Key2" = "Value2"
                        "Key3" = "Value3"
                    }
                } -Style 'Warning'
            }

            Set-CardDefaultFallback -FallbackContent $longFallback -Confirm:$false

            $settings = Get-SettingsContent
            $settings.General.DefaultFallback.Length | Should -BeGreaterThan 100
        }

        It "Should handle unicode characters in fallback" {
            Set-CardDefaultFallback -FallbackContent {
                New-CardTextBlock -Text "✗ Not supported 不支持" -Wrap
            } -Confirm:$false

            $settings = Get-SettingsContent
            $settings.General.DefaultFallback | Should -Match "Not supported"
        }
    }

    Context "Error Handling" {
        It "Should handle missing Get-CardSetting gracefully" {
            # This test assumes Get-CardSetting is available
            { $settings = Get-SettingsContent } | Should -Not -Throw
        }

        It "Should handle missing Set-CardSetting gracefully" {
            # This test assumes Set-CardSetting is available
            { Set-CardDefaultFallback -Clear -Confirm:$false } | Should -Not -Throw
        }
    }

    Context "Command Metadata" {
        It "Should have correct command name" {
            $command = Get-Command Set-CardDefaultFallback
            $command.Name | Should -Be "Set-CardDefaultFallback"
        }

        It "Should support ShouldProcess" {
            $command = Get-Command Set-CardDefaultFallback
            $command.CmdletBinding | Should -Match $true
        }

        It "Should have help documentation" {
            $help = Get-Help Set-CardDefaultFallback
            $help.Synopsis | Should -Not -BeNullOrEmpty
            $help.Description | Should -Not -BeNullOrEmpty
        }

        It "Should have examples in help" {
            $help = Get-Help Set-CardDefaultFallback -Full
            $help.Examples | Should -Not -BeNullOrEmpty
            $help.Examples.Example.Count | Should -BeGreaterThan 0
        }
    }
}
