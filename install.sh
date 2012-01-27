#!/bin/bash

################################################################################
source ./config.sh
source ./core.sh
################################################################################

################################################################################
# Core Configuration
################################################################################

## Setup core features of the server

installation_disable_environment
installation_upgrade_release
installation_locale_update
installation_timezone_update
installation_motd_clear
installation_admin_skeleton_files
installation_admin_group_create
installation_admin_user_create

## Update the package management system

package_management_source_configure
package_management_aptitude_install
package_management_essentials_install

## Apply networking functionality

networking_hostname_update
networking_ntp_install

## Postfix is required for various packages

postfix_install_send_only
package_management_notifications_install

## Setup SSH now that the core functionality is setup

remote_admin_ssh_install
remote_admin_ssh_configure
remote_admin_ssh_banner_update
remote_admin_ssh_configure_sftp

## Configure the system firewall

firewall_backup
firewall_configure
firewall_finish

## Configure user security settings

user_management_adduser_configure
user_management_password_expirations
security_console_disable_reboot

## Install various security applications

chkrootkit_install
rkhunter_install
logwatch_install
fail2ban_install
logcheck_install
denyhosts_install

################################################################################
# MySQL
################################################################################

mysql_install

################################################################################
# PostgreSQL
################################################################################

postgresql_install

################################################################################
# PHP
################################################################################

php_install
php_configure

################################################################################
# Apache
################################################################################

apache_install
apache_configure_settings
apache_configure_modules

################################################################################
# Ruby on Rails
################################################################################

ruby_on_rails_install

################################################################################
# Java
################################################################################

java_install

################################################################################
# Apache Tomcat
################################################################################

#tomcat_install

################################################################################
# GlassFish
################################################################################

glassfish_install
glassfish_configure

################################################################################
# Git
################################################################################

git_install

################################################################################
# Backup
################################################################################

backup_install

################################################################################
# Exit
################################################################################

exit_message