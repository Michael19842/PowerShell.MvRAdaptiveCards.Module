function New-AdaptiveCard {
    [CmdletBinding()]
    param (
        [scriptblock]$Content,
        [switch]$SetFullWidthForTeams,
        [switch]$TestSchema,
        [switch]$AsObject
    )

    $BaseCard = @{
        type      = "AdaptiveCard"
        body      = [System.Collections.ArrayList]@()
        '$schema' = "http://adaptivecards.io/schemas/adaptive-card.json"
        version   = "1.5"
    }

    if ($SetFullWidthForTeams) {
        $BaseCard["msTeams"] = @{
            width = "Full"
        }
    }
    
    
    $ContentResult = Invoke-Command -ScriptBlock $Content 

    
    if ($ContentResult -is [array]) {
        [void]($BaseCard.body.AddRange($ContentResult))
    }
    else {
        [void]($BaseCard.body.Add($ContentResult))
    }

    
    

    #Test if the output conforms to the Adaptive Card schema
    $Json = $BaseCard | ConvertTo-Json -Depth $_MaxDepth
    
    
    if ($TestSchema) {
        
        # $SchemaUrl = "http://adaptivecards.io/schemas/adaptive-card.json"
        # $Schema = (Invoke-WebRequest -Uri $SchemaUrl).Content 

        #The manifest schema is stored locally to avoid dependency on internet access and mitigate inconsistencies in the schema
        

        $IsValid = Test-CardSchema -Json $Json -ShowErrors:$false

    }
    if ($AsObject) {
        return $BaseCard
    }
    return $Json
}