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
    A unique identifier for the FactSet element. Useful for referencing the element
    in actions like toggle visibility or for accessibility purposes.

.PARAMETER Language
    Specifies the language/locale for the FactSet element. Used for proper text rendering
    and accessibility features. Alias: Lang

.PARAMETER TargetWidth
    Specifies the target width for the FactSet in adaptive layouts. Valid values include:
    - VeryNarrow, Narrow, Standard, Wide
    - atLeast:VeryNarrow, atMost:VeryNarrow, etc.

.PARAMETER Height
    Controls the height behavior of the FactSet. Valid values are:
    - Auto: Height adjusts automatically to content (default)
    - Stretch: FactSet stretches to fill available vertical space

.PARAMETER Requires
    A hashtable specifying feature requirements for the FactSet. Used to declare dependencies
    on specific Adaptive Card features or host capabilities.

.PARAMETER Fallback
    A scriptblock that defines fallback content to display if the FactSet cannot be rendered
    or is not supported by the host. Should return an appropriate Adaptive Card element.

.PARAMETER GridArea
    Specifies the named grid area where the FactSet should be placed when used in a grid layout.
    This corresponds to the CSS grid-area property.

.PARAMETER Spacing
    Controls the amount of spacing above the FactSet. Valid values are:
    - None: No spacing
    - Small: Small spacing
    - Default: Default spacing
    - Medium: Medium spacing
    - Large: Large spacing
    - ExtraLarge: Extra large spacing
    - Padding: Adds padding around the element

.PARAMETER EveryProperty
    A switch parameter available only when using the Object parameter. When specified, includes all
    property types from the object (not just NoteProperties) in the fact set.

.PARAMETER Separator
    When specified, adds a separator line above the FactSet to visually separate it from
    preceding content.

.PARAMETER IsSortKey
    When specified, marks this FactSet as a sort key element. Used in scenarios where
    multiple elements need to be sorted or grouped.

.PARAMETER IsHidden
    When specified, sets the FactSet to be hidden (isVisible = false). The element will
    not be displayed but can be shown programmatically. Alias: Hide

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

    Creates a fact set with system status information, including formatted dates.

.EXAMPLE
    New-CardFactSet -Facts @{
        "Server" = "WEB-01"
        "Status" = "Running"
        "Uptime" = "15 days"
    } -Spacing "Medium" -Separator -Height "Auto"

    Creates a fact set with spacing, separator, and specific height behavior.

.EXAMPLE
    $user = [PSCustomObject]@{
        Username = "jdoe"
        FullName = "John Doe"
        Department = "IT"
        LastLogin = Get-Date
    }
    New-CardFactSet -Object $user -Language "en-US" -GridArea "user-info"

    Creates a fact set from a custom object with language and grid positioning.

.NOTES
    - The function uses parameter sets to handle different input types (hashtable vs object)
    - When using Object parameter, null values are converted to empty strings
    - All values are converted to strings for display in the fact set
    - The EveryProperty switch allows inclusion of all object members, not just NoteProperties
    - Facts are displayed in the order they appear in the input (hashtable key order or object property order)
    - TargetWidth helps with responsive design by specifying width breakpoints
    - Height parameter controls vertical space usage, with "Stretch" filling available space
    - GridArea enables precise positioning in grid-based layouts
    - Spacing and Separator help with visual organization and hierarchy

.LINK
    https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/card-schema#factset
#>
function New-CardFactSet {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Hashtable', Position = 0)]
        [hashtable]$Facts,
        # Future parameter sets can be added here for different input types
        [Parameter(Mandatory = $true, ParameterSetName = 'Object', Position = 0)]
        [object]$Object,

        [Parameter(Mandatory = $false)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [Alias('Lang')]
        [string]$Language,

        [parameter(Mandatory = $false)]
        [ValidateSet("VeryNarrow", "Narrow", "Standard", "Wide", "atLeast:VeryNarrow", "atMost:VeryNarrow", "atLeast:Narrow", "atMost:Narrow", "atLeast:Standard", "atMost:Standard", "atLeast:Wide", "atMost:Wide")]
        [string]$TargetWidth,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Auto", "Stretch")]
        [string]$Height,

        [Parameter(Mandatory = $false)]
        [hashtable]$Requires,

        [Parameter(Mandatory = $false)]
        [scriptblock]$Fallback,

        [Parameter(Mandatory = $false)]
        [string]$GridArea,

        [Parameter(Mandatory = $false)]
        [ValidateSet("None", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")]
        [string]$Spacing,

        [parameter(ParameterSetName = 'Object')]
        [switch]$EveryProperty,

        [switch]$Separator,


        [switch]$IsSortKey,

        [Alias('Hide')]
        [switch]$IsHidden
    )


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
                    $Facts[$_.Name] = $Object.$($_.Name)
                }
            }

        }
    }

    foreach ($Key in $Facts.Keys) {
        if ($null -eq $Facts[$Key]) {
            $FactSet.facts += @{
                title = $Key
                value = ''
            }
        }
        elseif ($Facts[$Key] -is [array]) {
            # Write-Host "Key '$Key' has an array value. Joining elements with a comma."

            $FactSet.facts += @{
                title = $Key
                value = ($Facts[$Key] -join ',')
            }
        }
        else {
            $FactSet.facts += @{
                title = $Key
                value = $Facts[$Key].ToString()
            }
        }
    }
    if ($Fallback) {
        $FactSet.fallback = Invoke-Command -ScriptBlock $Fallback
    }
    if ($GridArea) {
        $FactSet.gridArea = $GridArea
    }
    if ($IsHidden) {
        $FactSet.isVisible = $false
    }
    if ($IsSortKey) {
        $FactSet.isSortKey = $true
    }
    if ($Separator) {
        $FactSet.separator = $true
    }
    if ($Requires) {
        $FactSet.requires = $Requires
    }
    if ($Height) {
        $FactSet.height = $Height
    }
    if ($Language) {
        $FactSet.lang = $Language
    }
    if ($Spacing) {
        $FactSet.spacing = $Spacing
    }
    if ($TargetWidth) {
        $FactSet.targetWidth = $TargetWidth
    }


    if ($PSCmdlet.ShouldProcess("Creating FactSet element with ID '$Id'.")) {
        return $FactSet
    }
}