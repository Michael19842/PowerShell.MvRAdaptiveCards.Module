<#
.SYNOPSIS
    Creates an Input.Text element for text input in an Adaptive Card.

.DESCRIPTION
    The New-CardInputText function creates an Input.Text element that allows users to enter text data.
    Supports various input styles (email, phone, URL, password), validation (min/max length, regex),
    multiline text areas, and required field marking.

.PARAMETER Id
    Unique identifier for the input element. Used to retrieve the input value when the card is submitted.

.PARAMETER Placeholder
    Placeholder text displayed in the input field when it's empty. Provides hints about expected input format.

.PARAMETER Value
    Initial/default value to pre-populate in the input field.

.PARAMETER Style
    Input style that affects keyboard and validation behavior:
    - Text: Standard text input (default)
    - Tel: Telephone number input with numeric keyboard
    - Url: URL input with URL-optimized keyboard
    - Email: Email input with email-optimized keyboard
    - Password: Masked password input
    - Number: Numeric input with number keyboard

.PARAMETER MaxLength
    Maximum number of characters allowed in the input field.

.PARAMETER MinLength
    Minimum number of characters required in the input field.

.PARAMETER IsMultiline
    Switch to enable multiline text input (text area). When set, the input expands to multiple lines.

.PARAMETER IsRequired
    Marks the input field as required. The card cannot be submitted without a value in this field.

.PARAMETER Regex
    Regular expression pattern for input validation. The input value must match this pattern.

.PARAMETER Label
    Label text displayed above the input field. Describes the purpose of the input.

.OUTPUTS
    [hashtable]
    Returns a hashtable representing the Input.Text element with all configured properties.

.EXAMPLE
    New-CardInputText -Id "name" -Label "Full Name" -Placeholder "Enter your name" -IsRequired $true

    Creates a required text input field with label and placeholder.

.EXAMPLE
    New-CardInputText -Id "email" -Style Email -Placeholder "user@example.com" -Regex "^[^@]+@[^@]+\.[^@]+$"

    Creates an email input with validation pattern.

.EXAMPLE
    New-CardInputText -Id "phone" -Style Tel -Label "Phone Number" -MaxLength 15

    Creates a phone number input with maximum length restriction.

.EXAMPLE
    New-CardInputText -Id "password" -Style Password -Label "Password" -MinLength 8 -IsRequired $true

    Creates a required password field with minimum length validation.

.EXAMPLE
    New-CardInputText -Id "comments" -IsMultiline -Label "Comments" -Placeholder "Enter your feedback"

    Creates a multiline text area for longer text input.

.EXAMPLE
    New-CardInputText -Id "website" -Style Url -Value "https://example.com" -Label "Website"

    Creates a URL input with a pre-filled default value.

.NOTES
    - The Id parameter is essential for retrieving submitted values
    - Style parameter affects mobile keyboard layout and browser input hints
    - Regex validation is performed client-side before submission
    - IsMultiline creates an expandable text area instead of single-line input
    - Required fields prevent card submission until filled

.LINK
    New-AdaptiveCard

.LINK
    New-CardInputChoiceSet

.LINK
    New-CardInputToggle
#>
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
    if ($PSBoundParameters.ContainsKey('MaxLength')) {
        $InputText.maxLength = $MaxLength
    }
    if ($PSBoundParameters.ContainsKey('MinLength')) {
        $InputText.minLength = $MinLength
    }
    if ($IsMultiline) {
        $InputText.isMultiline = $IsMultiline
    }
    if ($PSBoundParameters.ContainsKey('IsRequired')) {
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