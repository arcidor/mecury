#!/bin/bash

################################################################################
source ./config.sh
source ./core.sh
################################################################################

################################################################################
# Core Configuration
################################################################################

## Setup core features of the server

#installation_upgrade_release
#installation_locale_update
#installation_timezone_update
#installation_motd_clear
#installation_admin_group_create
#installation_admin_user_create

## Update the package management system

#package_management_source_configure
#package_management_aptitude_install
#package_management_essentials_install

## Apply networking functionality

#networking_hostname_update
#networking_ntp_install

## Postfix is required for package notification updates (among other updates)

#postfix_install_send_only
#package_management_notifications_install

## Setup SSH now that the core functionality is setup

#remote_admin_ssh_install
#remote_admin_ssh_configure
#remote_admin_ssh_banner_update
#remote_admin_ssh_configure_sftp
#remote_admin_ssh_restart

## Configure the system firewall

#firewall_backup
#firewall_configure
#firewall_finish

## Configure user security settings

#user_management_adduser_configure
#user_management_password_expirations
#security_console_disable_reboot
#security_alert_root

## Install various security applications

#chkrootkit_install
#rkhunter_install
#logwatch_install
#fail2ban_install
#logcheck_install
#denyhosts_install

################################################################################
# MySQL
################################################################################

#mysql_install
#mysql_configure
#mysql_restart

################################################################################
# PostgreSQL
################################################################################

#postgresql_install

################################################################################
# PHP
################################################################################

php_install
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
# Git
################################################################################

#git_install

################################################################################
# Backup
################################################################################

#backup_install