#!/bin/bash

################################################################################
# 1. Introduction
################################################################################

# Welcome to the Ubuntu Server setup script
#
# This script contains functions that can be used to install and configure 
# various aspects of an Ubuntu server and its applications. It follows the 
# basic format of the official Ubuntu server guide, which can be found at:
#
#	https://help.ubuntu.com/
#
# Each section reflects the index of the guide and contains functions relating 
# to that area of server configuration. 
#
# As this script is only a companion to the guide it will also contain 
# additional functions that the author has deemed appropriate for inclusion, 
# but are not mentioned in the official guide.
#
# To make use of this script, please consult the README file provided.
#
# It is assumed that the Ubuntu Server has already been installed with the 
# basic setup.

################################################################################
# 2. Installation
################################################################################

function installation_disable_environment {
	# Prevent environment sharing as this can cause some issues with locales
	sed -i "s/^AcceptEnv.*/# AcceptEnv LANG LC_*/" /etc/ssh/sshd_config
	/etc/init.d/ssh restart
}

function installation_upgrade_release {
	# Upgrade to the latest version of Ubuntu
	do-release-upgrade
}

function installation_locale_update {
	# Enable the locale set in the settings file
	/usr/sbin/locale-gen $setting_locale
	/usr/sbin/update-locale LANG=$setting_locale
	
	# Update the locale list
	dpkg-reconfigure locales
}

function installation_timezone_update {
	# Update the timezone to the one set in the settings folder
	ln -sf /usr/share/zoneinfo/$setting_location /etc/localtime
}

function installation_motd_clear {
	# Clear the message of the day file
	cat /dev/null > /etc/motd
	
	# Rmove the PAM message of the day modules
	rm -R /etc/update-motd.d/
	mkdir /etc/update-motd.d/
}

function installation_admin_skeleton_files {
	# Move the files to the skeleton directory
	mv setting.sh /etc/skel/.setting.sh
	mv admin.sh /etc/skel/.admin.sh
	
	# Change the permissions
	chmod -R 777 /etc/skel
	
	# Make sure the files are sourced on login
	echo "source /etc/skel/.setting.sh" >> /etc/profile
	echo "source /etc/skel/.admin.sh" >> /etc/profile
}

function installation_admin_group_create {
	# Create an admin group
	groupadd $setting_group_admin
	
	if [[ "$setting_group_admin" != "admin" ]]; then	
		# Give sudo permission to the admin group
		cp /etc/{sudoers,sudoers.tmp}
		chmod 0640 /etc/sudoers.tmp
		echo "# Members of the $setting_group_admin group gain root privileges" >> /etc/sudoers.tmp
		echo "%$setting_group_admin ALL=(ALL) ALL" >> /etc/sudoers.tmp
		chmod 0440 /etc/sudoers.tmp
		mv /etc/sudoers.tmp /etc/sudoers
	fi
}

function installation_admin_user_create {
	# Create the admin user and change the account password
	adduser --ingroup $setting_group_admin --shell /bin/bash --disabled-password --gecos "Administrator,,," $setting_admin
	echo "$setting_admin:$setting_admin_password" | chpasswd
	
	# Add the admin user to the ssh group for ssh access
	usermod -a -G $setting_group_ssh $setting_admin
}

################################################################################
# 3. Package Management
################################################################################

function package_management_source_configure {
	# Output the updated sources list taking into account the settings file
	cat > /etc/apt/sources.list <<EOF
deb http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release main restricted
deb-src http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release main restricted

deb http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release-updates main restricted
deb-src http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release-updates main restricted

deb http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release universe
deb-src http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release universe
deb http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release-updates universe
deb-src http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release-updates universe

deb http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release multiverse
deb-src http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release multiverse
deb http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release-updates multiverse
deb-src http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release-updates multiverse

deb http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release-backports main restricted universe multiverse
deb-src http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release-backports main restricted universe multiverse

deb http://security.ubuntu.com/ubuntu $setting_release-security main restricted
deb-src http://security.ubuntu.com/ubuntu $setting_release-security main restricted
deb http://security.ubuntu.com/ubuntu $setting_release-security universe
deb-src http://security.ubuntu.com/ubuntu $setting_release-security universe
deb http://security.ubuntu.com/ubuntu $setting_release-security multiverse
deb-src http://security.ubuntu.com/ubuntu $setting_release-security multiverse

deb http://archive.canonical.com/ubuntu $setting_release partner
deb-src http://archive.canonical.com/ubuntu $setting_release partner

deb http://extras.ubuntu.com/ubuntu $setting_release main
deb-src http://extras.ubuntu.com/ubuntu $setting_release main
EOF

	# Add the key for the extras package list to prevent the GPG error from displaying
	apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 16126D3A3E5C1192

	# Update the package list
	apt-get -y update
}

function package_management_aptitude_install {
	# Install aptitude 
	apt-get -y install aptitude

	# Update aptitude and upgrade the system
	aptitude -y update
}

function package_management_essentials_install {
	# Install commonly used software
	aptitude -y install build-essential curl expect htop iotop libssl-dev lshw screen unzip vim wget zlib1g-dev
}

function package_management_notifications_install {
	# Install apticron
	aptitude -y install apticron
	
	# Configure for the correct email
	sed -i "s/^EMAIL=.*/EMAIL=\"$setting_admin_email\"/" /etc/apticron/apticron.conf
}

################################################################################
# 4. Networking
################################################################################

function networking_hostname_update {
	# Set the hostname
	echo $setting_hostname > /etc/hostname
    hostname -F /etc/hostname

	# Set the FQDN
	sed -i "s/127.0.0.1.*/127.0.0.1       localhost.localdomain   localhost\n$setting_ip       $setting_fqdn   $setting_hostname/" /etc/hosts
	
	# Restart the service
	service hostname start
}

function networking_ntp_install {
	# Install the Network Time Protocol package
	aptitude -y install ntp

 	# Update the configuration file to reflect an addtional time pool
	sed -i "s/^server ntp.ubuntu.com/server ntp.ubuntu.com\nserver pool.ntp.org/" /etc/ntp.conf
	
	# Restart the service
	/etc/init.d/ntp reload
}

################################################################################
# 5. Remote Administration
################################################################################

########################################
# 5.1 SSH
########################################

function remote_admin_ssh_install {
	# Install both the ssh client and daemon
	aptitude -y install openssh-client openssh-server
}

function remote_admin_ssh_configure {
	# Output settings to the daemon configuration file
	cat > /etc/ssh/sshd_config <<EOF
# AcceptEnv LANG LC_*
AllowAgentForwarding yes
AllowGroups $setting_group_ssh
AllowTcpForwarding yes
# AllowUsers
# AuthorizedKeysFile	%h/.ssh/authorized_keys
Banner /etc/issue.net
ChallengeResponseAuthentication no
Compression yes
# ChrootDirectory
# Ciphers
# DenyGroups
# DenyUsers
# ForceCommand
GatewayPorts no
# GSSAPIAuthentication no
# GSSAPICleanupCredentials yes
# GSSAPIKeyExchange no
# GSSAPIStrictAcceptorCheck no
HostbasedAuthentication no
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_rsa_key
IgnoreRhosts yes
# IgnoreUserKnownHosts yes
# KerberosAuthentication no
# KerberosGetAFSToken no
# KerberosOrLocalPasswd yes
# KerberosTicketCleanup yes
KeyRegenerationInterval 3600
# ListenAddress ::
# ListenAddress 0.0.0.0
LoginGraceTime 30
LogLevel INFO
# MaxStartups 10:30:60
PasswordAuthentication yes
PermitBlacklistedKeys no
PermitEmptyPasswords no
# PermitOpen 
PermitRootLogin no
PermitTunnel yes
PermitUserEnvironment no
# PidFile 
Port $setting_port_ssh
PrintLastLog no
PrintMotd no
Protocol 2
PubkeyAuthentication yes
RhostsRSAAuthentication no
RSAAuthentication yes
ServerKeyBits 768
StrictModes yes
Subsystem sftp /usr/lib/openssh/sftp-server
SyslogFacility AUTH
TCPKeepAlive yes
# UseLogin no
UseDNS no
UsePAM yes
UsePrivilegeSeparation yes
X11DisplayOffset 10
X11Forwarding yes
# X11UseLocalhost 
# XAuthLocation
EOF
}

function remote_admin_ssh_banner_update {
	# Save the new message
	cat > /etc/issue.net <<EOF	
*******************************************************************************
Unauthorized access prohibited; all access and activities not explicitly
authorized by the administrator are unauthorized. All activities are monitored 
and logged.  There is no privacy on this system.  Unauthorized access and 
activities or any criminal activity will be reported to appropriate authorities
*******************************************************************************
EOF
}

function remote_admin_ssh_configure_sftp {	
	# Add sftp group specific settings to the SSH configuration file
	cat >> /etc/ssh/sshd_config <<EOF
Match Group $setting_group_sftp
	ChrootDirectory /home/%u
	X11Forwarding no
	AllowTcpForwarding no
	ForceCommand internal-sftp
EOF
	
	# Add the sftp group to the system	
	groupadd $setting_group_sftp
}

########################################
# 5.2 Puppet
########################################

# Place holder

################################################################################
# 6. Network Authentication
################################################################################

# Place holder

################################################################################
# 7. Domain Name Service (DNS)
################################################################################

# Place holder

################################################################################
# 8. Security
################################################################################

########################################
# User Management
########################################

function user_management_adduser_configure {
	# Set the default access to user only
	sed -i "s/^DIR_MODE.*/DIR_MODE=0700/" /etc/adduser.conf
}

function user_management_password_expirations {
	# Update the password expiration times
	sed -i "s/^PASS_MAX_DAYS.*/PASS_MAX_DAYS 60/" /etc/login.defs
	sed -i "s/^PASS_MIN_DAYS.*/PASS_MIN_DAYS 7/" /etc/login.defs
	sed -i "s/^PASS_WARN_AGE.*/PASS_WARN_AGE 7/" /etc/login.defs

	# Log various user actions
	sed -i "s/^LOG_OK_LOGINS.*/LOG_OK_LOGINS yes/" /etc/login.defs
	sed -i "s/^#SULOG_FILE.*/SULOG_FILE \/var\/log\/sulog/" /etc/login.defs
}

########################################
# Console Security
########################################

function security_console_disable_reboot {
	# Disable reboot on ctrl-alt-del
	sed -i "s/^exec.*/\# exec shutdown -r now \"Control-Alt-Delete pressed\"/" /etc/init/control-alt-delete.conf
}

########################################
# Firewall
########################################

function firewall_backup {
	# Make a backup of the current firewall rules
	/sbin/iptables-save > /sbin/iptables.backup
	chmod 700 /sbin/iptables.backup
	
	# Reset the default policies
	/sbin/iptables -P INPUT ACCEPT
	/sbin/iptables -P FORWARD ACCEPT
	/sbin/iptables -P OUTPUT ACCEPT
	/sbin/iptables -t nat -P PREROUTING ACCEPT
	/sbin/iptables -t nat -P POSTROUTING ACCEPT
	/sbin/iptables -t nat -P OUTPUT ACCEPT
	/sbin/iptables -t mangle -P PREROUTING ACCEPT
	/sbin/iptables -t mangle -P OUTPUT ACCEPT
	
	# Flush the tables
	/sbin/iptables -F
	/sbin/iptables -t nat -F
	/sbin/iptables -t mangle -F
	
	# Erase all non default chains
	/sbin/iptables -X
	/sbin/iptables -t nat -X
	/sbin/iptables -t mangle -X
}

function firewall_configure {
	# Allows all loopback (lo0) traffic and drop all traffic to 127/8 that doesn't use lo0
	/sbin/iptables -A INPUT -i lo -j ACCEPT
	/sbin/iptables -A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT
	
	# Accepts all established inbound connections
	/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
	
	# Allow all outbound traffic
	/sbin/iptables -A OUTPUT -j ACCEPT

	# Allow SSH traffic
	/sbin/iptables -A INPUT -p tcp --dport $setting_port_ssh -j ACCEPT
	
	# Allow HTTP and HTTPS connections from anywhere (the normal ports for websites)
	/sbin/iptables -A INPUT -p tcp --dport $setting_port_http -j ACCEPT
	/sbin/iptables -A INPUT -p tcp --dport $setting_port_https -j ACCEPT

	# Allow SMTP, POP, and IMAP connections from anywhere (the normal ports for mail)
	/sbin/iptables -A INPUT -p tcp --dport $setting_port_smtp -j ACCEPT
	/sbin/iptables -A INPUT -p tcp --dport $setting_port_pop -j ACCEPT
	/sbin/iptables -A INPUT -p tcp --dport $setting_port_imap -j ACCEPT
	
	# Allow connection to MySQL
	/sbin/iptables -A INPUT -p tcp --dport $setting_port_mysql -j ACCEPT
	
	# Allow DNS from anywhere (the normal ports for nameserver)
	/sbin/iptables -A INPUT -p tcp --dport $setting_port_dns -j ACCEPT

	# Allow access to the glassfish ports
	/sbin/iptables -A INPUT -p tcp --dport $setting_port_glassfish -j ACCEPT
	#/sbin/iptables -A INPUT -p tcp --dport $setting_port_glassfish_admin -j ACCEPT

	# Allows FTP connections from anywhere (the normal ports for ftp)
	# /sbin/iptables -A INPUT -p tcp --dport $setting_port_ftp -j ACCEPT

	# Allow ping
	# /sbin/iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

	# log iptables denied calls
	/sbin/iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables: " --log-level 7

	# Reject all other inbound - default deny unless explicitly allowed policy
	/sbin/iptables -A INPUT -j REJECT
	/sbin/iptables -A FORWARD -j REJECT
}

function firewall_finish {
	# Save the firewall rules
	/sbin/iptables-save > /sbin/iptables-rules
	chmod 700 /sbin/iptables-rules
	
	# Create a bash file that imports the firewall rules from iptables
	cat >> /etc/network/if-up.d/iptables <<EOF
#!/bin/bash
/sbin/iptables-restore < /sbin/iptables-rules
EOF
	
	# Make it executable
	chmod 700 /etc/network/if-up.d/iptables

	# Create a bash file that imports the firewall rules from iptables
	cat >> /etc/network/if-down.d/iptables <<EOF
#!/bin/bash
/sbin/iptables-save > /sbin/iptables-rules
EOF

	# Make it executable
	chmod 700 /etc/network/if-down.d/iptables
}

########################################
# AppArmor
########################################

# Place holder

########################################
# Certificates
########################################

# Place holder

########################################
# eCryptfs
########################################

# Place holder

########################################
# CHKRootKit
########################################

function chkrootkit_install {
	# Install Chkrootkit
	aptitude -y install chkrootkit

	# Create the ckhrootkit daily script file
	cat >> /etc/cron.daily/chkrootkit.sh <<EOF
#!/bin/sh
(
chkrootkit
) | mail -s 'Chkrootkit Output:' $setting_admin_email
EOF

	# Apply the correct permissions to the file
	chmod 755 /etc/cron.daily/chkrootkit.sh
}

########################################
# RKHunter
########################################

function rkhunter_install {
	# Install Rkhunter
	aptitude -y install rkhunter
	
	# Perform an update
	rkhunter --update
	
	# Create the ckhrootkit daily script file
	cat >> /etc/cron.daily/rkhunter.sh <<EOF
#!/bin/sh
(
	rkhunter --update
	rkhunter --cronjob --report-warnings-only
) | mail -s 'RKHunter Output:' $setting_admin_email
EOF
	
	# Apply the correct permissions to the file
	chmod 755 /etc/cron.daily/rkhunter.sh
}

########################################
# Logwatch
########################################

function logwatch_install {
	# Install logwatch
	aptitude -y install logwatch

	# Create the logwatch daily script file
	cat >> /etc/cron.daily/logwatch.sh <<EOF
#!/bin/sh
(
	logwatch
) | mail -s 'Logwatch Output:' $setting_admin_email
EOF
	
	# Apply the correct permissions to the file
	chmod 755 /etc/cron.daily/logwatch.sh
}

########################################
# Fail2Ban
########################################

function fail2ban_install {
	# Install fail2ban
	aptitude -y install fail2ban

	# Make changes to the setting file
	sed -i "s/^destemail.*/destemail = $setting_admin_email/" /etc/fail2ban/jail.conf
	sed -i "s/^mta.*/mta = mail/" /etc/fail2ban/jail.conf
	
	# Restart the service
	service fail2ban restart
}

########################################
# Logcheck
########################################

function logcheck_install {
	# Install logcheck
	aptitude -y install logcheck logcheck-database
	
	# Configure the mail settings
	sed -i "s/^SENDMAILTO=.*/SENDMAILTO=\"$setting_admin_email\"/" /etc/logcheck/logcheck.conf
}

########################################
# Denyhosts
########################################

function denyhosts_install {
	# Install denyhosts
	aptitude -y install denyhosts
	
	# Configure the thresholds for denying
	sed -i "s/^DENY_THRESHOLD_ROOT =.*/DENY_THRESHOLD_ROOT = 5/" /etc/denyhosts.conf 
	
	# Setup admin emailing
	sed -i "s/^ADMIN_EMAIL =.*/ADMIN_EMAIL = $setting_admin_email/" /etc/denyhosts.conf 
}

################################################################################
# 9. Monitoring
################################################################################

########################################
# 9.1 Nagios
########################################

# Place holder

########################################
# 9.2 Munin
########################################

# Place holder

################################################################################
# 10. Web Servers
################################################################################

########################################
# 10.1 Apache Web Server
########################################

function apache_install {
	# Check for any updated packages and install apache2
	aptitude -y install apache2 apache2-doc apache2-utils
}

function apache_configure_settings {
	# Edit the apache2 configuration file
	sed -i "s/^Timeout.*$/Timeout 30/" /etc/apache2/apache2.conf
	sed -i "s/^KeepAliveTimeout.*$/KeepAliveTimeout 5/g" /etc/apache2/apache2.conf
	sed -i "s/\(^\s*MaxKeepAliveRequests\)\s*[0-9]*/\1  400/" /etc/apache2/apache2.conf
	sed -i "s/\(^\s*MinSpareThreads\)\s*[0-9]*/\1      2/" /etc/apache2/apache2.conf
	sed -i "s/\(^\s*MaxSpareThreads\)\s*[0-9]*/\1      5/" /etc/apache2/apache2.conf
	sed -i "s/\(^\s*ThreadLimit\)\s*[0-9]*/\1          15/" /etc/apache2/apache2.conf
	sed -i "s/\(^\s*ThreadsPerChild\)\s*[0-9]*/\1      15/" /etc/apache2/apache2.conf	
	sed -i "s/\(^\s*StartServers\)\s*[0-9]*/\1         1/" /etc/apache2/apache2.conf
	sed -i "s/\(^\s*MaxClients\)\s*[0-9]*/\1           45/" /etc/apache2/apache2.conf
	sed -i "s/\(^\s*MaxRequestsPerChild\)\s*[0-9]*/\1  5000/" /etc/apache2/apache2.conf
	
	# Apply basic security settings
	sed -i "s/^ServerTokens.*/ServerTokens Prod/" /etc/apache2/conf.d/security
	sed -i "s/^ServerSignature.*/ServerSignature Off/" /etc/apache2/conf.d/security

	# Edit Ports.conf
	sed -i "s/^NameVirtualHost.*/NameVirtualHost $setting_ip:80/" /etc/apache2/ports.conf
	
	# Edit default virtual host
	sed -i "s/^<VirtualHost.*/<VirtualHost $setting_ip:80>/" /etc/apache2/sites-available/default
}

function apache_configure_modules {
	# Enable various modules
	a2enmod actions
	a2enmod ssl
	a2enmod rewrite
	a2enmod suexec
	a2enmod include
		
	# Disable various modules
	a2dismod status
	a2dismod autoindex
	a2dismod cgi
	
	# Disable default site
	a2dissite 000-default
}

########################################
# 10.2 PHP5 - Scripting Language
########################################

function php_install {
	# Check for any updated packages and install php
	aptitude -y install php5 php5-json php5-cli php5-mysql php5-dev php5-curl php5-gd php5-imagick php5-mcrypt php5-memcache php5-mhash php5-pspell php5-snmp php5-sqlite php5-xmlrpc php5-xsl libapache2-mod-php5 php5-gd php5-ldap php5-odbc php5-pgsql php5-cli php5-suhosin libapache2-mod-php5 php5-common
}

function php_configure {
	# Edit php.ini
	sed -i "s/^short_open_tag.*$/short_open_tag = Off/" /etc/php5/apache2/php.ini
	sed -i "s/^disable_functions.*$/disable_functions = _getppid,diskfreespace,dl,escapeshellarg,escapeshellcmd,exec,fpaththru,getmypid,getmyuid,highlight_file,ignore_user_abord,leak,link,listen,passthru,pcntl_alarm,pcntl_exec,pcntl_fork,pcntl_get_last_error,pcntl_getpriority,pcntl_setpriority,pcntl_signal,pcntl_signal_dispatch,pcntl_sigprocmask,pcntl_sigtimedwait,pcntl_sigwaitinfo,pcntl_strerror,pcntl_wait,pcntl_waitpid,pcntl_wexitstatus,pcntl_wifexited,pcntl_wifsignaled,pcntl_wifstopped,pcntl_wstopsig,pcntl_wtermsig,php_uname,phpinfo,popen,posix,posix_ctermid,posix_getcwd,posix_getegid,posix_geteuid,posix_getgid,posix_getgrgid,posix_getgrnam,posix_getgroups,posix_getlogin,posix_getpgid,posix_getpgrp,posix_getpid,posix_getpwnam,posix_getpwuid,posix_getrlimit,posix_getsid,posix_getuid,posix_isatty,posix_kill,posix_mkfifo,posix_setegid,posix_seteuid,posix_setgid,posix_setpgid,posix_setsid,posix_setuid,posix_times,posix_ttyname,posix_uname,proc_close,proc_get_status,proc_nice,proc_open,proc_terminate,set_time_limit,shell_exec,show_source,source,system,tmpfile,virtual/" /etc/php5/apache2/php.ini
	sed -i "s/^expose_php.*$/expose_php = Off/" /etc/php5/apache2/php.ini
	sed -i 's/^max_execution_time.*$/max_execution_time = 1120/' /etc/php5/apache2/php.ini	
	sed -i 's/^max_input_time.*$/max_input_time = 1300/' /etc/php5/apache2/php.ini
	sed -i "s/^display_errors.*$/display_errors = Off/" /etc/php5/apache2/php.ini
	sed -i "s/^log_errors = Off$/log_errors = On/" /etc/php5/apache2/php.ini
	sed -i "s/^;error_log = syslog$/error_log = \/var\/log\/php.log/" /etc/php5/apache2/php.ini	
	sed -i "s/^;error_log = php_errors.log$/error_log = \/var\/log\/php.log/" /etc/php5/apache2/php.ini
	sed -i "s/^;error_log.*$/error_log = \/var\/log\/php.log/" /etc/php5/apache2/php.ini
	sed -i "s/^memory_limit.*$/memory_limit = $setting_mysql_memory_limitM/" /etc/php5/apache2/php.ini
	sed -i "s/^post_max_size.*$/post_max_size = 125M/" /etc/php5/apache2/php.ini	
	sed -i "s/^upload_max_filesize.*$/upload_max_filesize = 125M/" /etc/php5/apache2/php.ini
	sed -i "s/^register_globals.*$/register_globals = Off/" /etc/php5/apache2/php.ini
	sed -i "s/^allow_url_fopen.*$/allow_url_fopen = Off/" /etc/php5/apache2/php.ini
	sed -i "s/^enable_dl.*$/enable_dl = Off/" /etc/php5/apache2/php.ini
	sed -i "s/^;date.timezone*$/date.timezone = $setting_php_zone/" /etc/php5/apache2/php.ini
}

########################################
# 10.3 Squid - Proxy Server
########################################

# Placeholder

########################################
# 10.4 Ruby on Rails
########################################

function ruby_on_rails_install {
	# Check for any updated packages and install rails
	aptitude -y install rails
}


########################################
# 10.5 Apache Tomcat
########################################

function tomcat_install {
	# Check for any updated packages and install tomcat
	aptitude -y install tomcat6
}

########################################
# 10.6 GlassFish
########################################

function glassfish_install {
	#Add a new user called glassfish
	adduser --home /home/glassfish --system --shell /bin/bash $setting_glassfish

	#add a new group for glassfish administration
	groupadd $setting_glassfish_admin

	#add your users that shall be Glassfish adminstrators
	usermod -a -G $setting_glassfish_admin $setting_admin
	usermod -a -G $setting_glassfish_admin $setting_glassfish

	# Create a download folder in the glassfish user profile
	mkdir /home/$setting_glassfish/downloads
	cd /home/$setting_glassfish/downloads
	wget http://download.java.net/glassfish/3.1.1/release/glassfish-3.1.1.zip
	unzip glassfish-3.1.1.zip
	mv glassfish3 /home/$setting_glassfish/
	
	# Move back to root home and change permissions of the downloaded files
	cd ~
	rm -R /home/glassfish/downloads/
	chown -R $setting_glassfish /home/$setting_glassfish
	chgrp -R $setting_glassfish_admin /home/$setting_glassfish
	chmod -R 750 /home/$setting_glassfish/glassfish3
}

function glassfish_configure {
	# Create a script to launch glassfish on startup
	cat >> /etc/init.d/glassfish <<EOF
#!/bin/sh
/home/$setting_glassfish/glassfish3/bin/asadmin start-domain domain1	
EOF

	# Make the script executable
	chmod 700 /etc/init.d/glassfish
}

################################################################################
# 11. Databases
################################################################################

########################################
# 11.1 MySQL
########################################

function mysql_install {
	# Set the password for the MySQL installation
	echo "mysql-server-5.1 mysql-server/root_password password $setting_mysql_password" | debconf-set-selections
	echo "mysql-server-5.1 mysql-server/root_password_again password $setting_mysql_password" | debconf-set-selections
	
	# Check for any updated packages and install mysql
	aptitude -y install mysql-server
}

########################################
# 11.2 PostgreSQL
########################################

function postgresql_install {
	# Check for any updated packages and install postgresql
	aptitude -y install postgresql postgresql-contrib
}

################################################################################
# 12. LAMP Applications
################################################################################

########################################
# Moin Moin
########################################

# Place holder

########################################
# MediaWiki
########################################

# Place holder

########################################
# phpMyAdmin
########################################

# Place holder

################################################################################
# 13. File Servers
################################################################################

########################################
# FTP Server
########################################

# Place holder

########################################
# Network File System
########################################

# Placeholder

########################################
# CUPS - Print Server
########################################

# Placeholder

################################################################################
# 14. Email Services
################################################################################

########################################
# Postfix
########################################

function postfix_install_send_only {
	# Install postfix
	echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
	echo "postfix postfix/mailname string $setting_domain" | debconf-set-selections
	echo "postfix postfix/destinations string localhost.localdomain, localhost" | debconf-set-selections
	aptitude -y install postfix telnet mailutils

	/usr/sbin/postconf -e "inet_interfaces = loopback-only"
	/usr/sbin/postconf -e "local_transport = error:local delivery is disabled"

	# Configure the hostname
	sed -i "s/^myhostname .*$/myhostname = $setting_domain/" /etc/postfix/main.cf

	# Put the domain the mail name
	cat > /etc/mailname << EOF
$setting_domain
EOF
	
	# Disable local mail
	sed -i "s/^mydestination =.*$/mydestination = localhost/" /etc/postfix/main.cf
	
	# Ensure postfix will start at boot
	/usr/sbin/update-rc.d postfix defaults

	# Restart to apply changes
	/etc/init.d/postfix start
}

########################################
# Exim4
########################################

# Placeholder

########################################
# Dovecot Server
########################################

# Placeholder

########################################
# Mailman
########################################

# Placeholder

########################################
# Mail Filtering
########################################

# Placeholder

################################################################################
# 15. Chat Applications
################################################################################

########################################
# IRC Server
########################################

# Placeholder

########################################
# Jabber Instant Messaging Server
########################################

# Placeholder

################################################################################
# 16. Version Control System
################################################################################

########################################
# Bazaar
########################################

# Placeholder

########################################
# Subversion
########################################

# Placeholder

########################################
# CVS Server
########################################

# Placeholder

########################################
# Git
########################################

function git_install {
	aptitude -y install git-core git-svn
}

################################################################################
# 17. Windows Networking
################################################################################

########################################
# Samba File Server
########################################

# Place holder

########################################
# Samba Print Server
########################################

# Place holder

########################################
# Samba Domain Controller
########################################

# Place holder

########################################
# Samba Active Directory Integration
########################################

# Place holder

################################################################################
# 18. Backups
################################################################################

########################################
# Shell Scripts
########################################

function backup_install {
	# Create the logwatch daily script file
	cat >> /etc/cron.daily/backup.sh <<EOF
#!/bin/sh
(
	# What to backup. 
	backup_files="/home /var/spool/mail /etc /root /boot /opt"

	# Where to backup to.
	dest="/mnt/backup"

	# Create archive filename.
	day=$(date +%A)
	hostname=$(hostname -s)
	archive_file="$hostname-$day.tgz"

	# Backup the files using tar.
	tar czf $dest/$archive_file $backup_files
) | /bin/mail -s 'Logwatch Output:' $setting_admin_email
EOF

	# Apply the correct permissions to the file
	chmod 700 /etc/cron.daily/backup.sh
}

########################################
# Archive Rotation
########################################

# Placeholder

########################################
# Bacula
########################################

################################################################################
# 19. Virtualization
################################################################################

########################################
# libvirt
########################################

# Place holder

########################################
# JeOS and vmbuilder
########################################

# Place holder

########################################
# UEC
########################################

# Place holder

################################################################################
# 20. Clustering
################################################################################

########################################
# DRBD
########################################

# Place holder

################################################################################
# 21. VPN
################################################################################

########################################
# OpenVPN
########################################

# Place holder

################################################################################
# 22. Other Useful Applications
################################################################################

########################################
# 22.1 Java
########################################

function java_install {
	# Update to reflect the repo containing the java libs
	aptitude -y install python-software-properties
	add-apt-repository -y ppa:ferramroberto/java
	
	# Provide the parameters required for the installation
	echo "sun-java6-jdk shared/accepted-sun-dlj-v1-1 select true" | /usr/bin/debconf-set-selections
	echo "sun-java6-jre shared/accepted-sun-dlj-v1-1 select true" | /usr/bin/debconf-set-selections
	
	# Install Java
	aptitude update
	aptitude -y install sun-java6-jdk sun-java6-jre
	
	# Setup the various Java paths
	echo "JAVA_HOME=\"/usr/lib/jvm/java-6-sun\"" > /etc/environment
	echo "PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/lib/jvm/java-6-sun/bin\"" >> /etc/environment
}

################################################################################
# A1. Misc
################################################################################

function exit_message {
	clear
	echo "###############################################################"
	echo "Configuration complete..."
	echo "Remember to run mysql_secure_installation and then reboot"
	echo "###############################################################"
}