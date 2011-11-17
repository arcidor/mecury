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

function installation_upgrade_release {
	apt-get dist-upgrade
	#do-release-upgrade
}

function installation_locale_update {
	/usr/sbin/locale-gen $setting_locale
	/usr/sbin/update-locale LANG=$setting_locale
}

function installation_timezone_update {
	ln -sf /usr/share/zoneinfo/$setting_location /etc/localtime
}

function installation_motd_clear {
	cat /dev/null > /etc/motd
}

function installation_sysctl_update {
	# Make a backup of the source list	
	cp /etc/{sysctl.conf,sysctl.conf.backup}
	
	# Enable spoof protection
	sed -i 's/^#net.ipv4.conf.default.rp_filter=1/net.ipv4.conf.default.rp_filter=1/' /etc/sysctl.conf
	sed -i 's/^#net.ipv4.conf.all.rp_filter=1/net.ipv4.conf.all.rp_filter=1/' /etc/sysctl.conf
	
	# Enable TCP/IP SYN cookies
	sed -i 's/^#net.ipv4.tcp_syncookies=1/net.ipv4.tcp_syncookies=1/' /etc/sysctl.conf
	
	# Disable forwarding
	sed -i 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=0/' /etc/sysctl.conf
	sed -i 's/^#net.ipv6.conf.all.forwarding=1/#net.ipv6.conf.all.forwarding=0/' /etc/sysctl.conf
	
	# Prevent man in the middle attacks
	sed -i 's/^#net.ipv4.conf.all.accept_redirects = 0/net.ipv4.conf.all.accept_redirects = 0/' /etc/sysctl.conf	
	sed -i 's/^#net.ipv6.conf.all.accept_redirects = 0/net.ipv6.conf.all.accept_redirects = 0/' /etc/sysctl.conf	
	
	sed -i 's/^# net.ipv4.conf.all.secure_redirects = 1/net.ipv4.conf.all.secure_redirects = 0/' /etc/sysctl.conf
	sed -i 's/^#net.ipv4.conf.all.send_redirects = 0/net.ipv4.conf.all.send_redirects = 0/' /etc/sysctl.conf	

	sed -i 's/^#net.ipv4.conf.all.accept_source_route = 0/net.ipv4.conf.all.accept_source_route = 0/' /etc/sysctl.conf
	sed -i 's/^#net.ipv6.conf.all.accept_source_route = 0/net.ipv6.conf.all.accept_source_route = 0/' /etc/sysctl.conf
	
	# Log various suspicious packets	
	sed -i 's/^#net.ipv4.conf.all.log_martians = 1/net.ipv4.conf.all.log_martians = 1/' /etc/sysctl.conf

	cat >> /etc/sysctl.conf <<EOF

net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_messages = 1
EOF
	
	# Load the changes
	sysctl -p
}

################################################################################
# 3. Package Management
################################################################################

function package_management_sources_configure {
	# Make a backup of the source list
	cp /etc/apt/{sources.list,sources.list.backup}

	# Output the updates sources list
	cat > /etc/apt/sources.list <<EOF
deb http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release main restricted universe multiverse
deb-src http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release main restricted universe multiverse

deb http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release-updates main restricted universe multiverse
deb-src http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release-updates main restricted universe multiverse

deb http://security.ubuntu.com/ubuntu $setting_release-security main restricted universe multiverse
deb-src http://security.ubuntu.com/ubuntu $setting_release-security main restricted universe multiverse

deb http://archive.canonical.com/ubuntu $setting_release partner
deb-src http://archive.canonical.com/ubuntu $setting_release partner

# deb http://extras.ubuntu.com/ubuntu $setting_release main
# deb-src http://extras.ubuntu.com/ubuntu $setting_release main

# deb http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release-backports main restricted universe multiverse
# deb-src http://$setting_region.archive.ubuntu.com/ubuntu/ $setting_release-backports main restricted universe multiverse
EOF
}

function package_management_aptitude_install {
	# Update the package list and install aptitude
	apt-get -y update
	apt-get -y install aptitude

	# Update aptitude and upgrade the system
	aptitude -y update
	aptitude -y upgrade
}

function package_management_essentials_install {
	# Install essential software
	aptitude -y update
	aptitude -y install build-essential curl dnsutils htop iotop less libssl-dev libreadline5-dev screen unzip vim wget zlib1g-dev
}

function package_management_notifications_configure {
	# Install apticron
	aptitude -y update
	aptitude -y install apticron
	
	# Configure for the correct email
	sed -i "s/^EMAIL=/EMAIL=\"$setting_admin_email\"/" /etc/apticron/apticron.conf
}

################################################################################
# 4. Networking
################################################################################

function networking_install_lshw {
	aptitude install lshw
}

function networking_info_configure {
	# Set the hostname
	echo $setting_hostname > /etc/hostname
    hostname -F /etc/hostname

	# Disable DHCP setting the system hostname
	cp /etc/default/{dhcpcd,dhcpcd.backup}
	sed -i "s/SET_HOSTNAME/#SET_HOSTNAME/" /etc/default/dhcpcd

	# Set the FQDN
	cp /etc/{hosts,hosts.backup}
	sed -i "s/127.0.0.1       localhost.localdomain   localhost/127.0.0.1       localhost.localdomain   localhost\n$setting_ip       $setting_fqdn   $setting_hostname/" /etc/hosts

	# Restart the service
	service hostname start
}

function networking_ntp_install {
	# Install the Network Time Protocol package
	aptitude -y update
	aptitude -y install ntp

 	# Update the configuration file to reflect an addtional time pool
	cp /etc/{ntp.conf,ntp.conf.backup}
	sed -i "s/^server ntp.ubuntu.com/server ntp.ubuntu.com\nserver pool.ntp.org/" /etc/ntp.conf
}

################################################################################
# 5. Remote Administration
################################################################################

########################################
# SSH
########################################

function remote_admin_create_base_access {
	# If an alternative admin group has been specified, create it and give the group admin privileges
	if [[ "$setting_group_admin" != "admin" ]]; then
		
		# Create an admin group
		groupadd $setting_group_admin
		
		# Give sudo permission to the admin group
		cp /etc/{sudoers,sudoers.tmp}
		chmod 0640 /etc/sudoers.tmp
		echo "# Members of the $setting_group_admin group gain root privileges" >> /etc/sudoers.tmp
		echo "%$setting_group_admin ALL=(ALL) ALL" >> /etc/sudoers.tmp
		chmod 0440 /etc/sudoers.tmp
		mv /etc/sudoers.tmp /etc/sudoers
		
	fi
	
	# Create the admin user and change the account password
	adduser --ingroup "admin" --shell /bin/bash --disabled-password --gecos "Administrator,,," $setting_admin
	echo "$setting_admin:$setting_admin_password" | chpasswd

	# Set the password expiry to 90 days and the warning to 14 days
	chage -M 90 -W 14 $setting_admin
}

function remote_admin_ssh_install {
	# Install both the ssh client and daemon
	aptitude -y update
	aptitude -y install openssh-client openssh-server
}

function remote_admin_ssh_configure {
	# Backup the SSH configuration file
	cp /etc/ssh/{sshd_config,sshd_config.backup}
	chmod a-w /etc/ssh/sshd_config.backup
	
	# Output settings to the daemon configuration file
	cat > /etc/ssh/sshd_config <<EOF
AcceptEnv LANG LC_*
AddressFamily any
AllowAgentForwarding no
AllowGroups $setting_group_ssh
AllowTcpForwarding no
# AllowUsers
# AuthorizedKeysFile %h/.ssh/authorized_keys
Banner /etc/issue.net
ChallengeResponseAuthentication no
# ChrootDirectory
# Ciphers
ClientAliveCountMax 3
ClientAliveInterval 600
Compression yes
# DenyGroups
# DenyUsers
# ForceCommand
GatewayPorts no
# GSSAPIAuthentication no
# GSSAPIKeyExchange no
# GSSAPICleanupCredentials yes
# GSSAPIStrictAcceptorCheck no
HostbasedAuthentication no
# HostbasedUsesNameFromPacketOnly 
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
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
MaxAuthTries 5
MaxSessions 5
# MaxStartups 10:30:60
PasswordAuthentication yes
PermitBlacklistedKeys no
PermitEmptyPasswords no
# PermitOpen 
PermitRootLogin no 
PermitTunnel no
PermitUserEnvironment no
# PidFile 
Port $setting_port_ssh
PrintLastLog no
PrintMotd no
Protocol 2
PubkeyAuthentication yes
RhostsRSAAuthentication no
RSAAuthentication yes
ServerKeyBits 1024
StrictModes yes
Subsystem sftp internal-sftp
SyslogFacility AUTH
TCPKeepAlive yes
UseDNS no
# UseLogin no
UsePAM yes
UsePrivilegeSeparation yes
# X11DisplayOffset 10
X11Forwarding no
# X11UseLocalhost 
# XAuthLocation
EOF
}

function remote_admin_ssh_banner_configure {
	# Backup the current message
 	cp /etc/{issue.net,issue.net.backup}

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

function remote_admin_ssh_restart {
	service ssh restart
}

########################################
# SSH
########################################

function remote_install_puppet {
	# ToDo
}

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

function user_management_configure_adduser {
	# Sort users into groups when created
	sed -i "s/^GROUPHOMES=no/GROUPHOMES=yes/" /etc/adduser.conf
	
	# Set the default access to user only
	sed -i "s/^DIR_MODE.*/DIR_MODE=0700/" /etc/adduser.conf
}

function user_management_password_expirations {
	cat >> /etc/login.defs <<EOF
PASS_MAX_DAYS 60
PASS_MIN_DAYS 7
PASS_MIN_LEN 14
PASS_WARN_AGE 7
EOF
}

function user_management_lock_system_users {	
	# Lock certain system users
	usermod -L adm
	usermod -L bin
	usermod -L daemon
	usermod -L games
	usermod -L listen
	usermod -L lp
	usermod -L nobody
	usermod -L noaccess
	usermod -L nuucp
	usermod -L smtp
	usermod -L sys
	usermod -L uucp

	# Disable access to shell
	chsh -s /dev/null adm /etc/shadow
	chsh -s /dev/null bin /etc/shadow
	chsh -s /dev/null daemon /etc/shadow
	chsh -s /dev/null games /etc/shadow
	chsh -s /dev/null listen /etc/shadow
	chsh -s /dev/null lp /etc/shadow
	chsh -s /dev/null nobody /etc/shadow
	chsh -s /dev/null noaccess /etc/shadow
	chsh -s /dev/null nuucp /etc/shadow
	chsh -s /dev/null smtp /etc/shadow
	chsh -s /dev/null sys /etc/shadow
	chsh -s /dev/null uucp /etc/shadow	
}

########################################
# Console Security
########################################

function security_console_disable_reboot {
	
	sed -i "s/^exec shutdown -r now "Control-Alt-Delete pressed.*/\#exec shutdown -r now "Control-Alt-Delete pressed/" /etc/init/control-alt-delete.conf
}

function console_services_disable {
	# Disable services for users who do not require them
	chmod 4750 su

	#rexd, rquotad, talk, sadmind, kcmsd, rstatd, fs, exec, 
	#daytime, walld, fingerd, systat, rusersd, sprayd, uucpd, chargen, time, echo, display, 
	#tftp, comsat and discard
}

########################################
# Firewall
########################################

function firewall_backup {
	# Make a backup of the current firewall rules
	/sbin/iptables-save > /sbin/iptables.backup
	
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

	# Allows FTP connections from anywhere (the normal ports for ftp)
	/sbin/iptables -A INPUT -p tcp --dport $setting_port_ftp -j ACCEPT

	# Allow ping
	# /sbin/iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

	# log iptables denied calls
	/sbin/iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

	# Reject all other inbound - default deny unless explicitly allowed policy
	/sbin/iptables -A INPUT -j REJECT
	/sbin/iptables -A FORWARD -j REJECT
}

function firewall_finish {
	# Save the firewall rules
	/sbin/iptables-save > /sbin/iptables-rules
	
	# Create a bash file that imports the firewall rules into iptables
	echo '#!/bin/bash'  > /etc/network/if-up.d/iptables
	echo "/sbin/iptables-restore < /sbin/iptables-rules" >> /etc/network/if-up.d/iptables
	
	# Create a bash file that exports the firewall rules from iptables
	echo '#!/bin/bash'  > /etc/network/if-down.d/iptables
	echo "/sbin/iptables-save > /sbin/iptables-rules" >> /etc/network/if-down.d/iptables
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
	
	# Create a cron job that outputs the result of chkrootkit
	echo "0 3 * * * (chkrootkit 2>&1 | mail -s \"Chkrootkit Output\" $setting_admin_email)" >> $setting_cron_file
}

########################################
# RKHunter
########################################

function rkhunter_install {
	# Install Rkhunter
	aptitude -y install rkhunter
	
	rkhunter --update
	
	# Create a cron job that outputs the result of rkhunter
	cat >> $setting_cron_file <<EOF
15 3 * * * (/usr/bin/rkhunter --update)
15 3 * * * ((/usr/bin/rkhunter --cronjob --report-warnings-only) | mail -s \"$setting_fqdn Rkhunter Output\" $setting_admin_email)
EOF

	# Clear false positives in rkhunter.conf
}

########################################
# Logwatch
########################################

function logwatch_install {
	# Install logwatch
	aptitude -y install logwatch
	
	# Create a cron job that outputs the result of logwatch
	echo "30 3 * * * (logwatch | mail -s \"Logwatch Output\" $setting_admin_email)" >> $setting_cron_file
}

########################################
# Fail2Ban
########################################

function fail2ban_install {
	# Install fail2ban
	aptitude -y install fail2ban

	# Make a copy of the configuration file
	sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
	
	# Make changes to the setting file
	sed -i 's/^destemail.*/destemail = $setting_admin_email Prod/' /etc/fail2ban/jail.conf
	sed -i 's/^mta.*/mta = mail/' /etc/fail2ban/jail.conf
	
	service fail2ban restart
}

########################################
# Logcheck
########################################

function security_install_logcheck {
	aptitude -y install logcheck logcheck-database
}

########################################
# Denyhosts
########################################

function security_install_denyhosts {
	
	# Install denyhosts
	aptitude -y install denyhosts
	
}

########################################
# Misc
########################################

# Mail the relevant account when someone logs into the root account
function security_alert_root {
	cat > /root/.bashrc <<EOF
	echo 'ALERT - Root Shell Access on:' `date` `who` | mail -s "Alert: Root Login from `who | awk '{print $6}'`" $setting_admin_email 
EOF
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
	aptitude -y update
	aptitude -y install apache2 apache2-doc apache2-utils ssl libapache2-mod-security
}

function apache_configure {
	# Edit apache2.conf
	cp /etc/apache2/{apache2.conf,apache2.conf.backup}
	sed -i "s/^Timeout.*$/Timeout 30/" /etc/apache2/apache2.conf
	sed -i "s/^KeepAliveTimeout.*$/KeepAliveTimeout 5/g" /etc/apache2/apache2.conf
	sed -i "s/\(^\s*StartServers\)\s*[0-9]*/\1         1/" /etc/apache2/apache2.conf
	sed -i "s/\(^\s*MaxClients\)\s*[0-9]*/\1           45/" /etc/apache2/apache2.conf
	sed -i "s/\(^\s*MinSpareThreads\)\s*[0-9]*/\1      2/" /etc/apache2/apache2.conf
	sed -i "s/\(^\s*MaxSpareThreads\)\s*[0-9]*/\1      5/" /etc/apache2/apache2.conf
	sed -i "s/\(^\s*ThreadLimit\)\s*[0-9]*/\1          15/" /etc/apache2/apache2.conf
	sed -i "s/\(^\s*ThreadsPerChild\)\s*[0-9]*/\1      15/" /etc/apache2/apache2.conf
	sed -i "s/\(^\s*MaxRequestsPerChild\)\s*[0-9]*/\1  5000/" /etc/apache2/apache2.conf
	sed -i "s/\(^\s*//MaxKeepAliveRequests\)\s*[0-9]*/\1  400/" /etc/apache2/apache2.conf
	
	# Replace the server name
	sed -i "s/^ServerName.*/ServerName $setting_domain/" /etc/apache2/conf.d/servername.conf

	# Remove Apache server information from headers. 
	sed -i "s/^ServerTokens.*/ServerTokens Prod/" /etc/apache2/conf.d/security
	sed -i "s/^ServerSignature.*/ServerSignature Off/" /etc/apache2/conf.d/security

	# Enable apache modules
	a2enmod actions > $directory_logs/server_apache_settingure_actions.log
	a2enmod ssl > $directory_logs/server_apache_settingure_ssl.log
	a2enmod rewrite > $directory_logs/server_apache_settingure_rewrite.log
	a2enmod suexec
	a2enmod include
		
	# Disable apache modules
	a2dismod php4
	a2dismod status > $directory_logs/server_apache_install.log
	a2dismod autoindex > $directory_logs/server_apache_install.log
	a2dismod cgi

	# Edit Ports.conf
	sed -i "s/^NameVirtualHost.*/NameVirtualHost $setting_ip:80/" /etc/apache2/ports.conf
	
	# Edit default virtual host
	sed -i "s/^<VirtualHost.*/<VirtualHost $setting_ip:80>/" /etc/apache2/sites-available/default

	# Disable default site
	a2dissite 000-default


	# Create server encryption keys
	openssl genrsa -des3 -out server.key 1024
	
	# Create certificate request
	openssl req -new -key server.key -out server.csr
	
	# Create self-signed signature
	openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
	
	# Install the certificate and key
	cp server.crt /etc/ssl/certs/ 
	cp server.key /etc/ssl/private/
	
	# /etc/apache2/sites-available/default-ssl
	
	# uncomment the SSLOptions line
	# SSLEngine on
	# SSLOptions +FakeBasicAuth +ExportCertData +StrictRequire
	# SSLCertificateFile /etc/ssl/certs/server.crt
	# SSLCertificateKeyFile /etc/ssl/private/server.key
	
	# a2ensite default-ssl
}

function apache_restart {
	service apache2 restart
}

########################################
# 10.2 PHP5 - Scripting Language
########################################

function php_install {
	# Check for any updated packages and install php
	aptitude -y update
	aptitude -y install php5 php5-json php5-cli php5-mysql php5-dev php5-curl php5-gd php5-imagick php5-mcrypt php5-memcache php5-mhash php5-pspell php5-snmp php5-sqlite php5-xmlrpc php5-xsl libapache2-mod-php5 php5-gd php5-ldap php5-odbc php5-pgsql
}

function php_configure {
	# Install PHP
	aptitude -y install libapache2-mod-php5 php5 php5-common php5-curl php5-dev php5-gd php5-imagick php5-mcrypt php5-memcache php5-mhash php5-mysql php5-pspell php5-snmp php5-sqlite php5-xmlrpc php5-xsl php5-cli php5-suhosin > $directory_logs/server_php_install.log
	
	# Edit php.ini
	sed -i "s/^disable_functions.*$/disable_functions = php_uname, getmyuid, getmypid, passthru, leak, listen, diskfreespace, tmpfile, link, ignore_user_abord, shell_exec, dl, set_time_limit, exec, system, highlight_file, source, show_source, fpaththru, virtual, posix_ctermid, posix_getcwd, posix_getegid, posix_geteuid, posix_getgid, posix_getgrgid, posix_getgrnam, posix_getgroups, posix_getlogin, posix_getpgid, posix_getpgrp, posix_getpid, posix, _getppid, posix_getpwnam, posix_getpwuid, posix_getrlimit, posix_getsid, posix_getuid, posix_isatty, posix_kill, posix_mkfifo, posix_setegid, posix_seteuid, posix_setgid, posix_setpgid, posix_setsid, posix_setuid, posix_times, posix_ttyname, posix_uname, proc_open, proc_close, proc_get_status, proc_nice, proc_terminate, phpinfo/" /etc/php5/apache2/php.ini
	sed -i "s/^display_errors.*$/display_errors = Off/" /etc/php5/apache2/php.ini
	sed -i "s/^expose_php.*$/expose_php = Off/" /etc/php5/apache2/php.ini
	sed -i "s/^log_errors.*$/log_errors = On/" /etc/php5/apache2/php.ini
	sed -i "s/^memory_limit.*$/memory_limit = $setting_mysql_memory_limit/" /etc/php5/apache2/php.ini
	sed -i "s/^;error_log.*$/error_log = \/var\/log\/php.log/" /etc/php5/apache2/php.ini
	
	# Tweak php.ini. 
	phpinidir="/etc/php5/cgi/php.ini" 
	sed -i 's/^\(max_execution_time = \)[0-9]*/\1120/' $phpinidir 
	sed -i 's/^\(max_input_time = \)[0-9]*/\1300/' $phpinidir 
	sed -i 's/^\(memory_limit = \)[0-9]*M/\164M/' $phpinidir 
	sed -i 's/^\(post_max_size = \)[0-9]*M/\125M/' $phpinidir 
	sed -i 's/^\(upload_max_filesize = \)[0-9]*M/\125M/' $phpinidir 
	sed -i 's/disable_functions =/disable_functions = exec,system,passthru,shell_exec,escapeshellarg,escapeshellcmd,proc_close,proc_open,dl,popen,show_source/' $phpinidir 
	
	
	# register_globals = Off
	# allow_url_fopen = Off
	# enable_dl = Off
	# expose_PHP = Off
	# disable_functions = show_source, system, shell_exec, passthru, exec, phpinfo, popen, proc_open
	#	
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
	aptitude -y update
	aptitude -y install rails
}

########################################
# 10.5 Apache Tomcat
########################################

function tomcat_install {
	
	# Check for any updated packages and install tomcat
	aptitude -y update
	aptitude -y install tomcat6
	
}

########################################
# 10.6 GlassFish
########################################

function server_glassfish_install {

	echo "sun-java6-jdk shared/accepted-sun-dlj-v1-1 select true" | /usr/bin/debconf-set-selections
	echo "sun-java6-jre shared/accepted-sun-dlj-v1-1 select true" | /usr/bin/debconf-set-selections
	
	aptitude -y install sun-java6-jdk sun-java6-jre > $directory_logs/server_glassfish_install.log

	echo "JAVA_HOME=\"/usr/lib/jvm/java-6-sun\"" > /etc/environment
	echo "PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/lib/jvm/java-6-sun/bin" >> /etc/environment

}

################################################################################
# 11. Databases
################################################################################

########################################
# 11.1 MySQL
########################################

function mysql_install {

	# Set the password for the MySQL installation
	echo "mysql-server-5.1 mysql-server/root_password password $setting_mysql_root_password" | debconf-set-selections
	echo "mysql-server-5.1 mysql-server/root_password_again password $setting_mysql_root_password" | debconf-set-selections
	
	# Check for any updated packages and install mysql
	aptitude -y update
	aptitude -y install mysql-server

	# Set the root password for the installation
	mysqladmin -u root password $setting_mysql_password
	mysqladmin -u root -h localhost password $setting_mysql_password -p$setting_mysql_password

}

function mysql_configure {
	
	#!!!! EDIT /etc/mysql/my.cnf 
	
	# Secure MySQL
	mysql_secure_installation
	
	# Configure core settings
	#sed -i 's/[mysqld]/[mysqld]\ndefault-storage-engine=InnoDB/' /etc/mysql/my.cnf
		
}

function mysql_restart {
	
	service mysql restart
	
}

########################################
# 11.2 PostgreSQL
########################################

function postgresql_install {

	# Check for any updated packages and install postgresql
	aptitude -y update
	aptitude -y install postgresql postgresql-contrib
	
	# Set the password for the default postgres user
	passwd postgres $setting_postgres_password
	
	# Alter the password for the postgres user within the database
	psql -d template1 -c "ALTER USER postgres WITH PASSWORD '$setting_postgres_password';"
	
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

# Notice: FTP communication has been widely accepted as an insecure protocol.
# This script will not make use of FTP, instead users should consider a 
# combination of SSH/SFTP.

########################################
# Network File System
########################################

# Placeholder

########################################
# CUPS - Print Server
########################################

function cups_install {
	
	# Check for any updated packages and install cups
	aptitude -y update
	aptitude -y install cups
	
}

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
# Git
########################################

function git_install {
	util_aptitude -y install git-core git-svn
}

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

function backup_install {
	
	cat >> $setting_cron_file <<EOF
	#!/bin/sh
	####################################
	#
	# Backup to NFS mount script.
	#
	####################################

	# What to backup. 
	backup_files="/home /var/spool/mail /etc /root /boot /opt"

	# Where to backup to.
	dest="/mnt/backup"

	# Create archive filename.
	day=$(date +%A)
	hostname=$(hostname -s)
	archive_file="$hostname-$day.tgz"

	# Print start status message.
	echo "Backing up $backup_files to $dest/$archive_file"
	date
	echo

	# Backup the files using tar.
	tar czf $dest/$archive_file $backup_files

	# Print end status message.
	echo
	echo "Backup finished"
	date

	# Long listing of files in $dest to check file sizes.
	ls -lh $dest
EOF


	# Echo this to a cron file
	#cat "0 0 * * * bash /usr/local/bin/backup.sh" >>
	
}

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

function application_install_ntp {
	aptitude -y install ntp
}

################################################################################
# A1. Misc
################################################################################

# Delete unused users
function cleanup_unused_users {

	# Remove uneeded applications
	aptitude -y purge nano vsftpd lpr nfs-common portmap pidentd pcmcia-cs pppoe pppoeconf ppp pppconfig telnet-server telnet rsh-server rsh ypserv tftp-server talk-server talk
	
	
	# Enusre permissions are correct
	chown root:root /etc/passwd /etc/shadow /etc/group /etc/gshadow
	chmod 644 /etc/passwd /etc/group
	chmod 400 /etc/shadow /etc/gshadow

}