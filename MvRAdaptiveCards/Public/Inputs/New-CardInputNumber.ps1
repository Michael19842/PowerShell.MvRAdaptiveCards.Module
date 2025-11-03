<#
.SYNOPSIS
    Creates an Input.Number element for numeric input in an Adaptive Card.

.DESCRIPTION
    The New-CardInputNumber function creates an Input.Number element that allows users to enter numeric values.
    Supports number range constraints (min/max), default values, validation, and labels.

.PARAMETER Id
    Unique identifier for the input element. Used to retrieve the input value when the card is submitted.

.PARAMETER Label
    Label text displayed above the number input. Describes the purpose of the input.

.PARAMETER Value
    Initial/default numeric value for the input field.

.PARAMETER Min
    Minimum numeric value that can be entered. Users cannot enter numbers below this.

.PARAMETER Max
    Maximum numeric value that can be entered. Users cannot enter numbers above this.

.PARAMETER Placeholder
    Placeholder text displayed when no value is entered. Provides hints about expected numeric format.

.PARAMETER IsRequired
    Marks the number input as required. The card cannot be submitted without entering a value.

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
    Returns a hashtable representing the Input.Number element with all configured properties.

.EXAMPLE
    New-CardInputNumber -Id "age" -Label "Age" -Min 0 -Max 120 -IsRequired $true

    Creates a required number input for age with range constraints.

.EXAMPLE
    New-CardInputNumber -Id "quantity" -Label "Quantity" -Value 1 -Min 1 -Max 100

    Creates a number input for quantity with default value of 1 and range limits.

.EXAMPLE
    New-CardInputNumber -Id "price" -Label "Price" -Placeholder "Enter amount" -Value 0

    Creates a number input for price with placeholder text and default value.

.EXAMPLE
    New-CardInputNumber -Id "rating" -Label "Rating" -Min 1 -Max 5 -IsRequired $true

    Creates a required rating input limited to values between 1 and 5.

.EXAMPLE
    New-CardInputNumber -Id "score" -Label "Score" -Spacing "Large" -Separator

    Creates a number input with extra spacing and a separator line above it.

.NOTES
    - The Id parameter is essential for retrieving submitted values
    - Min and Max constraints are enforced by the input UI
    - IsRequired prevents card submission until a value is entered
    - Not all hosts support all features (check host capabilities)
    - Value, Min, and Max parameters accept numeric types (int, double, etc.)

.LINK
    New-AdaptiveCard

.LINK
    New-CardInputText

.LINK
    New-CardInputDate
#>
function New-CardInputNumber {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $false)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [string]$Label,

        [Parameter(Mandatory = $false)]
        [double]$Value,

        [Parameter(Mandatory = $false)]
        [double]$Min,

        [Parameter(Mandatory = $false)]
        [double]$Max,

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

    $InputNumber = @{
        type = "Input.Number"
    }

    if ($PSBoundParameters.ContainsKey('Id')) {
        $InputNumber.id = $Id
    }
    if ($PSBoundParameters.ContainsKey('Label')) {
        $InputNumber.label = $Label
    }
    if ($PSBoundParameters.ContainsKey('Value')) {
        $InputNumber.value = $Value
    }
    if ($PSBoundParameters.ContainsKey('Min')) {
        $InputNumber.min = $Min
    }
    if ($PSBoundParameters.ContainsKey('Max')) {
        $InputNumber.max = $Max
    }
    if ($PSBoundParameters.ContainsKey('Placeholder')) {
        $InputNumber.placeholder = $Placeholder
    }
    if ($PSBoundParameters.ContainsKey('IsRequired')) {
        $InputNumber.isRequired = $IsRequired
    }
    if ($PSBoundParameters.ContainsKey('ErrorMessage')) {
        $InputNumber.errorMessage = $ErrorMessage
    }
    if ($PSBoundParameters.ContainsKey('Height')) {
        $InputNumber.height = $Height
    }
    if ($Separator) {
        $InputNumber.separator = $true
    }
    if ($PSBoundParameters.ContainsKey('Spacing')) {
        $InputNumber.spacing = $Spacing
    }
    if ($PSBoundParameters.ContainsKey('IsVisible')) {
        $InputNumber.isVisible = $IsVisible
    }
    if ($PSBoundParameters.ContainsKey('Requires')) {
        $InputNumber.requires = $Requires
    }
    if ($PSBoundParameters.ContainsKey('Fallback')) {
        $InputNumber.fallback = $Fallback
    }
    if ($PSBoundParameters.ContainsKey('TargetWidth')) {
        $InputNumber.targetWidth = $TargetWidth
    }
    if ($PSBoundParameters.ContainsKey('GridArea')) {
        $InputNumber.'grid.area' = $GridArea
    }
    if ($PSBoundParameters.ContainsKey('Lang')) {
        $InputNumber.lang = $Lang
    }
    if ($PSBoundParameters.ContainsKey('IsSortKey')) {
        $InputNumber.isSortKey = $IsSortKey
    }

    #Return the Input.Number object
    if ($PSCmdlet.ShouldProcess("Creating Input.Number with Id '$Id'")) {
        return $InputNumber
    }
}