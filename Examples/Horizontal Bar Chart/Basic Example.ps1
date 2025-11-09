#Requires -Module MvRAdaptiveCards
#Create a horizontal bar chart element demonstrating basic usage of the New-CardChartHorizontalBar function.


New-AdaptiveCard {
    New-CardChartHorizontalBar -Id "chart1" `
        -Title "Sales by Region" `
        -Data @(
        @{ label = "North"; value = 150; color = "good" }
        @{ label = "South"; value = 100; color = "warning" }
        @{ label = "East"; value = 200; color = "attention" }
        @{ label = "West"; value = 175; color = "neutral" }
    ) `
        -XAxisTitle "Sales (in thousands)" `
        -YAxisTitle "Regions" `
        -DisplayMode "AbsoluteWithAxis" `
        -ColorSet "categorical"
} | Get-CardResponse -ViewMethod EdgeApp -AutoSize


8