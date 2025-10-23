function New-CardLayoutStack {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet("VeryNarrow", "Narrow", "Standard", "Wide", "atLeast:VeryNarrow", "atMost:VeryNarrow", "atLeast:Narrow", "atMost:Narrow", "atLeast:Standard", "atMost:Standard", "atLeast:Wide", "atMost:Wide")]
        $TargetWidth
    )
    $LayoutStack = @{
        type = "StackLayout"
    }
    if ($TargetWidth) {
        $LayoutStack.targetWidth = $TargetWidth
    }

    if ($PSCmdlet.ShouldProcess("Creating Layout Stack")) {
        return $LayoutStack
    }

}