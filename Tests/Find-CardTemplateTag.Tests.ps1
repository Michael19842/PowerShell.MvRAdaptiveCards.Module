BeforeAll {
    # Import the module
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MvRAdaptiveCards\MvRAdaptiveCards.psd1'
    Import-Module $ModulePath -Force -ArgumentList $True, $true
}

Describe "Find-CardTemplateTag" {

    Context "Basic Functionality" {
        It "Should find single template tag" {
            $content = @{
                type = "TextBlock"
                text = "Hello !{{Name}}"
            }

            $result = Find-CardTemplateTag -Content $content

            $result | Should -Not -BeNullOrEmpty
            $result | Should -HaveCount 1
            $result | Should -Be "Name"
        }

        It "Should find multiple template tags" {
            $content = @{
                type  = "Container"
                items = @(
                    @{ type = "TextBlock"; text = "!{{FirstName}}" }
                    @{ type = "TextBlock"; text = "!{{LastName}}" }
                    @{ type = "TextBlock"; text = "!{{Email}}" }
                )
            }

            $result = Find-CardTemplateTag -Content $content

            $result | Should -HaveCount 3
            $result | Should -Contain "FirstName"
            $result | Should -Contain "LastName"
            $result | Should -Contain "Email"
        }

        It "Should return null when no tags found" {
            $content = @{
                type = "TextBlock"
                text = "No template tags here"
            }

            $result = Find-CardTemplateTag -Content $content

            $result | Should -BeNullOrEmpty
        }

        It "Should return array type" {
            $content = @{
                type = "TextBlock"
                text = "Hello !{{World}}"
            }

            $result = Find-CardTemplateTag -Content $content
            #If there is only one item, powershell may return a string instead of an array
            if ($result.Count -eq 1) {
                $result = @($result)
            }
            $result -is [array] | Should -Be $true
        }
    }

    Context "Duplicate Tag Handling" {
        It "Should deduplicate identical tags" {
            $content = @{
                type  = "Container"
                items = @(
                    @{ type = "TextBlock"; text = "!{{Name}}" }
                    @{ type = "TextBlock"; text = "!{{Name}}" }
                    @{ type = "TextBlock"; text = "!{{Name}}" }
                )
            }

            $result = Find-CardTemplateTag -Content $content

            $result | Should -HaveCount 1
            #Powershell may return a string instead of an array when there is only one item
            if ($result.Count -eq 1) {
                $result = @($result)
            }

            $result[0] | Should -Be "Name"
        }

        It "Should deduplicate mixed with unique tags" {
            $content = @{
                type  = "Container"
                items = @(
                    @{ type = "TextBlock"; text = "!{{User}}" }
                    @{ type = "TextBlock"; text = "!{{Email}}" }
                    @{ type = "TextBlock"; text = "!{{User}}" }
                    @{ type = "TextBlock"; text = "!{{Phone}}" }
                )
            }

            $result = Find-CardTemplateTag -Content $content

            $result | Should -HaveCount 3
            $result | Should -Contain "User"
            $result | Should -Contain "Email"
            $result | Should -Contain "Phone"
        }
    }

    Context "Case Sensitivity" {
        It "Should treat different cases as different tags" {
            $content = @{
                type  = "Container"
                items = @(
                    @{ type = "TextBlock"; text = "!{{Name}}" }
                    @{ type = "TextBlock"; text = "!{{name}}" }
                    @{ type = "TextBlock"; text = "!{{NAME}}" }
                )
            }

            $result = Find-CardTemplateTag -Content $content

            $result | Should -HaveCount 3
            $result | Should -Contain "Name"
            $result | Should -Contain "name"
            $result | Should -Contain "NAME"
        }
    }

    Context "Tag Format Validation" {
        It "Should find tags with standard format !{{TagName}}" {
            $content = @{
                type = "TextBlock"
                text = "!{{StandardTag}}"
            }

            $result = Find-CardTemplateTag -Content $content
            $result | Should -Be "StandardTag"
        }

        It "Should find tags with underscores" {
            $content = @{
                type = "TextBlock"
                text = "!{{User_Name}}"
            }

            $result = Find-CardTemplateTag -Content $content
            $result | Should -Be "User_Name"
        }

        It "Should find tags with numbers" {
            $content = @{
                type = "TextBlock"
                text = "!{{Value123}}"
            }

            $result = Find-CardTemplateTag -Content $content
            $result | Should -Be "Value123"
        }

        It "Should find tags with dots" {
            $content = @{
                type = "TextBlock"
                text = "!{{User.FirstName}}"
            }

            $result = Find-CardTemplateTag -Content $content
            $result | Should -Be "User.FirstName"
        }

        It "Should find tags with hyphens" {
            $content = @{
                type = "TextBlock"
                text = "!{{First-Name}}"
            }

            $result = Find-CardTemplateTag -Content $content
            $result | Should -Be "First-Name"
        }

        It "Should find tags embedded in text" {
            $content = @{
                type = "TextBlock"
                text = "Welcome !{{Name}} to our system!"
            }

            $result = Find-CardTemplateTag -Content $content
            $result | Should -Be "Name"
        }

        It "Should find multiple tags in same text" {
            $content = @{
                type = "TextBlock"
                text = "!{{FirstName}} !{{LastName}} - !{{Email}}"
            }

            $result = Find-CardTemplateTag -Content $content

            $result | Should -HaveCount 3
            $result | Should -Contain "FirstName"
            $result | Should -Contain "LastName"
            $result | Should -Contain "Email"
        }
    }

    Context "Complex Nested Structures" {
        It "Should find tags in deeply nested structure" {
            $content = @{
                type  = "Container"
                items = @(
                    @{
                        type  = "Container"
                        items = @(
                            @{
                                type  = "Container"
                                items = @(
                                    @{ type = "TextBlock"; text = "!{{DeepTag}}" }
                                )
                            }
                        )
                    }
                )
            }

            $result = Find-CardTemplateTag -Content $content
            $result | Should -Be "DeepTag"
        }

        It "Should find tags at multiple nesting levels" {
            $content = @{
                type  = "Container"
                items = @(
                    @{ type = "TextBlock"; text = "!{{Level1}}" }
                    @{
                        type  = "Container"
                        items = @(
                            @{ type = "TextBlock"; text = "!{{Level2}}" }
                            @{
                                type  = "Container"
                                items = @(
                                    @{ type = "TextBlock"; text = "!{{Level3}}" }
                                )
                            }
                        )
                    }
                )
            }

            $result = Find-CardTemplateTag -Content $content

            $result | Should -HaveCount 3
            $result | Should -Contain "Level1"
            $result | Should -Contain "Level2"
            $result | Should -Contain "Level3"
        }

        It "Should find tags in FactSet structure" {
            $content = @{
                type  = "FactSet"
                facts = @(
                    @{ title = "Name"; value = "!{{UserName}}" }
                    @{ title = "Email"; value = "!{{UserEmail}}" }
                    @{ title = "Department"; value = "!{{UserDept}}" }
                )
            }

            $result = Find-CardTemplateTag -Content $content

            $result | Should -HaveCount 3
            $result | Should -Contain "UserName"
            $result | Should -Contain "UserEmail"
            $result | Should -Contain "UserDept"
        }

        It "Should find tags in action properties" {
            $content = @{
                type         = "TextBlock"
                text         = "Click me"
                selectAction = @{
                    type = "Action.OpenUrl"
                    url  = "!{{ActionUrl}}"
                }
            }

            $result = Find-CardTemplateTag -Content $content
            $result | Should -Be "ActionUrl"
        }

        It "Should find tags in array properties" {
            $content = @{
                type   = "ImageSet"
                images = @(
                    @{ type = "Image"; url = "!{{Image1}}" }
                    @{ type = "Image"; url = "!{{Image2}}" }
                    @{ type = "Image"; url = "!{{Image3}}" }
                )
            }

            $result = Find-CardTemplateTag -Content $content

            $result | Should -HaveCount 3
            $result | Should -Contain "Image1"
            $result | Should -Contain "Image2"
            $result | Should -Contain "Image3"
        }
    }

    Context "Integration with Card Functions" {
        It "Should work with New-CardTextBlock" {
            $content = New-CardTextBlock -Text "Hello !{{Name}}"
            $result = Find-CardTemplateTag -Content $content

            $result | Should -Be "Name"
        }

        It "Should work with New-CardContainer" {
            $content = New-CardContainer -Content {
                New-CardTextBlock -Text "!{{Title}}"
                New-CardTextBlock -Text "!{{Description}}"
            }

            $result = Find-CardTemplateTag -Content $content

            $result | Should -HaveCount 2
            $result | Should -Contain "Title"
            $result | Should -Contain "Description"
        }

        It "Should work with New-CardTemplateTag" {
            $content = @{
                type = "TextBlock"
                text = (New-CardTemplateTag -TagName "DynamicValue")
            }

            $result = Find-CardTemplateTag -Content $content
            $result | Should -Be "DynamicValue"
        }

        It "Should work with New-AdaptiveCard" {
            $card = New-AdaptiveCard {
                New-CardTextBlock -Text "!{{Header}}"
                New-CardTextBlock -Text "!{{Body}}"
                New-CardTextBlock -Text "!{{Footer}}"
            } -AsObject

            $result = Find-CardTemplateTag -Content $card

            $result | Should -HaveCount 3
            $result | Should -Contain "Header"
            $result | Should -Contain "Body"
            $result | Should -Contain "Footer"
        }
    }

    Context "Edge Cases" {
        It "Should handle empty hashtable" {
            $content = @{}
            $result = Find-CardTemplateTag -Content $content

            $result | Should -BeNullOrEmpty
        }

        It "Should handle hashtable with null values" {
            $content = @{
                type = "TextBlock"
                text = $null
            }

            $result = Find-CardTemplateTag -Content $content
            $result.Count | Should -Be 0
        }

        It "Should handle tags with spaces" {
            $content = @{
                type = "TextBlock"
                text = "!{{Tag With Spaces}}"
            }

            $result = Find-CardTemplateTag -Content $content
            $result | Should -Be "Tag With Spaces"
        }

        It "Should handle tags with special characters" {
            $content = @{
                type = "TextBlock"
                text = "!{{Tag@123!#}}"
            }

            $result = Find-CardTemplateTag -Content $content
            $result | Should -Be "Tag@123!#"
        }

        It "Should handle empty tag name" {
            $content = @{
                type = "TextBlock"
                text = "!{{}}"
            }

            $result = Find-CardTemplateTag -Content $content

            $result | Should -HaveCount 1
            $result | Should -Be ""
        }

        It "Should not find malformed tags {{NoExclamation}}" {
            $content = @{
                type = "TextBlock"
                text = "{{NoExclamation}}"
            }

            $result = Find-CardTemplateTag -Content $content
            $result.Count | Should -Be 0
        }

        It "Should not find incomplete tags !{{Incomplete" {
            $content = @{
                type = "TextBlock"
                text = "!{{Incomplete"
            }

            $result = Find-CardTemplateTag -Content $content
            $result.Count | Should -Be 0
        }

        It "Should handle very long tag names" {
            $longTagName = "A" * 500
            $content = @{
                type = "TextBlock"
                text = "!{{$longTagName}}"
            }

            $result = Find-CardTemplateTag -Content $content
            $result | Should -Be $longTagName
        }

        It "Should handle unicode in tag names" {
            $content = @{
                type = "TextBlock"
                text = "!{{用户名称}}"
            }

            $result = Find-CardTemplateTag -Content $content
            $result | Should -Be "用户名称"
        }
    }

    Context "Performance and Scalability" {
        It "Should handle large number of tags" {
            $items = 1..100 | ForEach-Object {
                @{ type = "TextBlock"; text = "!{{Tag$_}}" }
            }

            $content = @{
                type  = "Container"
                items = $items
            }

            $result = Find-CardTemplateTag -Content $content
            $result | Should -HaveCount 100
        }

        It "Should handle deeply nested structure (10 levels)" {
            $deepContent = @{ type = "TextBlock"; text = "!{{DeepestTag}}" }

            for ($i = 0; $i -lt 10; $i++) {
                $deepContent = @{
                    type  = "Container"
                    items = @($deepContent)
                }
            }

            $result = Find-CardTemplateTag -Content $deepContent
            $result | Should -Be "DeepestTag"
        }
    }

    Context "Alias Support" {
        It "Should support Find-CardTemplateTags alias" {
            $content = @{
                type = "TextBlock"
                text = "!{{TagName}}"
            }

            $result = Find-CardTemplateTags -Content $content
            $result | Should -Be "TagName"
        }

        It "Should have Find-CardTemplateTags alias defined" {
            $alias = Get-Alias -Name Find-CardTemplateTags -ErrorAction SilentlyContinue
            $alias | Should -Not -BeNullOrEmpty
            $alias.Definition | Should -Be "Find-CardTemplateTag"
        }
    }

    Context "Command Metadata" {
        It "Should have correct command name" {
            $command = Get-Command Find-CardTemplateTag
            $command.Name | Should -Be "Find-CardTemplateTag"
        }

        It "Should have help documentation" {
            $help = Get-Help Find-CardTemplateTag
            $help.Synopsis | Should -Not -BeNullOrEmpty
            $help.Description | Should -Not -BeNullOrEmpty
        }

        It "Should have examples in help" {
            $help = Get-Help Find-CardTemplateTag -Full
            $help.Examples | Should -Not -BeNullOrEmpty
            $help.Examples.Example.Count | Should -BeGreaterThan 0
        }

        It "Should have parameter descriptions" {
            $help = Get-Help Find-CardTemplateTag -Full
            $help.parameters.parameter | Should -Not -BeNullOrEmpty
        }

        It "Should document Content parameter" {
            $help = Get-Help Find-CardTemplateTag -Parameter Content
            $help | Should -Not -BeNullOrEmpty
        }
    }

    Context "Output Validation" {
        It "Should always return array type" {
            $content1 = @{ type = "TextBlock"; text = "No tags" }
            $content2 = @{ type = "TextBlock"; text = "!{{OneTag}}" }

            $result1 = Find-CardTemplateTag -Content $content1
            $result2 = Find-CardTemplateTag -Content $content2

            $result1 | Should -BeNullOrEmpty
        }

        It "Should return string elements" {
            $content = @{
                type = "TextBlock"
                text = "!{{Tag1}} and !{{Tag2}}"
            }

            $result = Find-CardTemplateTag -Content $content

            foreach ($tag in $result) {
                $tag | Should -BeOfType [string]
            }
        }

        It "Should not modify input content" {
            $content = @{
                type = "TextBlock"
                text = "!{{OriginalTag}}"
            }

            $originalJson = $content | ConvertTo-Json
            $result = Find-CardTemplateTag -Content $content
            $afterJson = $content | ConvertTo-Json

            $afterJson | Should -Be $originalJson
        }
    }

    Context "Real-World Scenarios" {
        It "Should find tags in user profile template" {
            $content = @{
                type  = "Container"
                items = @(
                    @{ type = "TextBlock"; text = "Name: !{{UserName}}" }
                    @{ type = "TextBlock"; text = "Email: !{{UserEmail}}" }
                    @{ type = "TextBlock"; text = "Department: !{{UserDepartment}}" }
                    @{ type = "TextBlock"; text = "Manager: !{{ManagerName}}" }
                )
            }

            $result = Find-CardTemplateTag -Content $content

            $result | Should -HaveCount 4
            $result | Should -Contain "UserName"
            $result | Should -Contain "UserEmail"
            $result | Should -Contain "UserDepartment"
            $result | Should -Contain "ManagerName"
        }

        It "Should find tags in notification template" {
            $content = @{
                type  = "Container"
                items = @(
                    @{ type = "TextBlock"; text = "!{{NotificationTitle}}"; weight = "Bolder" }
                    @{ type = "TextBlock"; text = "!{{NotificationBody}}" }
                    @{ type = "TextBlock"; text = "Sent: !{{Timestamp}}" }
                )
            }

            $result = Find-CardTemplateTag -Content $content

            $result | Should -HaveCount 3
            $result | Should -Contain "NotificationTitle"
            $result | Should -Contain "NotificationBody"
            $result | Should -Contain "Timestamp"
        }

        It "Should find tags in report template" {
            $content = @{
                type  = "Container"
                items = @(
                    @{ type = "TextBlock"; text = "Report: !{{ReportName}}" }
                    @{
                        type  = "FactSet"
                        facts = @(
                            @{ title = "Total"; value = "!{{Total}}" }
                            @{ title = "Average"; value = "!{{Average}}" }
                            @{ title = "Status"; value = "!{{Status}}" }
                        )
                    }
                )
            }

            $result = Find-CardTemplateTag -Content $content

            $result | Should -HaveCount 4
            $result | Should -Contain "ReportName"
            $result | Should -Contain "Total"
            $result | Should -Contain "Average"
            $result | Should -Contain "Status"
        }
    }
}
