

function New-CardTextRun {
    [CmdletBinding(supportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Text,
        [Parameter(Mandatory = $false)]
        [ValidateSet("Default", "Dark", "Light", "Accent", "Good", "Warning", "Attention", $null)]
        [string]$Color,

        [Parameter(Mandatory = $false)]
        [string]
        $Id,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Default", "Monospace", $null)]
        [string]$FontType,
        [string]$Lang,
        [scriptblock]$SelectAction,
        [ValidateSet("Small", "Default", "Medium", "Large", "ExtraLarge", $null)]
        [string]$Size,
        [ValidateSet("Lighter", "Default", "Bolder", $null)]
        [string]$Weight,

        [switch]$IsVisible,
        [switch]$IsSubtle,
        [switch]$Highlight,
        [switch]$Italic,
        [switch]$Strikethrough,
        [switch]$Underline
    )


    $TextRun = @{
        type = "TextRun"
        text = $Text
    }

    if ($Color) {
        $TextRun.color = $Color
    }

    if ($Id) {
        $TextRun.id = $Id
    }

    if ($FontType) {
        $TextRun.fontType = $FontType
    }

    if ($IsSubtle) {
        $TextRun.isSubtle = $true
    }

    if ($IsVisible) {
        $TextRun.isVisible = $true
    }

    if ($Lang) {
        $TextRun.lang = $Lang
    }

    if ($SelectAction) {
        $TextRun.selectAction = Invoke-Command -ScriptBlock $SelectAction
    }

    if ($Size) {
        $TextRun.size = $Size
    }

    if ($Weight) {
        $TextRun.weight = $Weight
    }

    if ($Highlight) {
        $TextRun.highlight = $true
    }

    if ($Italic) {
        $TextRun.italic = $true
    }

    if ($Strikethrough) {
        $TextRun.strikethrough = $true
    }

    if ($Underline) {
        $TextRun.underline = $true
    }

    if ($PSCmdlet.ShouldProcess("Creating TextRun element with text: $Text")) {
        return $TextRun
    }
}