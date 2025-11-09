<#
.SYNOPSIS
    Creates a new ProgressRing element for an Adaptive Card.

.DESCRIPTION
    The New-CardProgressRing function creates a ProgressRing element that displays a circular
    progress indicator in an Adaptive Card. ProgressRings are typically used to show indeterminate
    progress or loading states with an optional label. They provide a visually distinct alternative
    to progress bars with a circular design that works well in compact spaces.

.PARAMETER Label
    The optional text label to display with the progress ring. This text provides context
    about what is being loaded or processed.

.PARAMETER LabelPosition
    Controls the relative position of the label to the progress ring. Valid values are:
    - Below: Label appears below the progress ring (default)
    - Above: Label appears above the progress ring
    - Before: Label appears to the left of the progress ring
    - After: Label appears to the right of the progress ring

.PARAMETER Size
    Controls the size of the progress ring. Valid values are:
    - Tiny: Very small progress ring
    - Small: Small progress ring
    - Medium: Medium-sized progress ring (default)
    - Large: Large progress ring

.PARAMETER Id
    A unique identifier for the ProgressRing element. Useful for referencing the element
    programmatically or for accessibility purposes.

.PARAMETER Height
    Controls the height behavior of the ProgressRing. Valid values are:
    - auto: Height adjusts automatically to content (default)
    - stretch: ProgressRing stretches to fill available vertical space

.PARAMETER HorizontalAlignment
    Controls the horizontal alignment of the progress ring within its container. Valid values are:
    - Left: Aligns progress ring to the left side
    - Center: Centers progress ring horizontally
    - Right: Aligns progress ring to the right side

.PARAMETER GridArea
    Specifies the named grid area where the ProgressRing should be placed when used in a grid layout.
    This corresponds to the CSS grid-area property.

.PARAMETER Spacing
    Controls the amount of spacing above the progress ring. Valid values are:
    - None: No spacing
    - ExtraSmall: Extra small spacing
    - Small: Small spacing
    - Default: Default spacing
    - Medium: Medium spacing
    - Large: Large spacing
    - ExtraLarge: Extra large spacing
    - Padding: Padding spacing

.PARAMETER TargetWidth
    Specifies the target width for the progress ring in adaptive layouts. Valid values include:
    - VeryNarrow, Narrow, Standard, Wide
    - atLeast:VeryNarrow, atMost:VeryNarrow
    - atLeast:Narrow, atMost:Narrow
    - atLeast:Standard, atMost:Standard
    - atLeast:Wide, atMost:Wide

.PARAMETER Lang
    Specifies the language/locale for the ProgressRing element. Used for proper rendering
    and accessibility features.

.PARAMETER Requires
    A hashtable specifying feature requirements for the ProgressRing. Used to declare dependencies
    on specific Adaptive Card features or host capabilities.

.PARAMETER Fallback
    A scriptblock that defines fallback content to display if the ProgressRing cannot be rendered
    or is not supported by the host. Should return an appropriate Adaptive Card element.

.PARAMETER Separator
    When specified, displays a separator line above the ProgressRing to visually separate it
    from the previous element. No separator will be displayed for the first element in a container.

.PARAMETER IsHidden
    When specified, sets the progress ring to be hidden (isVisible = false).
    Alias: Hide

.PARAMETER IsSortKey
    When specified, marks this element as a sort key for collections that allow sorting.

.EXAMPLE
    New-CardProgressRing

    Creates a simple progress ring with default medium size and no label.

.EXAMPLE
    New-CardProgressRing -Label "Loading..." -Size Large

    Creates a large progress ring with a "Loading..." label below it.

.EXAMPLE
    New-CardProgressRing -Label "Processing" -LabelPosition Above -Size Small

    Creates a small progress ring with the label positioned above it.

.EXAMPLE
    New-AdaptiveCard -Body {
        New-CardTextBlock -Text "System Status" -Weight Bolder
        New-CardProgressRing -Label "Initializing services..." -Size Medium -HorizontalAlignment Center
        New-CardTextBlock -Text "Please wait while we set up your environment." -Size Small -Color Accent
    }

    Creates a card with a centered progress ring showing system initialization status.

.EXAMPLE
    New-CardProgressRing -Label "Syncing data" -Size Tiny -Fallback {
        New-CardTextBlock -Text "⟳ Syncing data..." -Color Accent
    }

    Creates a progress ring with fallback content for hosts that don't support ProgressRing.

.NOTES
    - ProgressRing elements are typically used for indeterminate progress (unknown completion time)
    - Unlike ProgressBar, ProgressRing doesn't show specific completion percentages
    - The circular design makes progress rings suitable for compact layouts
    - Consider the size and label position based on your card's overall design
    - Progress rings are ideal for loading states, background processes, or ongoing operations

.LINK
    New-AdaptiveCard
    New-CardProgressBar
    New-CardTextBlock
#>
function New-CardProgressRing {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $false)]
        [string]$Label,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Before", "After", "Above", "Below")]
        [string]$LabelPosition,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Tiny", "Small", "Medium", "Large")]
        [string]$Size,

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
        [Object]$Fallback,

        [Alias("Hide")]
        [switch]$IsHidden,

        [switch]$IsSortKey,

        [switch]$Separator
    )

    # Create base ProgressRing object
    $ProgressRing = @{
        type = "ProgressRing"
    }
    # Apply default fallback from settings if none provided and default is set
    if ($Null -eq $Fallback -and $_MvRACSettings.General.DefaultFallback) {
        $Fallback = [scriptblock]::Create($_MvRACSettings.General.DefaultFallback)
    }

    # Add optional parameters only if specified
    if ($PSBoundParameters.ContainsKey('Label')) {
        $ProgressRing.label = $Label
    }

    if ($PSBoundParameters.ContainsKey('LabelPosition')) {
        $ProgressRing.labelPosition = $LabelPosition
    }

    if ($PSBoundParameters.ContainsKey('Size')) {
        $ProgressRing.size = $Size
    }

    if ($PSBoundParameters.ContainsKey('Id')) {
        $ProgressRing.id = $Id
    }

    if ($PSBoundParameters.ContainsKey('Height')) {
        $ProgressRing.height = $Height
    }

    if ($PSBoundParameters.ContainsKey('HorizontalAlignment')) {
        $ProgressRing.horizontalAlignment = $HorizontalAlignment
    }

    if ($PSBoundParameters.ContainsKey('GridArea')) {
        $ProgressRing."grid.area" = $GridArea
    }

    if ($PSBoundParameters.ContainsKey('Spacing')) {
        $ProgressRing.spacing = $Spacing
    }

    if ($PSBoundParameters.ContainsKey('TargetWidth')) {
        $ProgressRing.targetWidth = $TargetWidth
    }

    if ($PSBoundParameters.ContainsKey('Lang')) {
        $ProgressRing.lang = $Lang
    }

    if ($PSBoundParameters.ContainsKey('Requires')) {
        $ProgressRing.requires = $Requires
    }

    if ($PSBoundParameters.ContainsKey('Fallback')) {
        if ( $Fallback -is [scriptblock]) {
            $ProgressRing.fallback = Invoke-Command -ScriptBlock $Fallback
        }
        else {
            $ProgressRing.fallback = $Fallback
        }
    }

    if ($IsHidden) {
        $ProgressRing.isVisible = $false
    }

    if ($IsSortKey) {
        $ProgressRing.isSortKey = $true
    }

    if ($Separator) {
        $ProgressRing.separator = $true
    }

    # Create description for ShouldProcess
    $description = "Creating ProgressRing element"
    if ($PSBoundParameters.ContainsKey('Label')) {
        $description += " with label '$Label'"
    }
    if ($PSBoundParameters.ContainsKey('Size')) {
        $description += " (size: $Size)"
    }

    if ($PSCmdlet.ShouldProcess($description)) {
        return $ProgressRing
    }
}