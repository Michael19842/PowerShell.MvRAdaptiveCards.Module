<#
.SYNOPSIS
    Creates a new RichTextBlock element for an Adaptive Card with advanced inline formatting capabilities.

.DESCRIPTION
    The New-CardRichTextBlock function creates a RichTextBlock element that supports rich text formatting
    through an intuitive tag-based markup system. Unlike simple TextBlocks, RichTextBlocks can contain
    multiple text runs with different styles, colors, weights, and even interactive actions within a single block.

    The function uses a custom markup language with tags like {{bold}}, {{color:Good}}, {{action:myAction}}, etc.
    to define formatting and behavior for different parts of the text. This enables complex text layouts
    with mixed formatting, colors, and interactivity all within a single text element.

.PARAMETER Text
    The text content with embedded formatting tags. Tags use the format {{tagname}} for opening and {{/tagname}}
    for closing. Some tags support values using {{tagname:value}} syntax.

    Supported formatting tags:
    - Style: {{bold}}, {{italic}}, {{strikethrough}}, {{underline}}, {{highlight}}
    - Weight: {{bolder}}, {{lighter}}, {{weight:value}}
    - Size: {{small}}, {{medium}}, {{large}}, {{extraLarge}}, {{size:value}}
    - Color: {{color:colorname}} (Default, Dark, Light, Accent, Good, Warning, Attention)
    - Font: {{monospace}}, {{fontType:value}}
    - Visibility: {{hidden}}, {{subtle}}
    - Language: {{lang:code}}
    - Actions: {{action:actionname}} (references NamedSelectActions)

.PARAMETER Id
    An optional unique identifier for the RichTextBlock element. Useful for referencing the element
    in actions like toggle visibility or for accessibility purposes.

.PARAMETER HorizontalAlignment
    The horizontal alignment of the text block. Valid values are:
    - Left: Align text to the left (default)
    - Center: Center the text
    - Right: Align text to the right
    - Justify: Justify the text (stretch to fill width)

.PARAMETER FontType
    The font family to use for the text block. Valid values are:
    - Default: Use the default system font
    - Monospace: Use a monospace font (good for code or data)

.PARAMETER Size
    The default size for text in the block. Valid values are:
    - Small: Smaller than default text
    - Default: Standard text size
    - Medium: Medium sized text
    - Large: Large text
    - ExtraLarge: Extra large text
    Note: Individual text runs can override this with size tags.

.PARAMETER Weight
    The default weight (boldness) for text in the block. Valid values are:
    - Lighter: Lighter than normal text
    - Default: Normal text weight
    - Bolder: Bold text
    Note: Individual text runs can override this with weight tags.

.PARAMETER NamedSelectActions
    A hashtable containing named actions that can be referenced within the text using {{action:name}} tags.
    Each key in the hashtable should be an action name, and each value should be a ScriptBlock that
    generates an action using functions like New-CardActionToggleVisibility, New-CardActionShowCard, etc.

    Example: @{ "showDetails" = { New-CardActionShowCard -Title "Details" -Card {...} } }

.PARAMETER Separator
    A switch parameter that adds a separator line above the RichTextBlock element. Useful for
    visually separating the text block from preceding elements.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the RichTextBlock element structure for the Adaptive Card.

.EXAMPLE
    New-CardRichTextBlock -Text "This is {{bold}}bold text{{/bold}} and this is {{color:Good}}green text{{/color}}."

    Creates a rich text block with bold formatting and colored text using inline tags.

.EXAMPLE
    $text = @"
Welcome {{bold}}{{color:Good}}John Doe{{/color}}{{/bold}}!
Your account status is {{color:Good}}{{bold}}Active{{/bold}}{{/color}}.
Click {{action:viewProfile}}here{{/action}} to view your profile.
"@

    $actions = @{
        "viewProfile" = { New-CardActionShowCard -Title "Profile" -Card {
            New-AdaptiveCard -AsObject -Content {
                New-CardTextBlock -Text "Profile details..."
            }
        }}
    }

    New-CardRichTextBlock -Text $text -NamedSelectActions $actions

    Creates a rich text block with nested formatting, colors, and an interactive action link.

.EXAMPLE
    $complexText = @"
{{size:Large}}{{bold}}System Status Report{{/bold}}{{/size}}

{{color:Good}} All systems operational{{/color}}
{{color:Warning}} Minor performance degradation detected{{/color}}
{{color:Attention}} Critical error in database connection{{/color}}

{{monospace}}Error Code: DB_CONN_001{{/monospace}}
{{italic}}Last updated: $(Get-Date){{/italic}}

For more information, {{action:contactSupport}}contact support{{/action}}.
"@

    $actions = @{
        "contactSupport" = { New-CardActionOpenUrl -Url "mailto:support@company.com" }
    }

    New-CardRichTextBlock -Text $complexText -NamedSelectActions $actions -Id "StatusReport"

    Creates a complex system status report with multiple formatting styles, colors, and an action link.

.EXAMPLE
    New-CardRichTextBlock -Text "Code example: {{monospace}}{{highlight}}Get-Process | Select-Object Name{{/highlight}}{{/monospace}}" -FontType "Default" -HorizontalAlignment "Left"

    Creates a text block demonstrating code formatting with monospace font and highlighting.

.EXAMPLE
    $styledText = @"
{{bold}}{{size:Large}}Product Features{{/size}}{{/bold}}

- {{color:Good}}Fast performance{{/color}} - Up to 10x faster
- {{color:Accent}}Easy integration{{/color}} - Simple API
- {{strikethrough}}Expensive licensing{{/strikethrough}} {{color:Good}}Now free!{{/color}}
- {{underline}}24/7 support{{/underline}} available

{{subtle}}{{size:Small}}* Terms and conditions apply{{/size}}{{/subtle}}
"@

    New-CardRichTextBlock -Text $styledText -HorizontalAlignment "Left" -Separator

    Creates a product features list with various formatting styles and a separator.

.NOTES
    - Tags can be nested for combined effects (e.g., {{bold}}{{color:Good}}text{{/color}}{{/bold}})
    - All opening tags must have corresponding closing tags
    - Color values must match Adaptive Card color scheme values
    - Action names in {{action:name}} tags must exist in the NamedSelectActions hashtable
    - The function performs validation to ensure proper tag matching and valid values
    - Text runs are automatically created for each formatted segment
    - Unknown tags generate warnings but don't break the function
    - The markup language is designed to be intuitive and similar to HTML/XML

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#richtextblock

.LINK
    New-CardTextRun

.LINK
    New-CardTextBlock
#>
function New-CardRichTextBlock {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Text,
        [string]
        [Parameter(Mandatory = $false)]
        $Id,
        [ValidateSet("Left", "Center", "Right", "Justify")]
        [string]$HorizontalAlignment,
        [ValidateSet("Default", "Monospace")]
        [string]$FontType,
        [ValidateSet("Small", "Default", "Medium", "Large", "ExtraLarge")]
        [string]$Size,
        [ValidateSet("Lighter", "Default", "Bolder")]
        [string]$Weight,
        [Parameter(Mandatory = $false)]
        [ValidateScript( {
                foreach ($key in $_.Keys) {
                    if ($_[$key] -isnot [scriptblock]) {
                        throw "The NamedSelectActions hashtable must contain scriptblocks as values. The value for key '$key' is of type '$($_[$key].GetType().Name)'. Use the CardAction... functions to create the actions. Then use {{action:$key}} in the text to reference the action."
                    }
                }
                return $true
            })]
        [hashtable]
        $NamedSelectActions,
        [switch]$Separator

    )


    # Split the text into runs based on tags like {{bold}} and {{/bold}} or {{action:name}}
    $Inlines = [System.Collections.ArrayList]@()


    # $TestText = "{{s}}Dit{{/s}} is een {{b}}test{{/b}}{{large}} van{{/large}} een {{color:Dark}}{{italic}}RichTextBlock{{/italic}} met een actie{{/color}} en zonder."
    # $Text = $TestText

    $TagPattern = '{{(\/?)([a-zA-Z]+)(?::([^}]+))?}}'
    $TagsMatches = [regex]::Matches($Text, $TagPattern)

    #Variables to track current position
    $CurrentIndex = 0
    #Variables to function as a stack for colors to handle nested tags
    $ColorStack = [System.Collections.Stack]::new()
    #Collect all open tags to mark if they are closed properly
    $OpenTags = [System.Collections.ArrayList]@()

    if ( $TagsMatches.Count -gt 0 ) {
    }
    else {
        $CurrentText = $Text
    }
    $ActiveStyle = @{}

    foreach ($TagMatch in $TagsMatches) {

        $CurrentText = $Text.Substring($CurrentIndex, $TagMatch.Index - $CurrentIndex)

        Write-Debug "Current text segment: '$CurrentText'"
        Write-Debug "Tag found: $($TagMatch.Value) at index $($TagMatch.Index)"
        Write-Debug "Tag length: $($TagMatch.Length)"
        Write-Debug "Current index: $CurrentIndex"

        #Grab all text before the tag
        if ($CurrentText.Length -gt 0) {
            $TextRun = New-CardTextRun -Text $CurrentText @ActiveStyle
            [void]$Inlines.Add($TextRun)
        }

        $Tag = [pscustomobject]@{
            IsClosing = $TagMatch.Groups[1].Value -eq '/'
            TagName   = $TagMatch.Groups[2].Value
            Value     = $TagMatch.Groups[3].Value
            pos       = $TagMatch.Index
            length    = $TagMatch.Length
        }

        Write-Debug "Processing tag: $($Tag.TagName), IsClosing: $($Tag.IsClosing), Value: $($Tag.Value) at position $($Tag.pos)"

        #Collect all open tags
        if (-not $Tag.IsClosing) {
            [void]$OpenTags.Add($Tag)
        }
        else {
            #Test if there is a matching opening tag in the open tags collection
            if ($OpenTags.TagName -notcontains $Tag.TagName) {
                throw "Closing tag $($Tag.TagName) found without matching opening tag."
            }

            #Find the matching opening tag and remove it from the open tags collection
            for ($i = $OpenTags.Count - 1; $i -ge 0; $i--) {
                if ($OpenTags[$i].TagName -eq $Tag.TagName) {
                    [void]$OpenTags.RemoveAt($i)
                    break
                }
            }
        }

        #Process the tag
        switch ($Tag.TagName) {
            "color" {
                if (-not $Tag.IsClosing) {
                    #Test if the color is valid Adaptive Card color
                    $ValidColors = @("Default", "Dark", "Light", "Accent", "Good", "Warning", "Attention")
                    if ($ValidColors -contains $Tag.Value) {
                        $ActiveStyle["Color"] = $Tag.Value
                        $ColorStack.Push($Tag.Value)
                    }
                }
                else {
                    if ($ColorStack.Count -gt 0) {
                        [void]($ColorStack.Pop())
                    }
                    if ($ColorStack.Count -gt 0) {
                        $ActiveStyle["Color"] = $ColorStack.Peek()
                    }
                    else {
                        $ActiveStyle["Color"] = $null
                    }
                }
            }

            #Bunch of aliases for bold
            { "bold", "bolder", "strong", "b" -eq $_ } {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["Weight"] = "Bolder"
                }
                else {
                    $ActiveStyle["Weight"] = $null
                }
            }

            "lighter" {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["Weight"] = "Lighter"
                }
                else {
                    $ActiveStyle["Weight"] = $null
                }
            }

            "weight" {
                if (-not $Tag.IsClosing) {
                    #Validate weight value
                    $ValidWeights = @("Lighter", "Default", "Bolder")
                    if ($ValidWeights -contains $Tag.Value) {
                        $ActiveStyle["Weight"] = $Tag.Value
                    }
                }
                else {
                    $ActiveStyle["Weight"] = $null
                }
            }

            #Bunch of aliases for italic
            { "italic", "em", "i" -eq $_ } {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["Italic"] = $true
                }
                else {
                    $ActiveStyle["Italic"] = $null
                }
            }

            { "strikethrough", "strike", "s" -eq $_ } {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["Strikethrough"] = $true
                }
                else {
                    $ActiveStyle["Strikethrough"] = $null
                }
            }

            { "underline", "u" -eq $_ } {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["Underline"] = $true
                }
                else {
                    $ActiveStyle["Underline"] = $null
                }
            }

            { "highlight", "mark" -eq $_ } {

                if (-not $Tag.IsClosing) {
                    $ActiveStyle["Highlight"] = $true
                }
                else {
                    $ActiveStyle["Highlight"] = $null
                }
            }

            { "hidden", "invisible" -eq $_ } {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["IsVisible"] = $false
                }
                else {
                    $ActiveStyle["IsVisible"] = $null
                }
            }

            { "id" } {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["Id"] = $Tag.Value
                }
                else {
                    $ActiveStyle["Id"] = $null
                }
            }

            { "monospace", "mono", "code" -eq $_ } {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["FontType"] = "Monospace"
                }
                else {
                    $ActiveStyle["FontType"] = $null
                }
            }

            "FontType" {
                if (-not $Tag.IsClosing) {
                    #Validate FontType value
                    $ValidFontTypes = @("Default", "Monospace")
                    if ($ValidFontTypes -contains $Tag.Value) {
                        $ActiveStyle["FontType"] = $Tag.Value
                    }
                }
                else {
                    $ActiveStyle["FontType"] = $null
                }
            }

            { "lang", "language" -eq $_ } {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["Lang"] = $Tag.Value
                }
                else {
                    $ActiveStyle["Lang"] = $null
                }
            }

            { "large", "medium", "small" -eq $_ } {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["Size"] = ([System.Globalization.CultureInfo]::InvariantCulture.TextInfo).ToTitleCase($Tag.TagName)
                }
                else {
                    $ActiveStyle["Size"] = $null
                }
            }

            { "extraLarge" -eq $_ } {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["Size"] = "ExtraLarge"
                }
                else {
                    $ActiveStyle["Size"] = $null
                }
            }

            "Size" {
                if (-not $Tag.IsClosing) {
                    #Validate Size value
                    $ValidSizes = @("Small", "Default", "Medium", "Large", "ExtraLarge")
                    if ($ValidSizes -contains $Tag.Value) {
                        $ActiveStyle["Size"] = $Tag.Value
                    }
                }
                else {
                    $ActiveStyle["Size"] = $null
                }
            }

            { "sub", "subtitle", "subtle" -eq $_ } {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["IsSubtle"] = $true
                }
                else {
                    $ActiveStyle["IsSubtle"] = $null
                }
            }

            "action" {
                if (-not $Tag.IsClosing) {
                    if ($NamedSelectActions.ContainsKey($Tag.Value)) {
                        $ActiveStyle["SelectAction"] = $NamedSelectActions[$Tag.Value]
                    }
                    else {
                        throw "No SelectAction found with name '$($Tag.Value)'. Ensure that the NamedSelectActions hashtable contains an entry with this key."
                    }
                }
                else {
                    $ActiveStyle["SelectAction"] = $null
                }
            }


            default {
                Write-Warning "Unknown tag: $($Tag.TagName). Ignoring."
            }




        }

        #Update the current index to after the tag
        $CurrentIndex = $TagMatch.Index + $TagMatch.Length
    }

    #Grab any remaining text after the last tag
    $RemainingText = $Text.Substring($CurrentIndex)
    if ($RemainingText.Length -gt 0) {
        $TextRun = New-CardTextRun -Text $RemainingText @ActiveStyle
        [void]$Inlines.Add($TextRun)
    }




    $RichTextBlock = @{
        type    = "RichTextBlock"
        inlines = @()
    }

    if ($Inlines.Count -gt 0) {
        $RichTextBlock.inlines = $Inlines
    }

    if ($Id) {
        $RichTextBlock.id = $Id
    }

    if ($HorizontalAlignment) {
        $RichTextBlock.horizontalAlignment = $HorizontalAlignment
    }

    if ($FontType) {
        $RichTextBlock.fontType = $FontType
    }

    if ($Size) {
        $RichTextBlock.size = $Size
    }

    if ($Weight) {
        $RichTextBlock.weight = $Weight
    }

    if ($Separator) {
        $RichTextBlock.separator = $true
    }

    if ( $PSCmdlet.ShouldProcess("Creating RichTextBlock element with text '$Text'." ) ) {
        return $RichTextBlock
    }
}