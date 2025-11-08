<#
.SYNOPSIS
    Creates a new ActionSet element for an Adaptive Card to group multiple actions together.

.DESCRIPTION
    The New-CardActionSet function creates an ActionSet element that displays a collection of actions
    in an Adaptive Card. ActionSets are used to group related actions together and can be placed
    anywhere within a card's body, unlike the card-level actions which appear at the bottom.

.PARAMETER Actions
    An array of ScriptBlocks, each containing an action to include in the ActionSet.
    Each ScriptBlock should call an action function like New-CardActionToggleVisibility,
    New-CardActionShowCard, or other supported action types.

.PARAMETER Fallback
    An optional ScriptBlock that generates fallback content for clients that don't support
    ActionSet elements. The fallback content will be displayed instead of the ActionSet
    on unsupported clients.

.PARAMETER Id
    An optional unique identifier for the ActionSet element. Useful for referencing the element
    in other actions like toggle visibility or for accessibility purposes.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the ActionSet element structure for the Adaptive Card.

.EXAMPLE
    New-CardActionSet -Actions {
        New-CardActionToggleVisibility -Title "Show Details" -TargetElements @("DetailPanel")
        New-CardActionToggleVisibility -Title "Show Chart" -TargetElements @("ChartContainer")
    }

    Creates an ActionSet with two toggle visibility actions.

.EXAMPLE
    New-CardActionSet -Actions {
        New-CardActionShowCard -Title "Edit Profile" -Card {
            New-AdaptiveCard -AsObject -Content {
                New-CardTextBlock -Text "Edit your profile information"
            }
        }
    } -Id "ProfileActions"

    Creates an ActionSet with a ShowCard action and assigns an ID for reference.

.EXAMPLE
    New-CardActionSet -Actions {
        New-CardActionToggleVisibility -Title "Toggle Panel 1" -TargetElements @("Panel1")
        New-CardActionToggleVisibility -Title "Toggle Panel 2" -TargetElements @("Panel2")
    } -Fallback {
        New-CardTextBlock -Text "Actions not supported on this client"
    }

    Creates an ActionSet with fallback content for unsupported clients.

.NOTES
    - ActionSets are supported in Adaptive Cards schema version 1.2 and later
    - Unlike card-level actions, ActionSets can be placed anywhere in the card body
    - Each action in the Actions array is executed as a ScriptBlock to generate the action definition
    - The Fallback parameter helps ensure graceful degradation on clients that don't support ActionSets
    - ActionSets are useful for grouping related actions or placing actions within specific containers

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#actionset
#>
function New-CardActionSet {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [scriptblock[]]$Actions,

        [Parameter(Mandatory = $false)]
        [scriptblock]$Fallback,

        [Parameter(Mandatory = $false)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [ValidateSet("auto", "stretch")]
        [string]$Height,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Left", "Center", "Right")]
        [string]$HorizontalAlignment,

        [Parameter(Mandatory = $false)]
        [bool]$IsSortKey = $false,

        [Parameter(Mandatory = $false)]
        [bool]$IsVisible = $true,

        [Parameter(Mandatory = $false)]
        [string]$Lang,

        [Parameter(Mandatory = $false)]
        [hashtable]$Requires,

        [Parameter(Mandatory = $false)]
        [switch]$Separator,

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
        [string]$GridArea
    )

    $ActionSet = @{
        type    = "ActionSet"
        actions = @()
    }
    # Apply default fallback from settings if none provided and default is set
    if ($Null -eq $Fallback -and $_MvRACSettings.General.DefaultFallback) {
        $Fallback = [scriptblock]::Create($_MvRACSettings.General.DefaultFallback)
    }

    if ($PSBoundParameters.ContainsKey('Id')) {
        $ActionSet.id = $Id
    }

    if ($PSBoundParameters.ContainsKey('Fallback')) {
        if ($Fallback -is [scriptblock]) {
            $ActionSet.fallback = Invoke-Command -ScriptBlock $Fallback

            #Test if the fallback is allowed in the ActionSet schema
            if (!(Test-CardAllowedElementType -TestedContent $ActionSet.fallback -AllowedElementTypes $script:_AdaptiveCardAllowedFallbackElementTypes -ElementType "ActionSet.Fallback")) {
                throw "The fallback content in the ActionSet is of an invalid type."
            }
        }
    }

    if ($PSBoundParameters.ContainsKey('Height')) {
        $ActionSet.height = $Height.ToLower()
    }

    if ($PSBoundParameters.ContainsKey('HorizontalAlignment')) {
        $ActionSet.horizontalAlignment = $HorizontalAlignment
    }

    if ($PSBoundParameters.ContainsKey('IsSortKey') -and $IsSortKey) {
        $ActionSet.isSortKey = $true
    }

    if ($PSBoundParameters.ContainsKey('IsVisible')) {
        $ActionSet.isVisible = $IsVisible
    }

    if ($PSBoundParameters.ContainsKey('Lang')) {
        $ActionSet.lang = $Lang
    }

    if ($PSBoundParameters.ContainsKey('Requires')) {
        $ActionSet.requires = $Requires
    }

    if ($Separator) {
        $ActionSet.separator = $true
    }

    if ($PSBoundParameters.ContainsKey('Spacing')) {
        $ActionSet.spacing = $Spacing
    }

    if ($PSBoundParameters.ContainsKey('TargetWidth')) {
        $ActionSet.targetWidth = $TargetWidth
    }

    if ($PSBoundParameters.ContainsKey('GridArea')) {
        $ActionSet.'grid.area' = $GridArea
    }

    foreach ($Action in $Actions) {
        $ActionSet.actions += Invoke-Command -ScriptBlock $Action

    }
    #Test if the actions are allowed in the ActionSet schema
    if (!(Test-CardAllowedElementType -TestedContent $ActionSet.actions -AllowedElementTypes $script:_ActionSetActionAllowedActionTypes -ElementType "ActionSet.Actions")) {
        throw "One or more actions in the ActionSet are of an invalid type."
    }

    if ( $PSCmdlet.ShouldProcess("Creating ActionSet element with ID '$Id'." ) ) {
        return $ActionSet
    }
}

# Schema
# Name
# Type
# Default
# Description
# In version
# type
# string
# Must be ActionSet.

# 1.0
# actions
# Array of
# object
# The actions in the set.

# Valid values:
# Action.Execute,
# Action.InsertImage,
# Action.OpenUrl,
# Action.OpenUrlDialog,
# Action.Popover,
# Action.ResetInputs,
# Action.ShowCard,
# Action.Submit,
# Action.ToggleVisibility
# 1.0
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
