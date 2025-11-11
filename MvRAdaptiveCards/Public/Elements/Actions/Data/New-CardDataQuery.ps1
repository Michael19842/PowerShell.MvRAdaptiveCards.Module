<#
.SYNOPSIS
Creates a new Data.Query object for dynamic data fetching in Adaptive Cards.

.DESCRIPTION
The New-CardDataQuery function creates a Data.Query object that defines how to fetch
dynamic data from a backend service or bot. This is typically used with Input.ChoiceSet
elements to provide dynamic choices based on user input or external data sources.

Data.Query objects are commonly used in Microsoft Teams scenarios where choices
need to be populated dynamically from a bot or external API.

.PARAMETER Dataset
The name or identifier of the dataset from which to fetch the data. This should
correspond to a dataset that your bot or backend service can handle.

.PARAMETER AssociatedInputs
Controls which input values are sent along with the query to enable filtering:
- "auto": All input values in the card are sent (default)
- "none": No input values are sent, query is executed independently

.PARAMETER Count
The maximum number of data items that should be returned by the query.
Note: This is typically set by the client for pagination purposes and
Should not be specified by card authors in most cases.

.PARAMETER Skip
The number of data items to skip (for pagination).
Note: This is typically set by the client for pagination purposes and
Should not be specified by card authors in most cases.

.OUTPUTS
System.Collections.Hashtable
Returns a hashtable representing the Data.Query structure for the Adaptive Card.

.EXAMPLE
New-CardDataQuery -Dataset "products"

Creates a basic data query for the "products" dataset with automatic input association.

.EXAMPLE
New-CardDataQuery -Dataset "users" -AssociatedInputs "none"

Creates a data query that fetches from the "users" dataset without sending any input values.

.EXAMPLE
# Used with Input.ChoiceSet for dynamic choices
New-CardInputChoiceSet -Id "category" -Label "Select Category" -Choices @{
    data = New-CardDataQuery -Dataset "categories" -AssociatedInputs "auto"
}

.EXAMPLE
New-CardDataQuery -Dataset "searchResults" -Count 50

Creates a data query with a specific maximum count (typically used by clients for pagination).

.NOTES
- Data.Query is primarily used in Microsoft Teams and other bot-enabled environments
- The Count and Skip parameters are usually managed by the client for pagination
- Card authors should primarily focus on Dataset and AssociatedInputs parameters
- The backend service must be configured to handle the specified dataset
- This feature requires Adaptive Cards schema version 1.5 or later

.LINK
New-CardInputChoiceSet
https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#dataquery

#>
function New-CardDataQuery {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Dataset,

        [Parameter(Mandatory = $false)]
        [ValidateSet("auto", "none")]
        [string]$AssociatedInputs = "auto",

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$Count,

        [Parameter(Mandatory = $false)]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$Skip
    )

    # Create base Data.Query object
    $DataQuery = @{
        type    = "Data.Query"
        dataset = $Dataset
    }

    # Add optional parameters only if specified
    if ($PSBoundParameters.ContainsKey('AssociatedInputs')) {
        $DataQuery.associatedInputs = $AssociatedInputs
    }

    if ($PSBoundParameters.ContainsKey('Count')) {
        $DataQuery.count = $Count
    }

    if ($PSBoundParameters.ContainsKey('Skip')) {
        $DataQuery.skip = $Skip
    }

    # Create description for ShouldProcess
    $description = "Creating Data.Query for dataset '$Dataset'"
    if ($PSBoundParameters.ContainsKey('AssociatedInputs')) {
        $description += " (associatedInputs: $AssociatedInputs)"
    }
    if ($PSBoundParameters.ContainsKey('Count')) {
        $description += " (count: $Count)"
    }

    if ($PSCmdlet.ShouldProcess($description)) {
        return $DataQuery
    }
}