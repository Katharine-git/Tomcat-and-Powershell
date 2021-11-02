<h2>This repository contains scripts that uninstalls and install Apache Tomcat Version 8.5.72 and also checks for internet connectivity.
A properties file is added to generalise the scripts and improve flexibility.</h2>

<b>The script contains 3 functions ;</b>

#1. To <i>uninstall</i> tomcat if it is already installed. 
- Before uninstalling, it shuts down the server and uninstalls the tomcat service thereafter removing the tomcat directory.

#2. <i>Download and install</i> the tomcat zip file <i>if there is internet access</i>.
- Checks if url is valid and existing
- If valid, downloads the zip file and extracts it to the tomcat folder.

#3. <i>Download the zip file</i> from a seperate location and install <i>if no access to internet.</i>
-unzips the existing zip file in another location(Preferrably a repositry.)

<b>This script installs Tomcat as a service</b>
