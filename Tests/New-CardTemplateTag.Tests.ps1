BeforeAll {
    Import-Module "$PSScriptRoot/../MvRAdaptiveCards/MvRAdaptiveCards.psd1" -Force
}

Describe "New-CardTemplateTag" {
    Context "Basic Functionality" {
        It "Should create a basic template tag" {
            $result = New-CardTemplateTag -TagName "Test"

            $result | Should -Be "!{{Test}}"
        }

        It "Should accept TagName parameter" {
            $result = New-CardTemplateTag -TagName "UserName"

            $result | Should -Be "!{{UserName}}"
        }

        It "Should return a string" {
            $result = New-CardTemplateTag -TagName "Sample"

            $result | Should -BeOfType [string]
        }

        It "Should include exclamation mark prefix" {
            $result = New-CardTemplateTag -TagName "Test"

            $result | Should -Match "^!"
        }

        It "Should include curly braces" {
            $result = New-CardTemplateTag -TagName "Test"

            $result | Should -Match "\{\{.*\}\}"
        }

        It "Should preserve TagName exactly" {
            $result = New-CardTemplateTag -TagName "MyCustomTag"

            $result | Should -Be "!{{MyCustomTag}}"
        }
    }

    Context "Tag Name Variations" {
        It "Should handle simple alphanumeric names" {
            $result = New-CardTemplateTag -TagName "Tag123"

            $result | Should -Be "!{{Tag123}}"
        }

        It "Should handle camelCase names" {
            $result = New-CardTemplateTag -TagName "myTagName"

            $result | Should -Be "!{{myTagName}}"
        }

        It "Should handle PascalCase names" {
            $result = New-CardTemplateTag -TagName "MyTagName"

            $result | Should -Be "!{{MyTagName}}"
        }

        It "Should handle names with underscores" {
            $result = New-CardTemplateTag -TagName "my_tag_name"

            $result | Should -Be "!{{my_tag_name}}"
        }

        It "Should handle names with hyphens" {
            $result = New-CardTemplateTag -TagName "my-tag-name"

            $result | Should -Be "!{{my-tag-name}}"
        }

        It "Should handle names with dots" {
            $result = New-CardTemplateTag -TagName "user.name"

            $result | Should -Be "!{{user.name}}"
        }

        It "Should handle all uppercase names" {
            $result = New-CardTemplateTag -TagName "TAGNAME"

            $result | Should -Be "!{{TAGNAME}}"
        }

        It "Should handle all lowercase names" {
            $result = New-CardTemplateTag -TagName "tagname"

            $result | Should -Be "!{{tagname}}"
        }

        It "Should handle names with numbers" {
            $result = New-CardTemplateTag -TagName "Tag123Name456"

            $result | Should -Be "!{{Tag123Name456}}"
        }

        It "Should handle single character names" {
            $result = New-CardTemplateTag -TagName "A"

            $result | Should -Be "!{{A}}"
        }

        It "Should handle very long names" {
            $longName = "A" * 100
            $result = New-CardTemplateTag -TagName $longName

            $result | Should -Be "!{{$longName}}"
        }
    }

    Context "Special Characters" {
        It "Should handle names with spaces" {
            $result = New-CardTemplateTag -TagName "My Tag Name"

            $result | Should -Be "!{{My Tag Name}}"
        }

        It "Should handle names with special characters" {
            $result = New-CardTemplateTag -TagName "tag@#$%"

            $result | Should -Be "!{{tag@#$%}}"
        }

        It "Should handle unicode characters" {
            $result = New-CardTemplateTag -TagName "タグ名"

            $result | Should -Be "!{{タグ名}}"
        }

        It "Should handle emoji in names" {
            $result = New-CardTemplateTag -TagName "Tag🎉Name"

            $result | Should -Be "!{{Tag🎉Name}}"
        }

        It "Should handle names with quotes" {
            $result = New-CardTemplateTag -TagName "Tag'Name"

            $result | Should -Be "!{{Tag'Name}}"
        }

        It "Should handle names with double quotes" {
            $result = New-CardTemplateTag -TagName 'Tag"Name'

            $result | Should -Be '!{{Tag"Name}}'
        }

        It "Should handle names with backslashes" {
            $result = New-CardTemplateTag -TagName "Tag\Name"

            $result | Should -Be "!{{Tag\Name}}"
        }

        It "Should handle names with forward slashes" {
            $result = New-CardTemplateTag -TagName "Tag/Name"

            $result | Should -Be "!{{Tag/Name}}"
        }
    }

    Context "Integration with Card Functions" {
        It "Should work with New-CardTextBlock" {
            $tag = New-CardTemplateTag -TagName "Message"
            $textBlock = New-CardTextBlock -Text $tag

            $textBlock.text | Should -Be "!{{Message}}"
        }

        It "Should work as TextBlock parameter" {
            $textBlock = New-CardTextBlock -Text (New-CardTemplateTag -TagName "Title")

            $textBlock.text | Should -Be "!{{Title}}"
        }

        It "Should work in Container content" {
            $container = New-CardContainer -Content {
                New-CardTextBlock -Text (New-CardTemplateTag -TagName "Header")
                New-CardTextBlock -Text (New-CardTemplateTag -TagName "Body")
            }

            $container.items[0].text | Should -Be "!{{Header}}"
            $container.items[1].text | Should -Be "!{{Body}}"
        }

        It "Should work with New-CardFactSet" {
            $userNameTag = New-CardTemplateTag -TagName "UserName"
            $userEmailTag = New-CardTemplateTag -TagName "UserEmail"

            $factSet = New-CardFactSet -Facts @{
                Name  = $userNameTag
                Email = $userEmailTag
            }

            # Check that both tags are present (order not guaranteed with hashtables)
            $factValues = $factSet.facts | ForEach-Object { $_.value }
            $factValues | Should -Contain "!{{UserName}}"
            $factValues | Should -Contain "!{{UserEmail}}"
        }

        It "Should work with New-CardInputText placeholder" {
            $inputField = New-CardInputText -Id "name" -Placeholder (New-CardTemplateTag -TagName "PlaceholderText")

            $inputField.placeholder | Should -Be "!{{PlaceholderText}}"
        }

        It "Should work with New-CardInputText value" {
            $inputField = New-CardInputText -Id "name" -Value (New-CardTemplateTag -TagName "DefaultValue")

            $inputField.value | Should -Be "!{{DefaultValue}}"
        }

        It "Should work in multiple places within same card" {
            $card = New-AdaptiveCard {
                New-CardTextBlock -Text (New-CardTemplateTag -TagName "Title")
                New-CardTextBlock -Text (New-CardTemplateTag -TagName "Subtitle")
                New-CardTextBlock -Text (New-CardTemplateTag -TagName "Body")
            } -AsObject

            $card.body[0].text | Should -Be "!{{Title}}"
            $card.body[1].text | Should -Be "!{{Subtitle}}"
            $card.body[2].text | Should -Be "!{{Body}}"
        }
    }

    Context "Integration with Build-CardFromTemplate" {
        It "Should work with Build-CardFromTemplate for string replacement" {
            $template = @{
                type = "TextBlock"
                text = New-CardTemplateTag -TagName "Message"
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Message = "Hello World"
            }

            $result.text | Should -Be "Hello World"
        }

        It "Should work with multiple tags in template" {
            $template = @{
                type  = "Container"
                items = @(
                    @{ type = "TextBlock"; text = (New-CardTemplateTag -TagName "Title") }
                    @{ type = "TextBlock"; text = (New-CardTemplateTag -TagName "Body") }
                )
            }

            $result = Build-CardFromTemplate -Content $template -Tags @{
                Title = "My Title"
                Body  = "My Body"
            }

            $result.items[0].text | Should -Be "My Title"
            $result.items[1].text | Should -Be "My Body"
        }

        It "Should be discoverable by Find-CardTemplateTag" {
            $template = @{
                type = "TextBlock"
                text = New-CardTemplateTag -TagName "TestTag"
            }

            $tags = Find-CardTemplateTag -Content $template

            $tags | Should -Contain "TestTag"
        }
    }

    Context "Edge Cases" {
        It "Should handle whitespace-only TagName" {
            $result = New-CardTemplateTag -TagName "   "

            $result | Should -Be "!{{   }}"
        }

        It "Should handle TagName with leading/trailing spaces" {
            $result = New-CardTemplateTag -TagName " MyTag "

            $result | Should -Be "!{{ MyTag }}"
        }

        It "Should handle multiple consecutive spaces in TagName" {
            $result = New-CardTemplateTag -TagName "My  Tag  Name"

            $result | Should -Be "!{{My  Tag  Name}}"
        }

        It "Should handle newline in TagName" {
            $result = New-CardTemplateTag -TagName "Line1`nLine2"

            $result | Should -Be "!{{Line1`nLine2}}"
        }

        It "Should handle tab character in TagName" {
            $result = New-CardTemplateTag -TagName "Before`tAfter"

            $result | Should -Be "!{{Before`tAfter}}"
        }
    }

    Context "Real-World Scenarios" {
        It "Should create user profile template tags" {
            $nameTag = New-CardTemplateTag -TagName "UserName"
            $emailTag = New-CardTemplateTag -TagName "UserEmail"
            $roleTag = New-CardTemplateTag -TagName "UserRole"

            $nameTag | Should -Be "!{{UserName}}"
            $emailTag | Should -Be "!{{UserEmail}}"
            $roleTag | Should -Be "!{{UserRole}}"
        }

        It "Should create notification template" {
            $template = New-AdaptiveCard {
                New-CardTextBlock -Text (New-CardTemplateTag -TagName "NotificationTitle") -Weight Bolder
                New-CardTextBlock -Text (New-CardTemplateTag -TagName "NotificationMessage") -Wrap
                New-CardTextBlock -Text (New-CardTemplateTag -TagName "Timestamp") -Size Small
            } -AsObject

            $template.body[0].text | Should -Be "!{{NotificationTitle}}"
            $template.body[1].text | Should -Be "!{{NotificationMessage}}"
            $template.body[2].text | Should -Be "!{{Timestamp}}"
        }

        It "Should create data report template" {
            $reportTitleTag = New-CardTemplateTag -TagName "ReportTitle"
            $totalTag = New-CardTemplateTag -TagName "Total"
            $countTag = New-CardTemplateTag -TagName "Count"
            $averageTag = New-CardTemplateTag -TagName "Average"

            $template = New-CardContainer -Content {
                New-CardTextBlock -Text $reportTitleTag
                New-CardFactSet -Facts @{
                    Total   = $totalTag
                    Count   = $countTag
                    Average = $averageTag
                }
            }

            $template.items[0].text | Should -Be "!{{ReportTitle}}"
            # FactSet order may vary, so check all values are present
            $factValues = $template.items[1].facts.value
            $factValues | Should -Contain "!{{Total}}"
            $factValues | Should -Contain "!{{Count}}"
            $factValues | Should -Contain "!{{Average}}"
        }

        It "Should create form template with input placeholders" {
            $firstNameTag = New-CardTemplateTag -TagName "FirstNamePlaceholder"
            $lastNameTag = New-CardTemplateTag -TagName "LastNamePlaceholder"
            $emailTag = New-CardTemplateTag -TagName "EmailPlaceholder"

            $container = New-CardContainer -Content {
                New-CardInputText -Id "firstName" -Placeholder $firstNameTag
                New-CardInputText -Id "lastName" -Placeholder $lastNameTag
                New-CardInputText -Id "email" -Placeholder $emailTag -Style Email
            }

            $container.items[0].placeholder | Should -Be "!{{FirstNamePlaceholder}}"
            $container.items[1].placeholder | Should -Be "!{{LastNamePlaceholder}}"
            $container.items[2].placeholder | Should -Be "!{{EmailPlaceholder}}"
        }
    }

    Context "Command Metadata" {
        It "Should support WhatIf" {
            $result = New-CardTemplateTag -TagName "Test" -WhatIf

            $result | Should -BeNullOrEmpty
        }

        It "Should have correct output type" {
            $result = New-CardTemplateTag -TagName "Test"

            $result | Should -BeOfType [string]
        }

        It "Should have SupportsShouldProcess" {
            $command = Get-Command New-CardTemplateTag
            $command.Parameters.ContainsKey('WhatIf') | Should -Be $true
            $command.Parameters.ContainsKey('Confirm') | Should -Be $true
        }

        It "Should have mandatory TagName parameter" {
            $command = Get-Command New-CardTemplateTag
            $tagNameParam = $command.Parameters['TagName']

            $mandatory = $tagNameParam.Attributes | Where-Object { $_ -is [System.Management.Automation.ParameterAttribute] }
            $mandatory.Mandatory | Should -Contain $true
        }

        It "Should have correct parameter type" {
            $command = Get-Command New-CardTemplateTag
            $command.Parameters['TagName'].ParameterType | Should -Be ([string])
        }
    }

    Context "Parameter Validation" {
        It "Should not accept null TagName" {
            { New-CardTemplateTag -TagName $null } | Should -Throw
        }
    }

    Context "Output Consistency" {
        It "Should produce consistent output for same input" {
            $result1 = New-CardTemplateTag -TagName "Consistent"
            $result2 = New-CardTemplateTag -TagName "Consistent"

            $result1 | Should -Be $result2
        }

        It "Should preserve case in TagName" {
            $result1 = New-CardTemplateTag -TagName "MyTag"
            $result2 = New-CardTemplateTag -TagName "MYTAG"
            $result3 = New-CardTemplateTag -TagName "mytag"

            $result1 | Should -Be "!{{MyTag}}"
            $result2 | Should -Be "!{{MYTAG}}"
            $result3 | Should -Be "!{{mytag}}"
            # Verify case is preserved (case-sensitive comparison)
            $result1 -ceq $result2 | Should -Be $false
            $result2 -ceq $result3 | Should -Be $false
        }

        It "Should maintain exact tag format" {
            $result = New-CardTemplateTag -TagName "Test"

            $result.Length | Should -Be 9  # "!{{Test}}" = 9 characters
            $result[0] | Should -Be '!'
            $result[1] | Should -Be '{'
            $result[2] | Should -Be '{'
            $result[-1] | Should -Be '}'
            $result[-2] | Should -Be '}'
        }
    }
}
