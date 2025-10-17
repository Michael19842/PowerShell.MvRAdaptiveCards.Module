function New-CardTable {
    param (
        [array]$Collection,
        [array]$CustomColums = @(),  
        [switch]$NoHeader,

        [string]
        [Parameter(Mandatory = $false)]
        $Id
         
    )

    $Table = @{
        type              = "Table"
        rows              = [System.Collections.ArrayList]@()
        columns           = [System.Collections.ArrayList]@()
        firstRowAsHeaders = -not $NoHeader
    }

    if ($Id) {
        $Table.id = $Id
    }

    # Test if the collection is an array of objects or an array of hashtables
    if ($Collection[0] -is [hashtable]) {
        #Grab the keys from the first hashtable as headers
        $Headers = $Collection[0].Keys
    }
    elseif ($Collection[0] -is [psobject]) {
        #Grab the property names from the first object as headers
        $Headers = $Collection[0] | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
    }
    else {
        throw "The collection must be an array of hashtables or an array of objects."
    }
        
    foreach ($Header in $Headers) {
        $ThisCustomColumn = $CustomColums | Where-Object { $_.Name -eq $Header }
        # If a custom column definition is found, use it. Otherwise, use a default column definition
        if ($ThisCustomColumn) {
            [void]($Table.columns.add( ($ThisCustomColumn | Select-Object -ExcludeProperty Name )))
        }
        else {
            [void]($Table.columns.Add(  @{ width = 1 }))
        }
    }

    # Add the header row if needed
    if (-not $NoHeader) {
        
        $HeaderRow = @{
            type  = "TableRow"
            cells = @()
        }
        foreach ($Header in $Headers) {
            $HeaderRow.cells += @{
                type  = "TableCell"
                items = @(@{
                        type   = "TextBlock"
                        text   = $Header
                        weight = "Bolder"
                        wrap   = $true
                    })
            }
        }
        [void]($Table.rows.Add($HeaderRow))
    }

    foreach ($Item in $Collection) {
        $DataRow = @{
            type  = "TableRow"
            cells = @()
        }
        foreach ($Header in $Headers) {
            $CellContent = if ($Item -is [hashtable]) { 
                $Item[$Header]
            }
            else { $Item.$Header }

            $DataRow.cells += 
            switch ($CellContent) {
                { $_ -is [scriptblock] } {
                    @{
                        type  = "TableCell"
                        items = @(
                            Invoke-Command -ScriptBlock $CellContent
                        )
                    }
                }
                default {
                    @{
                        type  = "TableCell"
                        items = @(@{
                                type = "TextBlock"
                                text = if ($null -ne $CellContent) { $CellContent.ToString() } else { "" }
                                wrap = $true
                            })
                    } 
                }
            }
            
        }
        [void]($Table.rows.Add($DataRow))

    }

    return $Table
}