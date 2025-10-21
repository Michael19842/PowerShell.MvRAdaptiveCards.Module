BeforeAll {
    # Import the module
    $ModulePath = Split-Path -Parent $PSScriptRoot
    Import-Module "$ModulePath\MvRAdaptiveCards\MvRAdaptiveCards.psd1" -Force

    # Test data
    $script:ValidCardJson = @'
{
    "type": "AdaptiveCard",
    "version": "1.3",
    "body": [
        {
            "type": "TextBlock",
            "text": "Test Card",
            "size": "Medium",
            "weight": "Bolder"
        }
    ]
}
'@

    $script:InvalidCardJson = '{ "invalid": "json structure" }'
    $script:EmptyJson = ''
    $script:MalformedJson = '{ "incomplete": json'

    # Mock Start-Process to prevent actual browser launches during tests
    Mock Start-Process { }
}

Describe "Out-CardPreview" -Tag "Unit" {

    Context "Parameter Validation" {

        It "Should accept JSON string parameter" {
            { Out-CardPreview -Json $script:ValidCardJson -WhatIf } | Should -Not -Throw
        }

        It "Should accept JSON from pipeline" {
            { $script:ValidCardJson | Out-CardPreview -WhatIf } | Should -Not -Throw
        }

        It "Should throw when Json parameter is missing" {
            { Out-CardPreview -Json $null -WhatIf } | Should -Throw
        }

        It "Should accept empty string without throwing" {
            { Out-CardPreview -Json $script:EmptyJson -WhatIf } | Should -Not -Throw
        }

        It "Should accept malformed JSON without throwing during parameter binding" {
            { Out-CardPreview -Json $script:MalformedJson -WhatIf } | Should -Not -Throw
        }
    }

    Context "ShouldProcess Support" {

        It "Should support WhatIf parameter" {
            $result = Out-CardPreview -Json $script:ValidCardJson -WhatIf
            Should -Invoke Start-Process -Times 0
        }

        It "Should support Confirm parameter" {
            # Mock user choosing 'No' to confirmation
            Mock $PSCmdlet.ShouldProcess { $false }
            Out-CardPreview -Json $script:ValidCardJson -Confirm:$false
            Should -Invoke Start-Process -Times 0
        }

        It "Should call Start-Process when ShouldProcess returns true" {
            Out-CardPreview -Json $script:ValidCardJson -Confirm:$false
            Should -Invoke Start-Process -Times 1
        }
    }

    Context "HTML File Generation" {

        BeforeEach {
            # Clean up any existing temp files
            $tempFile = "$env:TEMP\AdaptiveCardDesigner.html"
            if (Test-Path $tempFile) {
                Remove-Item $tempFile -Force
            }
        }

        AfterEach {
            # Clean up temp files after each test
            $tempFile = "$env:TEMP\AdaptiveCardDesigner.html"
            if (Test-Path $tempFile) {
                Remove-Item $tempFile -Force
            }
        }

        It "Should create HTML file in TEMP directory" {
            Out-CardPreview -Json $script:ValidCardJson -Confirm:$false

            $expectedPath = "$env:TEMP\AdaptiveCardDesigner.html"
            $expectedPath | Should -Exist
        }

        It "Should create HTML file with proper encoding" {
            Out-CardPreview -Json $script:ValidCardJson -Confirm:$false

            $htmlContent = Get-Content "$env:TEMP\AdaptiveCardDesigner.html" -Raw -Encoding UTF8
            $htmlContent | Should -Not -BeNullOrEmpty
            $htmlContent | Should -Match '<!DOCTYPE html>'
        }

        It "Should embed JSON data in HTML file" {
            $testJson = '{"type":"AdaptiveCard","version":"1.3","body":[{"type":"TextBlock","text":"Test"}]}'
            Out-CardPreview -Json $testJson -Confirm:$false

            $htmlContent = Get-Content "$env:TEMP\AdaptiveCardDesigner.html" -Raw
            # The JSON should be embedded somewhere in the HTML
            $htmlContent | Should -Match "AdaptiveCard"
        }

        It "Should include AdaptiveCards JavaScript library reference" {
            Out-CardPreview -Json $script:ValidCardJson -Confirm:$false

            $htmlContent = Get-Content "$env:TEMP\AdaptiveCardDesigner.html" -Raw
            $htmlContent | Should -Match "adaptivecards.*\.js"
        }

        It "Should include module branding and styling" {
            Out-CardPreview -Json $script:ValidCardJson -Confirm:$false

            $htmlContent = Get-Content "$env:TEMP\AdaptiveCardDesigner.html" -Raw
            $htmlContent | Should -Match "module-header"
            $htmlContent | Should -Match "MvRAdaptiveCards"
        }
    }

    Context "Template File Dependency" {

        It "Should use PreviewCard.html template" {
            $templatePath = Join-Path $PSScriptRoot "..\MvRAdaptiveCards\Public\Application\Templates\PreviewCard.html"
            $templatePath | Should -Exist
        }

        It "Should handle missing template file gracefully" {
            # Backup original template
            $templatePath = Join-Path $PSScriptRoot "..\MvRAdaptiveCards\Public\Application\Templates\PreviewCard.html"
            $backupPath = "$templatePath.backup"

            if (Test-Path $templatePath) {
                Copy-Item $templatePath $backupPath
                Remove-Item $templatePath

                try {
                    { Out-CardPreview -Json $script:ValidCardJson -WhatIf } | Should -Throw
                }
                finally {
                    # Restore template
                    if (Test-Path $backupPath) {
                        Move-Item $backupPath $templatePath
                    }
                }
            }
        }
    }

    Context "Start-Process Integration" {

        It "Should call Start-Process with correct path" {
            Out-CardPreview -Json $script:ValidCardJson -Confirm:$false

            $expectedPath = "$env:TEMP\AdaptiveCardDesigner.html"
            Should -Invoke Start-Process -Times 1 -ParameterFilter { $FilePath -eq $expectedPath -or $_ -eq $expectedPath }
        }

        It "Should handle Start-Process errors gracefully" {
            Mock Start-Process { throw "Browser not found" }

            { Out-CardPreview -Json $script:ValidCardJson -Confirm:$false } | Should -Throw "Browser not found"
        }
    }

    Context "Edge Cases and Error Handling" {

        It "Should handle very large JSON strings" {
            # Create a large JSON structure
            $largeBody = @()
            1..1000 | ForEach-Object {
                $largeBody += @{
                    type = "TextBlock"
                    text = "Item $_"
                }
            }

            $largeCard = @{
                type    = "AdaptiveCard"
                version = "1.3"
                body    = $largeBody
            } | ConvertTo-Json -Depth 10

            { Out-CardPreview -Json $largeCard -WhatIf } | Should -Not -Throw
        }

        It "Should handle special characters in JSON" {
            $specialCharJson = @'
{
    "type": "AdaptiveCard",
    "version": "1.3",
    "body": [
        {
            "type": "TextBlock",
            "text": "Special chars: àáâãäåæçèéêë 中文 🎉 \"quotes\" 'apostrophes'"
        }
    ]
}
'@

            { Out-CardPreview -Json $specialCharJson -WhatIf } | Should -Not -Throw
        }

        It "Should handle null or empty JSON gracefully" {
            { Out-CardPreview -Json "" -WhatIf } | Should -Not -Throw
            { Out-CardPreview -Json " " -WhatIf } | Should -Not -Throw
        }
    }

    Context "Pipeline Input" {

        It "Should accept multiple JSON strings from pipeline" {
            $cards = @($script:ValidCardJson, $script:ValidCardJson)

            { $cards | Out-CardPreview -WhatIf } | Should -Not -Throw
            Should -Invoke Start-Process -Times 0  # WhatIf should prevent execution
        }

        It "Should process each pipeline item separately" {
            $cards = @($script:ValidCardJson, $script:ValidCardJson)

            $cards | Out-CardPreview -Confirm:$false
            Should -Invoke Start-Process -Times 2  # Once for each card
        }
    }

    Context "Output Validation" {

        It "Should not return any output" {
            $result = Out-CardPreview -Json $script:ValidCardJson -WhatIf
            $result | Should -BeNullOrEmpty
        }

        It "Should have correct OutputType attribute" {
            $function = Get-Command Out-CardPreview
            $outputType = $function.OutputType
            $outputType.Type.Name | Should -Be "Void"
        }
    }

    Context "Function Attributes" {

        It "Should support ShouldProcess" {
            $function = Get-Command Out-CardPreview
            $function.CmdletBinding.SupportsShouldProcess | Should -Be $true
        }

        It "Should have correct ConfirmImpact" {
            $function = Get-Command Out-CardPreview
            $function.CmdletBinding.ConfirmImpact | Should -Be "None"
        }

        It "Should suppress PSReviewUnusedParameter for template variables" {
            $functionContent = Get-Content (Get-Command Out-CardPreview).ScriptBlock.File -Raw
            $functionContent | Should -Match "SuppressMessageAttribute.*PSReviewUnusedParameter"
        }
    }
}

Describe "Out-CardPreview Integration" -Tag "Integration" {

    BeforeAll {
        # Ensure we have a valid module environment
        $ModulePath = Split-Path -Parent $PSScriptRoot
        Import-Module "$ModulePath\MvRAdaptiveCards\MvRAdaptiveCards.psd1" -Force

        Mock Start-Process { }
    }

    Context "Integration with New-AdaptiveCard" {

        It "Should work with New-AdaptiveCard output" {
            $card = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "Integration Test" -Size "Medium"
            }

            { $card | Out-CardPreview -WhatIf } | Should -Not -Throw
        }

        It "Should work with complex card structures" {
            $card = New-AdaptiveCard -Content {
                New-CardContainer -Style "Emphasis" -Content {
                    New-CardTextBlock -Text "Complex Card" -Weight "Bolder"
                    New-CardFactSet -Facts @(
                        @{ title = "Created"; value = (Get-Date).ToString() }
                        @{ title = "Type"; value = "Test" }
                    )
                }
            }

            { $card | Out-CardPreview -WhatIf } | Should -Not -Throw
        }
    }

    Context "Real File System Operations" {

        BeforeEach {
            $script:tempFile = "$env:TEMP\AdaptiveCardDesigner.html"
            if (Test-Path $script:tempFile) {
                Remove-Item $script:tempFile -Force
            }
        }

        AfterEach {
            if (Test-Path $script:tempFile) {
                Remove-Item $script:tempFile -Force
            }
        }

        It "Should create a valid HTML file that can be parsed" {
            # Remove mock for this test to actually create the file
            Mock Start-Process { } -ModuleName MvRAdaptiveCards

            $testCard = New-AdaptiveCard -Content {
                New-CardTextBlock -Text "File System Test"
            }

            $testCard | Out-CardPreview -Confirm:$false

            $script:tempFile | Should -Exist

            # Verify HTML is well-formed (basic check)
            $htmlContent = Get-Content $script:tempFile -Raw
            $htmlContent | Should -Match '<html.*>'
            $htmlContent | Should -Match '</html>'
            $htmlContent | Should -Match '<head>'
            $htmlContent | Should -Match '<body>'
        }
    }
}