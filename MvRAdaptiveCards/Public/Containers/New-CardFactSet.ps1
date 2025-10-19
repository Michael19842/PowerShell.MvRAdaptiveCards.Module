<#
.SYNOPSIS
    Creates a new FactSet element for an Adaptive Card to display key-value pairs.

.DESCRIPTION
    The New-CardFactSet function creates a FactSet element that displays information as a series of
    title-value pairs in a structured format. It supports input from hashtables or PowerShell objects,
    automatically converting object properties to facts for display.

.PARAMETER Facts
    A hashtable containing key-value pairs to display as facts. Each key becomes the title
    and the corresponding value becomes the fact value. This parameter is used with the 'Hashtable' parameter set.

.PARAMETER Object
    A PowerShell object whose properties will be converted to facts. By default, only NoteProperties
    are included unless the EveryProperty switch is specified. This parameter is used with the 'Object' parameter set.

.PARAMETER Id
    An optional unique identifier for the FactSet element. Useful for referencing the element
    in actions like toggle visibility or for accessibility purposes.

.PARAMETER EveryProperty
    A switch parameter available only when using the Object parameter. When specified, includes all
    property types from the object (not just NoteProperties) in the fact set.

.OUTPUTS
    System.Collections.Hashtable
        Returns a hashtable representing the FactSet element structure for the Adaptive Card.

.EXAMPLE
    New-CardFactSet -Facts @{
        "Name" = "John Doe"
        "Department" = "Engineering"
        "Start Date" = "2020-01-15"
        "Employee ID" = "EMP001"
    }

    Creates a fact set from a hashtable displaying employee information.

.EXAMPLE
    $process = Get-Process -Name "notepad" | Select-Object -First 1
    New-CardFactSet -Object $process -Id "ProcessInfo"

    Creates a fact set from a process object, showing its NoteProperties with an assigned ID.

.EXAMPLE
    $fileInfo = Get-Item "C:\temp\file.txt"
    New-CardFactSet -Object $fileInfo -EveryProperty

    Creates a fact set from a file object, including all properties (not just NoteProperties).

.EXAMPLE
    New-CardFactSet -Facts @{
        "Status" = "Online"
        "Last Backup" = (Get-Date).ToString("yyyy-MM-dd HH:mm")
        "Size" = "2.5 GB"
    } -Id "SystemStatus"

    Creates a fact set with system status information, including formatted dates and emojis.

.NOTES
    - The function uses parameter sets to handle different input types (hashtable vs object)
    - When using Object parameter, null values are converted to empty strings
    - All values are converted to strings for display in the fact set
    - The EveryProperty switch allows inclusion of all object members, not just NoteProperties
    - Facts are displayed in the order they appear in the input (hashtable key order or object property order)

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#factset
#>
function New-CardFactSet {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
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
        type  = "FactSet"
        facts = @()
    }
    if ($Id) {
        $FactSet.id = $Id
    }


    if ($PSCmdlet.ParameterSetName -eq 'Object') {
        # Convert object properties to hashtable
        $Facts = @{}
        $Object | Get-Member | ForEach-Object {
            if (($EveryProperty -or ($_.MemberType -eq 'NoteProperty')) -and $null -ne $_.Name  ) {
                if ($null -eq $Object.$($_.Name)) {
                    $Facts[$_.Name] = ''
                    return
                }
                else {
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

    if ($PSCmdlet.ShouldProcess("Creating FactSet element with ID '$Id'.")) {
        return $FactSet
    }
}