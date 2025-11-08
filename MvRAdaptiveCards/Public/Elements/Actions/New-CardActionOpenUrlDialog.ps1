<#
.SYNOPSIS
    Creates an Action.OpenUrlDialog action for Adaptive Cards.

.DESCRIPTION
    Creates an action that opens a URL in a dialog/modal window within the host application,
    rather than in a new browser tab. This provides a more integrated experience.

.PARAMETER Url
    The URL to open in the dialog.

.PARAMETER Title
    The title of the action as it appears on buttons.

.PARAMETER DialogTitle
    The title to be displayed in the dialog header.

.PARAMETER DialogWidth
    The width of the dialog. Can be "small", "medium", "large", or a pixel value like "500px".

.PARAMETER DialogHeight
    The height of the dialog. Can be "small", "medium", "large", or a pixel value like "400px".

.PARAMETER Style
    Control the style of the action. Valid values: default, positive, destructive.

.PARAMETER Id
    A unique identifier for the action.

.PARAMETER IconUrl
    A URL or icon name to display on the left of the action's title.

.PARAMETER IsEnabled
    Controls the enabled state of the action. Default is true.

.PARAMETER Mode
    Controls if the action is primary or secondary. Valid values: primary, secondary.

.PARAMETER Tooltip
    The tooltip text to display when the action is hovered over.

.PARAMETER MenuActions
    The actions to display in the overflow menu of a Split action button.

.PARAMETER ThemedIconUrls
    A set of theme-specific icon URLs.

.PARAMETER Fallback
    An alternate action to render if this action type is unsupported.

.PARAMETER Requires
    A hashtable of capabilities the element requires the host application to support.

.EXAMPLE
    New-CardActionOpenUrlDialog -Title "View Details" -Url "https://example.com/details" -DialogWidth "large" -DialogHeight "medium"

.EXAMPLE
    New-CardActionOpenUrlDialog -Title "Help" -Url "https://docs.example.com" -DialogTitle "Help Documentation" -DialogWidth "800px" -DialogHeight "600px"
#>
function New-CardActionOpenUrlDialog {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Url,

        [Parameter(Mandatory = $false)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        [string]$DialogTitle,

        [Parameter(Mandatory = $false)]
        [string]$DialogWidth,

        [Parameter(Mandatory = $false)]
        [string]$DialogHeight,

        [Parameter(Mandatory = $false)]
        [ValidateSet("default", "positive", "destructive")]
        [string]$Style,

        [Parameter(Mandatory = $false)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
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
        type = "Action.OpenUrlDialog"
        url  = $Url
    }
    # Apply default fallback from settings if none provided and default is set
    if ($Null -eq $Fallback -and $_MvRACSettings.General.DefaultFallback) {
        $Fallback = [scriptblock]::Create($_MvRACSettings.General.DefaultFallback)
    }

    if ($PSBoundParameters.ContainsKey('Title')) {
        $action.title = $Title
    }

    if ($PSBoundParameters.ContainsKey('DialogTitle')) {
        $action.dialogTitle = $DialogTitle
    }

    if ($PSBoundParameters.ContainsKey('DialogWidth')) {
        $action.dialogWidth = $DialogWidth
    }

    if ($PSBoundParameters.ContainsKey('DialogHeight')) {
        $action.dialogHeight = $DialogHeight
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

    if ($PSCmdlet.ShouldProcess("Creating Action.OpenUrlDialog action to '$Url'")) {
        return $action
    }
}

# Schema comments below for reference
<#chema
Name
Type
Default
Description
In version
type
string
Must be Action.OpenUrlDialog.

1.0
url
string
The URL to open.

1.5
dialogHeight
string
The height of the dialog. To define height as a number of pixels, use the <number>px format.

Valid values:
"small",
"medium",
"large",
"<number>px"
1.5
dialogTitle
string
The title of the dialog to be displayed in the dialog header.

1.5
dialogWidth
string
The width of the dialog. To define width as a number of pixels, use the <number>px format.

Valid values:
"small",
"medium",
"large",
"<number>px"
1.5
fallback
One of
object
string
An alternate action to render if the type of this one is unsupported or if the host application doesn't support all the capabilities specified in the requires property.

Valid values:
Action.Submit,
Action.OpenUrl,
Action.Execute,
Action.ToggleVisibility,
Action.ShowCard,
Action.ResetInputs,
Action.Popover,
Action.OpenUrlDialog,
Action.InsertImage,
"drop"
1.2
iconUrl
string
A URL (or Base64-encoded Data URI) to a PNG, GIF, JPEG or SVG image to be displayed on the left of the action's title.

iconUrl also accepts the <icon-name>[,regular|filled] format to display an icon from the vast Adaptive Card icon catalog instead of an image.

1.1
id
string
A unique identifier for the element or action. Input elements must have an id, otherwise they will not be validated and their values will not be sent to the Bot.

1.0
isEnabled
boolean
true
Controls the enabled state of the action. A disabled action cannot be clicked. If the action is represented as a button, the button's style will reflect this state.

1.5
menuActions
Array of
object
Preview
The actions to display in the overflow menu of a Split action button.

Valid values:
Action.Execute,
Action.InsertImage,
Action.OpenUrl,
Action.OpenUrlDialog,
Action.ResetInputs,
Action.Submit,
Action.ToggleVisibility
1.5
mode
string
"primary"
Controls if the action is primary or secondary. Secondary actions appear in an overflow menu.

Valid values:
"primary",
"secondary"
1.5
requires
object
{}
A list of capabilities the element requires the host application to support. If the host application doesn't support at least one of the listed capabilities, the element is not rendered (or its fallback is rendered if provided).

Valid values:
HostCapabilities
1.2
style
string
"default"
Control the style of the action, affecting its visual and spoken representations.

Valid values:
"default",
"positive",
"destructive"
1.2
themedIconUrls
Array of
object
Preview
A set of theme-specific icon URLs

Valid values:
ThemedUrl
1.5
title
string
The title of the action, as it appears on buttons.

1.0
tooltip
string
The tooltip text to display when the action is hovered over.

1.5#>