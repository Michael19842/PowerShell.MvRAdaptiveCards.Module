function New-CardActionOpenUrl {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Url,

        [Parameter(Mandatory = $false)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        [ValidateSet("default", "positive", "destructive")]
        [string]$Style,

        [Parameter(Mandatory = $false)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [Alias("Icon")]
        [string]$IconUrl,

        [Parameter(Mandatory = $false)]
        [bool]$IsEnabled = $true,

        [Parameter(Mandatory = $false)]
        [ValidateSet("primary", "secondary")]
        [string]$Mode,

        [Parameter(Mandatory = $false)]
        [string]$Tooltip,

        [Parameter(Mandatory = $false)]
        [array]$MenuActions,

        [Parameter(Mandatory = $false)]
        [array]$ThemedIconUrls,

        [Parameter(Mandatory = $false)]
        [scriptblock]$Fallback,

        [Parameter(Mandatory = $false)]
        [hashtable]$Requires
    )

    $action = @{
        type = "Action.OpenUrl"
        url  = $Url
    }

    # Apply default fallback from settings if none provided and default is set
    if ($Null -eq $Fallback -and $_MvRACSettings.General.DefaultFallback) {
        $Fallback = [scriptblock]::Create($_MvRACSettings.General.DefaultFallback)
    }

    if ($PSBoundParameters.ContainsKey('Title')) {
        $action.title = $Title
    }

    if ($PSBoundParameters.ContainsKey('Style')) {
        $action.style = $Style.ToLower()
    }

    if ($PSBoundParameters.ContainsKey('Id')) {
        $action.id = $Id
    }

    if ($PSBoundParameters.ContainsKey('IconUrl')) {
        $action.iconUrl = $IconUrl
    }

    if ($PSBoundParameters.ContainsKey('IsEnabled')) {
        $action.isEnabled = $IsEnabled
    }

    if ($PSBoundParameters.ContainsKey('Mode')) {
        $action.mode = $Mode.ToLower()
    }

    if ($PSBoundParameters.ContainsKey('Tooltip')) {
        $action.tooltip = $Tooltip
    }

    if ($PSBoundParameters.ContainsKey('MenuActions') -and $MenuActions.Count -gt 0) {
        $action.menuActions = $MenuActions
    }

    if ($PSBoundParameters.ContainsKey('ThemedIconUrls') -and $ThemedIconUrls.Count -gt 0) {
        $action.themedIconUrls = $ThemedIconUrls
    }

    if ($PSBoundParameters.ContainsKey('Fallback')) {
        $action.fallback = Invoke-Command -ScriptBlock $Fallback
    }

    if ($PSBoundParameters.ContainsKey('Requires')) {
        $action.requires = $Requires
    }

    if ($PSCmdlet.ShouldProcess("Creating Action.OpenUrl action to '$Url'")) {
        return $action
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
# Must be Action.OpenUrl.

# 1.0
# url
# string
# The URL to open.

# 1.0
# fallback
# One of
# object
# string
# An alternate action to render if the type of this one is unsupported or if the host application doesn't support all the capabilities specified in the requires property.

# Valid values:
# Action.Submit,
# Action.OpenUrl,
# Action.Execute,
# Action.ToggleVisibility,
# Action.ShowCard,
# Action.ResetInputs,
# Action.Popover,
# Action.OpenUrlDialog,
# Action.InsertImage,
# "drop"
# 1.2
# iconUrl
# string
# A URL (or Base64-encoded Data URI) to a PNG, GIF, JPEG or SVG image to be displayed on the left of the action's title.

# iconUrl also accepts the <icon-name>[,regular|filled] format to display an icon from the vast Adaptive Card icon catalog instead of an image.

# 1.1
# id
# string
# A unique identifier for the element or action. Input elements must have an id, otherwise they will not be validated and their values will not be sent to the Bot.

# 1.0
# isEnabled
# boolean
# true
# Controls the enabled state of the action. A disabled action cannot be clicked. If the action is represented as a button, the button's style will reflect this state.

# 1.5
# menuActions
# Array of
# object
# Preview
# The actions to display in the overflow menu of a Split action button.

# Valid values:
# Action.Execute,
# Action.InsertImage,
# Action.OpenUrl,
# Action.OpenUrlDialog,
# Action.ResetInputs,
# Action.Submit,
# Action.ToggleVisibility
# 1.5
# mode
# string
# "primary"
# Controls if the action is primary or secondary. Secondary actions appear in an overflow menu.

# Valid values:
# "primary",
# "secondary"
# 1.5
# requires
# object
# {}
# A list of capabilities the element requires the host application to support. If the host application doesn't support at least one of the listed capabilities, the element is not rendered (or its fallback is rendered if provided).

# Valid values:
# HostCapabilities
# 1.2
# style
# string
# "default"
# Control the style of the action, affecting its visual and spoken representations.

# Valid values:
# "default",
# "positive",
# "destructive"
# 1.2
# themedIconUrls
# Array of
# object
# Preview
# A set of theme-specific icon URLs

# Valid values:
# ThemedUrl
# 1.5
# title
# string
# The title of the action, as it appears on buttons.

# 1.0
# tooltip
# string
# The tooltip text to display when the action is hovered over.

# 1.5