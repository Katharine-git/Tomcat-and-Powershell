#Uninstalltomcat
function uninstallTomcat ($path) {

    if (Test-Path $path)
    {
      Write-Host $path
  
      Set-Location -Path $path\bin
      #shut down server
      cmd.exe /c " shutdown.bat"
      #remove service
      cmd.exe /c "service.bat uninstall"
  
      Set-Location -Path "/"
  
  
      #Uninstall 
      Remove-Item -Path $path -Force -Recurse
      if (!(Test-Path $path))
      {
        Write-Verbose "Tomcat Uninstalled Successfully"
      }
      else {
        Write-Verbose "System can't Uninstall Tomcat because it may be use in another program(s)"
      }
    }
    else {
      Write-Verbose "Tomcat is not installed"
    }
  }
  
  #install apache tomcat
  
  #downloading 
  function downloadtomcat ($url,$tomcatversion,$destination,$unzip_destination,$port) {
  
    $status = wget $url -UseBasicParsing | ForEach-Object { $_.StatusCode }
  
    if ($status -eq 200)
    {
      Write-Verbose "URL exist ...downloading started"
    }
    Invoke-WebRequest -Uri $url -OutFile $destination
    if (Test-Path $destination)
    {
      Write-Verbose "ready to extract"
    }
  
    installtomcat $tomcatversion $destination $unzip_destination $port
  }
  
  #installing
  function installtomcat ($tomcatversion,$destination,$unzip_destination,$port) {
    Expand-Archive -LiteralPath $destination -DestinationPath $unzip_destination -Force
    if (Test-Path $unzip_destination\$tomcatversion)
    {
      Write-Verbose "File extracted successfully"
    }
    else
    {
      Write-Verbose "File extraction failed. Please check the path is correct"
    }
    
    #port change
    (Get-Content "$unzip_destination\$tomcatversion\conf\server.xml").Replace('8080',$port) | Set-Content "$unzip_destination\$tomcatversion\conf\server.xml"
  }
  
  #variables
  $path = "C:\Users\Administrator\Desktop\internetconnection_tomcat_install\tomcat.properties"
  $output = Get-Content $path | ConvertFrom-StringData
  
  $url = $output.url
  $destination = $output.destination
  $unzip_destination = $output.unzip_destination
  $port = $output.port
  $tomcatversion = $output.version
  $logpath = $output.logpath
  $VerbosePreference = "continue"
  $servername = $output.servername
  Start-Transcript -Path $logpath
  uninstallTomcat "$unzip_destination/$tomcatversion"

  #check server have internet access, if yes, download the zip file from the web
  if ((Test-Connection -ComputerName $servername -Quiet) -eq "True")
  {
    Write-Verbose "Server have Internet access"
    downloadtomcat $url $tomcatversion $destination $unzip_destination $port
  }
  #if server don't have internet access install tomcat by taking zip file from artifactory
  else
  {
    installtomcat $tomcatversion $destination $unzip_destination $port
  }

  #Install tomcat as service
  Set-Location -Path $unzip_destination\$tomcatversion\bin
  cmd.exe /c " service.bat install"
  
  
  Stop-Transcript
  
  
  
  
  