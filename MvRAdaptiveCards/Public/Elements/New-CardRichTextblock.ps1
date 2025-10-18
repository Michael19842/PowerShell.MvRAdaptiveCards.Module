function New-CardRichTextBlock {
    param (
        [Parameter(Mandatory = $true)]
        [string] 
        $Text,
        [string]
        [Parameter(Mandatory = $false)]
        $Id,
        [ValidateSet("Left","Center","Right","Justify")]
        [string]$HorizontalAlignment,
        [ValidateSet("Default","Monospace")]
        [string]$FontType,
        [ValidateSet("Small","Default","Medium","Large","ExtraLarge")]
        [string]$Size,
        [ValidateSet("Lighter","Default","Bolder")]
        [string]$Weight,
        [Parameter(Mandatory = $false)]
        [ValidateScript( {
            foreach ($key in $_.Keys) {
                if($_[$key] -isnot [scriptblock]) {
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
    
    If( $TagsMatches.Count -gt 0 ) {
    }
    else {
        $CurrentText = $Text
    }
    $ActiveStyle = @{}
    
    foreach ($TagMatch in $TagsMatches) {

        $CurrentText = $Text.Substring($CurrentIndex, $TagMatch.Index - $CurrentIndex)

        write-Host "Current text segment: '$CurrentText'"
        Write-Host "Tag found: $($TagMatch.Value) at index $($TagMatch.Index)"
        Write-Host "Tag length: $($TagMatch.Length)"
        Write-Host "Current index: $CurrentIndex"

        #Grab all text before the tag
        if ($CurrentText.Length -gt 0) {
            $TextRun = New-CardTextRun -Text $CurrentText @ActiveStyle
            [void]$Inlines.Add($TextRun)
        }
        
        $Tag = [pscustomobject]@{
            IsClosing = $TagMatch.Groups[1].Value -eq '/'
            TagName = $TagMatch.Groups[2].Value
            Value = $TagMatch.Groups[3].Value
            pos = $TagMatch.Index
            length = $TagMatch.Length
        }
        
        Write-Host "Processing tag: $($Tag.TagName), IsClosing: $($Tag.IsClosing), Value: $($Tag.Value) at position $($Tag.pos)"
        
        #Collect all open tags
        if (-not $Tag.IsClosing) {
            [void]$OpenTags.Add($Tag)
        }
        else {
            #Test if there is a matching opening tag in the open tags collection
            If($OpenTags.TagName -notcontains $Tag.TagName) {
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
                    $ValidColors = @("Default","Dark","Light","Accent","Good","Warning","Attention")
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
            {"bold","bolder","strong","b" -eq $_} {
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
                    $ValidWeights = @("Lighter","Default","Bolder")
                    if ($ValidWeights -contains $Tag.Value) {
                        $ActiveStyle["Weight"] = $Tag.Value
                    }
                } 
                else {
                    $ActiveStyle["Weight"] = $null
                }
            }

            #Bunch of aliases for italic
            {"italic","em","i" -eq $_} {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["Italic"] = $true
                } 
                else {
                    $ActiveStyle["Italic"] = $null
                }
            }

            {"strikethrough","strike","s" -eq $_} {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["Strikethrough"] = $true
                } 
                else {
                    $ActiveStyle["Strikethrough"] = $null
                }
            }

            {"underline","u" -eq $_} {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["Underline"] = $true
                } 
                else {
                    $ActiveStyle["Underline"] = $null
                }
            }

            {"highlight","mark" -eq $_} {

                if (-not $Tag.IsClosing) {
                    $ActiveStyle["Highlight"] = $true
                } 
                else {
                    $ActiveStyle["Highlight"] = $null
                }
            }

            {"hidden","invisible" -eq $_} {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["IsVisible"] = $false
                } 
                else {
                    $ActiveStyle["IsVisible"] = $null
                }
            }

            {"id"} {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["Id"] = $Tag.Value
                } 
                else {
                    $ActiveStyle["Id"] = $null
                }
            }

            {"monospace","mono","code" -eq $_} {
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
                    $ValidFontTypes = @("Default","Monospace")
                    if ($ValidFontTypes -contains $Tag.Value) {
                        $ActiveStyle["FontType"] = $Tag.Value
                    }
                } 
                else {
                    $ActiveStyle["FontType"] = $null
                }
            }

            {"lang","language" -eq $_} {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["Lang"] = $Tag.Value
                } 
                else {
                    $ActiveStyle["Lang"] = $null
                }
            }

            {"large","medium","small" -eq $_} {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["Size"] = ([System.Globalization.CultureInfo]::InvariantCulture.TextInfo).ToTitleCase($Tag.TagName)
                } 
                else {
                    $ActiveStyle["Size"] = $null
                }
            }

            {"extraLarge" -eq $_} {
                if (-not $Tag.IsClosing) {
                    $ActiveStyle["Size"] = "ExtraLarge"
                } 
                else {
                    $ActiveStyle["Size"] = $null
                }
            }

            "Size"{
                if (-not $Tag.IsClosing) {
                    #Validate Size value
                    $ValidSizes = @("Small","Default","Medium","Large","ExtraLarge")
                    if ($ValidSizes -contains $Tag.Value) {
                        $ActiveStyle["Size"] = $Tag.Value
                    }
                } 
                else {
                    $ActiveStyle["Size"] = $null
                }
            }

            {"sub","subtitle","subtle" -eq $_} {
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

    return $RichTextBlock
}