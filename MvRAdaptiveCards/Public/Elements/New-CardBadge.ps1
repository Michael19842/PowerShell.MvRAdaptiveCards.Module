function New-CardBadge {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Text,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Filled", "Tint")]
        [string]$Appearance,

        [Parameter(Mandatory = $false)]
        [ValidateScript( {
                if ( $_AdaptiveCardIconCollection -contains $_ ) {
                    return $true
                }
                else {
                    throw "Invalid icon name '$_'. Valid names are: $($_AdaptiveCardIconCollection -join ', ')"
                }
            } )]
        [string]$Icon,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Before", "After")]
        [string]$IconPosition,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Square", "Rounded", "Circular")]
        [string]$Shape,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Medium", "Large", "ExtraLarge")]
        [string]$Size,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Default", "Subtle", "Informative", "Accent", "Good", "Attention", "Warning")]
        [string]$Style,

        [Parameter(Mandatory = $false)]
        [string]$Tooltip,

        [Parameter(Mandatory = $false)]
        [hashtable]$Requires,

        [Parameter(Mandatory = $false)]
        [scriptblock]$Fallback,

        [Parameter(Mandatory = $false)]
        [string]$GridArea,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Auto", "Stretch")]
        [string]$Height = "auto",

        [Parameter(Mandatory = $false)]
        [ValidateSet("Left", "Center", "Right")]
        [string]$HorizontalAlignment,

        [Parameter(Mandatory = $false)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [switch]$IsSortKey,

        [Alias("Hide")]
        [Parameter(Mandatory = $false)]
        [switch]$IsHidden,

        [Parameter(Mandatory = $false)]
        [ValidateSet("None", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")]
        [string]$Spacing,

        [Parameter(Mandatory = $false)]
        [ValidateSet("VeryNarrow", "Narrow", "Standard", "Wide", "atLeast:VeryNarrow", "atMost:VeryNarrow", "atLeast:Narrow", "atMost:Narrow", "atLeast:Standard", "atMost:Standard", "atLeast:Wide", "atMost:Wide")]
        [string]$TargetWidth
    )

    $Badge = @{
        type = "Badge"
        text = $Text
    }

    if ($Appearance) {
        $Badge.appearance = $Appearance.ToLower()
    }
    if ($Icon) {
        $Badge.icon = $Icon
    }
    if ($IconPosition) {
        $Badge.iconPosition = $IconPosition
    }
    if ($Shape) {
        $Badge.shape = $Shape
    }
    if ($Size) {
        $Badge.size = $Size
    }
    if ($Style) {
        $Badge.style = $Style.ToLower()
    }
    if ($Tooltip) {
        $Badge.tooltip = $Tooltip
    }
    if ($Requires) {
        $Badge.requires = $Requires
    }
    if ($Fallback) {
        $Badge.fallback = Invoke-Command -ScriptBlock $Fallback
    }
    if ($GridArea) {
        $Badge."grid.area" = $GridArea
    }
    if ($Height) {
        $Badge.height = $Height
    }
    if ($HorizontalAlignment) {
        $Badge.horizontalAlignment = $HorizontalAlignment
    }
    if ($Id) {
        $Badge.id = $Id
    }
    if ($IsSortKey) {
        $Badge.isSortKey = $true
    }
    if ($IsHidden) {
        $Badge.isVisible = $false
    }
    if ($Spacing) {
        $Badge.spacing = $Spacing
    }
    if ($TargetWidth) {
        $Badge.targetWidth = $TargetWidth
    }

    if ($PSCmdlet.ShouldProcess("Create Badge with text '$Text'")) {
        return $Badge
    }


}