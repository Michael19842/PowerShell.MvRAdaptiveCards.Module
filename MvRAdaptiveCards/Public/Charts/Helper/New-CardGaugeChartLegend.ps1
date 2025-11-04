function New-CardGaugeChartLegend {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet(
            "good",
            "warning",
            "attention",
            "neutral",
            "categoricalRed",
            "categoricalPurple",
            "categoricalLavender",
            "categoricalBlue",
            "categoricalLightBlue",
            "categoricalTeal",
            "categoricalGreen",
            "categoricalLime",
            "categoricalMarigold",
            "sequential1",
            "sequential2",
            "sequential3",
            "sequential4",
            "sequential5",
            "sequential6",
            "sequential7",
            "sequential8",
            "divergingBlue",
            "divergingLightBlue",
            "divergingCyan",
            "divergingTeal",
            "divergingYellow",
            "divergingPeach",
            "divergingLightRed",
            "divergingRed",
            "divergingMaroon",
            "divergingGray"
        )]
        [string]$color,


        [Parameter(Mandatory = $true)]
        [string]$legend,

        [Parameter(Mandatory = $false)]
        [int]$size = 0
    )

    $LegendEntry = @{
        color  = $color
        legend = $legend
    }
    if ($PSBoundParameters.ContainsKey('size')) {
        $LegendEntry.size = $size
    }
    if ($PSCmdlet.ShouldProcess("Creating Gauge Chart Legend Entry")) {
        return $LegendEntry
    }

}



<#color
string
The color to use for the segment. See Chart colors reference.

Valid values:
"good",
"warning",
"attention",
"neutral",
"categoricalRed",
"categoricalPurple",
"categoricalLavender",
"categoricalBlue",
"categoricalLightBlue",
"categoricalTeal",
"categoricalGreen",
"categoricalLime",
"categoricalMarigold",
"sequential1",
"sequential2",
"sequential3",
"sequential4",
"sequential5",
"sequential6",
"sequential7",
"sequential8",
"divergingBlue",
"divergingLightBlue",
"divergingCyan",
"divergingTeal",
"divergingYellow",
"divergingPeach",
"divergingLightRed",
"divergingRed",
"divergingMaroon",
"divergingGray"
1.5
legend
string
The legend text associated with the segment.

1.5
size
number
0
The size of the segment.#>