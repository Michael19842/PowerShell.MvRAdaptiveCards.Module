BeforeAll {
    # Import the module
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MvRAdaptiveCards\MvRAdaptiveCards.psd1'
    Import-Module $ModulePath -Force -ArgumentList $True, $true
}

Describe "New-CardIcon" {

    Context "Basic Functionality" {
        It "Should create an icon with required Name parameter" {
            $result = New-CardIcon -Name "Calendar"

            $result | Should -Not -BeNullOrEmpty
            $result | Should -BeOfType [hashtable]
            $result.type | Should -Be "Icon"
            $result.name | Should -Be "Calendar"
        }

        It "Should return a hashtable" {
            $result = New-CardIcon -Name "Mail"
            $result | Should -BeOfType [hashtable]
        }

        It "Should have required type property" {
            $result = New-CardIcon -Name "Shield"
            $result.type | Should -Be "Icon"
        }

        It "Should accept various icon names" {
            $validIcons = @("Calendar", "Mail", "Shield", "Warning", "Home", "Settings")
            foreach ($icon in $validIcons) {
                $result = New-CardIcon -Name $icon
                $result.name | Should -Be $icon
            }
        }
    }

    Context "Color Property" {
        It "Should set Default color" {
            $result = New-CardIcon -Name "Mail" -Color "Default"
            $result.color | Should -Be "Default"
        }

        It "Should set Dark color" {
            $result = New-CardIcon -Name "Mail" -Color "Dark"
            $result.color | Should -Be "Dark"
        }

        It "Should set Light color" {
            $result = New-CardIcon -Name "Mail" -Color "Light"
            $result.color | Should -Be "Light"
        }

        It "Should set Accent color" {
            $result = New-CardIcon -Name "Mail" -Color "Accent"
            $result.color | Should -Be "Accent"
        }

        It "Should set Good color" {
            $result = New-CardIcon -Name "Shield" -Color "Good"
            $result.color | Should -Be "Good"
        }

        It "Should set Warning color" {
            $result = New-CardIcon -Name "Warning" -Color "Warning"
            $result.color | Should -Be "Warning"
        }

        It "Should set Attention color" {
            $result = New-CardIcon -Name "Error" -Color "Attention"
            $result.color | Should -Be "Attention"
        }

        It "Should not include color property when not specified" {
            $result = New-CardIcon -Name "Mail"
            $result.ContainsKey("color") | Should -Be $false
        }

        It "Should validate color values" {
            { New-CardIcon -Name "Mail" -Color "InvalidColor" } | Should -Throw
        }

        It "Should handle all valid color values" {
            $validColors = @("Default", "Dark", "Light", "Accent", "Good", "Warning", "Attention")
            foreach ($color in $validColors) {
                $result = New-CardIcon -Name "Mail" -Color $color
                $result.color | Should -Be $color
            }
        }
    }

    Context "Size Property" {
        It "Should set xxSmall size" {
            $result = New-CardIcon -Name "Mail" -Size "xxSmall"
            $result.size | Should -Be "xxSmall"
        }

        It "Should set xSmall size" {
            $result = New-CardIcon -Name "Mail" -Size "xSmall"
            $result.size | Should -Be "xSmall"
        }

        It "Should set Small size" {
            $result = New-CardIcon -Name "Mail" -Size "Small"
            $result.size | Should -Be "Small"
        }

        It "Should set Standard size" {
            $result = New-CardIcon -Name "Mail" -Size "Standard"
            $result.size | Should -Be "Standard"
        }

        It "Should set Medium size" {
            $result = New-CardIcon -Name "Mail" -Size "Medium"
            $result.size | Should -Be "Medium"
        }

        It "Should set Large size" {
            $result = New-CardIcon -Name "Mail" -Size "Large"
            $result.size | Should -Be "Large"
        }

        It "Should set xLarge size" {
            $result = New-CardIcon -Name "Mail" -Size "xLarge"
            $result.size | Should -Be "xLarge"
        }

        It "Should set xxLarge size" {
            $result = New-CardIcon -Name "Mail" -Size "xxLarge"
            $result.size | Should -Be "xxLarge"
        }

        It "Should not include size property when not specified" {
            $result = New-CardIcon -Name "Mail"
            $result.ContainsKey("size") | Should -Be $false
        }

        It "Should validate size values" {
            { New-CardIcon -Name "Mail" -Size "InvalidSize" } | Should -Throw
        }

        It "Should handle all valid size values" {
            $validSizes = @("xxSmall", "xSmall", "Small", "Standard", "Medium", "Large", "xLarge", "xxLarge")
            foreach ($size in $validSizes) {
                $result = New-CardIcon -Name "Mail" -Size $size
                $result.size | Should -Be $size
            }
        }
    }

    Context "Style Property" {
        It "Should set Regular style" {
            $result = New-CardIcon -Name "Shield" -Style "Regular"
            $result.style | Should -Be "Regular"
        }

        It "Should set Filled style" {
            $result = New-CardIcon -Name "Shield" -Style "Filled"
            $result.style | Should -Be "Filled"
        }

        It "Should not include style property when not specified" {
            $result = New-CardIcon -Name "Mail"
            $result.ContainsKey("style") | Should -Be $false
        }

        It "Should validate style values" {
            { New-CardIcon -Name "Mail" -Style "InvalidStyle" } | Should -Throw
        }

        It "Should handle both style values" {
            @("Regular", "Filled") | ForEach-Object {
                $result = New-CardIcon -Name "Shield" -Style $_
                $result.style | Should -Be $_
            }
        }
    }

    Context "Layout Properties" {
        It "Should set Id" {
            $result = New-CardIcon -Name "Mail" -Id "mail-icon"
            $result.id | Should -Be "mail-icon"
        }

        It "Should set HorizontalAlignment Left" {
            $result = New-CardIcon -Name "Mail" -HorizontalAlignment "Left"
            $result.horizontalAlignment | Should -Be "Left"
        }

        It "Should set HorizontalAlignment Center" {
            $result = New-CardIcon -Name "Mail" -HorizontalAlignment "Center"
            $result.horizontalAlignment | Should -Be "Center"
        }

        It "Should set HorizontalAlignment Right" {
            $result = New-CardIcon -Name "Mail" -HorizontalAlignment "Right"
            $result.horizontalAlignment | Should -Be "Right"
        }

        It "Should validate HorizontalAlignment values" {
            { New-CardIcon -Name "Mail" -HorizontalAlignment "InvalidAlignment" } | Should -Throw
        }

        It "Should handle all horizontal alignment values" {
            @("Left", "Center", "Right") | ForEach-Object {
                $result = New-CardIcon -Name "Mail" -HorizontalAlignment $_
                $result.horizontalAlignment | Should -Be $_
            }
        }

        It "Should set Spacing None" {
            $result = New-CardIcon -Name "Mail" -Spacing "None"
            $result.spacing | Should -Be "None"
        }

        It "Should set Spacing Small" {
            $result = New-CardIcon -Name "Mail" -Spacing "Small"
            $result.spacing | Should -Be "Small"
        }

        It "Should set Spacing Default" {
            $result = New-CardIcon -Name "Mail" -Spacing "Default"
            $result.spacing | Should -Be "Default"
        }

        It "Should set Spacing Medium" {
            $result = New-CardIcon -Name "Mail" -Spacing "Medium"
            $result.spacing | Should -Be "Medium"
        }

        It "Should set Spacing Large" {
            $result = New-CardIcon -Name "Mail" -Spacing "Large"
            $result.spacing | Should -Be "Large"
        }

        It "Should set Spacing ExtraLarge" {
            $result = New-CardIcon -Name "Mail" -Spacing "ExtraLarge"
            $result.spacing | Should -Be "ExtraLarge"
        }

        It "Should not include spacing when not specified" {
            $result = New-CardIcon -Name "Mail"
            $result.ContainsKey("spacing") | Should -Be $false
        }

        It "Should set separator" {
            $result = New-CardIcon -Name "Mail" -separator
            $result.separator | Should -Be $true
        }

        It "Should not include separator when not specified" {
            $result = New-CardIcon -Name "Mail"
            $result.ContainsKey("separator") | Should -Be $false
        }

        It "Should set GridArea" {
            $result = New-CardIcon -Name "Mail" -GridArea "header"
            $result."grid.area" | Should -Be "header"
        }

        It "Should not include GridArea when not specified" {
            $result = New-CardIcon -Name "Mail"
            $result.ContainsKey("grid.area") | Should -Be $false
        }

        It "Should set TargetWidth with simple value" {
            $result = New-CardIcon -Name "Mail" -TargetWidth "Standard"
            $result.targetWidth | Should -Be "Standard"
        }

        It "Should set TargetWidth with atLeast modifier" {
            $result = New-CardIcon -Name "Mail" -TargetWidth "atLeast:Standard"
            $result.targetWidth | Should -Be "atLeast:Standard"
        }

        It "Should set TargetWidth with atMost modifier" {
            $result = New-CardIcon -Name "Mail" -TargetWidth "atMost:Wide"
            $result.targetWidth | Should -Be "atMost:Wide"
        }

        It "Should not include TargetWidth when not specified" {
            $result = New-CardIcon -Name "Mail"
            $result.ContainsKey("targetWidth") | Should -Be $false
        }
    }

    Context "Visibility Properties" {
        It "Should set IsHidden to true when specified" {
            $result = New-CardIcon -Name "Mail" -IsHidden
            $result.isVisible | Should -Be $False
        }

        It "Should not include isVisible when not specified" {
            $result = New-CardIcon -Name "Mail"
            $result.ContainsKey("isVisible") | Should -Be $false
        }

        It "Should set isSortKey" {
            $result = New-CardIcon -Name "Mail" -isSortKey
            $result.isSortKey | Should -Be $true
        }

        It "Should not include isSortKey when not specified" {
            $result = New-CardIcon -Name "Mail"
            $result.ContainsKey("isSortKey") | Should -Be $false
        }
    }

    Context "Localization" {
        It "Should set Lang property" {
            $result = New-CardIcon -Name "Mail" -Lang "en-US"
            $result.lang | Should -Be "en-US"
        }

        It "Should handle different language codes" {
            $languages = @("en-US", "fr-FR", "de-DE", "es-ES", "ja-JP", "zh-CN")
            foreach ($lang in $languages) {
                $result = New-CardIcon -Name "Mail" -Lang $lang
                $result.lang | Should -Be $lang
            }
        }

        It "Should not include lang when not specified" {
            $result = New-CardIcon -Name "Mail"
            $result.ContainsKey("lang") | Should -Be $false
        }
    }

    Context "SelectAction Property" {
        It "Should set SelectAction from scriptblock" {
            $action = { New-CardActionOpenUrl -Url "https://example.com" }
            $result = New-CardIcon -Name "Mail" -SelectAction $action

            $result.selectAction | Should -Not -BeNullOrEmpty
            $result.selectAction.type | Should -Be "Action.OpenUrl"
        }

        It "Should not include selectAction when not specified" {
            $result = New-CardIcon -Name "Mail"
            $result.ContainsKey("selectAction") | Should -Be $false
        }

        It "Should execute SelectAction scriptblock" {
            $action = {
                @{
                    type = "Action.OpenUrl"
                    url  = "https://test.com"
                }
            }
            $result = New-CardIcon -Name "Mail" -SelectAction $action

            $result.selectAction.url | Should -Be "https://test.com"
        }

        It "Should handle different action types in SelectAction" {
            $submitAction = { New-CardActionSubmit -Title "Submit" }
            $result = New-CardIcon -Name "Mail" -SelectAction $submitAction

            $result.selectAction.type | Should -Be "Action.Submit"
        }
    }

    Context "Fallback Property" {
        It "Should set Fallback from scriptblock" {
            $fallback = { New-CardTextBlock -Text "Icon not supported" }
            $result = New-CardIcon -Name "Mail" -Fallback $fallback

            $result.fallback | Should -Not -BeNullOrEmpty
        }

        It "Should not include fallback when not specified" {
            $result = New-CardIcon -Name "Mail"
            $result.ContainsKey("fallback") | Should -Be $false
        }

        It "Should execute Fallback scriptblock" {
            $fallback = {
                @{
                    type = "TextBlock"
                    text = "Fallback text"
                }
            }
            $result = New-CardIcon -Name "Mail" -Fallback $fallback

            $result.fallback.text | Should -Be "Fallback text"
        }
    }

    Context "Combined Properties" {
        It "Should set multiple properties together" {
            $result = New-CardIcon -Name "Shield" -Color "Good" -Size "Large" -Style "Filled"

            $result.name | Should -Be "Shield"
            $result.color | Should -Be "Good"
            $result.size | Should -Be "Large"
            $result.style | Should -Be "Filled"
        }

        It "Should set all layout properties" {
            $result = New-CardIcon -Name "Mail" -Id "icon1" -HorizontalAlignment "Center" -Spacing "Medium" -separator

            $result.id | Should -Be "icon1"
            $result.horizontalAlignment | Should -Be "Center"
            $result.spacing | Should -Be "Medium"
            $result.separator | Should -Be $true
        }

        It "Should handle icon with action and fallback" {
            $action = { New-CardActionOpenUrl -Url "https://example.com" }
            $fallback = { New-CardTextBlock -Text "Icon unavailable" }

            $result = New-CardIcon -Name "Mail" -SelectAction $action -Fallback $fallback

            $result.selectAction | Should -Not -BeNullOrEmpty
            $result.fallback | Should -Not -BeNullOrEmpty
        }

        It "Should handle comprehensive icon configuration" {
            $result = New-CardIcon -Name "Warning" -Color "Warning" -Size "Large" -Style "Filled" `
                -Id "warning-icon" -HorizontalAlignment "Center" -Spacing "Medium" `
                -separator -Lang "en-US"

            $result.name | Should -Be "Warning"
            $result.color | Should -Be "Warning"
            $result.size | Should -Be "Large"
            $result.style | Should -Be "Filled"
            $result.id | Should -Be "warning-icon"
            $result.horizontalAlignment | Should -Be "Center"
            $result.spacing | Should -Be "Medium"
            $result.separator | Should -Be $true
            $result.lang | Should -Be "en-US"
        }
    }

    Context "Integration with Adaptive Card" {
        It "Should work within New-AdaptiveCard" {
            $card = New-AdaptiveCard {
                New-CardIcon -Name "Calendar"
            } -AsObject

            $card.body | Should -HaveCount 1
            $card.body[0].type | Should -Be "Icon"
            $card.body[0].name | Should -Be "Calendar"
        }

        It "Should work with multiple icons" {
            $card = New-AdaptiveCard {
                New-CardIcon -Name "Mail" -Color "Accent"
                New-CardIcon -Name "Calendar" -Color "Good"
                New-CardIcon -Name "Shield" -Color "Warning"
            } -AsObject

            $card.body | Should -HaveCount 3
            $card.body[0].name | Should -Be "Mail"
            $card.body[1].name | Should -Be "Calendar"
            $card.body[2].name | Should -Be "Shield"
        }

        It "Should work in containers" {
            $card = New-AdaptiveCard {
                New-CardContainer {
                    New-CardIcon -Name "Warning" -Color "Attention"
                    New-CardTextBlock -Text "Warning message"
                }
            } -AsObject

            $card.body[0].items | Should -HaveCount 2
            $card.body[0].items[0].type | Should -Be "Icon"
        }
    }

    Context "Real-World Examples" {
        It "Should create status indicator icon" {
            $result = New-CardIcon -Name "MailAttach" -Color "Good" -Size "Medium" -Style "Filled"

            $result.name | Should -Be "MailAttach"
            $result.color | Should -Be "Good"
            $result.style | Should -Be "Filled"
        }

        It "Should create error indicator icon" {
            $result = New-CardIcon -Name "Error" -Color "Attention" -Size "Large" -HorizontalAlignment "Center"

            $result.name | Should -Be "Error"
            $result.color | Should -Be "Attention"
            $result.size | Should -Be "Large"
        }

        It "Should create clickable icon button" {
            $action = { New-CardActionOpenUrl -Url "https://settings.example.com" }
            $result = New-CardIcon -Name "Settings" -SelectAction $action -Size "Medium"

            $result.selectAction | Should -Not -BeNullOrEmpty
            $result.selectAction.type | Should -Be "Action.OpenUrl"
        }

        It "Should create icon with accessibility" {
            $result = New-CardIcon -Name "Mail" -Id "mail-notifications" -Lang "en-US"

            $result.id | Should -Be "mail-notifications"
            $result.lang | Should -Be "en-US"
        }
    }

    Context "Edge Cases" {
        It "Should handle icon names with numbers" {
            # Assuming icon collection includes names with numbers
            $result = New-CardIcon -Name "Calendar"
            $result.name | Should -Be "Calendar"
        }

        It "Should handle empty Id string" {
            $result = New-CardIcon -Name "Mail" -Id ""
            $result.id | Should -BeNullOrEmpty
        }

        It "Should handle empty GridArea string" {
            $result = New-CardIcon -Name "Mail" -GridArea ""
            $result."grid.area" | Should -BeNullOrEmpty
        }

        It "Should not modify input parameters" {
            $iconName = "Calendar"
            $result = New-CardIcon -Name $iconName
            $iconName | Should -Be "Calendar"
        }
    }

    Context "ShouldProcess Support" {
        It "Should support WhatIf" {
            $result = New-CardIcon -Name "Mail" -WhatIf
            $result | Should -BeNullOrEmpty
        }

        It "Should process normally without WhatIf" {
            $result = New-CardIcon -Name "Mail"
            $result | Should -Not -BeNullOrEmpty
        }
    }

    Context "Command Metadata" {
        It "Should have correct command name" {
            $command = Get-Command New-CardIcon
            $command.Name | Should -Be "New-CardIcon"
        }

        It "Should support ShouldProcess" {
            $command = Get-Command New-CardIcon
            $command.Parameters.ContainsKey('WhatIf') | Should -Be $true
            $command.Parameters.ContainsKey('Confirm') | Should -Be $true
        }

        It "Should have help documentation" {
            $help = Get-Help New-CardIcon
            $help.Synopsis | Should -Not -BeNullOrEmpty
            $help.Description | Should -Not -BeNullOrEmpty
        }

        It "Should have examples in help" {
            $help = Get-Help New-CardIcon -Full
            $help.Examples | Should -Not -BeNullOrEmpty
            $help.Examples.Example.Count | Should -BeGreaterThan 0
        }

        It "Should have parameter descriptions" {
            $help = Get-Help New-CardIcon -Full
            $help.parameters.parameter | Should -Not -BeNullOrEmpty
        }

        It "Should have all parameters documented" {
            $command = Get-Command New-CardIcon
            $help = Get-Help New-CardIcon -Full

            $commonParams = @('WhatIf', 'Confirm', 'Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction', 'ErrorVariable', 'WarningVariable', 'InformationVariable', 'OutVariable', 'OutBuffer', 'PipelineVariable', 'ProgressAction')
            $parameters = $command.Parameters.Keys | Where-Object { $_ -notin $commonParams }

            foreach ($param in $parameters) {
                $paramHelp = $help.parameters.parameter | Where-Object { $_.name -eq $param }
                $paramHelp | Should -Not -BeNullOrEmpty -Because "Parameter $param should be documented"
            }
        }
    }

    Context "Output Validation" {
        It "Should return valid Adaptive Card element structure" {
            $result = New-CardIcon -Name "Mail"

            $result | Should -BeOfType [hashtable]
            $result.type | Should -Be "Icon"
            $result.name | Should -Not -BeNullOrEmpty
        }

        It "Should only include specified properties" {
            $result = New-CardIcon -Name "Mail" -Color "Accent"

            $result.ContainsKey("type") | Should -Be $true
            $result.ContainsKey("name") | Should -Be $true
            $result.ContainsKey("color") | Should -Be $true
            $result.ContainsKey("size") | Should -Be $false
            $result.ContainsKey("style") | Should -Be $false
        }

        It "Should produce JSON-serializable output" {
            $result = New-CardIcon -Name "Mail" -Color "Good" -Size "Large"
            { $result | ConvertTo-Json -Depth 10 } | Should -Not -Throw
        }
    }
}
