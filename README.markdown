Ubuntu Setup Scripts
====================================================================================================

Description
----------------------------------------------------------------------------------------------------

A shell script, used to install and configure various settings and applications on a freshly installed Ubuntu web server.

The script has three sections:

> 	*	Settings: used to customise the installation/administration process
>	*	Core functions: used to install various parts of the server
>	*	Admin function: used post-installation for maintenance
	
File list
----------------------------------------------------------------------------------------------------

	*	config.sh: customises the installation funtions (user configurable)
	*	settings.sh: customises the administration functions (user configurable)
	* 	core.sh: installation functions for the build
	*	install.sh: installation script that uses config.sh and core.sh (user configurable)
	* 	admin.sh: admin functions for after the build

	The config file and install file are combined to provide the installation script
	with the required functionality.
	
	The setting file and admin file are combined  to provide administration script
	functionality.
	
Compatibility
----------------------------------------------------------------------------------------------------

	This tool has been configured and tested on the following systems:
	
	*	Ubuntu 11.10

Usage
----------------------------------------------------------------------------------------------------

	* 	Download the latest version of the script:

			https://github.com/arcidor/mecury

	* 	Navigate to the script directory
	
	*	Configure the config.sh file
	
	*	Customise the install script (install.sh)
	
	*	Ensure that the install script is executable:
	
			chmod 700 install.sh
			
	*	Run the script
	
			./install.sh

Status
----------------------------------------------------------------------------------------------------
	
	To Be Completed:
	
	* PostgreSQL hardening
	* TomCat hardening
	* Ruby on rails hardening
	* GlassFish hardening

Notes
----------------------------------------------------------------------------------------------------

	This script should be run under the root user (or equivalent).

	Sections listed in the script as "not implemented" or "placeholder", are
	not required for a normal Ubuntu web server installation. These sections 
	may be updated in the future, however there is no timeline in place for
	the relevant functionality.

Licensing
----------------------------------------------------------------------------------------------------

	Copyright 2012 Ricardo Oliveira

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
	
Additional Resources
----------------------------------------------------------------------------------------------------

	*	Ubuntu server guide
		https://help.ubuntu.com/11.04/serverguide/C/index.html
		
	*	DebianAdmin
		http://www.debianadmin.com/
		
	*	Securing IP tables
		http://www.sitepoint.com/secure-server-iptables/
	
	*	Low end VPS server
		http://madspace2.rajeshprakash.com/lowendvpsconfig.htm
		
	*	Various linux scripts
		http://bash.cyberciti.biz/
	
	*	Slicehost articles and tutorials
		http://articles.slicehost.com/
		
	*	Server tutorials
		http://beginlinux.com/
		
	*	Server fault: tips for securing a LAMP server
		http://serverfault.com/questions/212269/tips-for-securing-a-lamp-server
		
	*	NSA security guidance
		http://www.nsa.gov/ia/guidance/security_configuration_guides/operating_systems.shtml
		
	*	The 60 Minute Network Security Guide
		http://www.nsa.gov/ia/_files/support/I33-011R-2006.pdf
		
	*	Guide to the Secure Conﬁguration of Red Hat Enterprise Linux 5
		http://www.nsa.gov/ia/_files/os/redhat/rhel5-guide-i731.pdf
		
	*	Slackware hardening
		http://transamrit.net/docs/sysHardening/system-hardening-10.2.txt
		
	*	What is the easiest way to resolve apt-get BADSIG GPG errors? (Ubuntu Forums)
		http://askubuntu.com/questions/1877/what-is-the-easiest-way-to-resolve-apt-get-badsig-gpg-errors