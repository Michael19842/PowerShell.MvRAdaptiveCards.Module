

function New-CardWizard {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [object[]]$WizardPages,

        $NextButtonText = "Next",
        $BackButtonText = "Back",
        $FinishButtonText = "Finish",
        $CancelButtonText = "Cancel",

        [switch]$NoCancelButton,
        [switch]$NoBackButton
    )



    $WizardResponse = [System.Collections.ArrayList]@()


    foreach ($page in $WizardPages) {

        #Enumerate pages to make navigation possible
        $CurrentPageIndex = $WizardPages.IndexOf($page)

        [void]($WizardResponse.Add((
                    New-CardContainer -Items {
                        if ($page -is [scriptblock]) {
                            Invoke-Command -ScriptBlock $page
                        }
                        elseif ($page -is [string]) {
                            New-CardTextBlock -Text $page -Wrap
                        }
                        # Add the buttons to navigate between pages
                        New-CardActionSet -Actions {
                            if (-not $NoBackButton -and $CurrentPageIndex -gt 0) {
                                New-CardActionToggleVisibility -Title $BackButtonText -TargetElements ("Page" + $CurrentPageIndex.ToString()), ("Page" + ($CurrentPageIndex - 1).ToString()) -Style "Default"
                            }
                            if ($CurrentPageIndex -lt ($WizardPages.Count - 1)) {
                                New-CardActionToggleVisibility -Title $NextButtonText -TargetElements ("Page" + $CurrentPageIndex.ToString()), ("Page" + ($CurrentPageIndex + 1).ToString()) -Style "Positive"
                            }
                            else {
                                New-CardActionSubmit -Title $FinishButtonText -Style "Positive"
                            }
                            if (-not $NoCancelButton) {
                                New-CardActionSubmit -Title $CancelButtonText -Data @{ Action = "Cancel" } -Style "Destructive"
                            }
                        }

                    } -Id ("Page" + ($CurrentPageIndex).ToString()) -Hidden:($CurrentPageIndex -ne 0))))
    }

    if ($PSCmdlet.ShouldProcess("Creating Wizard with $($WizardPages.Count) pages")) {
        return $WizardResponse
    }

}