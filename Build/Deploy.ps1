#Deploy to PSGallery

$ModuleName = 'MvRAdaptiveCards'

$ModuleRoot = "$PSScriptRoot\..\$ModuleName"

Publish-Module -Path $ModuleRoot -NuGetApiKey $env:PSGalleryApiKey -Repository PSGallery 