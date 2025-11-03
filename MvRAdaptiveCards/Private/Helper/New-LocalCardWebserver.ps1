function New-LocalCardWebserver {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'None')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Html,

        [Parameter(Mandatory = $true)]
        [string]$ServiceUrl,

        [Parameter(Mandatory = $true)]
        [string]$ResponseGuid
    )


    #Create a task to listen for requests
    $Runspace = [runspacefactory]::CreateRunspace()
    $Runspace.Open()

    $ScriptBlock = {
        param ($html, $ServiceUrl, $ResponseGuid )

        $listener = [System.Net.HttpListener]::new()
        #Test if the host is a windows system to determine the correct prefix

        #Dot source Read-HttpRequest function
        $listener.Prefixes.Add($ServiceUrl)

        $listener.Start()
        while ($listener.IsListening) {
            # Wait for request, but handle Ctrl+C safely
            if ($listener.IsListening) {
                $context = $listener.GetContext()
                $request = $context.Request
                $response = $context.Response

                if ($request.HttpMethod -eq "GET") {
                    # inside GET handler

                    #Test to see if the request came from the localhost
                    if ($request.Url.Host -eq "localhost" -or $request.Url.Host -eq "[::1]") {
                        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html )
                    }
                    else {
                        $buffer = [System.Text.Encoding]::UTF8.GetBytes("Invalid ResponseGuid provided")
                    }

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

                    #Test to see the response GUID matches
                    $jsonData = $data | ConvertFrom-Json
                    if ($jsonData.ResponseGuid -eq $ResponseGuid) {
                        $data
                        break
                    }

                }
            }
        }
        $listener.Stop()
        $listener.Close()
    }
    $PowerShell = [powershell]::Create()
    $PowerShell.Runspace = $Runspace

    if ( $PSCmdlet.ShouldProcess("Starting local webserver to host Adaptive Card") ) {
        [void]($PowerShell.AddScript($ScriptBlock).AddArgument($html).AddArgument($ServiceUrl).AddArgument($ResponseGuid).AddArgument($IsPesterTest))


    }

    return @{
        PowerShell = $PowerShell
        Runspace   = $Runspace
    }

}