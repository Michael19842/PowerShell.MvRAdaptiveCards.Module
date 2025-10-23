function New-CardInputRating {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        [int]$MinValue = 1,

        [Parameter(Mandatory = $false)]
        [int]$MaxValue = 5,

        [Parameter(Mandatory = $false)]
        [int]$Value,

        [Parameter(Mandatory = $false)]
        [string]$Label,

        [Parameter(Mandatory = $false)]
        [bool]$IsRequired = $false,

        [Parameter(Mandatory = $false)]
        [string]$Placeholder,

        [parameter(Mandatory = $false)]
        [ValidateSet("None", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")]
        [string]$Spacing,

        [parameter(Mandatory = $false)]
        [ValidateSet("VeryNarrow", "Narrow", "Standard", "Wide", "atLeast:VeryNarrow", "atMost:VeryNarrow", "atLeast:Narrow", "atMost:Narrow", "atLeast:Standard", "atMost:Standard", "atLeast:Wide", "atMost:Wide")]
        [string]$TargetWidth,

        [Parameter(Mandatory = $false)]
        [string]$GridArea,

        [Alias("Hide")]
        [switch] $IsHidden,
        [switch] $isSortKey,
        [switch] $separator
    )

    $InputRating = @{
        type     = "Input.Rating"
        id       = $Id
        minValue = $MinValue
        maxValue = $MaxValue
    }

    if ($Title) {
        $InputRating.title = $Title
    }

    if ($Value) {
        $InputRating.value = $Value
    }

    if ($Label) {
        $InputRating.label = $Label
    }

    if ($IsRequired) {
        $InputRating.isRequired = $IsRequired
    }

    if ($Placeholder) {
        $InputRating.placeholder = $Placeholder
    }


    if ($Spacing) {
        $InputRating.spacing = $Spacing
    }
    if ($TargetWidth) {
        $InputRating.targetWidth = $TargetWidth
    }
    if ($GridArea) {
        $InputRating.gridArea = $GridArea
    }
    if ($IsHidden) {
        $InputRating.isVisible = $false
    }
    if ($separator) {
        $InputRating.separator = $true
    }
    if ($isSortKey) {
        $InputRating.isSortKey = $true
    }

    if ($PSCmdlet.ShouldProcess("Creating Input.Rating with ID '$Id'")) {
        return $InputRating
    }
}