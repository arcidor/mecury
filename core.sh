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
	# Upgrade to the latest version of Ubuntu
	do-release-upgrade
}

function installation_locale_update {
	# Enable the locale set in the settings file
	/usr/sbin/locale-gen $setting_locale
	/usr/sbin/update-locale LANG=$setting_locale
}

function installation_timezone_update {
	# Update the timezone to the one set in the settings folder
	ln -sf /usr/share/zoneinfo/$setting_location /etc/localtime
}

function installation_motd_clear {
	# Clear the message of the day file
	cat /dev/null > /etc/motd
}

function installation_admin_group_create {
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
}

function installation_admin_user_create {
	# Create the admin user and change the account password
	adduser --ingroup $setting_group_admin --shell /bin/bash --disabled-password --gecos "Administrator,,," $setting_admin
	echo "$setting_admin:$setting_admin_password" | chpasswd

	# Set the password expiry to 90 days and the warning to 14 days
	chage -M 90 -W 14 $setting_admin
}

################################################################################
# 3. Package Management
################################################################################

function package_management_source_configure {
	# Make a backup of the source list
	cp /etc/apt/{sources.list,sources.list.backup}

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
}

function package_management_source_update {
	# Update the package list
	apt-get -y update
}

function package_management_aptitude_install {
	# Install aptitude 
	apt-get -y install aptitude

	# Update aptitude and upgrade the system
	aptitude -y update
}

function package_management_aptitude_update {
	# Update the system via aptitude
	aptitude -y update
}

function package_management_notifications_install {
	# Install apticron
	aptitude -y install apticron
	
	# Make a backup of the apticron config file
	cp /etc/apticron/{apticron.conf,apticron.conf.backup}
	
	# Configure for the correct email
	sed -i "s/^EMAIL=.*/EMAIL=\"$setting_admin_email\"/" /etc/apticron/apticron.conf
}

function package_management_essentials_install {
	# Install commonly used software
	aptitude -y install build-essential curl dnsutils htop iotop libssl-dev libreadline5-dev lshw screen unzip vim wget zlib1g-dev
}

################################################################################
# 4. Networking
################################################################################

function networking_hostname_update {
	# Set the hostname
	echo $setting_hostname > /etc/hostname
    hostname -F /etc/hostname

	# Backup the DHCP setting file
	cp /etc/default/{dhcpcd,dhcpcd.backup}
	
	# Disable DHCP setting the system hostname
	sed -i "s/SET_HOSTNAME/#SET_HOSTNAME/" /etc/default/dhcpcd

	# Set the FQDN
	cp /etc/{hosts,hosts.backup}
	sed -i "s/127.0.0.1.*/127.0.0.1       localhost.localdomain   localhost\n$setting_ip       $setting_fqdn   $setting_hostname/" /etc/hosts

	# Restart the service
	service hostname start
}

function networking_ntp_install {
	# Install the Network Time Protocol package
	aptitude -y install ntp

 	# Update the configuration file to reflect an addtional time pool
	cp /etc/{ntp.conf,ntp.conf.backup}
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
# AuthorizedKeysFile	%h/.ssh/authorized_keys
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
# GSSAPICleanupCredentials yes
# GSSAPIKeyExchange no
# GSSAPIStrictAcceptorCheck no
# HostbasedAuthentication no
HostbasedUsesNameFromPacketOnly
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

function remote_admin_ssh_banner_update {
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
	# Sort users into groups when created
	sed -i "s/^GROUPHOMES=no/GROUPHOMES=yes/" /etc/adduser.conf
	
	# Set the default access to user only
	sed -i "s/^DIR_MODE.*/DIR_MODE=0700/" /etc/adduser.conf
}

function user_management_password_expirations {
	# Update the password expiration times
	sed -i "s/^PASS_MAX_DAYS.*/PASS_MAX_DAYS 60/" /etc/login.defs
	sed -i "s/^PASS_MIN_DAYS.*/PASS_MIN_DAYS 7/" /etc/login.defs
	sed -i "s/^PASS_WARN_AGE.*/PASS_WARN_AGE 7/" /etc/login.defs
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

	# Create the ckhrootkit daily script file
	cat >> /etc/cron.daily/chkrootkit.sh <<EOF
#!/bin/sh
(
/usr/local/chkrootkit/chkrootkit
) | /bin/mail -s 'Chkrootkit Output:' $setting_admin_email
EOF

	# Apply the correct permissions to the file
	chmod 700 /etc/cron.daily/chkrootkit.sh
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
	/usr/bin/rkhunter --update
	/usr/bin/rkhunter --cronjob --report-warnings-only
) | /bin/mail -s 'RKHunter Output:' $setting_admin_email
EOF
	
	# Apply the correct permissions to the file
	chmod 700 /etc/cron.daily/rkhunter.sh
}