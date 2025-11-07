#Requires -Module MvRAdaptiveCards

#This demo shows a more complex gauge in an adaptive card with multiple gauges

New-AdaptiveCard {
    New-CardContainer {
        New-CardTextBlock -Text "Complex Gauge Example" -Weight "Bolder" -Size "Medium" -Spacing "Large"
        New-CardChartGauge -Title "CPU Usage" -Value 75 -Min 0 -Max 100 -ColorSet categorical -ShowLegend $true
        New-CardChartGauge -Title "Memory Usage" -Value 60 -Min 0 -Max 100 -ColorSet categorical -ShowLegend $true
        New-CardChartGauge -Title "Disk Usage" -Value 85 -Min 0 -Max 100 -ColorSet categorical -ShowLegend $true
    }
} | Get-CardResponse -ViewMethod EdgeApp -AutoSize

#Thit example creates an adaptive card with a segmented gauge display for CPU, Memory, and Disk usage.
#Each gauge is configured with a categorical color set and includes a legend for clarity.

New-AdaptiveCard {
    New-CardContainer {
        New-CardTextBlock -Text "Complex Gauge Example" -Weight "Bolder" -Size "Medium" -Spacing "Large"
        New-CardChartGauge -Title "CPU Usage" -Value 75 -Min 0 -Max 100 -ColorSet categorical -ShowLegend $true -Segments {
            New-CardGaugeChartLegend -color "Good" -Value 0 -label "0-50%"
            New-CardGaugeChartLegend -color "Warning" -Value 50 -label "51-80%"
            New-CardGaugeChartLegend -color "Attention" -Value 80 -label "81-100%"
        }
        New-CardChartGauge -Title "Memory Usage" -Value 60 -Min 0 -Max 100 -ColorSet categorical -ShowLegend $true
        New-CardChartGauge -Title "Disk Usage" -Value 85 -Min 0 -Max 100 -ColorSet categorical -ShowLegend $true
    }
} | Get-CardResponse -ViewMethod EdgeApp -AutoSize