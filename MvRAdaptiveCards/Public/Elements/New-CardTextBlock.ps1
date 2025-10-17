function New-CardTextBlock {
    param (
        [string]
        $Text,
        [string]
        $Size = "Default",
        [string]
        $Weight = "Default",
        [string]
        [ValidateSet("Default", "Dark", "Light", "Accent", "Good", "Warning", "Attention")]
        $Color = "Default",
        [string]
        [Parameter(Mandatory = $false)]
        $Id,
        [switch]
        $Wrap 
    )

    $TextBlock = @{
        type = "TextBlock"
        text = $Text
        size = $Size
        weight = $Weight
        color = $Color
    }
    if ($Id) {
        $TextBlock.id = $Id
    }
    if ($Wrap) {
        $TextBlock.wrap = $true
    }

    Return ($TextBlock)
}