New-AdaptiveCard {
    New-CardTextBlock -Text "Credit limit details" -Wrap -Size Large -Weight Bolder
    New-CardColumnSet -Columns {
        New-CardColumn -Width 'stretch' -Content {
            New-CardTextBlock -Text "StellarEdge Outdoor Equipment" -Wrap -Weight Bolder -Size Default
            New-CardBadge -Text "Approved" -Size ExtraLarge -Style Good -Appearance Tint -Icon CheckmarkCircle
        }
    } -TargetWidth VeryNarrow
    New-CardColumnSet -Columns {
        New-CardColumn -Content {
            New-CardTextBlock -Text "StellarEdge Outdoor Equipment" -Wrap -Size Default -Weight Bolder
        }
        New-CardColumn -Content {
            New-CardBadge -Text "Approved" -Size ExtraLarge -Style Good -Appearance Tint -Icon CheckmarkCircle -HorizontalAlignment Right
        }
    } -TargetWidth AtLeast:Narrow
    New-CardColumnSet -Columns {
        New-CardColumn -Width 'auto' -Content {
            New-CardTextBlock -Text "Current Risk Class" -Wrap -Size Small -Weight Bolder
            New-CardColumnSet -Columns {
                New-CardColumn -Width 'auto' -Content {
                    New-CardIcon -Name CheckmarkCircle -Style Filled -Color Good -Size xSmall
                }
                New-CardColumn -Width 'stretch' -Content {
                    New-CardTextBlock -Text "E (Low Risk)" -Wrap -Spacing None -Size Small
                } -Spacing ExtraSmall
            } -Spacing ExtraSmall
        } -VerticalContentAlignment Center
        New-CardColumn -Width 'auto' -Content {
            New-CardTextBlock -Text "Requested by" -Wrap -Size Small -Weight Bolder
            New-CardColumnSet -Columns {
                New-CardColumn -Width 'auto' -Content {
                    New-CardImage -Url "https://raw.githubusercontent.com/OfficeDev/Microsoft-Teams-Adaptive-Card-Samples/refs/heads/Suz-ChartReveal/samples/insights/assets/avatar-requestor.png" -Style Person -Size Small -Width "20px"
                }
                New-CardColumn -Width 'stretch' -Content {
                    New-CardTextBlock -Text "Mark Fullbright" -Wrap -Size Small
                } -Spacing Small
            } -Spacing ExtraSmall
        } -VerticalContentAlignment Center -Spacing ExtraLarge
        New-CardColumn -Width 'auto' -Content {
            New-CardTextBlock -Text "Approvers" -Wrap -Size Small -Weight Bolder
            New-CardColumnSet -Columns {
                New-CardColumn -Width 'auto' -Content {
                    New-CardImage -Url "https://raw.githubusercontent.com/OfficeDev/Microsoft-Teams-Adaptive-Card-Samples/refs/heads/Suz-ChartReveal/samples/insights/assets/avatar-approver1.png" -Width 20px -Style Person
                }
                New-CardColumn -Width 'auto' -Content {
                    New-CardImage -Url "https://raw.githubusercontent.com/OfficeDev/Microsoft-Teams-Adaptive-Card-Samples/refs/heads/Suz-ChartReveal/samples/insights/assets/avatar-approver2.png" -Width 20px -Style Person
                } -Spacing Small
                New-CardColumn -Width 'auto' -Content {
                    New-CardImage -Url "https://raw.githubusercontent.com/OfficeDev/Microsoft-Teams-Adaptive-Card-Samples/refs/heads/Suz-ChartReveal/samples/insights/assets/avatar-approver3.png" -Width 20px -Style Person
                } -Spacing Small
            } -Spacing ExtraSmall
        } -Spacing ExtraLarge
    } -TargetWidth AtLeast:Narrow

    New-CardActionSet -Actions {
        New-CardActionShowCard -Title "Show graphical data" -Card {
            New-AdaptiveCard {
                New-CardContainer -Content {
                    New-CardChartDonut -Id "creditLimitUsageChart" -Title "Credit Limit Usage" -Data @(
                        @{ label = "Used Credit"; value = 65000; color = "#E81123" },
                        @{ label = "Available Credit"; value = 35000; color = "#107C10" }
                    )
                }
            } -AsObject
        } -Style Positive
    }
} | Get-CardResponse -ViewMethod EdgeApp -AutoSize -hideHeader

