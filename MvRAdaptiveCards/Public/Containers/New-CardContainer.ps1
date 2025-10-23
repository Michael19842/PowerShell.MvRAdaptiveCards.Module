<#
.SYNOPSIS
    Creates a new Container element for an Adaptive Card.

.DESCRIPTION
    The New-CardContainer function creates a Container element that can hold multiple card elements.
    Containers are used to group elements together and can apply styling and layout properties to their contents.
    They provide a way to organize and visually separate different sections of an Adaptive Card.

.PARAMETER Content
    A ScriptBlock containing the card elements to be included inside the container.
    This can include text blocks, images, other containers, and any other supported card elements.

.PARAMETER Style
    The visual style to apply to the container. Valid values are:
    - Default: Standard container appearance
    - Emphasis: Subtle emphasis styling
    - Attention: Attention-grabbing styling (typically orange/yellow)
    - Good: Success/positive styling (typically green)
    - Warning: Warning/caution styling (typically red)

    Default value is "Default".

.PARAMETER Id
    An optional unique identifier for the container element. Useful for referencing the container
    in actions like toggle visibility or for accessibility purposes.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the Container element structure for the Adaptive Card.

.EXAMPLE
    New-CardContainer -Content {
        New-CardTextBlock -Text "Title" -Weight "Bolder"
        New-CardTextBlock -Text "This is content inside a container"
    }

    Creates a basic container with two text blocks using the default styling.

.EXAMPLE
    New-CardContainer -Style "Good" -Content {
        New-CardTextBlock -Text "Success!" -Color "Good"
        New-CardTextBlock -Text "Operation completed successfully"
    } -Id "SuccessContainer"

    Creates a container with "Good" styling (typically green background) containing success messages,
    with an ID for potential referencing in actions.

.EXAMPLE
    New-CardContainer -Style "Attention" -Content {
        New-CardTextBlock -Text "Warning" -Weight "Bolder"
        New-CardTextBlock -Text "Please review the following information carefully"
    }

    Creates an attention-styled container (typically orange/yellow) with warning content.

.NOTES
    - Containers automatically handle both single elements and arrays of elements from the Content ScriptBlock
    - The Style parameter only adds the style property when it's not "Default" to keep the JSON clean
    - Containers can be nested within other containers for complex layouts
    - The Id parameter is optional but recommended when the container needs to be referenced by actions

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#container
#>
function New-CardContainer {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [scriptblock]$Content,

        [string]
        [ValidateSet("Default", "Emphasis", "Attention", "Good", "Warning", "Accent")]
        $Style = "Default",

        [Parameter(Mandatory = $false)]
        [object]
        $BackgroundImage,

        [Parameter(Mandatory = $false)]
        [int]
        $MinHeight,

        [Parameter(Mandatory = $false)]
        [int]
        $MaxHeight,

        [string]
        [Parameter(Mandatory = $false)]
        $Id,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Top", "Center", "Bottom")]
        [string]
        $VerticalContentAlignment,

        [Parameter(Mandatory = $false)]
        [switch]
        $Bleed,

        [Parameter(Mandatory = $false)]
        [scriptblock]
        $Fallback,

        [Parameter(Mandatory = $false)]
        [string]
        $GridArea,

        [Parameter(Mandatory = $false)]
        [ValidateSet("auto", "stretch")]
        [string]
        $Height = "auto",

        [Parameter(Mandatory = $false)]
        [ValidateSet("Left", "Center", "Right")]
        [string]
        $HorizontalAlignment,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsSortKey = $false,

        [Parameter(Mandatory = $false)]
        [string]
        $Lang,

        [Parameter(Mandatory = $false)]
        [scriptblock]
        $Layouts,

        [Parameter(Mandatory = $false)]
        [hashtable]
        $Requires,

        [Parameter(Mandatory = $false)]
        [switch]
        $RoundedCorners,

        [Parameter(Mandatory = $false)]
        [switch]
        $Rtl,

        [Parameter(Mandatory = $false)]
        [object]
        $SelectAction,

        [Parameter(Mandatory = $false)]
        [switch]
        $Separator,

        [Parameter(Mandatory = $false)]
        [switch]
        $ShowBorder,

        [Parameter(Mandatory = $false)]
        [ValidateSet("None", "ExtraSmall", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")]
        [string]
        $Spacing = "Default",

        [Parameter(Mandatory = $false)]
        [ValidateSet("VeryNarrow", "Narrow", "Standard", "Wide", "atLeast:VeryNarrow", "atMost:VeryNarrow", "atLeast:Narrow", "atMost:Narrow", "atLeast:Standard", "atMost:Standard", "atLeast:Wide", "atMost:Wide")]
        [string]
        $TargetWidth,

        [Alias('Hide')]
        [switch]$Hidden
    )

    $Container = @{
        type  = "Container"
        items = [System.Collections.ArrayList]@()
    }

    if ($Style -ne "Default") {
        $Container.style = $Style.ToLower()
    }

    if ($BackgroundImage) {
        $Container.backgroundImage = $BackgroundImage
    }

    if ($MinHeight) {
        $Container.minHeight = "${MinHeight}px"
    }

    if ($MaxHeight) {
        $Container.maxHeight = "${MaxHeight}px"
    }

    if ($Id) {
        $Container.id = $Id
    }

    if ($VerticalContentAlignment) {
        $Container.verticalContentAlignment = $VerticalContentAlignment
    }

    if ($Bleed) {
        $Container.bleed = $true
    }

    if ($Fallback) {
        $Container.fallback = Invoke-Command -ScriptBlock $Fallback
    }

    if ($GridArea) {
        $Container.'grid.area' = $GridArea
    }

    if ($Height -and $Height -ne "auto") {
        $Container.height = $Height
    }

    if ($HorizontalAlignment) {
        $Container.horizontalAlignment = $HorizontalAlignment
    }

    if ($IsSortKey) {
        $Container.isSortKey = $true
    }

    if ($Hidden) {
        $Container.isVisible = $false
    }

    if ($Lang) {
        $Container.lang = $Lang
    }

    if ($Layouts) {
        $Container.layouts = [System.Collections.ArrayList]@()

        $LayoutsResult = Invoke-Command -ScriptBlock $Layouts

        if ($LayoutsResult -is [array]) {
            [void]($Container.layouts.AddRange($LayoutsResult))
        }
        else {
            [void]($Container.layouts.Add($LayoutsResult))
        }
    }

    if ($Requires) {
        $Container.requires = $Requires
    }

    if ($RoundedCorners) {
        $Container.roundedCorners = $true
    }

    if ($Rtl) {
        $Container.rtl = $true
    }

    if ($SelectAction) {
        $Container.selectAction = $SelectAction
    }

    if ($Separator) {
        $Container.separator = $true
    }

    if ($ShowBorder) {
        $Container.showBorder = $true
    }

    if ($Spacing -and $Spacing -ne "Default") {
        $Container.spacing = $Spacing
    }

    if ($TargetWidth) {
        $Container.targetWidth = $TargetWidth
    }

    $ContentResult = Invoke-Command -ScriptBlock $Content

    if ($ContentResult -is [array]) {
        [void]($Container.items.AddRange($ContentResult))
    }
    else {
        [void]($Container.items.Add($ContentResult))
    }

    if ( $PSCmdlet.ShouldProcess("Creating Container element with style '$Style'." ) ) {
        return ($Container)
    }

}

