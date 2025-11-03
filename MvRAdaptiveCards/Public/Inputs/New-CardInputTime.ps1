<#
.SYNOPSIS
    Creates an Input.Time element for time selection in an Adaptive Card.

.DESCRIPTION
    The New-CardInputTime function creates an Input.Time element that allows users to select a time.
    Supports time range constraints (min/max), default values, validation, and labels.

.PARAMETER Id
    Unique identifier for the input element. Used to retrieve the input value when the card is submitted.

.PARAMETER Label
    Label text displayed above the time picker. Describes the purpose of the input.

.PARAMETER Value
    Initial/default time value in HH:MM format (e.g., "14:30" for 2:30 PM).

.PARAMETER Min
    Minimum selectable time in HH:MM format. Users cannot select times before this.

.PARAMETER Max
    Maximum selectable time in HH:MM format. Users cannot select times after this.

.PARAMETER Placeholder
    Placeholder text displayed when no time is selected. Provides hints about expected time format.

.PARAMETER IsRequired
    Marks the time input as required. The card cannot be submitted without selecting a time.

.PARAMETER ErrorMessage
    Custom error message displayed when the input fails validation.

.PARAMETER Height
    Controls the height of the element. Valid values: "auto", "stretch".

.PARAMETER Separator
    Displays a separator line above the element to visually separate it from the previous element.

.PARAMETER Spacing
    Controls the amount of space between this element and the previous one.
    Valid values: "None", "ExtraSmall", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding".

.PARAMETER IsVisible
    Controls the visibility of the element. Default is $true.

.PARAMETER Requires
    Hashtable of capabilities the element requires the host to support.

.PARAMETER Fallback
    Alternate element or "drop" to render if this element type is unsupported.

.PARAMETER TargetWidth
    Controls for which card width the element should be displayed. Enables responsive layouts.
    Valid values: "VeryNarrow", "Narrow", "Standard", "Wide", or atLeast/atMost variants.

.PARAMETER GridArea
    The area of a Layout.AreaGrid layout in which the element should be displayed.

.PARAMETER Lang
    The locale associated with the element.

.PARAMETER IsSortKey
    Controls whether the element should be used as a sort key by elements that allow sorting.

.OUTPUTS
    [hashtable]
    Returns a hashtable representing the Input.Time element with all configured properties.

.EXAMPLE
    New-CardInputTime -Id "meetingTime" -Label "Meeting Time" -IsRequired $true

    Creates a required time picker for meeting time.

.EXAMPLE
    New-CardInputTime -Id "startTime" -Label "Start Time" -Min "09:00" -Max "17:00"

    Creates a time picker limited to business hours (9 AM to 5 PM).

.EXAMPLE
    New-CardInputTime -Id "appointmentTime" -Value "14:30" -Placeholder "Select appointment time"

    Creates a time picker with a default value of 2:30 PM and placeholder text.

.EXAMPLE
    New-CardInputTime -Id "reminderTime" -Label "Reminder Time" -Value "08:00" -IsRequired $true

    Creates a required time picker with 8:00 AM as the default value.

.EXAMPLE
    New-CardInputTime -Id "eventTime" -Label "Event Time" -Spacing "Large" -Separator

    Creates a time picker with extra spacing and a separator line above it.

.NOTES
    - The Id parameter is essential for retrieving submitted values
    - Time values must be in HH:MM format (24-hour format)
    - Min and Max constraints are enforced by the time picker UI
    - IsRequired prevents card submission until a time is selected
    - Not all hosts support all features (check host capabilities)

.LINK
    New-AdaptiveCard

.LINK
    New-CardInputDate

.LINK
    New-CardInputText
#>
function New-CardInputTime {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $false)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [string]$Label,

        [Parameter(Mandatory = $false)]
        [string]$Value,

        [Parameter(Mandatory = $false)]
        [string]$Min,

        [Parameter(Mandatory = $false)]
        [string]$Max,

        [Parameter(Mandatory = $false)]
        [string]$Placeholder,

        [Parameter(Mandatory = $false)]
        [bool]$IsRequired,

        [Parameter(Mandatory = $false)]
        [string]$ErrorMessage,

        [Parameter(Mandatory = $false)]
        [ValidateSet("auto", "stretch")]
        [string]$Height,

        [Parameter(Mandatory = $false)]
        [switch]$Separator,

        [Parameter(Mandatory = $false)]
        [ValidateSet("None", "ExtraSmall", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")]
        [string]$Spacing,

        [Parameter(Mandatory = $false)]
        [bool]$IsVisible,

        [Parameter(Mandatory = $false)]
        [hashtable]$Requires,

        [Parameter(Mandatory = $false)]
        [object]$Fallback,

        [Parameter(Mandatory = $false)]
        [ValidateSet("VeryNarrow", "Narrow", "Standard", "Wide", "atLeast:VeryNarrow", "atMost:VeryNarrow",
            "atLeast:Narrow", "atMost:Narrow", "atLeast:Standard", "atMost:Standard",
            "atLeast:Wide", "atMost:Wide")]
        [string]$TargetWidth,

        [Parameter(Mandatory = $false)]
        [string]$GridArea,

        [Parameter(Mandatory = $false)]
        [string]$Lang,

        [Parameter(Mandatory = $false)]
        [bool]$IsSortKey
    )

    $InputTime = @{
        type = "Input.Time"
    }

    if ($PSBoundParameters.ContainsKey('Id')) {
        $InputTime.id = $Id
    }
    if ($PSBoundParameters.ContainsKey('Label')) {
        $InputTime.label = $Label
    }
    if ($PSBoundParameters.ContainsKey('Value')) {
        $InputTime.value = $Value
    }
    if ($PSBoundParameters.ContainsKey('Min')) {
        $InputTime.min = $Min
    }
    if ($PSBoundParameters.ContainsKey('Max')) {
        $InputTime.max = $Max
    }
    if ($PSBoundParameters.ContainsKey('Placeholder')) {
        $InputTime.placeholder = $Placeholder
    }
    if ($PSBoundParameters.ContainsKey('IsRequired')) {
        $InputTime.isRequired = $IsRequired
    }
    if ($PSBoundParameters.ContainsKey('ErrorMessage')) {
        $InputTime.errorMessage = $ErrorMessage
    }
    if ($PSBoundParameters.ContainsKey('Height')) {
        $InputTime.height = $Height
    }
    if ($Separator) {
        $InputTime.separator = $true
    }
    if ($PSBoundParameters.ContainsKey('Spacing')) {
        $InputTime.spacing = $Spacing
    }
    if ($PSBoundParameters.ContainsKey('IsVisible')) {
        $InputTime.isVisible = $IsVisible
    }
    if ($PSBoundParameters.ContainsKey('Requires')) {
        $InputTime.requires = $Requires
    }
    if ($PSBoundParameters.ContainsKey('Fallback')) {
        $InputTime.fallback = $Fallback
    }
    if ($PSBoundParameters.ContainsKey('TargetWidth')) {
        $InputTime.targetWidth = $TargetWidth
    }
    if ($PSBoundParameters.ContainsKey('GridArea')) {
        $InputTime.'grid.area' = $GridArea
    }
    if ($PSBoundParameters.ContainsKey('Lang')) {
        $InputTime.lang = $Lang
    }
    if ($PSBoundParameters.ContainsKey('IsSortKey')) {
        $InputTime.isSortKey = $IsSortKey
    }

    #Return the Input.Time object
    if ($PSCmdlet.ShouldProcess("Creating Input.Time with Id '$Id'")) {
        return $InputTime
    }
}