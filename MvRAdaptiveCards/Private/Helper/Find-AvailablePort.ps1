function Find-AvailablePort {
    param([int]$StartPort = 8081, [int]$MaxAttempts = 10)

    $Port = $StartPort
    $Attempts = 0

    while ($Attempts -lt $MaxAttempts) {
        $TcpListener = [System.Net.Sockets.TcpListener]::new($Port)
        try {
            $TcpListener.Start()
            return $Port
        }
        catch {
            $Attempts++
            $Port++
        }
        finally {
            $TcpListener.Stop()
            $TcpListener.Dispose()
        }
    }

    throw "No available port found"
}
