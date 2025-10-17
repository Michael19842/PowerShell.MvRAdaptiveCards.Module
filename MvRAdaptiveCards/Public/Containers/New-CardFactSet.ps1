function New-CardFactSet {
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Hashtable')]
        [hashtable]$Facts,
        # Future parameter sets can be added here for different input types
        [Parameter(Mandatory = $true, ParameterSetName = 'Object')]
        [object]$Object,
        [string]
        [Parameter(Mandatory = $false, ParameterSetName = 'Hashtable')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Object')]
        $Id,
        [parameter(ParameterSetName = 'Object')]
        [switch]$EveryProperty    )


    $FactSet = @{
        type = "FactSet"
        facts = @()
    }
    if ($Id) {
        $FactSet.id = $Id
    }


    if ($PSCmdlet.ParameterSetName -eq 'Object') {
        # Convert object properties to hashtable
        $Facts = @{}
        $Object | Get-Member | ForEach-Object {
            if(($EveryProperty -or ($_.MemberType -eq 'NoteProperty')) -and $null -ne $_.Name  ) {
                if($null -eq $Object.$($_.Name)) {
                    $Facts[$_.Name] = ''
                    return
                } ELSE {
                $Facts[$_.Name] = $Object.$($_.Name).ToString()
                }
            }

        }
    }

    foreach ($Key in $Facts.Keys) {
        $FactSet.facts += @{
            title = $Key
            value = $Facts[$Key].ToString()
        }
    }

    return $FactSet
}