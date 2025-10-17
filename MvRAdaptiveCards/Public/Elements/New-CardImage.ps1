Function New-CardImage {
    param(
        [string]$Url,
        [string]$AltText,
        [ValidateSet("Cover","Contain","Fill")]
        [string]$FitMode,
        [ValidateSet("Auto","Stretch","Small","Medium","Large")]
        [string]$Size,
        [string]
        [Parameter(Mandatory = $false)]
        $Id,
        [switch]$Separator, 
        [switch]$AllowExpand
        
    )

    $Image = @{
        type    = "Image"
        url     = $Url
        altText = $AltText
    }
    if ($Separator) {
        $Image.separator = $true
    }
    
    if ($FitMode) {
        $Image.fitMode = $FitMode
    }

    if ($Id) {
        $Image.id = $Id
    }
    
    if ($Size) {
        $Image.size = $Size
    }

    if ($AllowExpand) {
        $Image.allowExpand = $true
    }

    return $Image

}