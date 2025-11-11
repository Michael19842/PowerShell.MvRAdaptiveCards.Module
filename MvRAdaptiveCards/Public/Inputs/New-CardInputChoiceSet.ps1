function New-CardInputChoiceSet {
    <#
    .SYNOPSIS
        Creates a new Input.ChoiceSet element for an Adaptive Card.

    .DESCRIPTION
        The New-CardInputChoiceSet function creates an Input.ChoiceSet element that allows users
        to select one or more choices from a predefined list. The choices can be displayed as
        a dropdown (compact), radio buttons/checkboxes (expanded), or a searchable list (filtered).

    .PARAMETER Id
        A unique identifier for the input element. Required for input validation and data submission.

    .PARAMETER Choices
        A hashtable containing the choices where keys are values and values are display titles.
        Can also be an array of hashtables with 'value' and 'title' properties.

    .PARAMETER Value
        The default value(s) for the input. For single selection, use a string.
        For multi-select, use a comma-separated string or array.

    .PARAMETER IsMultiSelect
        When specified, allows multiple choices to be selected. Changes the UI to use checkboxes
        instead of radio buttons in expanded mode.

    .PARAMETER Style
        Controls how the choices are displayed:
        - compact: Dropdown list (default)
        - expanded: Radio buttons (single select) or checkboxes (multi-select)
        - filtered: Searchable dropdown with filtering capability

    .PARAMETER IsRequired
        When specified, marks the input as required for form validation.

    .PARAMETER Label
        The label text to display above the input. Recommended for accessibility.

    .PARAMETER Placeholder
        Placeholder text to show when no selection has been made (compact style only).

    .PARAMETER ErrorMessage
        Custom error message to display when input validation fails.

    .PARAMETER Wrap
        When specified, allows choice titles to wrap to multiple lines if needed.

    .PARAMETER Height
        Controls the height behavior of the input element:
        - auto: Height adjusts to content (default)
        - stretch: Fills available vertical space

    .PARAMETER HorizontalAlignment
        Controls horizontal alignment within the container:
        - Left, Center, Right

    .PARAMETER Spacing
        Controls spacing above the element: None, ExtraSmall, Small, Default, Medium, Large, ExtraLarge, Padding

    .PARAMETER TargetWidth
        Responsive width targeting: VeryNarrow, Narrow, Standard, Wide, or atLeast:/atMost: variants

    .PARAMETER GridArea
        Named grid area for grid layouts.

    .PARAMETER Lang
        Language/locale code for the element.

    .PARAMETER ValueChangedAction
        ScriptBlock that returns an action to execute when the value changes (Teams feature).

    .PARAMETER Requires
        Hashtable of required host capabilities.

    .PARAMETER Fallback
        ScriptBlock that returns fallback content if ChoiceSet is not supported.

    .PARAMETER Separator
        When specified, displays a separator line above the element.

    .PARAMETER IsHidden
        When specified, hides the element (sets isVisible to false).

    .PARAMETER IsSortKey
        When specified, marks this element as a sort key for collection sorting.

    .EXAMPLE
        New-CardInputChoiceSet -Id "color" -Label "Choose a color" -Choices @{
            "red" = "Red"
            "blue" = "Blue"
            "green" = "Green"
        }

    .EXAMPLE
        New-CardInputChoiceSet -Id "options" -Label "Select options" -IsMultiSelect -Style expanded -Choices @{
            "opt1" = "Option 1"
            "opt2" = "Option 2"
            "opt3" = "Option 3"
        } -Value "opt1,opt2"

    .EXAMPLE
        $choices = @(
            @{ value = "small"; title = "Small Size" }
            @{ value = "medium"; title = "Medium Size" }
            @{ value = "large"; title = "Large Size" }
        )
        New-CardInputChoiceSet -Id "size" -Choices $choices -Style filtered -Placeholder "Search sizes..."
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Id,

        [Parameter(Mandatory = $true)]
        [object]$Choices,

        [Parameter(Mandatory = $false)]
        [Object]$ChoicesData,

        [Parameter(Mandatory = $false)]
        [string]$Value,

        [Parameter(Mandatory = $false)]
        [switch]$IsMultiSelect,

        [Parameter(Mandatory = $false)]
        [ValidateSet("compact", "expanded", "filtered")]
        [string]$Style = "compact",

        [Parameter(Mandatory = $false)]
        [switch]$IsRequired,

        [Parameter(Mandatory = $false)]
        [string]$Label,

        [Parameter(Mandatory = $false)]
        [string]$Placeholder,

        [Parameter(Mandatory = $false)]
        [string]$ErrorMessage,

        [Parameter(Mandatory = $false)]
        [switch]$Wrap,

        [Parameter(Mandatory = $false)]
        [ValidateSet("auto", "stretch")]
        [string]$Height,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Left", "Center", "Right")]
        [string]$HorizontalAlignment,

        [Parameter(Mandatory = $false)]
        [ValidateSet("None", "ExtraSmall", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")]
        [string]$Spacing,

        [Parameter(Mandatory = $false)]
        [ValidateSet("VeryNarrow", "Narrow", "Standard", "Wide", "atLeast:VeryNarrow", "atMost:VeryNarrow", "atLeast:Narrow", "atMost:Narrow", "atLeast:Standard", "atMost:Standard", "atLeast:Wide", "atMost:Wide")]
        [string]$TargetWidth,

        [Parameter(Mandatory = $false)]
        [string]$GridArea,

        [Parameter(Mandatory = $false)]
        [string]$Lang,

        [Parameter(Mandatory = $false)]
        [scriptblock]$ValueChangedAction,

        [Parameter(Mandatory = $false)]
        [hashtable]$Requires,

        [Parameter(Mandatory = $false)]
        [scriptblock]$Fallback,

        [Parameter(Mandatory = $false)]
        [switch]$Separator,

        [Alias("Hide")]
        [Parameter(Mandatory = $false)]
        [switch]$IsHidden,

        [Parameter(Mandatory = $false)]
        [switch]$IsSortKey
    )

    # Create base ChoiceSet object
    $InputChoiceSet = @{
        type = "Input.ChoiceSet"
        id   = $Id
    }

    # Process choices - support both hashtable and array formats
    $InputChoiceSet.choices = @()
    if ($Choices) {
        if ($Choices -is [hashtable]) {
            # Hashtable format: @{ "value1" = "Title 1"; "value2" = "Title 2" }
            foreach ($key in $Choices.Keys) {
                $choiceItem = @{
                    value = $key
                    title = $Choices[$key]
                }
                $InputChoiceSet.choices += $choiceItem
            }
        }
        elseif ($Choices -is [array]) {
            # Array format: @( @{value="val1"; title="Title 1"}, @{value="val2"; title="Title 2"} )
            foreach ($choice in $Choices) {
                if ($choice -is [hashtable] -and $choice.ContainsKey('value')) {
                    $choiceItem = @{
                        value = $choice.value
                        title = if ($choice.ContainsKey('title')) { $choice.title } else { $choice.value }
                    }
                    $InputChoiceSet.choices += $choiceItem
                }
                else {
                    Write-Warning "Invalid choice format. Each choice should be a hashtable with 'value' property."
                }
            }
        }
        else {
            Write-Warning "Choices parameter should be either a hashtable or an array of hashtables."
        }
    }

    # Add optional parameters only if specified
    if ($PSBoundParameters.ContainsKey('Value')) {
        # Handle multi-select values (comma-separated string or array)
        if ($IsMultiSelect -and $Value) {
            if ($Value -is [array]) {
                $InputChoiceSet.value = $Value -join ","
            }
            else {
                $InputChoiceSet.value = $Value
            }
        }
        else {
            $InputChoiceSet.value = $Value
        }
    }

    if ($PSBoundParameters.ContainsKey('ChoicesData')) {
        $InputChoiceSet."choices.data" = @{
            data = Invoke-Command -ScriptBlock $ChoicesData
        }

        if (!(Test-CardAllowedElementType -TestedContent $InputChoiceSet."Choices.data" -AllowedElementTypes @("Data.Query"))) {
            throw "Data.Query for Choices requires a Data.Query element type."
        }
    }

    if ($IsMultiSelect) {
        $InputChoiceSet.isMultiSelect = $true
    }

    if ($PSBoundParameters.ContainsKey('Style')) {
        $InputChoiceSet.style = $Style
    }

    if ($IsRequired) {
        $InputChoiceSet.isRequired = $true
    }

    if ($PSBoundParameters.ContainsKey('Label')) {
        $InputChoiceSet.label = $Label
    }

    if ($PSBoundParameters.ContainsKey('Placeholder')) {
        $InputChoiceSet.placeholder = $Placeholder
    }

    if ($PSBoundParameters.ContainsKey('ErrorMessage')) {
        $InputChoiceSet.errorMessage = $ErrorMessage
    }

    if ($Wrap) {
        $InputChoiceSet.wrap = $true
    }
    else {
        # Default wrap to true as per schema
        $InputChoiceSet.wrap = $true
    }

    if ($PSBoundParameters.ContainsKey('Height')) {
        $InputChoiceSet.height = $Height
    }

    if ($PSBoundParameters.ContainsKey('HorizontalAlignment')) {
        $InputChoiceSet.horizontalAlignment = $HorizontalAlignment
    }

    if ($PSBoundParameters.ContainsKey('Spacing')) {
        $InputChoiceSet.spacing = $Spacing
    }

    if ($PSBoundParameters.ContainsKey('TargetWidth')) {
        $InputChoiceSet.targetWidth = $TargetWidth
    }

    if ($PSBoundParameters.ContainsKey('GridArea')) {
        $InputChoiceSet."grid.area" = $GridArea
    }

    if ($PSBoundParameters.ContainsKey('Lang')) {
        $InputChoiceSet.lang = $Lang
    }

    if ($PSBoundParameters.ContainsKey('ValueChangedAction')) {
        $InputChoiceSet.valueChangedAction = Invoke-Command -ScriptBlock $ValueChangedAction
    }

    if ($PSBoundParameters.ContainsKey('Requires')) {
        $InputChoiceSet.requires = $Requires
    }

    if ($PSBoundParameters.ContainsKey('Fallback')) {
        $InputChoiceSet.fallback = Invoke-Command -ScriptBlock $Fallback
    }

    if ($Separator) {
        $InputChoiceSet.separator = $true
    }

    if ($IsHidden) {
        $InputChoiceSet.isVisible = $false
    }

    if ($IsSortKey) {
        $InputChoiceSet.isSortKey = $true
    }


    # Create description for ShouldProcess
    $choiceCount = $InputChoiceSet.choices.Count
    $description = "Creating Input.ChoiceSet with ID '$Id'"
    if ($choiceCount -gt 0) {
        $description += " ($choiceCount choices"
        if ($IsMultiSelect) {
            $description += ", multi-select"
        }
        $description += ", style: $($InputChoiceSet.style))"
    }

    if ($PSCmdlet.ShouldProcess($description)) {
        return $InputChoiceSet
    }
}

<#Name
Type
Default
Description
In version
type
string
Must be Input.ChoiceSet.

1.0
choices
Array of
object
The choices associated with the input.

Valid values:
Choice
1.0
choices.data
object
A Data.Query object that defines the dataset from which to dynamically fetch the choices for the input.

Valid values:
Data.Query
1.5
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
isMultiSelect
boolean
false
Controls whether multiple choices can be selected.

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
placeholder
string
The text to display as a placeholder when the user has not entered any value.

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
style
string
"compact"
Controls whether the input should be displayed as a dropdown (compact) or a list of radio buttons or checkboxes (expanded).

Valid values:
"compact",
"expanded",
"filtered"
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
The default value of the input.

1.0
valueChangedAction
object
Teams
An Action.ResetInputs action that will be executed when the value of the input changes.

Valid values:
Action.OpenUrlDialog,
Action.Popover,
Action.ResetInputs
1.5
wrap
boolean
true
Controls if choice titles should wrap.

1.2#>