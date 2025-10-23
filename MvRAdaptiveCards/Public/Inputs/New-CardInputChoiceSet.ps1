function New-CardInputChoiceSet {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        [hashtable[]]$Choices,

        [Parameter(Mandatory = $false)]
        [string]$Value,

        [Parameter(Mandatory = $false)]
        [bool]$IsRequired = $false,

        [Parameter(Mandatory = $false)]
        [string]$Placeholder,

        [Parameter(Mandatory = $false)]
        [string]$Label,

        [Parameter(Mandatory = $false)]
        [ValidateSet("compact", "expanded", "filtered")]
        [string]
        $Style,

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
        [switch] $separator,
        [switch] $isMultiSelect
    )

    $InputChoiceSet = @{
        type = "Input.ChoiceSet"
        id   = $Id
    }

    if ($Title) {
        $InputChoiceSet.title = $Title
    }

    if ($Choices) {
        $InputChoiceSet.choices = $Choices
    }

    if ($Value) {
        $InputChoiceSet.value = $Value
    }

    if ($IsRequired) {
        $InputChoiceSet.isRequired = $IsRequired
    }

    if ($Placeholder) {
        $InputChoiceSet.placeholder = $Placeholder
    }
    if ( $Label) {
        $InputChoiceSet.label = $Label
    }


    if ($Spacing) {
        $InputChoiceSet.spacing = $Spacing
    }
    if ($TargetWidth) {
        $InputChoiceSet.targetWidth = $TargetWidth
    }
    if ($GridArea) {
        $InputChoiceSet.gridArea = $GridArea
    }
    if ($separator) {
        $InputChoiceSet.separator = $true
    }
    if ($isSortKey) {
        $InputChoiceSet.isSortKey = $true
    }
    if ($IsHidden) {
        $InputChoiceSet.isVisible = $false
    }
    if ($Style) {
        $InputChoiceSet.style = $Style
    }
    if ($isMultiSelect) {
        $InputChoiceSet.isMultiSelect = $true
    }


    if ($PSCmdlet.ShouldProcess("Creating Input.ChoiceSet with ID '$Id'")) {
        return $InputChoiceSet
    }
}