function New-CardInputText {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $false)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [string]$Placeholder,

        [Parameter(Mandatory = $false)]
        [string]$Value,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Text", "Tel", "Url", "Email", "Password", "Number")]
        [string]$Style,

        [Parameter(Mandatory = $false)]
        [int]$MaxLength,

        [Parameter(Mandatory = $false)]
        [int]$MinLength,

        [Parameter(Mandatory = $false)]
        [switch]$IsMultiline,

        [Parameter(Mandatory = $false)]
        [bool]$IsRequired,

        [Parameter(Mandatory = $false)]
        [string]$Regex,

        [Parameter(Mandatory = $false)]
        [string]$Label
    )

    $InputText = @{
        type = "Input.Text"
    }

    if ($Id) {
        $InputText.id = $Id
    }
    if ($Placeholder) {
        $InputText.placeholder = $Placeholder
    }
    if ($Value) {
        $InputText.value = $Value
    }
    if ($Style) {
        $InputText.style = $Style
    }
    if ($MaxLength) {
        $InputText.maxLength = $MaxLength
    }
    if ($MinLength) {
        $InputText.minLength = $MinLength
    }
    if ($IsMultiline) {
        $InputText.isMultiline = $IsMultiline
    }
    if ($IsRequired) {
        $InputText.isRequired = $IsRequired
    }
    if ($Regex) {
        $InputText.regex = $Regex
    }
    if ($Label) {
        $InputText.label = $Label
    }

    #Return the Input.Text object
    if ( $PSCmdlet.ShouldProcess("Creating Input.Text with Id '$Id'")) {
        return $InputText
    }
}