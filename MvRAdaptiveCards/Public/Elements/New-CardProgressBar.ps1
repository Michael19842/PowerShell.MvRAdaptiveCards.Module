<#
.SYNOPSIS
    Creates a new ProgressBar element for an Adaptive Card.

.DESCRIPTION
    The New-CardProgressBar function creates a ProgressBar element that displays a progress indicator
    in an Adaptive Card. ProgressBars can show determinate progress (with a specific value) or
    indeterminate progress (when no value is specified). They support color customization and
    configurable maximum values.

.PARAMETER Value
    The current value of the progress bar. Must be between 0 and the Max value.
    If not specified, the progress bar will be in indeterminate mode.

.PARAMETER Max
    The maximum value of the progress bar. Default is 100.
    The progress percentage is calculated as (Value / Max) * 100.

.PARAMETER Color
    The color scheme for the progress bar. Valid values are:
    - Accent: Uses the theme's accent color (default, also used for indeterminate mode)
    - Good: Green color, typically used for success or positive progress
    - Warning: Orange/yellow color, used for warnings or caution states
    - Attention: Red color, used for errors or critical states
    Note: Color has no effect when the ProgressBar is in indeterminate mode (no Value specified).

.PARAMETER Id
    A unique identifier for the ProgressBar element. Useful for referencing the element
    programmatically or for accessibility purposes.

.PARAMETER Height
    Controls the height behavior of the ProgressBar. Valid values are:
    - auto: Height adjusts automatically to content (default)
    - stretch: ProgressBar stretches to fill available vertical space

.PARAMETER HorizontalAlignment
    Controls the horizontal alignment of the progress bar within its container. Valid values are:
    - Left: Aligns progress bar to the left side
    - Center: Centers progress bar horizontally
    - Right: Aligns progress bar to the right side

.PARAMETER GridArea
    Specifies the named grid area where the ProgressBar should be placed when used in a grid layout.
    This corresponds to the CSS grid-area property.

.PARAMETER Spacing
    Controls the amount of spacing above the progress bar. Valid values are:
    - None: No spacing
    - ExtraSmall: Extra small spacing
    - Small: Small spacing
    - Default: Default spacing
    - Medium: Medium spacing
    - Large: Large spacing
    - ExtraLarge: Extra large spacing
    - Padding: Padding spacing

.PARAMETER TargetWidth
    Specifies the target width for the progress bar in adaptive layouts. Valid values include:
    - VeryNarrow, Narrow, Standard, Wide
    - atLeast:VeryNarrow, atMost:VeryNarrow
    - atLeast:Narrow, atMost:Narrow
    - atLeast:Standard, atMost:Standard
    - atLeast:Wide, atMost:Wide

.PARAMETER Lang
    Specifies the language/locale for the ProgressBar element. Used for proper rendering
    and accessibility features.

.PARAMETER Requires
    A hashtable specifying feature requirements for the ProgressBar. Used to declare dependencies
    on specific Adaptive Card features or host capabilities.

.PARAMETER Fallback
    A scriptblock that defines fallback content to display if the ProgressBar cannot be rendered
    or is not supported by the host. Should return an appropriate Adaptive Card element.

.PARAMETER Separator
    When specified, displays a separator line above the ProgressBar to visually separate it
    from the previous element. No separator will be displayed for the first element in a container.

.PARAMETER IsHidden
    When specified, sets the progress bar to be hidden (isVisible = false).
    Alias: Hide

.PARAMETER IsSortKey
    When specified, marks this element as a sort key for collections that allow sorting.

.EXAMPLE
    New-CardProgressBar -Value 75

    Creates a progress bar at 75% completion (75 out of 100).

.EXAMPLE
    New-CardProgressBar -Value 30 -Max 50 -Color Good

    Creates a green progress bar at 60% completion (30 out of 50).

.EXAMPLE
    New-CardProgressBar -Color Warning

    Creates an indeterminate progress bar in warning color (no specific value).

.EXAMPLE
    New-AdaptiveCard -Body {
        New-CardTextBlock -Text "Download Progress" -Weight Bolder
        New-CardProgressBar -Value 45 -Max 100 -Color Accent -Id "downloadProgress"
        New-CardTextBlock -Text "45% Complete" -Size Small -Color Good
    }

    Creates a card with a labeled progress bar showing download progress.

.NOTES
    - When Value is not specified, the progress bar operates in indeterminate mode
    - In indeterminate mode, the Color parameter has no effect (always uses accent color)
    - Value must be between 0 and Max
    - Progress bars are useful for showing task completion, loading states, or status indicators

.LINK
    New-AdaptiveCard
    New-CardTextBlock
#>
function New-CardProgressBar {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateRange(0, [double]::MaxValue)]
        [double]$Value,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [double]::MaxValue)]
        [double]$Max,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Accent", "Good", "Warning", "Attention")]
        [string]$Color,

        [Parameter(Mandatory = $false)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [ValidateSet("auto", "stretch")]
        [string]$Height,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Left", "Center", "Right")]
        [string]$HorizontalAlignment,

        [Parameter(Mandatory = $false)]
        [string]$GridArea,

        [Parameter(Mandatory = $false)]
        [ValidateSet("None", "ExtraSmall", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")]
        [string]$Spacing,

        [Parameter(Mandatory = $false)]
        [ValidateSet("VeryNarrow", "Narrow", "Standard", "Wide",
            "atLeast:VeryNarrow", "atMost:VeryNarrow",
            "atLeast:Narrow", "atMost:Narrow",
            "atLeast:Standard", "atMost:Standard",
            "atLeast:Wide", "atMost:Wide")]
        [string]$TargetWidth,

        [Parameter(Mandatory = $false)]
        [string]$Lang,

        [Parameter(Mandatory = $false)]
        [hashtable]$Requires,

        [Parameter(Mandatory = $false)]
        [scriptblock]$Fallback,

        [Alias("Hide")]
        [switch]$IsHidden,

        [switch]$IsSortKey,

        [switch]$Separator
    )

    # Create base ProgressBar object
    $ProgressBar = @{
        type = "ProgressBar"
    }

    # Add optional parameters only if specified
    if ($PSBoundParameters.ContainsKey('Value')) {
        $ProgressBar.value = $Value

        # Validate Value is not greater than Max if Max is specified
        if ($PSBoundParameters.ContainsKey('Max') -and $Value -gt $Max) {
            Write-Warning "Value ($Value) is greater than Max ($Max). Progress bar will show as complete."
        }
    }

    if ($PSBoundParameters.ContainsKey('Max')) {
        $ProgressBar.max = $Max
    }

    if ($PSBoundParameters.ContainsKey('Color')) {
        $ProgressBar.color = $Color
    }

    if ($PSBoundParameters.ContainsKey('Id')) {
        $ProgressBar.id = $Id
    }

    if ($PSBoundParameters.ContainsKey('Height')) {
        $ProgressBar.height = $Height
    }

    if ($PSBoundParameters.ContainsKey('HorizontalAlignment')) {
        $ProgressBar.horizontalAlignment = $HorizontalAlignment
    }

    if ($PSBoundParameters.ContainsKey('GridArea')) {
        $ProgressBar."grid.area" = $GridArea
    }

    if ($PSBoundParameters.ContainsKey('Spacing')) {
        $ProgressBar.spacing = $Spacing
    }

    if ($PSBoundParameters.ContainsKey('TargetWidth')) {
        $ProgressBar.targetWidth = $TargetWidth
    }

    if ($PSBoundParameters.ContainsKey('Lang')) {
        $ProgressBar.lang = $Lang
    }

    if ($PSBoundParameters.ContainsKey('Requires')) {
        $ProgressBar.requires = $Requires
    }

    if ($PSBoundParameters.ContainsKey('Fallback')) {
        $ProgressBar.fallback = Invoke-Command -ScriptBlock $Fallback
    }

    if ($IsHidden) {
        $ProgressBar.isVisible = $false
    }

    if ($IsSortKey) {
        $ProgressBar.isSortKey = $true
    }

    if ($Separator) {
        $ProgressBar.separator = $true
    }

    # Create description for ShouldProcess
    $description = "Creating ProgressBar element"
    if ($PSBoundParameters.ContainsKey('Value')) {
        $maxValue = if ($PSBoundParameters.ContainsKey('Max')) { $Max } else { 100 }
        $percentage = [math]::Round(($Value / $maxValue) * 100, 1)
        $description += " at $percentage% ($Value/$maxValue)"
    }
    else {
        $description += " in indeterminate mode"
    }

    if ($PSCmdlet.ShouldProcess($description)) {
        return $ProgressBar
    }
}