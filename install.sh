#!/bin/bash

################################################################################
# Load Required Files
################################################################################

source ./setting.sh
source ./core.sh

################################################################################
# Post Installation Setup
################################################################################

#installation_upgrade_release
#installation_locale_update
#installation_timezone_update
#installation_motd_clear
#installation_admin_group_create
#installation_admin_user_create

################################################################################
# Network Configuration
################################################################################

#networking_hostname_update
#networking_ntp_install

################################################################################
# Postfix (Send Only)
################################################################################

postfix_install_send_only

################################################################################
# Package Management Configuration
################################################################################

#package_management_source_configure
#package_management_source_update
#package_management_aptitude_install
#package_management_aptitude_update
#package_management_notifications_install
#package_management_essentials_install

################################################################################
# SSH Configuration
################################################################################

#remote_admin_ssh_install
#remote_admin_ssh_configure
#remote_admin_ssh_banner_update
#remote_admin_ssh_configure_sftp
#remote_admin_ssh_restart

################################################################################
# Security
################################################################################

#user_management_adduser_configure
#user_management_password_expirations
#security_console_disable_reboot
#firewall_backup
#firewall_configure
#firewall_finish
#chkrootkit_install
#rkhunter_install
#logwatch_install
#fail2ban_install
#logcheck_install
#denyhosts_install
#security_alert_root

################################################################################
# MySQL
################################################################################

#mysql_install
#mysql_configure
#mysql_restart

################################################################################
# PostgreSQL
################################################################################

postgresql_install

################################################################################
# PHP
################################################################################

#php_install
#php_configure

################################################################################
# Apache
################################################################################

#apache_install
#apache_configure_settings
#apache_configure_modules
#apache_restart

################################################################################
# Ruby on Rails
################################################################################

#ruby_on_rails_install

################################################################################
# Apache Tomcat
################################################################################

#tomcat_install

################################################################################
# GlassFish
################################################################################

#java_install

################################################################################
# Backup
################################################################################




