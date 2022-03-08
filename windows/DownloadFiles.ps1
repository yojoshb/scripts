# Download files and/or directories from web server

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12, [Net.SecurityProtocolType]::Tls11

function getFiles { 
param ( $folderUrl, $folderPath )
  $WebResponseFile = Invoke-WebRequest -Uri $folderUrl
  $WebResponseFile.Links | Select-Object -ExpandProperty href -Skip 4 | ForEach-Object {
    Write-Host "Downloading file '$_'"
    $filePath = Join-Path -Path $folderPath -ChildPath $_
    $fileUrl  = '{0}/{1}' -f $folderUrl.TrimEnd('/'), $_
    Invoke-WebRequest -Uri $fileUrl -OutFile $filePath
  }
}

function getFolders { 
param ( $url, $outputDir )
  $WebResponse = Invoke-WebRequest -Uri $url
  $WebResponse.Links | Select-Object -ExpandProperty href -Skip 4 | ForEach-Object {
    Write-Host "Creating folder '$_'"
    $folderUrl  = '{0}/{1}' -f $url.TrimEnd('/'), $_
    $folderPath = Join-Path -Path $outputDir -ChildPath $_.TrimEnd('/')
    mkdir $folderPath
    GetFiles $folderUrl $folderPath
  }
}

if ($args[0] -eq "files")
{
  $outputDir = Read-Host -Prompt 'Enter the location to save to'
  $url = Read-Host -Prompt 'Enter the URL to download from'
  getFiles $url $outputDir
}
elseif ($args[0] -eq "all")
{
  $outputDir = Read-Host -Prompt 'Enter the location to save to'
  $url = Read-Host -Prompt 'Enter the URL to download from'
  getFolders $url $outputDir
}
else
{
  Write-Host ""
  Write-Host "Arguments are: 'files' or 'all'"
  Write-Host "If you want to download just files in the top level directory use: 'files'"
  Write-Host "If you want to download all directories and files use: 'all'"
}
