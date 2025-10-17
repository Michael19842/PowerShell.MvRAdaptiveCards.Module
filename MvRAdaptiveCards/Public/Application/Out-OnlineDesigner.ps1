function Out-OnlineDesigner {
    param (
        [parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$Json
    )

    # Escape JSON for embedding in HTML/JS
    $Json = $Json -replace '"', '\"' -replace "`n", '' -replace "`r", ''

    # Generate HTML with iframe and postMessage handling
    $html = @"
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Adaptive Card Designer Iframe</title>
  <style>
    html, body { margin:0; height:100%; overflow:hidden; }
    iframe { width:100%; height:100%; border:none; }
  </style>
</head>
<body>
  <iframe id="designerFrame" src="https://adaptivecards.microsoft.com/designer"></iframe>
  <script>
    const designerFrame = document.getElementById("designerFrame");
    const cardPayload = "$Json";

    window.addEventListener("message", (event) => {
      console.log("Received message from iframe:", event.data);
      if (event.source === designerFrame.contentWindow && event.data === "ac-designer-ready") {
        console.log("Designer is ready, sending card payload.");
        designerFrame.contentWindow.postMessage({
          type: "cardPayload",
          id: "card",
          payload: cardPayload
        }, "*");
      }
    });
  </script>
</body>
</html>
"@

    # Save HTML to temp file
    $path = "$env:TEMP\AdaptiveCardDesigner.html"
    $html | Set-Content -Path $path -Encoding UTF8

    # Open HTML in default browser
    Start-Process $path
}
