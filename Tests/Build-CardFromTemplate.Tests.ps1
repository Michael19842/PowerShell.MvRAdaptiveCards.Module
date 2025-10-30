BeforeAll {
    # Import the module
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MvRAdaptiveCards\MvRAdaptiveCards.psd1'
    Import-Module $ModulePath -Force -ArgumentList $True, $true
}

Describe "Build-CardFromTemplate" {

    Context "Basic Functionality" {
        It "Should build card with simple string replacement" {
            $template = @{
                type = "TextBlock"
                text = "!{{Message}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Message = "Hello World"
            }

            $result | Should -Not -BeNullOrEmpty
            $result.text | Should -Be "Hello World"
        }

        It "Should return a hashtable" {
            $template = @{
                type = "TextBlock"
                text = "!{{Text}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Text = "Test"
            }

            $result | Should -BeOfType [hashtable]
        }

        It "Should preserve properties not containing template tags" {
            $template = @{
                type   = "TextBlock"
                text   = "!{{Message}}"
                weight = "Bolder"
                size   = "Large"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Message = "Test"
            }

            $result.type | Should -Be "TextBlock"
            $result.weight | Should -Be "Bolder"
            $result.size | Should -Be "Large"
        }
    }

    Context "String Value Replacement" {
        It "Should replace single string tag" {
            $template = @{
                type = "TextBlock"
                text = "!{{Greeting}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Greeting = "Welcome!"
            }

            $result.text | Should -Be "Welcome!"
        }

        It "Should replace multiple string tags in different properties" {
            $template = @{
                type = "TextBlock"
                text = "!{{Message}}"
                id   = "!{{ElementId}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Message   = "Hello"
                ElementId = "text-block-1"
            }

            $result.text | Should -Be "Hello"
            $result.id | Should -Be "text-block-1"
        }

        It "Should handle tags within text content" {
            $template = @{
                type = "TextBlock"
                text = "Welcome !{{UserName}} to our system!"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                UserName = "John"
            }

            $result.text | Should -Be "Welcome John to our system!"
        }

        It "Should handle empty string values" {
            $template = @{
                type = "TextBlock"
                text = "!{{Message}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Message = ""
            }

            $result.text | Should -Be ""
        }

        It "Should handle strings with special characters" {
            $template = @{
                type = "TextBlock"
                text = "!{{Message}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Message = "Test & <Special> 'Chars' `"Quotes`""
            }

            $result.text | Should -Match "Test"
        }
    }

    Context "Numeric Value Replacement" {
        It "Should replace integer values" {
            $template = @{
                type = "TextBlock"
                text = "Count: !{{Count}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Count = 42
            }

            $result.text | Should -Be "Count: 42"
        }

        It "Should replace double values" {
            $template = @{
                type = "TextBlock"
                text = "Price: `$!{{Price}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Price = 19.99
            }

            $result.text | Should -Be "Price: `$19.99"
        }

        It "Should handle zero values" {
            $template = @{
                type = "TextBlock"
                text = "!{{Value}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Value = 0
            }

            $result.text | Should -Be "0"
        }

        It "Should handle negative values" {
            $template = @{
                type = "TextBlock"
                text = "!{{Temperature}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Temperature = -5
            }

            $result.text | Should -Be "-5"
        }
    }

    Context "Boolean Value Replacement" {
        It "Should replace boolean true" {
            $template = @{
                type  = "Input.Toggle"
                value = "!{{DefaultValue}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                DefaultValue = $true
            }

            $result.value | Should -Be "True"
        }

        It "Should replace boolean false" {
            $template = @{
                type  = "Input.Toggle"
                value = "!{{DefaultValue}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                DefaultValue = $false
            }

            $result.value | Should -Be "False"
        }
    }

    Context "ScriptBlock Replacement" {
        It "Should execute scriptblock and use result" {
            $template = @{
                type = "TextBlock"
                text = "!{{DynamicText}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                DynamicText = { "Generated: $(Get-Date -Format 'yyyy-MM-dd')" }
            }

            $result.text | Should -Match "Generated: \d{4}-\d{2}-\d{2}"
        }

        It "Should execute scriptblock returning hashtable" {
            $template = @{
                type  = "Container"
                items = @("!{{DynamicItem}}")
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                DynamicItem = {
                    @{
                        type = "TextBlock"
                        text = "Dynamic content"
                    }
                }
            }

            $result.items[0].type | Should -Be "TextBlock"
            $result.items[0].text | Should -Be "Dynamic content"
        }

        It "Should allow scriptblock access to variables in scope" {
            $userName = "Alice"
            $template = @{
                type = "TextBlock"
                text = "!{{Greeting}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Greeting = { "Welcome, $userName!" }
            }

            $result.text | Should -Be "Welcome, Alice!"
        }

        It "Should handle scriptblock returning array" {
            $template = @{
                type  = "Container"
                items = "!{{Items}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Items = {
                    @(
                        @{ type = "TextBlock"; text = "Item 1" }
                        @{ type = "TextBlock"; text = "Item 2" }
                    )
                }
            }

            $result.items | Should -HaveCount 2
            $result.items[0].text | Should -Be "Item 1"
        }
    }

    Context "Multiple Tags" {
        It "Should replace multiple tags in same template" {
            $template = @{
                type  = "Container"
                items = @(
                    @{ type = "TextBlock"; text = "!{{Title}}" }
                    @{ type = "TextBlock"; text = "!{{Body}}" }
                    @{ type = "TextBlock"; text = "!{{Footer}}" }
                )
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Title  = "Main Title"
                Body   = "Content here"
                Footer = "End"
            }

            $result.items[0].text | Should -Be "Main Title"
            $result.items[1].text | Should -Be "Content here"
            $result.items[2].text | Should -Be "End"
        }

        It "Should handle same tag used multiple times" {
            $template = @{
                type  = "Container"
                items = @(
                    @{ type = "TextBlock"; text = "User: !{{Name}}" }
                    @{ type = "TextBlock"; text = "Welcome, !{{Name}}!" }
                )
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Name = "John"
            }

            $result.items[0].text | Should -Be "User: John"
            $result.items[1].text | Should -Be "Welcome, John!"
        }

        It "Should replace tags at different nesting levels" {
            $template = @{
                type  = "Container"
                id    = "!{{ContainerId}}"
                items = @(
                    @{
                        type = "TextBlock"
                        text = "!{{Message}}"
                        id   = "!{{TextId}}"
                    }
                )
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                ContainerId = "main-container"
                Message     = "Hello"
                TextId      = "text-1"
            }

            $result.id | Should -Be "main-container"
            $result.items[0].text | Should -Be "Hello"
            $result.items[0].id | Should -Be "text-1"
        }
    }

    Context "Integration with Card Functions" {
        It "Should work with New-CardTextBlock and New-CardTemplateTag" {
            $template = New-CardTextBlock -Text (New-CardTemplateTag -TagName "Message")

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Message = "Hello from template"
            }

            $result.text | Should -Be "Hello from template"
        }

        It "Should work with New-CardContainer" {
            $template = New-CardContainer -Content {
                New-CardTextBlock -Text (New-CardTemplateTag -TagName "Title")
                New-CardTextBlock -Text (New-CardTemplateTag -TagName "Body")
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Title = "Main Title"
                Body  = "Content"
            }

            $result.items[0].text | Should -Be "Main Title"
            $result.items[1].text | Should -Be "Content"
        }

        It "Should work with dynamic scriptblock content" {
            $template = New-CardContainer -Content {
                New-CardTextBlock -Text (New-CardTemplateTag -TagName "DynamicContent")
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                DynamicContent = { "Generated from scriptblock" }
            }

            $result.items[0].text | Should -Be "Generated from scriptblock"
        }
    }

    Context "Warning Generation" {
        It "Should warn when tag in Tags parameter not found in template" {
            $template = @{
                type = "TextBlock"
                text = "!{{Message}}"
            }

            $warnings = Build-CardFromTemplate -Content $template -Tags @{
                Message        = "Hello"
                NonExistentTag = "Value"
            } -WarningAction SilentlyContinue -WarningVariable script:capturedWarnings 3>&1 | Where-Object { $_ -is [System.Management.Automation.WarningRecord] }

            $warnings | Should -Not -BeNullOrEmpty
            $warnings[0].Message | Should -Match "NonExistentTag.*not found"
        }

        It "Should not warn when all tags are found" {
            $template = @{
                type = "TextBlock"
                text = "!{{Message}}"
            }

            $warnings = @()
            Build-CardFromTemplate -Content $template -Tags @{
                Message = "Hello"
            } -WarningAction SilentlyContinue -WarningVariable warnings

            $warnings | Should -BeNullOrEmpty
        }

        It "Should process successfully despite warning" {
            $template = @{
                type = "TextBlock"
                text = "!{{Message}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Message = "Hello"
                Extra   = "Not used"
            } -WarningAction SilentlyContinue

            $result.text | Should -Be "Hello"
        }
    }

    Context "Complex Structures" {
        It "Should handle deeply nested templates" {
            $template = @{
                type  = "Container"
                items = @(
                    @{
                        type  = "Container"
                        items = @(
                            @{
                                type = "TextBlock"
                                text = "!{{DeepTag}}"
                            }
                        )
                    }
                )
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                DeepTag = "Deep value"
            }

            $result.items[0].items[0].text | Should -Be "Deep value"
        }

        It "Should handle FactSet templates" {
            $template = @{
                type  = "FactSet"
                facts = @(
                    @{ title = "Name"; value = "!{{UserName}}" }
                    @{ title = "Email"; value = "!{{UserEmail}}" }
                )
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                UserName  = "John Doe"
                UserEmail = "john@example.com"
            }

            $result.facts[0].value | Should -Be "John Doe"
            $result.facts[1].value | Should -Be "john@example.com"
        }

        It "Should handle arrays in template" {
            $template = @{
                type  = "Container"
                items = @(
                    @{ type = "TextBlock"; text = "!{{Item1}}" }
                    @{ type = "TextBlock"; text = "!{{Item2}}" }
                    @{ type = "TextBlock"; text = "!{{Item3}}" }
                )
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Item1 = "First"
                Item2 = "Second"
                Item3 = "Third"
            }

            $result.items | Should -HaveCount 3
            $result.items[2].text | Should -Be "Third"
        }
    }

    Context "Edge Cases" {
        It "Should handle template with no tags" {
            $template = @{
                type = "TextBlock"
                text = "Static content"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{}

            $result.text | Should -Be "Static content"
        }

        It "Should handle empty Tags hashtable" {
            $template = @{
                type = "TextBlock"
                text = "!{{Message}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{}

            # Tag should remain unchanged since no replacement provided
            $result.text | Should -Be "!{{Message}}"
        }

        It "Should handle unicode characters" {
            $template = @{
                type = "TextBlock"
                text = "!{{Message}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Message = "你好世界"
            }

            $result.text | Should -Be "你好世界"
        }

        It "Should handle very long strings" {
            $longString = "A" * 5000
            $template = @{
                type = "TextBlock"
                text = "!{{LongText}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                LongText = $longString
            }

            $result.text.Length | Should -Be 5000
        }

        It "Should handle tag names with underscores" {
            $template = @{
                type = "TextBlock"
                text = "!{{User_Name}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                User_Name = "John"
            }

            $result.text | Should -Be "John"
        }

        It "Should handle tag names with dots" {
            $template = @{
                type = "TextBlock"
                text = "!{{User.FirstName}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                "User.FirstName" = "Jane"
            }

            $result.text | Should -Be "Jane"
        }

        It "Should handle tag names with numbers" {
            $template = @{
                type = "TextBlock"
                text = "!{{Value123}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Value123 = "Test"
            }

            $result.text | Should -Be "Test"
        }
    }

    Context "Real-World Scenarios" {
        It "Should create user profile card from template" {
            $template = @{
                type  = "Container"
                items = @(
                    @{ type = "TextBlock"; text = "!{{UserName}}"; weight = "Bolder" }
                    @{
                        type  = "FactSet"
                        facts = @(
                            @{ title = "Email"; value = "!{{Email}}" }
                            @{ title = "Department"; value = "!{{Department}}" }
                            @{ title = "Manager"; value = "!{{Manager}}" }
                        )
                    }
                )
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                UserName   = "Alice Smith"
                Email      = "alice@company.com"
                Department = "Engineering"
                Manager    = "Bob Jones"
            }

            $result.items[0].text | Should -Be "Alice Smith"
            $result.items[1].facts[0].value | Should -Be "alice@company.com"
        }

        It "Should create notification card with dynamic timestamp" {
            $template = @{
                type  = "Container"
                items = @(
                    @{ type = "TextBlock"; text = "!{{Title}}" }
                    @{ type = "TextBlock"; text = "!{{Message}}" }
                    @{ type = "TextBlock"; text = "Sent: !{{Timestamp}}"; size = "Small" }
                )
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Title     = "System Alert"
                Message   = "Database backup completed"
                Timestamp = { Get-Date -Format "yyyy-MM-dd HH:mm" }
            }

            $result.items[0].text | Should -Be "System Alert"
            $result.items[2].text | Should -Match "Sent: \d{4}-\d{2}-\d{2}"
        }

        It "Should create report card with calculated values" {
            $template = @{
                type  = "Container"
                items = @(
                    @{ type = "TextBlock"; text = "Report: !{{ReportName}}" }
                    @{
                        type  = "FactSet"
                        facts = @(
                            @{ title = "Total"; value = "!{{Total}}" }
                            @{ title = "Average"; value = "!{{Average}}" }
                        )
                    }
                )
            }

            $values = @(10, 20, 30, 40)
            $result = Build-CardFromTemplate -Content $template -Tags @{
                ReportName = "Monthly Sales"
                Total      = { [int]($values | Measure-Object -Sum).Sum }
                Average    = { [int]($values | Measure-Object -Average).Average }
            }

            $result.items[1].facts[0].value | Should -Be "100"
            $result.items[1].facts[1].value | Should -Be "25"
        }

        It "Should create multiple cards from same template" {
            $template = @{
                type = "TextBlock"
                text = "User: !{{Name}}"
                id   = "!{{UserId}}"
            }

            $users = @("Alice", "Bob", "Charlie")
            $cards = foreach ($user in $users) {
                Build-CardFromTemplate -Content $template -Tags @{
                    Name   = $user
                    UserId = "user_$user"
                }
            }

            $cards | Should -HaveCount 3
            $cards[0].text | Should -Be "User: Alice"
            $cards[1].text | Should -Be "User: Bob"
            $cards[2].text | Should -Be "User: Charlie"
        }
    }

    Context "Command Metadata" {
        It "Should have correct command name" {
            $command = Get-Command Build-CardFromTemplate
            $command.Name | Should -Be "Build-CardFromTemplate"
        }

        It "Should have help documentation" {
            $help = Get-Help Build-CardFromTemplate
            $help.Synopsis | Should -Not -BeNullOrEmpty
            $help.Description | Should -Not -BeNullOrEmpty
        }

        It "Should have examples in help" {
            $help = Get-Help Build-CardFromTemplate -Full
            $help.Examples | Should -Not -BeNullOrEmpty
            $help.Examples.Example.Count | Should -BeGreaterThan 0
        }

        It "Should have parameter descriptions" {
            $help = Get-Help Build-CardFromTemplate -Full
            $help.parameters.parameter | Should -Not -BeNullOrEmpty
        }

        It "Should document Content parameter" {
            $help = Get-Help Build-CardFromTemplate -Parameter Content
            $help | Should -Not -BeNullOrEmpty
        }

        It "Should document Tags parameter" {
            $help = Get-Help Build-CardFromTemplate -Parameter Tags
            $help | Should -Not -BeNullOrEmpty
        }
    }

    Context "Output Validation" {
        It "Should return valid hashtable structure" {
            $template = @{
                type = "TextBlock"
                text = "!{{Message}}"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Message = "Test"
            }

            $result | Should -BeOfType [hashtable]
            $result.type | Should -Be "TextBlock"
        }

        It "Should produce JSON-serializable output" {
            $template = @{
                type  = "Container"
                items = @(
                    @{ type = "TextBlock"; text = "!{{Message}}" }
                )
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Message = "Test"
            }

            { $result | ConvertTo-Json -Depth 10 } | Should -Not -Throw
        }

        It "Should not modify original template" {
            $template = @{
                type = "TextBlock"
                text = "!{{Message}}"
            }

            $originalJson = $template | ConvertTo-Json
            Build-CardFromTemplate -Content $template -Tags @{
                Message = "Changed"
            }
            $afterJson = $template | ConvertTo-Json

            $afterJson | Should -Be $originalJson
        }

        It "Should maintain data types after replacement" {
            $template = @{
                type  = "Container"
                items = @(
                    @{ type = "TextBlock"; text = "!{{Text}}" }
                    @{ type = "TextBlock"; text = "!{{Number}}" }
                )
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Text   = "Hello"
                Number = 42
            }

            $result.items[0].text | Should -Be "Hello"
            $result.items[1].text | Should -Be "42"
        }
    }
}
