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
# Package Management Configuration
################################################################################

#package_management_source_configure
#package_management_source_update
#package_management_aptitude_install
#package_management_aptitude_update
#package_management_notifications_install
#package_management_essentials_install

################################################################################
# Network Configuration
################################################################################

#networking_hostname_update
#networking_ntp_install

################################################################################
# SSH Configuration
################################################################################

#remote_admin_ssh_install
#remote_admin_ssh_configure
#remote_admin_ssh_banner_update
#remote_admin_ssh_configure_sftp
#remote_admin_ssh_restart

################################################################################
# Puppert Configuration
################################################################################

# Not implemented

################################################################################
# Authentication
################################################################################

# Not implemented

################################################################################
# Domain Name Service Installation
################################################################################

# Not implemented

################################################################################
# Security
################################################################################

#user_management_adduser_configure
#user_management_password_expirations
user_management_users_cleanup