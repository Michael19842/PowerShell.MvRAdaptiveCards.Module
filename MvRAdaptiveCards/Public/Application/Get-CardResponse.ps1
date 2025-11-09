function Get-CardResponse {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Variable used in template')]
    [system.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Settings variable used in module')]
    [system.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseUsingScopeModifierInNewRunspaces', '', Justification = 'Variable used in runspace via parameter')]
    param (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Json,

        [parameter(Mandatory = $false)]
        [string]$PromptTitle = $_MvRACSettings.'Get-Response'.PromptTitle,

        [parameter(Mandatory = $false)]
        [string]$CardTitle = $_MvRACSettings.'Get-Response'.CardTitle,
        [parameter(Mandatory = $false)]
        [string]$LogoUrl = $_MvRACSettings.'Get-Response'.LogoUrl,
        [parameter(Mandatory = $false)]
        [string]$LogoHeaderText = $_MvRACSettings.'Get-Response'.LogoHeader,

        [parameter(Mandatory = $false)]
        [bool]$ShowVersion = ($_MvRACSettings.'Get-Response'.ShowVersion -eq $true),

        [parameter(Mandatory = $false)]
        [int]$PortNumber = $_MvRACSettings.'Get-Response'.PortNumber,

        [parameter(Mandatory = $false)]
        [string]$HeaderBackgroundStart = $_MvRACSettings.'Get-Response'.HeaderBackgroundStart,
        [parameter(Mandatory = $false)]
        [string]$HeaderBackgroundEnd = $_MvRACSettings.'Get-Response'.HeaderBackgroundEnd,

        [parameter(Mandatory = $false)]
        [ValidateSet("Browser", "EdgeApp")]
        [string]$ViewMethod = $_MvRACSettings.'Get-Response'.ViewMethod,

        [parameter(Mandatory = $false)]
        [int]$WindowWidth = 400,

        [parameter(Mandatory = $false)]
        [int]$WindowHeight = 600,

        [switch]$HideHeader,

        [switch]$ShowTitle,

        [switch]$ServeOnly,

        [switch]$AutoSize
    )

    #Serve the card as a web page to capture response
    process {
        $html = Get-Content -Path "$PSScriptRoot\Templates\PromptCard.html" -Raw

        # Find an available port if the default is in use
        $MaxPortRetries = 10
        $CurrentPort = $PortNumber
        $PortFound = $false

        $CurrentPort = Find-AvailablePort -StartPort $CurrentPort -MaxAttempts $MaxPortRetries

        # Set the service URL based on OS
        if ($IsWindows) {
            $ServiceUrl = "http://localhost:$CurrentPort/"
        }
        else {
            $ServiceUrl = "http://+:$CurrentPort/"
        }

        $LogoHeader = $LogoHeaderText

        if ( $ShowVersion ) {
            $LogoHeader = "$LogoHeaderText <span class='version'>v$ModuleVersion</span>"
        }

        if ( -not $ShowTitle ) {
            $TitleClass = "hide-title"
        }
        else {
            $TitleClass = ""
        }

        # Build the extensions payload using the provided JSON
        $ExtensionsPayload = Build-ExtensionsPayload -Json $Json -ScriptsPath "$PSScriptRoot\Templates\Extension\Script" -StylesPath "$PSScriptRoot\Templates\Extension\Style" -EncapsulateStyles

        if ($ExtensionsPayload) {
            $ExtensionsJs = $ExtensionsPayload.Scripts
            $ExtensionsCss = $ExtensionsPayload.Styles
        }
        else {
            $ExtensionsJs = ''
            $ExtensionsCss = ''
        }

        # Generate a unique response GUID to track the response of the card
        $ResponseGuid = [guid]::NewGuid().ToString()


        #Hide header class
        if ( $HideHeader ) {
            $HideHeaderClass = "hide-header"
        }
        else {
            $HideHeaderClass = ""
        }

        # Set max width and height for autosize
        if ( $AutoSize ) {
            Add-Type -AssemblyName System.Windows.Forms
            $Screen = [System.Windows.Forms.Screen]::PrimaryScreen
            $MaxWidth = [math]::Max(1200, $Screen.WorkingArea.Width - 100)
            $MaxHeight = [math]::Max(900, $Screen.WorkingArea.Height - 100)
        }
        else {
            $MaxWidth = 1200
            $MaxHeight = 900
        }

        # Expand any variables in the HTML template (ResponseGuid, ServiceUrl, CardTitle, LogoUrl, etc)
        $html = $ExecutionContext.InvokeCommand.ExpandString($html)


        # Create a synchronized hashtable for heartbeat tracking
        $HeartbeatTracker = [hashtable]::Synchronized(@{
                LastHeartbeat = Get-Date
            })

        #Start the local web server to serve the card and listen for response
        $WSSession = New-LocalCardWebserver -Html $html -ServiceUrl $ServiceUrl -ResponseGuid $ResponseGuid -HeartbeatTracker $HeartbeatTracker

        Write-Verbose "Webserver started at $ServiceUrl to serve Adaptive Card and capture response."
        Write-Verbose "Listening for user response..."

        #Start the listener
        $asyncResult = $WSSession.PowerShell.BeginInvoke()

        #Open browser to the page
        if (!$ServeOnly) {
            # Initialize EdgeAppProcess variable for window close detection
            $EdgeAppProcess = $null

            switch ($ViewMethod) {
                "EdgeApp" {
                    try {
                        # Use Edge in app mode for clean WebView2 experience
                        Write-Information "Opening in Edge (WebView2 browser mode)..."

                        # Create a wrapper HTML that resizes window and redirects
                        $wrapperHtml = $ExecutionContext.InvokeCommand.ExpandString((Get-Content -Path "$PSScriptRoot\Templates\EdgeAppLoader.html" -Raw))

                        $StartTime = Get-Date

                        $tempFile = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "AdaptiveCard_$(Get-Random).html")
                        [System.IO.File]::WriteAllText($tempFile, $wrapperHtml, [System.Text.Encoding]::UTF8)

                        # Open with Edge app mode and capture the process
                        $ParentEdgeProcess = Start-Process "msedge" -ArgumentList "--app=file:///$($tempFile.Replace('\','/'))" -PassThru

                        #Give the Edge app some time to start
                        Start-Sleep -Seconds 1

                        # Clean up temp file after a delay
                        Start-Job -ScriptBlock {
                            param($file)
                            Start-Sleep -Seconds 10
                            if (Test-Path $file) {
                                Remove-Item $file -Force -ErrorAction SilentlyContinue
                            }
                        } -ArgumentList $tempFile | Out-Null

                    }
                    catch {
                        Write-Warning "Failed to launch Edge: $($_.Exception.Message)"
                        Write-Warning "Falling back to default browser..."
                        Start-Process $ServiceUrl
                    }
                }
                "Browser" {

                    #Test for parameters that are not compatible with browser view
                    if ( $AutoSize ) {
                        Write-Warning "AutoSize parameter is not supported in Browser view. Ignoring."
                    }
                    if ( $WindowWidth -ne 400 -or $WindowHeight -ne 600 ) {
                        Write-Warning "Custom window size parameters are not supported in Browser view. Ignoring."
                    }
                    Start-Process $ServiceUrl
                }
                default {}
            }

            $WaitingPrompt = "{blue}[{white}Waiting for user response{gray}{use Ctrl+C to cancel}{blue}]"

            #Set The Dot count for animation
            $DotCount = 0

            Write-ColoredHost $WaitingPrompt -NoNewLine
            [console]::CursorVisible = $false

            #Test to see if $asyncResult halted abnormally
            if ($asyncResult.IsCompleted -eq $True ) {
                Write-Warning "Async operation did not complete as expected."

                #Grab the log stream from the runspace
                $Global:logStream = $PowerShell.Streams.Error

                $logStream | ForEach-Object { Write-Verbose "Error: $_" }
            }

            try {
                while ($asyncResult.IsCompleted -eq $false) {
                    #If crtl+c is pressed, stop listening
                    Start-Sleep -Milliseconds 250
                    $DotCount = ($DotCount + 1) % 7
                    $Dots = "►" * $DotCount

                    if ($DotCount -eq 0) {
                        $Dots = "               "
                    }
                    $PromptToShow = "{blue}[{white}Waiting for user response{gray}(use Ctrl+C to cancel){blue}]   $Dots"

                    #Overwrite the previous line
                    $Host.UI.RawUI.CursorPosition = @{X = 0; Y = $Host.UI.RawUI.CursorPosition.Y }

                    #Hide the cursor while waiting
                    Write-ColoredHost ("`r" + $PromptToShow) -NoNewLine



                    # Check if the Edge process is still running
                    $TimeSinceLastHeartbeat = (Get-Date) - $HeartbeatTracker.LastHeartbeat
                    if ($TimeSinceLastHeartbeat.TotalSeconds -gt 5) {
                        Write-Verbose "No heartbeat detected for 5 seconds - window likely closed"
                        throw "WindowClosed"
                    }

                    # if ($EdgeAppProcess -and $EdgeAppProcess.HasExited -and $asyncResult.IsCompleted -eq $false) {
                    #     Write-Verbose "EdgeApp window was closed by user"
                    #     throw "WindowClosed"
                    # }

                }
                Write-ColoredHost "{Green}[V]"
                #Show the cursor again
                [console]::CursorVisible = $true
                $data = $WSSession.PowerShell.EndInvoke($asyncResult)
            }


            catch {
                Write-Error "An error occurred: $_"
            }
            finally {
                if ($null -eq $data) {
                    try { [void](Invoke-WebRequest -Uri $ServiceUrl -Method Post -OperationTimeoutSeconds 1 -ConnectionTimeoutSeconds 1 -Body @{responseGuid = $ResponseGuid }) } catch { [void]$_ }
                    [void]($WSSession.PowerShell.Stop())
                }

                #Kill the Edge app process if still running
                # if ($EdgeAppProcess) {
                #     # Stop-Process -Id $EdgeAppProcess.Id -Force -ErrorAction SilentlyContinue
                # }
                #Force kill the powershell if still running
                [void]($WSSession.PowerShell.Dispose())


                #Close the runspace
                $WSSession.Runspace.Close()
                $WSSession.Runspace.Dispose()
            }
            if ( ![string]::IsNullOrWhiteSpace($data) ) {
                return $data | ConvertFrom-Json | Select-Object -ExcludeProperty ResponseGuid
            }
        }
    }
}

