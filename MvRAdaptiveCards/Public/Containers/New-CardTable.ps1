<#
.SYNOPSIS
    Creates a new Table element for an Adaptive Card from a collection of objects or hashtables.

.DESCRIPTION
    The New-CardTable function creates a Table element that displays tabular data in an Adaptive Card.
    It automatically generates columns and rows from PowerShell objects or hashtables, with support for
    custom column definitions, header control, and dynamic content including ScriptBlocks for complex cell content.

.PARAMETER Collection
    An array of objects or hashtables that will be displayed as table rows. The function automatically
    detects the type and extracts properties or keys to create the table structure.
    - For hashtables: Uses the keys from the first hashtable as column headers
    - For objects: Uses the NoteProperty names from the first object as column headers

.PARAMETER CustomColums
    An array of hashtables defining custom column properties. Each hashtable can contain:
    - Name: The property/key name to match (required)
    - width: Relative width of the column (e.g., 1, 2, 3 for proportional sizing)
    - Other column properties supported by Adaptive Cards
    
    If not specified for a column, default width of 1 is used.

.PARAMETER NoHeader
    A switch parameter that suppresses the generation of header row. When specified,
    the table will display only data rows without column headers.

.PARAMETER Id
    An optional unique identifier for the table element. Useful for referencing the table
    in actions like toggle visibility or for accessibility purposes.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the Table element structure for the Adaptive Card.

.EXAMPLE
    $data = @(
        @{Name = "John"; Age = 30; City = "New York"},
        @{Name = "Jane"; Age = 25; City = "Boston"},
        @{Name = "Bob"; Age = 35; City = "Chicago"}
    )
    New-CardTable -Collection $data
    
    Creates a table with automatic headers (Name, Age, City) and default column widths.

.EXAMPLE
    $users = Get-Process | Select-Object Name, CPU, WorkingSet -First 5
    New-CardTable -Collection $users -CustomColums @(
        @{Name = "Name"; width = 2},
        @{Name = "CPU"; width = 1},
        @{Name = "WorkingSet"; width = 2}
    )
    
    Creates a table from process objects with custom column widths (Name and WorkingSet twice as wide as CPU).

.EXAMPLE
    New-CardTable -Collection $data -NoHeader -Id "DataTable"
    
    Creates a table without headers and assigns an ID for potential reference in actions.

.EXAMPLE
    $complexData = @(
        @{
            Name = "User 1"
            Status = { New-CardTextBlock -Text "✅ Active" -Color "Good" }
            Details = "Regular user"
        }
    )
    New-CardTable -Collection $complexData
    
    Creates a table where the Status column contains a ScriptBlock that generates a colored text block,
    demonstrating support for complex cell content.

.NOTES
    - The function automatically detects whether the input is hashtables or objects
    - ScriptBlocks in cell values are executed to generate dynamic content
    - Custom column definitions only need to specify the properties you want to override
    - The firstRowAsHeaders property is automatically set based on the NoHeader parameter
    - Column widths are relative values (1, 2, 3, etc.) that determine proportional sizing

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#table
#>
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