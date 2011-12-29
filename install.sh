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

################################################################################
# Package Management Configuration
################################################################################

#package_management_source_configure
#package_management_source_update
#package_management_aptitude_install
#package_management_aptitude_update
package_management_notifications_install
#package_management_essentials_install