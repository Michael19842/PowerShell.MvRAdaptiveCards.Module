

Describe 'New-AdaptiveCard' {

    BeforeAll {
        # Import the module
        $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MvRAdaptiveCards\MvRAdaptiveCards.psd1'
        Import-Module $ModulePath -Force -ArgumentList $false, $true
    }

    Context 'Basic Functionality' {
        It 'Should create a basic adaptive card with default properties' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            }

            $card = $result | ConvertFrom-Json
            $card.type | Should -Be "AdaptiveCard"
            $card.'$schema' | Should -Be "http://adaptivecards.io/schemas/adaptive-card.json"
            $card.version | Should -Be "1.5"
            $card.body | Should -Not -BeNullOrEmpty
            $card.body[0].type | Should -Be "TextBlock"
            $card.body[0].text | Should -Be "Test"
        }

        It 'Should return hashtable when AsObject is specified' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -AsObject

            $result | Should -BeOfType [hashtable]
            $result.type | Should -Be "AdaptiveCard"
            $result.version | Should -Be "1.5"
        }

        It 'Should handle empty content gracefully' {
            $result = New-AdaptiveCard -Content { }

            $card = $result | ConvertFrom-Json -NoEnumerate
            $card.type | Should -Be "AdaptiveCard"
            $card.body | Should -BeNullOrEmpty
            $card.body.Count | Should -Be 0
        }
    }

    Context 'Content Handling' {
        It 'Should add single content element to body' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Single Element"
            } -AsObject

            $result.body | Should -HaveCount 1
            $result.body[0].text | Should -Be "Single Element"
        }

        It 'Should add multiple content elements to body' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "First"
                New-CardTextBlock -Text "Second"
            } -AsObject

            $result.body | Should -HaveCount 2
            $result.body[0].text | Should -Be "First"
            $result.body[1].text | Should -Be "Second"
        }
    }

    Context 'Actions Parameter' {
        It 'Should add actions to the card' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -Actions {
                New-CardActionSubmit -Title "Submit" -Data @{ test = "value" }
            } -AsObject

            $result.actions | Should -Not -BeNullOrEmpty
            $result.actions.title | Should -Be "Submit"
            $result.actions.type | Should -Be "Action.Submit"
        }
    }

    Context 'Card Properties' {
        It 'Should set card ID when specified' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -Id "test-card" -AsObject

            $result.id | Should -Be "test-card"
        }

        It 'Should set custom version when ForceVersion is specified' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -ForceVersion "1.4" -AsObject

            $result.version | Should -Be "1.4"
        }

        It 'Should set language when specified' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -Language "en-US" -AsObject

            $result.lang | Should -Be "en-US"
        }

        It 'Should set style when specified' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -Style "emphasis" -AsObject

            $result.style | Should -Be "emphasis"
        }

        It 'Should set fallback text when specified' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -FallbackText "Fallback content" -AsObject

            $result.fallbackText | Should -Be "Fallback content"
        }

        It 'Should set speak text when specified' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -Speak "This is test content" -AsObject

            $result.speak | Should -Be "This is test content"
        }

        It 'Should set minimum height when specified' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -MinimalHeightInPixels 200 -AsObject

            $result.minHeight | Should -Be "200px"
        }

        It 'Should set vertical content alignment when specified' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -verticalContentAlignment "Center" -AsObject

            $result.verticalContentAlignment | Should -Be "Center"
        }
    }

    Context 'Teams Integration' {
        It 'Should set Teams full width when SetFullWidthForTeams is specified' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -SetFullWidthForTeams -AsObject

            $result.msTeams | Should -Not -BeNullOrEmpty
            $result.msTeams.width | Should -Be "Full"
        }
    }

    Context 'Advanced Features' {
        It 'Should set RTL when RightToLeft is specified' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -RightToLeft -AsObject

            $result.rtl | Should -Be $true
        }

        It 'Should set isVisible to false when Hidden is specified' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -Hidden -AsObject

            $result.isVisible | Should -Be $false
        }

        It 'Should set isSortKey when specified' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -isSortKey -AsObject

            $result.isSortKey | Should -Be $true
        }

        It 'Should set grid area when specified' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -GridArea "main-content" -AsObject

            $result.gridArea | Should -Be "main-content"
        }

        It 'Should set metadata when MetadataOriginatingUrl is specified' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -MetadataOriginatingUrl "https://example.com" -AsObject

            $result.metadata | Should -Not -BeNullOrEmpty
            $result.metadata.originatingUrl | Should -Be "https://example.com"
        }
    }

    Context 'Authentication' {
        It 'Should set authentication when valid authentication hashtable is provided' {
            $authConfig = @{
                buttons               = @("signin")
                connectionName        = "TestConnection"
                tokenExchangeResource = @{ id = "resource-id"; uri = "https://example.com" }
                text                  = "Please sign in"
            }

            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -Authentication $authConfig -AsObject

            $result.authentication | Should -Not -BeNullOrEmpty
            $result.authentication.connectionName | Should -Be "TestConnection"
            $result.authentication.text | Should -Be "Please sign in"
        }

        It 'Should throw error when authentication hashtable is missing required keys' {
            $invalidAuth = @{
                buttons = @("signin")
                # Missing connectionName, tokenExchangeResource, text
            }

            { New-AdaptiveCard -Content {
                    New-CardTextBlock -Text "Test"
                } -Authentication $invalidAuth } | Should -Throw
        }
    }

    Context 'Resources and Refresh' {
        It 'Should set resources when valid resources hashtable is provided' {
            $resources = @{
                "greeting" = @{
                    "en-US" = "Hello"
                    "es-ES" = "Hola"
                }
            }

            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -Resources $resources -AsObject

            $result.resources | Should -Not -BeNullOrEmpty
            $result.resources.greeting."en-US" | Should -Be "Hello"
            $result.resources.greeting."es-ES" | Should -Be "Hola"
        }

        It 'Should set refresh when valid refresh hashtable is provided' {
            $refreshConfig = @{
                action = @{
                    type = "Action.Execute"
                    verb = "refresh"
                }
            }

            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -Refresh $refreshConfig -AsObject

            $result.refresh | Should -Not -BeNullOrEmpty
            $result.refresh.action.type | Should -Be "Action.Execute"
            $result.refresh.action.verb | Should -Be "refresh"
        }
    }

    Context 'Background Image and Select Action' {
        It 'Should set background image when specified' {
            $backgroundImage = @{
                url      = "https://example.com/image.jpg"
                fillMode = "cover"
            }

            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -BackgroundImage $backgroundImage -AsObject

            $result.backgroundImage | Should -Not -BeNullOrEmpty
            $result.backgroundImage.url | Should -Be "https://example.com/image.jpg"
            $result.backgroundImage.fillMode | Should -Be "cover"
        }

        It 'Should set select action when specified' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -SelectAction {
                New-CardActionOpenUrl -Url "https://example.com"
            } -AsObject

            $result.selectAction | Should -Not -BeNullOrEmpty
            $result.selectAction.type | Should -Be "Action.OpenUrl"
            $result.selectAction.url | Should -Be "https://example.com"
        }
    }

    Context 'Scriptblock Parameters' {
        It 'Should process Fallback scriptblock' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -Fallback {
                New-CardTextBlock -Text "Fallback content"
            } -AsObject

            $result.fallback | Should -Not -BeNullOrEmpty
            $result.fallback.text | Should -Be "Fallback content"
        }

        It 'Should process Layouts scriptblock' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -Layouts {
                @{
                    type = "Layout"
                    name = "TestLayout"
                }
            } -AsObject

            $result.layouts | Should -Not -BeNullOrEmpty
            $result.layouts.name | Should -Be "TestLayout"
        }

        It 'Should process References scriptblock' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -References {
                @{
                    type = "Reference"
                    id   = "TestReference"
                }
            } -AsObject

            $result.references | Should -Not -BeNullOrEmpty
            $result.references.id | Should -Be "TestReference"
        }
    }

    Context 'Error Handling' {
        It 'Should handle WhatIf parameter' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            } -WhatIf

            # WhatIf should not return anything
            $result | Should -BeNullOrEmpty
        }

        It 'Should throw error when refresh hashtable is missing action key' {
            $invalidRefresh = @{
                # Missing action key
                interval = 30
            }

            { New-AdaptiveCard -Content {
                    New-CardTextBlock -Text "Test"
                } -Refresh $invalidRefresh } | Should -Throw
        }

        It 'Should throw error when resources contain non-hashtable values' {
            $invalidResources = @{
                "greeting" = "Hello"  # Should be hashtable, not string
            }

            { New-AdaptiveCard -Content {
                    New-CardTextBlock -Text "Test"
                } -Resources $invalidResources } | Should -Throw
        }
    }

    Context 'JSON Output Validation' {
        It 'Should produce valid JSON output' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Test"
            }

            { $result | ConvertFrom-Json } | Should -Not -Throw
        }

        It 'Should maintain proper JSON structure for complex cards' {
            $result = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Header" -Size "Large"
                New-CardContainer -Content {
                    New-CardTextBlock -Text "Content"
                }
            } -Actions {
                New-CardActionSubmit -Title "Submit"
                New-CardActionOpenUrl -Title "Link" -Url "https://example.com"
            }

            $card = $result | ConvertFrom-Json
            $card.body | Should -HaveCount 2
            $card.actions | Should -HaveCount 2
            $card.body[0].size | Should -Be "Large"
            $card.actions[0].title | Should -Be "Submit"
            $card.actions[1].title | Should -Be "Link"
        }
    }
}
