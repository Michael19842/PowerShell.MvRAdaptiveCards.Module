<#
.SYNOPSIS
    Helper functions for testing the MvRAdaptiveCards module.

.DESCRIPTION
    This file contains utility functions to support testing, including the ability
    to access private module functions for unit testing purposes.
#>

<#
.SYNOPSIS
    Gets a private function from the MvRAdaptiveCards module for testing.

.DESCRIPTION
    Retrieves a private function from the module using PowerShell's ability to access
    module-scoped commands. This allows unit testing of private helper functions.

.PARAMETER FunctionName
    The name of the private function to retrieve.

.EXAMPLE
    $convertFunc = Get-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable'
    & $convertFunc -InputObject '{"key":"value"}'

.NOTES
    This function uses the module's internal scope to access private functions.
    Should only be used for testing purposes.
#>
function Get-PrivateFunction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$FunctionName
    )

    $module = Get-Module -Name 'MvRAdaptiveCards'
    if (-not $module) {
        throw "MvRAdaptiveCards module is not loaded. Please import the module first."
    }

    # Try to get the function from the module's internal scope
    $function = & $module { param($name) Get-Command -Name $name -ErrorAction SilentlyContinue } $FunctionName

    if (-not $function) {
        throw "Private function '$FunctionName' not found in the MvRAdaptiveCards module."
    }

    return $function
}

<#
.SYNOPSIS
    Invokes a private function from the MvRAdaptiveCards module.

.DESCRIPTION
    Calls a private function from the module with the provided parameters.
    This is a convenience wrapper around Get-PrivateFunction.

.PARAMETER FunctionName
    The name of the private function to invoke.

.PARAMETER Parameters
    A hashtable of parameters to pass to the function.

.PARAMETER ArgumentList
    An array of positional arguments to pass to the function.

.EXAMPLE
    Invoke-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable' -Parameters @{ InputObject = '{"key":"value"}' }

.EXAMPLE
    Invoke-PrivateFunction -FunctionName 'IIF' -ArgumentList $true, 'Yes', 'No'

.NOTES
    This function uses the module's internal scope to access private functions.
    Should only be used for testing purposes.
#>
function Invoke-PrivateFunction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$FunctionName,

        [Parameter(Mandatory = $false)]
        [hashtable]$Parameters,

        [Parameter(Mandatory = $false)]
        [object[]]$ArgumentList
    )

    $module = Get-Module -Name 'MvRAdaptiveCards'
    if (-not $module) {
        throw "MvRAdaptiveCards module is not loaded. Please import the module first."
    }

    try {
        if ($Parameters) {
            return & $module { param($name, $params) & $name @params } $FunctionName $Parameters
        }
        elseif ($ArgumentList) {
            return & $module { param($name, $argList) & $name @argList } $FunctionName $ArgumentList
        }
        else {
            return & $module { param($name) & $name } $FunctionName
        }
    }
    catch {
        throw "Error invoking private function '$FunctionName': $_"
    }
}

<#
.SYNOPSIS
    Tests if a private function exists in the module.

.DESCRIPTION
    Checks whether a private function with the given name exists in the MvRAdaptiveCards module.

.PARAMETER FunctionName
    The name of the private function to test.

.EXAMPLE
    Test-PrivateFunction -FunctionName 'ConvertFrom-JsonAsHashtable'

.OUTPUTS
    System.Boolean
    Returns $true if the function exists, $false otherwise.
#>
function Test-PrivateFunction {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$FunctionName
    )

    $module = Get-Module -Name 'MvRAdaptiveCards'
    if (-not $module) {
        return $false
    }

    $function = & $module { param($name) Get-Command -Name $name -ErrorAction SilentlyContinue } $FunctionName

    return $null -ne $function
}
