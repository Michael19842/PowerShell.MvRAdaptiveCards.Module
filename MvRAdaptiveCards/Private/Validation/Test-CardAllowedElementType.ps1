function Test-CardAllowedElementType {
    param (
        $TestedContent,
        [string]$ElementType,
        [string[]]$AllowedElementTypes,
        [string[]]$DisallowedElementTypes
    )

    Write-Verbose "Testing allowed element types for '$ElementType'."


    # Validate the content against allowed element types
    foreach ($element in $TestedContent) {
        Write-Verbose "Validating element of type '$($element.type)' in '$ElementType'."
        if ($element.type -and ($DisallowedElementTypes -contains $element.type)) {
            Write-Error "Element type '$($element.type)' is not in the allowed in '$ElementType'."
            return $false
        }
        if ($element.type -and -not ($AllowedElementTypes -contains $element.type)) {
            Write-Error "Element type '$($element.type)' is not in the allowed in '$ElementType'. Please use one of the following types: $($AllowedElementTypes -join ', ')"
            return $false
        }
    }

    return $true
}