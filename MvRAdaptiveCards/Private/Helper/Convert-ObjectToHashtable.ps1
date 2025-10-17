function Convert-ObjectToHashtable {
    param (
        [Parameter(Mandatory = $true)]
        [object]$Object
    )

    if ($Object -is [System.Collections.IDictionary]) {
        $Hashtable = @{}
        foreach ($Key in $Object.Keys) {
            $Hashtable[$Key] = Convert-ObjectToHashtable -Object $Object[$Key]
        }
        return $Hashtable
    }
    elseif ($Object -is [System.Collections.IEnumerable] -and -not ($Object -is [string])) {
        $Array = @()
        foreach ($Item in $Object) {
            $Array += Convert-ObjectToHashtable -Object $Item
        }
        return $Array
    }
    else {
        return $Object
    }
}