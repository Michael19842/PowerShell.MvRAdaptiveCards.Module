<#
    .SYNOPSIS
    Creates an Input.Toggle element for Adaptive Cards.

    .DESCRIPTION
    Creates a toggle input (checkbox) element that allows users to select between two values (typically true/false or on/off).

    .PARAMETER Id
    A unique identifier for the input element. Required for the input to be validated and submitted.

    .PARAMETER Title
    The title (caption) to display next to the toggle.

    .PARAMETER Value
    The default value of the input. Defaults to "false".

    .PARAMETER ValueOn
    The value to send when the toggle is on. Defaults to "true".

    .PARAMETER ValueOff
    The value to send when the toggle is off. Defaults to "false".

    .PARAMETER Label
    The label of the input. A label should always be provided to ensure the best user experience especially for users of assistive technology.

    .PARAMETER IsRequired
    Controls whether the input is required.

    .PARAMETER ErrorMessage
    The error message to display when the input fails validation.

    .PARAMETER Wrap
    Controls if the title should wrap. Defaults to true.

    .PARAMETER IsVisible
    Controls the visibility of the element. Defaults to true.

    .PARAMETER Separator
    Controls whether a separator line should be displayed above the element.

    .PARAMETER Spacing
    Controls the amount of space between this element and the previous one.
    Valid values: None, ExtraSmall, Small, Default, Medium, Large, ExtraLarge, Padding

    .PARAMETER Height
    The height of the element. Valid values: auto, stretch

    .PARAMETER TargetWidth
    Controls for which card width the element should be displayed.
    Valid values: VeryNarrow, Narrow, Standard, Wide, atLeast:VeryNarrow, atMost:VeryNarrow, etc.

    .PARAMETER GridArea
    The area of a Layout.AreaGrid layout in which the element should be displayed.

    .PARAMETER IsSortKey
    Controls whether the element should be used as a sort key.

    .PARAMETER Lang
    The locale associated with the element.

    .PARAMETER Fallback
    An alternate element to render if this type is unsupported.

    .PARAMETER Requires
    A hashtable of capabilities the element requires the host application to support.

    .PARAMETER ValueChangedAction
    An action that will be executed when the value of the input changes.

    .EXAMPLE
    New-CardInputToggle -Id "acceptTerms" -Title "I accept the terms and conditions" -IsRequired

    .EXAMPLE
    New-CardInputToggle -Id "notifications" -Title "Enable notifications" -Value "true" -Label "Notification Settings"

    .EXAMPLE
    New-CardInputToggle -Id "darkMode" -Title "Dark Mode" -ValueOn "dark" -ValueOff "light" -Value "light"
    #>

function New-CardInputToggle {

    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        [string]$Value = "false",

        [Parameter(Mandatory = $false)]
        [string]$ValueOn = "true",

        [Parameter(Mandatory = $false)]
        [string]$ValueOff = "false",

        [Parameter(Mandatory = $false)]
        [string]$Label,

        [Parameter(Mandatory = $false)]
        [switch]$IsRequired,

        [Parameter(Mandatory = $false)]
        [string]$ErrorMessage,

        [Parameter(Mandatory = $false)]
        [bool]$Wrap = $true,

        [Parameter(Mandatory = $false)]
        [bool]$IsVisible = $true,

        [Parameter(Mandatory = $false)]
        [switch]$Separator,

        [Parameter(Mandatory = $false)]
        [ValidateSet('None', 'ExtraSmall', 'Small', 'Default', 'Medium', 'Large', 'ExtraLarge', 'Padding')]
        [string]$Spacing = 'Default',

        [Parameter(Mandatory = $false)]
        [ValidateSet('auto', 'stretch')]
        [string]$Height,

        [Parameter(Mandatory = $false)]
        [ValidateSet('VeryNarrow', 'Narrow', 'Standard', 'Wide',
            'atLeast:VeryNarrow', 'atMost:VeryNarrow',
            'atLeast:Narrow', 'atMost:Narrow',
            'atLeast:Standard', 'atMost:Standard',
            'atLeast:Wide', 'atMost:Wide')]
        [string]$TargetWidth,

        [Parameter(Mandatory = $false)]
        [string]$GridArea,

        [Parameter(Mandatory = $false)]
        [switch]$IsSortKey,

        [Parameter(Mandatory = $false)]
        [string]$Lang,

        [Parameter(Mandatory = $false)]
        [object]$Fallback,

        [Parameter(Mandatory = $false)]
        [hashtable]$Requires,

        [Parameter(Mandatory = $false)]
        [object]$ValueChangedAction
    )

    $InputToggle = @{
        type = "Input.Toggle"
        id   = $Id
    }

    if ($PSBoundParameters.ContainsKey('Title')) {
        $InputToggle.title = $Title
    }

    if ($PSBoundParameters.ContainsKey('Value')) {
        $InputToggle.value = $Value
    }

    if ($PSBoundParameters.ContainsKey('ValueOn')) {
        $InputToggle.valueOn = $ValueOn
    }

    if ($PSBoundParameters.ContainsKey('ValueOff')) {
        $InputToggle.valueOff = $ValueOff
    }

    if ($PSBoundParameters.ContainsKey('Label')) {
        $InputToggle.label = $Label
    }

    if ($IsRequired) {
        $InputToggle.isRequired = $true
    }

    if ($PSBoundParameters.ContainsKey('ErrorMessage')) {
        $InputToggle.errorMessage = $ErrorMessage
    }

    if ($PSBoundParameters.ContainsKey('Wrap')) {
        $InputToggle.wrap = $Wrap
    }

    if ($PSBoundParameters.ContainsKey('IsVisible')) {
        $InputToggle.isVisible = $IsVisible
    }

    if ($Separator) {
        $InputToggle.separator = $true
    }

    if ($PSBoundParameters.ContainsKey('Spacing')) {
        $InputToggle.spacing = $Spacing
    }

    if ($PSBoundParameters.ContainsKey('Height')) {
        $InputToggle.height = $Height
    }

    if ($PSBoundParameters.ContainsKey('TargetWidth')) {
        $InputToggle.targetWidth = $TargetWidth
    }

    if ($PSBoundParameters.ContainsKey('GridArea')) {
        $InputToggle['grid.area'] = $GridArea
    }

    if ($IsSortKey) {
        $InputToggle.isSortKey = $true
    }

    if ($PSBoundParameters.ContainsKey('Lang')) {
        $InputToggle.lang = $Lang
    }

    if ($PSBoundParameters.ContainsKey('Fallback')) {
        $InputToggle.fallback = $Fallback
    }

    if ($PSBoundParameters.ContainsKey('Requires')) {
        $InputToggle.requires = $Requires
    }

    if ($PSBoundParameters.ContainsKey('ValueChangedAction')) {
        $InputToggle.valueChangedAction = $ValueChangedAction
    }

    if ( $PSCmdlet.ShouldProcess("Creating Input.Toggle with ID '$Id'")) {
        return $InputToggle
    }
}


