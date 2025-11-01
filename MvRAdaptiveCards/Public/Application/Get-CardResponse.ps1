function Get-CardResponse {
    <#
    .SYNOPSIS
    Serves an Adaptive Card as a web page and captures user responses.

    .DESCRIPTION
    The Get-CardResponse function creates a local HTTP server to serve an Adaptive Card,
    displays it in a browser or Edge app window, and waits for user input. When the user
    submits the card, the function returns the submitted data as a PowerShell object.

    .PARAMETER Json
    The JSON string representing the Adaptive Card to display. Accepts pipeline input.

    .PARAMETER PromptTitle
    The title for the prompt window. Uses module default if not specified.

    .PARAMETER CardTitle
    The title displayed at the top of the card. Uses module default if not specified.

    .PARAMETER LogoUrl
    The URL of the logo image to display in the header. Uses module default if not specified.

    .PARAMETER LogoHeaderText
    The text to display next to the logo in the header. Uses module default if not specified.

    .PARAMETER ShowVersion
    Whether to show the module version in the header. Uses module default if not specified.

    .PARAMETER PortNumber
    The port number for the local HTTP server. Uses module default if not specified.

    .PARAMETER HeaderBackgroundStart
    The starting color (hex) for the header gradient background. Uses module default if not specified.

    .PARAMETER HeaderBackgroundEnd
    The ending color (hex) for the header gradient background. Uses module default if not specified.

    .PARAMETER ViewMethod
    Specifies how to display the card. Valid values:
    - Browser: Opens in default browser
    - WindowsForms: Opens in a Windows Forms window (Windows only)
    - EdgeApp: Opens in Microsoft Edge app mode with custom window size

    .PARAMETER WindowWidth
    The width of the window in pixels when using EdgeApp view method. Default: 400

    .PARAMETER WindowHeight
    The height of the window in pixels when using EdgeApp view method. Default: 600

    .PARAMETER ServeOnly
    If specified, only starts the HTTP server without opening a browser window.

    .EXAMPLE
    New-AdaptiveCard {
        New-CardTextBlock -Text "Hello World"
    } | Get-CardResponse

    Creates a simple card and displays it in the default view method.

    .EXAMPLE
    $response = New-AdaptiveCard {
        New-CardInputText -Id "Name" -Label "Your Name"
        New-CardActionSet -Actions {
            New-CardActionSubmit -Title "Submit"
        }
    } | Get-CardResponse -ViewMethod EdgeApp -WindowWidth 800 -WindowHeight 600

    Creates an input card, displays it in Edge app mode with custom window size, and captures the response.

    .EXAMPLE
    New-AdaptiveCard {
        New-CardProgressBar -Value 75 -Max 100 -Color "Good"
    } | Get-CardResponse -ViewMethod Browser

    Displays a progress bar card in the default browser.

    .OUTPUTS
    System.Management.Automation.PSCustomObject
    Returns the submitted form data as a PowerShell object with properties matching the input IDs.

    .NOTES
    - Requires an available port (default: 8080)
    - EdgeApp mode requires Microsoft Edge to be installed
    - The function blocks until the user submits the form or cancels with Ctrl+C
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Variable used in template')]
    [system.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Settings variable used in module')]
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

        [bool]$ShowVersion = $_MvRACSettings.'Get-Response'.ShowVersion,

        [parameter(Mandatory = $false)]
        [int]$PortNumber = $_MvRACSettings.'Get-Response'.PortNumber,

        [parameter(Mandatory = $false)]
        [string]$HeaderBackgroundStart = $_MvRACSettings.'Get-Response'.HeaderBackgroundStart,
        [parameter(Mandatory = $false)]
        [string]$HeaderBackgroundEnd = $_MvRACSettings.'Get-Response'.HeaderBackgroundEnd,

        [parameter(Mandatory = $false)]
        [ValidateSet("Browser", "WindowsForms", "EdgeApp")]
        [string]$ViewMethod = $_MvRACSettings.'Get-Response'.ViewMethod,

        [parameter(Mandatory = $false)]
        [int]$WindowWidth = 400,

        [parameter(Mandatory = $false)]
        [int]$WindowHeight = 600,

        [switch]$ServeOnly
    )

    #Serve the card as a web page to capture response
    process {

        $html = Get-Content -Path "$PSScriptRoot\Templates\PromptCard.html" -Raw


        if ($IsWindows) {
            $ServiceUrl = "http://localhost:$PortNumber/"
        }
        else {
            $ServiceUrl = "http://+:$PortNumber/"
        }

        $LogoHeader = $LogoHeaderText

        if ( $ShowVersion ) {
            $LogoHeader = "$LogoHeaderText <span class='version'>v$ModuleVersion</span>"
        }

        #Read the JSON and only load needed extensions
        $AvailableExtensions = (Get-ChildItem -Path "$PSScriptRoot\Templates\Extension\Script" -Filter *.js | ForEach-Object { $_.BaseName })
        $ExtensionsToLoad = @()

        foreach ($Extension in $AvailableExtensions) {
            if ($Json -match [regex]::escape($Extension)) {
                $ExtensionsToLoad += $Extension
            }
        }

        $ExtensionsJs = ''
        $ExtensionsCss = ''
        foreach ($Extension in $ExtensionsToLoad) {
            #Get the file content
            $ExtensionPath = "$PSScriptRoot\Templates\Extension\Script\$Extension.js"


            if (Test-Path -Path $ExtensionPath) {
                $ExtensionContent = Get-Content -Path $ExtensionPath -Raw
                $ExtensionsJs += "`n`n// Extension: $Extension`n" + $ExtensionContent
            }
            $ExtensionCssPath = "$PSScriptRoot\Templates\Extension\Style\$Extension.css"
            if (Test-Path -Path $ExtensionCssPath) {
                $ExtensionCssContent = Get-Content -Path $ExtensionCssPath -Raw
                $ExtensionsCss += "`n/* Extension: $Extension */`n" + $ExtensionCssContent
            }
        }

        $ExtensionsCss = "<style type='text/css'>$ExtensionsCss</style>"

        $html = $ExecutionContext.InvokeCommand.ExpandString($html)


        #Create a task to listen for requests
        $Runspace = [runspacefactory]::CreateRunspace()
        $Runspace.Open()

        $ScriptBlock = {
            param ($html, $ServiceUrl)

            $listener = [System.Net.HttpListener]::new()
            #Test if the host is a windows system to determine the correct prefix

            $listener.Prefixes.Add($ServiceUrl)

            $listener.Start()
            while ($listener.IsListening) {
                # Wait for request, but handle Ctrl+C safely
                if ($listener.IsListening) {
                    $context = $listener.GetContext()
                    $request = $context.Request
                    $response = $context.Response

                    if ($request.HttpMethod -eq "GET") {
                        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
                        $response.OutputStream.Write($buffer, 0, $buffer.Length)
                        $response.Close()
                    }
                    elseif ($request.HttpMethod -eq "POST") {
                        $reader = New-Object IO.StreamReader($request.InputStream)
                        $data = $reader.ReadToEnd()
                        $reader.Close()

                        $responseString = "Thanks! Data received"
                        $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseString)

                        # Set response headers
                        $response.ContentLength64 = $buffer.Length
                        $response.ContentType = "text/plain; charset=utf-8"
                        $response.StatusCode = 200

                        # Write response
                        $response.OutputStream.Write($buffer, 0, $buffer.Length)

                        # CRITICAL: Flush and close the output stream before breaking
                        $response.OutputStream.Flush()
                        $response.OutputStream.Close()
                        $response.Close()

                        # Small delay to ensure response is sent
                        Start-Sleep -Milliseconds 100

                        $data

                        break
                    }
                }
            }

            $listener.Stop()
        }
        $PowerShell = [powershell]::Create()
        $PowerShell.Runspace = $Runspace
        [void]($PowerShell.AddScript($ScriptBlock).AddArgument($html).AddArgument($ServiceUrl))

        $asyncResult = $PowerShell.BeginInvoke()

        #Open browser to the page
        if (!$ServeOnly) {

            switch ($ViewMethod) {
                "EdgeApp" {
                    try {
                        # Use Edge in app mode for clean WebView2 experience
                        Write-Host "Opening in Edge (WebView2 browser mode)..."

                        # Create a wrapper HTML that resizes window and redirects
                        $wrapperHtml = $ExecutionContext.InvokeCommand.ExpandString((Get-Content -Path "$PSScriptRoot\Templates\EdgeAppLoader.html" -Raw))

                        $tempFile = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "AdaptiveCard_$(Get-Random).html")
                        [System.IO.File]::WriteAllText($tempFile, $wrapperHtml, [System.Text.Encoding]::UTF8)

                        # Open with Edge app mode
                        Start-Process "msedge" -ArgumentList "--app=file:///$($tempFile.Replace('\','/'))"

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
                        Write-Host "Falling back to default browser..."
                        Start-Process $ServiceUrl
                    }
                }
                "Browser" {
                    Start-Process $ServiceUrl
                }
                default {}
            }

            $WaitingPrompt = "{blue}[{white}Waiting for user response{gray}{use Ctrl+C to cancel}{blue}]"

            #Set The Dot count for animation
            $DotCount = 0

            Write-ColoredHost $WaitingPrompt -NoNewLine
            [console]::CursorVisible = $false

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




                }
                Write-ColoredHost "{Green}[V]"
                #Show the cursor again
                [console]::CursorVisible = $true
                $data = $PowerShell.EndInvoke($asyncResult)
            }


            catch {
                Write-Error "An error occurred: $_"
            }
            finally {
                if ($null -eq $data) {
                    try { Invoke-WebRequest -Uri $ServiceUrl -Method Post -OperationTimeoutSeconds 1 -ConnectionTimeoutSeconds 1 } catch { [void]$_ }
                    [void]($PowerShell.Stop())
                }
                #Force kill the powershell if still running

                [void]($PowerShell.Dispose())
                #Close the runspace
                $Runspace.Close()
                $Runspace.Dispose()
            }
            if ( $null -ne $data ) {
                return $data | ConvertFrom-Json
            }
        }
    }
}