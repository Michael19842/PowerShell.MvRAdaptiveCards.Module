#This demo shows a basic gauge in an adaptive card

#Requires -Module MvRAdaptiveCards

New-AdaptiveCard {
    New-CardContainer {
        New-CardTextBlock -Text "Basic Gauge Example" -Weight "Bolder" -Size "Medium" -Spacing "Large"
        New-CardChartGauge -Title "CPU Usage" -Value 65 -Min 0 -Max 100 -ColorSet categorical -ShowLegend $true
    }
} | Get-CardResponse -ViewMethod EdgeApp -AutoSize