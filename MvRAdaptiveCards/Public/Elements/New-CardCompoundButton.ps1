<#
.SYNOPSIS
    Creates a CompoundButton element for an Adaptive Card.

.DESCRIPTION
    The New-CardCompoundButton function creates a CompoundButton element that combines a title, description,
    icon, and badge into a single interactive button. This element is useful for creating rich, informative
    buttons that provide more context than standard action buttons.

.PARAMETER Title
    The title text of the button. This is the primary text displayed on the button.

.PARAMETER Description
    The description text of the button. This provides additional context or details below the title.

.PARAMETER Icon
    The icon to show on the button. Should be an icon object created with New-CardIcon or a hashtable
    representing an IconInfo object.

.PARAMETER Badge
    The badge to show on the button. Can be a string or a badge object created with New-CardBadge.

.PARAMETER SelectAction
    An action that will be invoked when the button is tapped or clicked. Should be an action object
    created with functions like New-CardActionSubmit, New-CardActionOpenUrl, etc.
    Note: Action.ShowCard is not supported.

.PARAMETER Id
    A unique identifier for the element. Useful for referencing the element programmatically.

.PARAMETER Height
    Controls the height of the element. Valid values: "auto", "stretch".

.PARAMETER HorizontalAlignment
    Controls how the element should be horizontally aligned. Valid values: "Left", "Center", "Right".

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
    Returns a hashtable representing the CompoundButton element with all configured properties.

.EXAMPLE
    New-CardCompoundButton -Title "Submit Report" -Description "Complete and submit your monthly report"

    Creates a simple compound button with title and description.

.EXAMPLE
    New-CardCompoundButton -Title "Open Dashboard" -Description "View analytics" -Icon (New-CardIcon -Name "ChartBar") -SelectAction (New-CardActionOpenUrl -Url "https://dashboard.example.com")

    Creates a compound button with icon and URL action.

.EXAMPLE
    New-CardCompoundButton -Title "Notifications" -Badge "5" -Description "You have unread messages" -SelectAction (New-CardActionSubmit -Title "View")

    Creates a compound button with a badge showing notification count.

.NOTES
    - Introduced in Adaptive Cards version 1.5
    - Action.ShowCard is not supported as a SelectAction
    - Compound buttons are ideal for menu-like interfaces or action-rich cards

.LINK
    New-AdaptiveCard

.LINK
    New-CardIcon

.LINK
    New-CardBadge

.LINK
    New-CardActionSubmit
#>
function New-CardCompoundButton {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $false)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        [string]$Description,

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
        [object]$Badge,

        [Parameter(Mandatory = $false)]
        [scriptblock]$SelectAction,

        [Parameter(Mandatory = $false)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [ValidateSet("auto", "stretch")]
        [string]$Height,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Left", "Center", "Right")]
        [string]$HorizontalAlignment,

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
        [ScriptBlock]$Fallback,

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

    $CompoundButton = @{
        type = "CompoundButton"
    }

    if ($PSBoundParameters.ContainsKey('Title')) {
        $CompoundButton.title = $Title
    }
    if ($PSBoundParameters.ContainsKey('Description')) {
        $CompoundButton.description = $Description
    }
    if ($PSBoundParameters.ContainsKey('Icon')) {
        $CompoundButton.icon = $Icon
    }
    if ($PSBoundParameters.ContainsKey('Badge')) {
        $CompoundButton.badge = $Badge
    }
    if ($PSBoundParameters.ContainsKey('SelectAction')) {
        $CompoundButton.selectAction = Invoke-Command -ScriptBlock $SelectAction
    }
    if ($PSBoundParameters.ContainsKey('Id')) {
        $CompoundButton.id = $Id
    }
    if ($PSBoundParameters.ContainsKey('Height')) {
        $CompoundButton.height = $Height
    }
    if ($PSBoundParameters.ContainsKey('HorizontalAlignment')) {
        $CompoundButton.horizontalAlignment = $HorizontalAlignment
    }
    if ($Separator) {
        $CompoundButton.separator = $true
    }
    if ($PSBoundParameters.ContainsKey('Spacing')) {
        $CompoundButton.spacing = $Spacing
    }
    if ($PSBoundParameters.ContainsKey('IsVisible')) {
        $CompoundButton.isVisible = $IsVisible
    }
    if ($PSBoundParameters.ContainsKey('Requires')) {
        $CompoundButton.requires = $Requires
    }
    if ($PSBoundParameters.ContainsKey('Fallback')) {
        $CompoundButton.fallback = Invoke-Command -ScriptBlock $Fallback
    }
    if ($PSBoundParameters.ContainsKey('TargetWidth')) {
        $CompoundButton.targetWidth = $TargetWidth
    }
    if ($PSBoundParameters.ContainsKey('GridArea')) {
        $CompoundButton.'grid.area' = $GridArea
    }
    if ($PSBoundParameters.ContainsKey('Lang')) {
        $CompoundButton.lang = $Lang
    }
    if ($PSBoundParameters.ContainsKey('IsSortKey')) {
        $CompoundButton.isSortKey = $IsSortKey
    }

    #Return the CompoundButton object
    if ($PSCmdlet.ShouldProcess("Creating CompoundButton with Title '$Title'")) {
        return $CompoundButton
    }
}


# 1.0
# badge
# string
# The badge to show on the button.

# 1.5
# description
# string
# The description text of the button.

# 1.5
# icon
# object
# The icon to show on the button.

# Valid values:
# IconInfo
# 1.5
# selectAction
# object
# An Action that will be invoked when the button is tapped or clicked. Action.ShowCard is not supported.

# Valid values:
# Action.Execute,
# Action.InsertImage,
# Action.OpenUrl,
# Action.OpenUrlDialog,
# Action.Popover,
# Action.ResetInputs,
# Action.Submit,
# Action.ToggleVisibility
# 1.5
# title
# string
# The title of the button.

# 1.5
# fallback
# One of
# object
# string
# An alternate element to render if the type of this one is unsupported or if the host application doesn't support all the capabilities specified in the requires property.

# Valid values:
# Container,
# ActionSet,
# ColumnSet,
# Media,
# RichTextBlock,
# Table,
# TextBlock,
# FactSet,
# ImageSet,
# Image,
# Input.Text,
# Input.Date,
# Input.Time,
# Input.Number,
# Input.Toggle,
# Input.ChoiceSet,
# Input.Rating,
# Rating,
# CompoundButton,
# Icon,
# Carousel,
# Badge,
# ProgressRing,
# ProgressBar,
# Chart.Donut,
# Chart.Pie,
# Chart.VerticalBar.Grouped,
# Chart.VerticalBar,
# Chart.HorizontalBar,
# Chart.HorizontalBar.Stacked,
# Chart.Line,
# Chart.Gauge,
# CodeBlock,
# Component.graph.microsoft.com/user,
# Component.graph.microsoft.com/users,
# Component.graph.microsoft.com/resource,
# Component.graph.microsoft.com/file,
# Component.graph.microsoft.com/event,
# "drop"
# 1.2
# grid.area
# string
# Teams
# The area of a Layout.AreaGrid layout in which an element should be displayed.

# 1.5
# height
# string
# "auto"
# The height of the element. When set to stretch, the element will use the remaining vertical space in its container.

# Valid values:
# "auto",
# "stretch"
# 1.1
# horizontalAlignment
# string
# Controls how the element should be horizontally aligned.

# Valid values:
# "Left",
# "Center",
# "Right"
# 1.0
# id
# string
# A unique identifier for the element or action. Input elements must have an id, otherwise they will not be validated and their values will not be sent to the Bot.

# 1.0
# isSortKey
# boolean
# false
# Controls whether the element should be used as a sort key by elements that allow sorting across a collection of elements.

# 1.5
# isVisible
# boolean
# true
# Controls the visibility of the element.

# 1.2
# lang
# string
# The locale associated with the element.

# 1.1
# requires
# object
# {}
# A list of capabilities the element requires the host application to support. If the host application doesn't support at least one of the listed capabilities, the element is not rendered (or its fallback is rendered if provided).

# Valid values:
# HostCapabilities
# 1.2
# separator
# boolean
# false
# Controls whether a separator line should be displayed above the element to visually separate it from the previous element. No separator will be displayed for the first element in a container, even if this property is set to true.

# 1.0
# spacing
# string
# "Default"
# Controls the amount of space between this element and the previous one. No space will be added for the first element in a container.

# Valid values:
# "None",
# "ExtraSmall"
# Preview
# ,
# "Small",
# "Default",
# "Medium",
# "Large",
# "ExtraLarge",
# "Padding"
# 1.0
# targetWidth
# string
# TeamsCopilot
# Controls for which card width the element should be displayed. If targetWidth isn't specified, the element is rendered at all card widths. Using targetWidth makes it possible to author responsive cards that adapt their layout to the available horizontal space. For more details, see Responsive layout.

# Valid values:
# "VeryNarrow",
# "Narrow",
# "Standard",
# "Wide",
# "atLeast:VeryNarrow",
# "atMost:VeryNarrow",
# "atLeast:Narrow",
# "atMost:Narrow",
# "atLeast:Standard",
# "atMost:Standard",
# "atLeast:Wide",
# "atMost:Wide"
# 1.0