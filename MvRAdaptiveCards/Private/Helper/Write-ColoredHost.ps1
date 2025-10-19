function Write-ColoredHost {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'This function is specifically designed to write colored output to the host')]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Text,
        [switch]$NoNewLine
    )

    # Detect tags in the text to change the color {red} for foreground and {RED} for background
    $Pattern = '\{([a-zA-Z]+)\}'

    $Segments = [System.Text.RegularExpressions.Regex]::Split($Text, $Pattern)

    $CurrentForeground = $Host.UI.RawUI.ForegroundColor
    $CurrentBackground = $Host.UI.RawUI.BackgroundColor


    for ($i = 0; $i -lt $Segments.Length; $i++) {
        $Segment = $Segments[$i]

        #Test if the segment is a system.ConsoleColor
        if ([Enum]::TryParse([System.ConsoleColor], $Segment, $true, [ref]$null)) {
            # Change the color
            $Color = [Enum]::Parse([System.ConsoleColor], $Segment, $true)
            if ($Segment -cmatch '^[A-Z]+$') {
                # Background color
                $Host.UI.RawUI.BackgroundColor = $Color
            }
            else {
                # Foreground color
                $Host.UI.RawUI.ForegroundColor = $Color
            }
        }
        else {
            # Regular text segment, write it to the host
            Write-Host -NoNewline $Segment
        }

    }

    if (-not $NoNewLine) {
        Write-Host ""
    }
    $host.UI.RawUI.ForegroundColor = $CurrentForeground
    $host.UI.RawUI.BackgroundColor = $CurrentBackground
}