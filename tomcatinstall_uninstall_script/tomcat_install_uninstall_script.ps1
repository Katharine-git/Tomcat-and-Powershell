#Uninstalltomcat
function uninstallTomcat($path){

    
    if(Test-Path $path)
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
        if(! (Test-Path $path))
        {
        Write-Verbose "Tomcat Uninstalled Successfully"
        }
        else{
        Write-Verbose "System can't Uninstall Tomcat because it may be use in another program(s)"
        } 
    }
    else{
    Write-Verbose "Tomcat is not installed"
    }
}




#install apache tomcat

#downloading 
function installtomcat($url,$tomcatversion,$destination,$unzip_destination,$port ){

$status= wget $url -UseBasicParsing|% {$_.StatusCode}
if($status -eq 200)
    {
    Write-Verbose "URL exist ...downloading started"
    }
Invoke-WebRequest -uri $url -OutFile $destination
    if ( Test-path $destination)
    {
    Write-Verbose "ready to extract"
    Write-Verbose "extracting files...."
    }
#installing
Expand-Archive -LiteralPath $destination -DestinationPath $unzip_destination -Force
    if( Test-path $unzip_destination\$tomcatversion)
    {
    Write-Verbose "File extracted successfully"
    }
    else
    {
    Write-Verbose "File extraction failed. Please check the path is correct"
    }
#port change

(Get-Content "$unzip_destination\$tomcatversion\conf\server.xml").replace('8080',$port)|Set-Content "$unzip_destination\$tomcatversion\conf\server.xml"
} 

#variables
$path= "C:\Users\Administrator\Desktop\tomcat_install_uninstall\tomcat.properties"
$output= Get-content $path| ConvertFrom-StringData

$url=$output.url
$destination=$output.destination
$unzip_destination=$output.unzip_destination
$port=$output.port
$tomcatversion=$output.version
$logpath=$output.logpath
$VerbosePreference= "continue"
Start-Transcript -Path $logpath
uninstallTomcat "$unzip_destination/$tomcatversion"
installtomcat $url $tomcatversion $destination $unzip_destination $port 


#Install tomcat as service
Set-Location -Path $unzip_destination\$tomcatversion\bin
cmd.exe /c " service.bat install" 


Stop-Transcript

   

        
 