function Get-CardResponse {
    param (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Json
    )

    #Serve the card as a web page to capture response

    $html = Get-Content -Path "$PSScriptRoot\Templates\PromptCard.html" -Raw
    $html = $ExecutionContext.InvokeCommand.ExpandString($html)

    #Create a task to listen for requests
    $Runspace = [runspacefactory]::CreateRunspace()
    $Runspace.Open()

    $ScriptBlock = {
        param ($html)

        $listener = [System.Net.HttpListener]::new()
        $listener.Prefixes.Add("http://localhost:8080/")
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

                    $responseString = "<html><body><h3>Thanks! Data received.</h3></body></html>"
                    $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseString)
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                    $response.Close()

                    $data

                    break
                }
            }
        }

        $listener.Stop()
    }
    $PowerShell = [powershell]::Create()
    $PowerShell.Runspace = $Runspace
    [void]($PowerShell.AddScript($ScriptBlock).AddArgument($html))

    $asyncResult = $PowerShell.BeginInvoke()

    #Open browser to the page
    Start-Process "http://localhost:8080/"

    $WaitingPrompt = "{blue}[{white}Waiting for user response{gray}{use Ctrl+C to cancel}{blue}]"

    # Get the length of the prompt for overwriting
    $PromptLength = ($WaitingPrompt -replace '\{[a-zA-Z]+\}', '').Length

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
        Write-Host "An error occurred: $_"
    }
    finally {
        if ($data -eq $null) {
            try { Invoke-WebRequest -Uri "http://localhost:8080" -Method Post -OperationTimeoutSeconds 1 -ConnectionTimeoutSeconds 1 } catch {}
            [void]($PowerShell.Stop())
        }
        #Force kill the powershell if still running

        [void]($PowerShell.Dispose())
        #Close the runspace
        $Runspace.Close()
        $Runspace.Dispose()
    }

    return $data
}