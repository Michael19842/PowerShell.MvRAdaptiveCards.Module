<#
.SYNOPSIS
Creates a page for a Carousel container.

.DESCRIPTION
Creates a carousel page that contains elements to be displayed in a carousel.

.PARAMETER Items
A scriptblock that generates the elements for this page.

.PARAMETER BackgroundImage
Defines the page's background image (URL or object).

.PARAMETER MinHeight
The minimum height of the page in pixels (format: "100px").

.PARAMETER MaxHeight
The maximum height of the page in pixels (format: "500px").

.PARAMETER VerticalContentAlignment
Controls how the page's content should be vertically aligned.
Valid values: Top, Center, Bottom

.PARAMETER Style
The style of the page. Valid values: default, emphasis, accent, good, attention, warning

.PARAMETER Rtl
Controls if the content should be rendered right-to-left.

.PARAMETER SelectAction
An action to invoke when the page is tapped or clicked.

.PARAMETER ShowBorder
Controls if a border should be displayed around the page.

.PARAMETER RoundedCorners
Controls if the page should have rounded corners.

.PARAMETER Layouts
Array of layout objects for responsive layout support.

.EXAMPLE
New-CardCarouselPage {
    New-CardTextBlock -Text "Welcome" -Size ExtraLarge
    New-CardImage -Url "https://example.com/welcome.jpg"
}

.EXAMPLE
New-CardCarouselPage -Style 'emphasis' -Items {
    New-CardTextBlock -Text "Featured Item" -Weight Bolder
    New-CardTextBlock -Text "Special offer today only!"
}
#>
function New-CardCarouselPage {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'none')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('Content')]
        [scriptblock]$Items,

        [Parameter(Mandatory = $false)]
        [object]$BackgroundImage,

        [Parameter(Mandatory = $false)]
        [ValidatePattern('^\d+px$')]
        [string]$MinHeight,

        [Parameter(Mandatory = $false)]
        [ValidatePattern('^\d+px$')]
        [string]$MaxHeight,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Top', 'Center', 'Bottom')]
        [string]$VerticalContentAlignment,

        [Parameter(Mandatory = $false)]
        [ValidateSet('default', 'emphasis', 'accent', 'good', 'attention', 'warning')]
        [string]$Style,

        [Parameter(Mandatory = $false)]
        [switch]$Rtl,

        [Parameter(Mandatory = $false)]
        [object]$SelectAction,

        [Parameter(Mandatory = $false)]
        [switch]$ShowBorder,

        [Parameter(Mandatory = $false)]
        [switch]$RoundedCorners,

        [Parameter(Mandatory = $false)]
        [array]$Layouts
    )

    $Page = @{
        type  = "CarouselPage"
        items = @(Invoke-Command -ScriptBlock $Items)
    }

    if ($PSBoundParameters.ContainsKey('BackgroundImage')) {
        $Page.backgroundImage = $BackgroundImage
    }

    if ($PSBoundParameters.ContainsKey('MinHeight')) {
        $Page.minHeight = $MinHeight
    }

    if ($PSBoundParameters.ContainsKey('MaxHeight')) {
        $Page.maxHeight = $MaxHeight
    }

    if ($PSBoundParameters.ContainsKey('VerticalContentAlignment')) {
        $Page.verticalContentAlignment = $VerticalContentAlignment
    }

    if ($PSBoundParameters.ContainsKey('Style')) {
        $Page.style = $Style
    }

    if ($Rtl) {
        $Page.rtl = $true
    }

    if ($PSBoundParameters.ContainsKey('SelectAction')) {
        $Page.selectAction = $SelectAction
    }

    if ($ShowBorder) {
        $Page.showBorder = $true
    }

    if ($RoundedCorners) {
        $Page.roundedCorners = $true
    }

    if ($PSBoundParameters.ContainsKey('Layouts')) {
        $Page.layouts = $Layouts
    }

    if ($PSCmdlet.ShouldProcess("Creating Carousel Page")) {
        return $Page
    }
}