BeforeAll {
    # Import the module
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MvRAdaptiveCards\MvRAdaptiveCards.psd1'
    Import-Module $ModulePath -Force -ArgumentList $false, $true
}

Describe 'New-CardFactSet' {

    Context 'Basic Functionality with Hashtable Parameter Set' {
        It 'Should create a basic FactSet from hashtable' {
            $facts = @{
                "Name"       = "John Doe"
                "Department" = "IT"
                "Role"       = "Developer"
            }

            $result = New-CardFactSet -Facts $facts

            $result | Should -BeOfType [hashtable]
            $result.type | Should -Be "FactSet"
            $result.facts | Should -HaveCount 3
            # $result.facts | Should -BeOfType [array]
        }

        It 'Should convert hashtable keys and values correctly' {
            $facts = @{
                "Server Name" = "WEB-01"
                "Status"      = "Online"
                "Port"        = 80
            }

            $result = New-CardFactSet -Facts $facts

            # Find specific facts (order might vary in hashtable)
            $serverFact = $result.facts | Where-Object { $_.title -eq "Server Name" }
            $statusFact = $result.facts | Where-Object { $_.title -eq "Status" }
            $portFact = $result.facts | Where-Object { $_.title -eq "Port" }

            $serverFact.value | Should -Be "WEB-01"
            $statusFact.value | Should -Be "Online"
            $portFact.value | Should -Be "80"
        }

        It 'Should handle empty hashtable' {
            $result = New-CardFactSet -Facts @{}

            $result.type | Should -Be "FactSet"
            $result.facts | Should -HaveCount 0
        }

        It 'Should convert all values to strings' {
            $facts = @{
                "Number"  = 42
                "Boolean" = $true
                "Date"    = Get-Date "2025-01-01"
                "Null"    = $null
            }

            $result = New-CardFactSet -Facts $facts

            $result.facts | ForEach-Object {
                $_.value | Should -BeOfType [string]
            }
        }
    }

    Context 'Object Parameter Set' {
        It 'Should create FactSet from PowerShell object with NoteProperties' {
            $obj = [PSCustomObject]@{
                Name   = "Test Object"
                Value  = 123
                Status = "Active"
            }

            $result = New-CardFactSet -Object $obj

            $result.type | Should -Be "FactSet"
            $result.facts | Should -HaveCount 3

            $nameFact = $result.facts | Where-Object { $_.title -eq "Name" }
            $nameFact.value | Should -Be "Test Object"
        }

        It 'Should handle null values in object properties' {
            $obj = [PSCustomObject]@{
                Name        = "Test"
                NullValue   = $null
                EmptyString = ""
            }

            $result = New-CardFactSet -Object $obj

            $nullFact = $result.facts | Where-Object { $_.title -eq "NullValue" }
            $emptyFact = $result.facts | Where-Object { $_.title -eq "EmptyString" }

            $nullFact.value | Should -Be ""
            $emptyFact.value | Should -Be ""
        }

        It 'Should include only NoteProperties by default' {
            $process = Get-Process | Select-Object -First 1

            $result = New-CardFactSet -Object $process

            # Should only include properties that are NoteProperties
            $result.facts | Should -Not -BeNullOrEmpty
            # The exact count will depend on the selected properties
        }

        It 'Should include all properties when EveryProperty is specified' {
            $obj = New-Object PSObject
            $obj | Add-Member -MemberType NoteProperty -Name "NoteProp" -Value "Note Value"
            $obj | Add-Member -MemberType ScriptProperty -Name "ScriptProp" -Value { "Script Value" }

            $resultDefault = New-CardFactSet -Object $obj
            $resultAll = New-CardFactSet -Object $obj -EveryProperty

            $resultDefault.facts | Should -HaveCount 1
            $resultAll.facts.Count | Should -BeGreaterThan 1
        }

        It 'Should handle complex object types' {
            $fileInfo = Get-Item $PSScriptRoot -ErrorAction SilentlyContinue
            if ($fileInfo) {
                $result = New-CardFactSet -Object $fileInfo -EveryProperty

                $result.type | Should -Be "FactSet"
                $result.facts | Should -Not -BeNullOrEmpty
            }
        }
    }

    Context 'Layout and Positioning Parameters' {
        It 'Should set target width when specified' {
            $facts = @{ "Test" = "Value" }

            $targetWidths = @("VeryNarrow", "Narrow", "Standard", "Wide", "atLeast:Standard", "atMost:Wide")

            foreach ($width in $targetWidths) {
                $result = New-CardFactSet -Facts $facts -TargetWidth $width
                $result.targetWidth | Should -Be $width
            }
        }

        It 'Should set height when specified' {
            $facts = @{ "Test" = "Value" }

            $heights = @("Auto", "Stretch")

            foreach ($height in $heights) {
                $result = New-CardFactSet -Facts $facts -Height $height
                $result.height | Should -Be $height
            }
        }

        It 'Should set grid area when specified' {
            $facts = @{ "Test" = "Value" }

            $result = New-CardFactSet -Facts $facts -GridArea "fact-section"

            $result.gridArea | Should -Be "fact-section"
        }

        It 'Should set spacing when specified' {
            $facts = @{ "Test" = "Value" }

            $spacings = @("None", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")

            foreach ($spacing in $spacings) {
                $result = New-CardFactSet -Facts $facts -Spacing $spacing
                $result.spacing | Should -Be $spacing
            }
        }
    }

    Context 'Identification and Metadata Parameters' {
        It 'Should set ID when specified' {
            $facts = @{ "Test" = "Value" }

            $result = New-CardFactSet -Facts $facts -Id "factset-001"

            $result.id | Should -Be "factset-001"
        }

        It 'Should set language when specified' {
            $facts = @{ "Test" = "Value" }

            $result = New-CardFactSet -Facts $facts -Language "en-US"

            $result.lang | Should -Be "en-US"
        }

        It 'Should set language using Lang alias' {
            $facts = @{ "Test" = "Value" }

            $result = New-CardFactSet -Facts $facts -Lang "fr-FR"

            $result.lang | Should -Be "fr-FR"
        }

        It 'Should set requires when specified' {
            $facts = @{ "Test" = "Value" }
            $requires = @{ "hostCapabilities" = @{ "adaptiveCards" = "1.3" } }

            $result = New-CardFactSet -Facts $facts -Requires $requires

            $result.requires | Should -Be $requires
        }
    }

    Context 'Switch Parameters' {
        It 'Should set separator when Separator switch is used' {
            $facts = @{ "Test" = "Value" }

            $result = New-CardFactSet -Facts $facts -Separator

            $result.separator | Should -Be $true
        }

        It 'Should not include separator property when switch is not used' {
            $facts = @{ "Test" = "Value" }

            $result = New-CardFactSet -Facts $facts

            $result.ContainsKey('separator') | Should -Be $false
        }

        It 'Should set isSortKey when IsSortKey switch is used' {
            $facts = @{ "Test" = "Value" }

            $result = New-CardFactSet -Facts $facts -IsSortKey

            $result.isSortKey | Should -Be $true
        }

        It 'Should set isVisible to false when IsHidden switch is used' {
            $facts = @{ "Test" = "Value" }

            $result = New-CardFactSet -Facts $facts -IsHidden

            $result.isVisible | Should -Be $false
        }

        It 'Should set isVisible to false when Hide alias is used' {
            $facts = @{ "Test" = "Value" }

            $result = New-CardFactSet -Facts $facts -Hide

            $result.isVisible | Should -Be $false
        }

        It 'Should not include visibility property when IsHidden is not used' {
            $facts = @{ "Test" = "Value" }

            $result = New-CardFactSet -Facts $facts

            $result.ContainsKey('isVisible') | Should -Be $false
        }
    }

    Context 'Fallback Functionality' {
        It 'Should execute fallback scriptblock when provided' {
            $facts = @{ "Test" = "Value" }

            $result = New-CardFactSet -Facts $facts -Fallback {
                @{
                    type = "TextBlock"
                    text = "FactSet not available"
                }
            }

            $result.fallback | Should -Not -BeNullOrEmpty
            $result.fallback.type | Should -Be "TextBlock"
            $result.fallback.text | Should -Be "FactSet not available"
        }

        It 'Should not include fallback property when not specified' {
            $facts = @{ "Test" = "Value" }

            $result = New-CardFactSet -Facts $facts

            $result.ContainsKey('fallback') | Should -Be $false
        }

        It 'Should handle complex fallback scriptblock' {
            $facts = @{ "Test" = "Value" }

            $result = New-CardFactSet -Facts $facts -Fallback {
                @{
                    type  = "Container"
                    items = @(
                        @{ type = "TextBlock"; text = "Facts unavailable" }
                    )
                }
            }

            $result.fallback.type | Should -Be "Container"
            $result.fallback.items[0].text | Should -Be "Facts unavailable"
        }
    }

    Context 'Complex Scenarios' {
        It 'Should handle all parameters together with hashtable' {
            $facts = @{
                "Server" = "WEB-01"
                "Status" = "Online"
                "Uptime" = "15 days"
            }
            $requires = @{ "hostCapabilities" = @{ "adaptiveCards" = "1.3" } }

            $result = New-CardFactSet -Facts $facts -Id "server-facts" -Language "en-US" -TargetWidth "Standard" -Height "Auto" -GridArea "server-info" -Spacing "Medium" -Requires $requires -Separator -IsSortKey -Fallback {
                @{ type = "TextBlock"; text = "Server info unavailable" }
            }

            $result.type | Should -Be "FactSet"
            $result.facts | Should -HaveCount 3
            $result.id | Should -Be "server-facts"
            $result.lang | Should -Be "en-US"
            $result.targetWidth | Should -Be "Standard"
            $result.height | Should -Be "Auto"
            $result.gridArea | Should -Be "server-info"
            $result.spacing | Should -Be "Medium"
            $result.requires | Should -Be $requires
            $result.separator | Should -Be $true
            $result.isSortKey | Should -Be $true
            $result.fallback.text | Should -Be "Server info unavailable"
        }

        It 'Should handle all parameters together with object' {
            $obj = [PSCustomObject]@{
                Name    = "Test Service"
                Version = "1.2.3"
                Status  = "Running"
            }

            $result = New-CardFactSet -Object $obj -Id "service-facts" -EveryProperty -Language "en-US" -Height "Stretch" -Separator

            $result.type | Should -Be "FactSet"
            $result.id | Should -Be "service-facts"
            $result.lang | Should -Be "en-US"
            $result.height | Should -Be "Stretch"
            $result.separator | Should -Be $true
        }

        It 'Should create FactSet for real-world scenario with system information' {
            $systemInfo = @{
                "Computer Name"      = $env:COMPUTERNAME
                "OS Version"         = [System.Environment]::OSVersion.VersionString
                "PowerShell Version" = $PSVersionTable.PSVersion.ToString()
                "Current User"       = [System.Environment]::UserName
                "Working Directory"  = (Get-Location).Path
            }

            $result = New-CardFactSet -Facts $systemInfo -Id "system-info" -Spacing "Medium"

            $result.type | Should -Be "FactSet"
            $result.facts | Should -HaveCount 5
            $result.id | Should -Be "system-info"
            $result.spacing | Should -Be "Medium"

            # Verify some expected facts
            $computerNameFact = $result.facts | Where-Object { $_.title -eq "Computer Name" }
            $computerNameFact.value | Should -Be $env:COMPUTERNAME
        }
    }

    Context 'Parameter Set Validation' {
        It 'Should require either Facts or Object parameter' {
            { New-CardFactSet } | Should -Throw
        }

        It 'Should not allow both Facts and Object parameters' {
            $facts = @{ "Test" = "Value" }
            $obj = [PSCustomObject]@{ Name = "Test" }

            { New-CardFactSet -Facts $facts -Object $obj } | Should -Throw
        }

        It 'Should only allow EveryProperty with Object parameter set' {
            $facts = @{ "Test" = "Value" }

            { New-CardFactSet -Facts $facts -EveryProperty } | Should -Throw
        }
    }

    Context 'ShouldProcess Support' {
        It 'Should support WhatIf parameter' {
            $facts = @{ "Test" = "Value" }

            $result = New-CardFactSet -Facts $facts -WhatIf

            # WhatIf should not return anything
            $result | Should -BeNullOrEmpty
        }

        It 'Should return FactSet when not using WhatIf' {
            $facts = @{ "Test" = "Value" }

            $result = New-CardFactSet -Facts $facts

            $result | Should -Not -BeNullOrEmpty
            $result.type | Should -Be "FactSet"
        }
    }

    Context 'Parameter Validation' {
        It 'Should throw error for invalid TargetWidth values' {
            $facts = @{ "Test" = "Value" }

            { New-CardFactSet -Facts $facts -TargetWidth "Invalid" } | Should -Throw
        }

        It 'Should throw error for invalid Height values' {
            $facts = @{ "Test" = "Value" }

            { New-CardFactSet -Facts $facts -Height "Invalid" } | Should -Throw
        }

        It 'Should throw error for invalid Spacing values' {
            $facts = @{ "Test" = "Value" }

            { New-CardFactSet -Facts $facts -Spacing "Invalid" } | Should -Throw
        }
    }

    Context 'Edge Cases' {
        It 'Should handle facts with special characters in keys and values' {
            $facts = @{
                "Key with spaces & symbols!" = "Value with 'quotes' and ""double quotes"""
                "Unicode: 🚀"                = "Emoji value: ✅"
                "HTML: <tag>"                = "XML: <?xml version='1.0'?>"
            }

            $result = New-CardFactSet -Facts $facts

            $result.facts | Should -HaveCount 3
            $unicodeFact = $result.facts | Where-Object { $_.title -eq "Unicode: 🚀" }
            $unicodeFact.value | Should -Be "Emoji value: ✅"
        }

        It 'Should handle very large number of facts' {
            $facts = @{}
            1..100 | ForEach-Object {
                $facts["Fact $_"] = "Value $_"
            }

            $result = New-CardFactSet -Facts $facts

            $result.facts | Should -HaveCount 100
        }

        It 'Should handle object with no properties' {
            $emptyObj = New-Object PSObject

            $result = New-CardFactSet -Object $emptyObj

            $result.type | Should -Be "FactSet"
            $result.facts | Should -HaveCount 0
        }

        It 'Should convert complex object values to strings' {
            $complexObj = [PSCustomObject]@{
                SimpleString = "Hello"
                Number       = 42
                Array        = @(1, 2, 3)
                Hashtable    = @{ nested = "value" }
                DateTime     = Get-Date "2023-01-01"
            }

            $result = New-CardFactSet -Object $complexObj

            $result.facts | ForEach-Object {
                $_.value | Should -BeOfType [string]
            }

            $arrayFact = $result.facts | Where-Object { $_.title -eq "Array" }
            $arrayFact.value | Should -Match "1.*2.*3"  # Array should be converted to string representation
        }
    }
}