function New-CardContainer {
    param (
        [scriptblock]$Content,
        
        [string]
        [ValidateSet("Default", "Emphasis", "Attention", "Good", "Warning")]
        $Style = "Default",

        [string]
        [Parameter(Mandatory = $false)]
        $Id
    )

    $Container = @{
        type = "Container"
        items = [System.Collections.ArrayList]@()
    }

    if ($Style -ne "Default") {
        $Container.style = $Style
    }

    if ($Id) {
        $Container.id = $Id
    }

    $ContentResult = Invoke-Command -ScriptBlock $Content

    if ($ContentResult -is [array]) {
        [void]($Container.items.AddRange($ContentResult))
    }
    else {
        [void]($Container.items.Add($ContentResult))
    }

    Return ($Container)
}