#!/bin/bash

################################################################################
# Server Access
################################################################################

# Administrator
setting_admin="administrator"			# Name of the administrative user
setting_admin_password="pass"			# Password for the administrative user
setting_admin_email="admin@email.com"	# Email for the administrative user

# Groups
setting_group_admin="admin"				# Admin group, grants sudo privileges
setting_group_ssh="ssh"					# Login group, access via SSH
setting_group_sftp="sftp"				# Login group, grants access via SFTP

################################################################################
# Server Properties
################################################################################

setting_region="gb"						# Country closest to server
setting_release="natty"					# Distro release version
setting_locale="en_GB.utf8"				# Locale for the system
setting_location="UTC"					# Timezone

################################################################################
# Network Properties
################################################################################

setting_hostname="zeus"					# Hostname for the system
setting_fqdn="zeus.arcidor.com"			# Fully Qualified Domain Name
setting_domain="arcidor.com"			# Domain name
setting_ip="109.74.196.160"				# Server IP
setting_interal_ip="192.168.163.176"	# Local IP
setting_ssh_port="2345"					# Port over which SSH will be accessed

################################################################################
# Application Properties
################################################################################

# Apache
setting_domain_owner="www-data"			# Server owner

# MySQL
setting_mysql_password="pass"			# Password for the MySQL root user
setting_mysql_memory_limit="64"			# Memory limit for MySQL processes