<#
.SYNOPSIS
    Creates an Input.Date element for date selection in an Adaptive Card.

.DESCRIPTION
    The New-CardInputDate function creates an Input.Date element that allows users to select a date.
    Supports date range constraints (min/max), default values, validation, and labels.

.PARAMETER Id
    Unique identifier for the input element. Used to retrieve the input value when the card is submitted.

.PARAMETER Label
    Label text displayed above the date picker. Describes the purpose of the input.

.PARAMETER Value
    Initial/default date value in YYYY-MM-DD format (e.g., "2025-11-02").

.PARAMETER Min
    Minimum selectable date in YYYY-MM-DD format. Users cannot select dates before this.

.PARAMETER Max
    Maximum selectable date in YYYY-MM-DD format. Users cannot select dates after this.

.PARAMETER Placeholder
    Placeholder text displayed when no date is selected. Provides hints about expected date format.

.PARAMETER IsRequired
    Marks the date input as required. The card cannot be submitted without selecting a date.

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
    Returns a hashtable representing the Input.Date element with all configured properties.

.EXAMPLE
    New-CardInputDate -Id "birthDate" -Label "Date of Birth" -IsRequired $true

    Creates a required date picker for birth date.

.EXAMPLE
    New-CardInputDate -Id "startDate" -Label "Start Date" -Min "2025-01-01" -Max "2025-12-31"

    Creates a date picker limited to the year 2025.

.EXAMPLE
    New-CardInputDate -Id "appointmentDate" -Value "2025-11-15" -Placeholder "Select appointment date"

    Creates a date picker with a default value and placeholder text.

.EXAMPLE
    New-CardInputDate -Id "deadline" -Label "Deadline" -Min (Get-Date -Format "yyyy-MM-dd") -IsRequired $true

    Creates a required date picker with today as the minimum selectable date.

.EXAMPLE
    New-CardInputDate -Id "eventDate" -Label "Event Date" -Spacing "Large" -Separator

    Creates a date picker with extra spacing and a separator line above it.

.NOTES
    - The Id parameter is essential for retrieving submitted values
    - Date values must be in YYYY-MM-DD format (ISO 8601)
    - Min and Max constraints are enforced by the date picker UI
    - IsRequired prevents card submission until a date is selected
    - Not all hosts support all features (check host capabilities)

.LINK
    New-AdaptiveCard

.LINK
    New-CardInputText

.LINK
    New-CardInputTime
#>
function New-CardInputDate {
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

    $InputDate = @{
        type = "Input.Date"
    }

    if ($PSBoundParameters.ContainsKey('Id')) {
        $InputDate.id = $Id
    }
    if ($PSBoundParameters.ContainsKey('Label')) {
        $InputDate.label = $Label
    }
    if ($PSBoundParameters.ContainsKey('Value')) {
        $InputDate.value = $Value
    }
    if ($PSBoundParameters.ContainsKey('Min')) {
        $InputDate.min = $Min
    }
    if ($PSBoundParameters.ContainsKey('Max')) {
        $InputDate.max = $Max
    }
    if ($PSBoundParameters.ContainsKey('Placeholder')) {
        $InputDate.placeholder = $Placeholder
    }
    if ($PSBoundParameters.ContainsKey('IsRequired')) {
        $InputDate.isRequired = $IsRequired
    }
    if ($PSBoundParameters.ContainsKey('ErrorMessage')) {
        $InputDate.errorMessage = $ErrorMessage
    }
    if ($PSBoundParameters.ContainsKey('Height')) {
        $InputDate.height = $Height
    }
    if ($Separator) {
        $InputDate.separator = $true
    }
    if ($PSBoundParameters.ContainsKey('Spacing')) {
        $InputDate.spacing = $Spacing
    }
    if ($PSBoundParameters.ContainsKey('IsVisible')) {
        $InputDate.isVisible = $IsVisible
    }
    if ($PSBoundParameters.ContainsKey('Requires')) {
        $InputDate.requires = $Requires
    }
    if ($PSBoundParameters.ContainsKey('Fallback')) {
        $InputDate.fallback = $Fallback
    }
    if ($PSBoundParameters.ContainsKey('TargetWidth')) {
        $InputDate.targetWidth = $TargetWidth
    }
    if ($PSBoundParameters.ContainsKey('GridArea')) {
        $InputDate.'grid.area' = $GridArea
    }
    if ($PSBoundParameters.ContainsKey('Lang')) {
        $InputDate.lang = $Lang
    }
    if ($PSBoundParameters.ContainsKey('IsSortKey')) {
        $InputDate.isSortKey = $IsSortKey
    }

    #Return the Input.Date object
    if ($PSCmdlet.ShouldProcess("Creating Input.Date with Id '$Id'")) {
        return $InputDate
    }
}

<#
Input.Date schema reference - to allow the user to select a date.

Schema
Name
Type
Default
Description
In version
type
string
Must be Input.Date.

1.0
errorMessage
string
The error message to display when the input fails validation. See Input validation for more details.

1.3
fallback
One of
object
string
An alternate element to render if the type of this one is unsupported or if the host application doesn't support all the capabilities specified in the requires property.

Valid values:
Container,
ActionSet,
ColumnSet,
Media,
RichTextBlock,
Table,
TextBlock,
FactSet,
ImageSet,
Image,
Input.Text,
Input.Date,
Input.Time,
Input.Number,
Input.Toggle,
Input.ChoiceSet,
Input.Rating,
Rating,
CompoundButton,
Icon,
Carousel,
Badge,
ProgressRing,
ProgressBar,
Chart.Donut,
Chart.Pie,
Chart.VerticalBar.Grouped,
Chart.VerticalBar,
Chart.HorizontalBar,
Chart.HorizontalBar.Stacked,
Chart.Line,
Chart.Gauge,
CodeBlock,
Component.graph.microsoft.com/user,
Component.graph.microsoft.com/users,
Component.graph.microsoft.com/resource,
Component.graph.microsoft.com/file,
Component.graph.microsoft.com/event,
"drop"
1.2
grid.area
string
Teams
The area of a Layout.AreaGrid layout in which an element should be displayed.

1.5
height
string
"auto"
The height of the element. When set to stretch, the element will use the remaining vertical space in its container.

Valid values:
"auto",
"stretch"
1.1
id
string
A unique identifier for the element or action. Input elements must have an id, otherwise they will not be validated and their values will not be sent to the Bot.

1.0
isRequired
boolean
false
Controls whether the input is required. See Input validation for more details.

1.3
isSortKey
boolean
false
Controls whether the element should be used as a sort key by elements that allow sorting across a collection of elements.

1.5
isVisible
boolean
true
Controls the visibility of the element.

1.2
label
string
The label of the input.

A label should always be provided to ensure the best user experience especially for users of assistive technology.

1.3
lang
string
The locale associated with the element.

1.1
max
string
The maximum date that can be selected.

1.0
min
string
The minimum date that can be selected.

1.0
placeholder
string
The text to display as a placeholder when the user has not selected a date.

1.0
requires
object
{}
A list of capabilities the element requires the host application to support. If the host application doesn't support at least one of the listed capabilities, the element is not rendered (or its fallback is rendered if provided).

Valid values:
HostCapabilities
1.2
separator
boolean
false
Controls whether a separator line should be displayed above the element to visually separate it from the previous element. No separator will be displayed for the first element in a container, even if this property is set to true.

1.0
spacing
string
"Default"
Controls the amount of space between this element and the previous one. No space will be added for the first element in a container.

Valid values:
"None",
"ExtraSmall"
Preview
,
"Small",
"Default",
"Medium",
"Large",
"ExtraLarge",
"Padding"
1.0
targetWidth
string
TeamsCopilot
Controls for which card width the element should be displayed. If targetWidth isn't specified, the element is rendered at all card widths. Using targetWidth makes it possible to author responsive cards that adapt their layout to the available horizontal space. For more details, see Responsive layout.

Valid values:
"VeryNarrow",
"Narrow",
"Standard",
"Wide",
"atLeast:VeryNarrow",
"atMost:VeryNarrow",
"atLeast:Narrow",
"atMost:Narrow",
"atLeast:Standard",
"atMost:Standard",
"atLeast:Wide",
"atMost:Wide"
1.0
value
string
The default value of the input, in the YYYY-MM-DD format.

1.0
valueChangedAction
object
Teams
An Action.ResetInputs action that will be executed when the value of the input changes.

Valid values:
Action.OpenUrlDialog,
Action.Popover,
Action.ResetInputs
1.5#>