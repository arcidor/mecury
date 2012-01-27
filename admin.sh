#!/bin/bash

source setting.sh

################################################################################
# 2. System Info
################################################################################

# Displays the number of processors used by the system
function system_processors_count {
	cat /proc/cpuinfo | grep -c processor
}

# Displays the current memory usage in MB
function system_memory_check {
	free -m
}

# Displays how much memory current processes are using (sorted largest-smallest)
function system_current_usage {
	ps -eo pmem,pcpu,rss,vsize,args | sort -k 1 -r
}

# Reports information about processes, memory, paging, block IO, traps, and cpu activity.
function system_overall_activity {
	vmstat 3
}

# Reports on how long the server has been running
function system_uptime {
	uptime
}

################################################################################
# 3. Package Management
################################################################################

function pm_installed_packages {
	dpkg -l
}

# $1=package name
function pm_is_installed {
	dpkg -l | grep $1
}

# $1=package name
function pm_installed_files {
	dpkg -L $1
}

# Check which package installed a file
# $1 = file
function pm_file_associated {
	dpkg -S $1
}

function pm_installed_recently {
	zcat -f /var/log/dpkg.log* | grep "\ install\ " | sort
}

# $1=deb package
function pm_install_deb {
	dpkg -i $1
}

# $1=deb package
function pm_uninstall_deb {
	dpkg -r $1
}

# $1=package name
function pm_install {
	aptitude update
	aptitude upgrade
	aptitude install $1
}

# $1=package name
function pm_uninstall {
	aptitude remove $1
}

function pm_help {
	aptitude help
}

function pm_output_logs {
	cat /var/log/dpkg.log
}

################################################################################
# 4. Networking
################################################################################

function net_list_eth_interfaces {
	ifconfig -a | grep eth
}

function net_list_loopback_interface {
	ifconfig lo
}

function net_list_network {
	lshw -class network
}

################################################################################
# 5. Remote Administration
################################################################################

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
# 8.1 User Management
########################################

# $1=username, $2=real_name,$3=password
function sum_user_add {
	# Create the user
	sudo adduser --shell /bin/bash --disabled-password --gecos "$2,,," $1

	# Update the shadow file to prevent pam authentication errors
	sudo pwconv

	# Change the password
	sudo echo "$1:$3" | chpasswd
}

# $1=username
function sum_user_delete {
	# Move the users file to an archive directory
	sudo mkdir -p /home/.archived_users/
	sudo mkdir -p /home/.archived_users/$1
	sudo mv /home/$1 /home/.archived_users/$1
	
	# Change ownership of the files
	sudo chown -R root:root /home/.archived_users/$1/
}

# $1=username
function user_lock {
	sudo passwd -l $1
}

function user_unlock {
	sudo passwd -u $1
}

# $1=group
function group_add {
	sudo addgroup $1
}

# $1=group
function group_delete {
	sudo delgroup $1
}

# $1 = username
function user_account_status {
	sudo chage -l $1
}

function password_check_empty {
	sudo awk -F: '($2 == "") {print}' /etc/shadow
}

function find_unowned_files {
	sudo find / -xdev \( -nouser -o -nogroup \) -print
}

################################################################################
# 9. Monitoring
################################################################################

# Place holder

################################################################################
# 10. Web Servers
################################################################################

########################################
# 10.1 Apache Web Server
########################################

function apache_create_domain {
	# Create the virtual host file
	touch $1

	# Output the template to the virtual host file
	sudo cat > $1 <<EOF
<VirtualHost $setting_ip:80>

	ServerAdmin admin@$1
	ServerName $1
	ServerAlias *.$1
	
	DocumentRoot /srv/www/$1/public/
	CustomLog /srv/www/$1/logs/access.log combined
	ErrorLog /srv/www/$1/logs/error.log
	
	LogLevel warn
	
	# SSLEngine on
	# SSLOptions +StrictRequire
	# SSLCertificateFile /etc/ssl/certs/server.crt
	# SSLCertificateKeyFile /etc/ssl/private/server.key

	<Directory $1/public>
		Options Indexes FollowSymLinks
		AllowOverride All
		Order allow,deny
		allow from all
	</Directory>

</VirtualHost>
EOF
	
	# Move the file to the correct position and change access
	sudo mv $1 /etc/apache2/sites-available/$1
	sudo chown root:root /etc/apache2/sites-available/$1

	# Create the required directory structure
	sudo mkdir -p /srv/www/$1/private
	sudo mkdir -p /srv/www/$1/backup
	sudo mkdir -p /srv/www/$1/logs
	sudo touch /srv/www/$1/logs/access.log
	sudo touch /srv/www/$1/logs/error.log
	sudo mkdir -p /srv/www/$1/public
	sudo mkdir -p /srv/www/$1/public/css
	sudo mkdir -p /srv/www/$1/public/img
	sudo mkdir -p /srv/www/$1/public/js
	sudo mkdir -p /srv/www/$1/public/temp
	
	# Create a default welcome page
	touch index.html
	sudo cat > index.html <<EOF
Welcome to the default placeholder!
Overwrite or remove index.html when uploading your site. 
EOF
	
	# Move the file to the correct position and change access
	sudo mv index.html /srv/www/$1/public/index.html
	sudo chown root:root /srv/www/$1/public/index.html
	
	# Create a robot.txt file
	touch robots.txt
	sudo cat > robots.txt <<EOF
User-agent: *
Disallow: /public/temp/
Sitemap: http://www.$1/sitemap.xml
EOF

	# Move the file to the correct position and change access
	sudo mv robots.txt /srv/www/$1/public/robots.txt
	sudo chown root:root /srv/www/$1/public/robots.txt

	# Check permissions are correct
	sudo chown -R $setting_domain_owner:$setting_domain_owner /srv/www/
	
	# Enable the site
	sudo a2ensite $1

	# Enable the domain and restart Apache
	sudo a2ensite $1
	sudo /etc/init.d/apache2 restart
}

function apache_disable_domain {
	# Disable the domain and restart Apache
	sudo a2dissite $1
	sudo /etc/init.d/apache2 restart
}

function apache_ssl_enable {
	sudo a2enmod ssl
	
	sed -i "s/# SSLEngine on/SSLEngine on/" /etc/apache2/sites-available/$1
	sed -i "s/# SSLOptions +StrictRequire/ SSLOptions +StrictRequire/" /etc/apache2/sites-available/$1
	sed -i "s/# SSLCertificateFile \/etc\/ssl\/certs\/server.crt/ SSLCertificateFile \/etc\/ssl\/certs\/server.crt/" /etc/apache2/sites-available/$1
	sed -i "s/# SSLCertificateKeyFile \/etc\/ssl\/private\/server.key/SSLCertificateKeyFile \/etc\/ssl\/private\/server.key/" /etc/apache2/sites-available/$1
}

function server_apache_reload {
	/etc/init.d/apache2 reload
}

################################################################################
# 11. Databases
################################################################################

########################################
# 11.1 MySQL
########################################

function mysql_check_database {
	mysqlcheck -p -u root virtual
}

function mysql_repair {
	mysqlcheck -p -u root –repair –quick virtual	
}

function mysql_backup {
	mysqldump -p -u root –opt virtual > /backup/virtual-2010-10-24
}

########################################
# 11.2 PostgreSQL
########################################

# $1 = username
function postgres_create_user {
	su - postgres
	createuser $1 --pwprompt
}

# $1 = username
function postgres_delete_user {
	su - postgres
	dropuser $1
}

# $1 = username, $2 = databaseName
function postgres_grant_privileges {
	su - postgres
	createdb $2
	psql $2
	GRANT ALL PRIVILEGES ON DATABASE $2 to $1;
}

################################################################################
# 12. LAMP Applications
################################################################################

# Place holder

################################################################################
# 13. File Servers
################################################################################

# Place holder

################################################################################
# 14. Email Services
################################################################################

# Place holder

################################################################################
# 15. Chat Applications
################################################################################

# Place holder

################################################################################
# 16. Version Control System
################################################################################

# Place holder

################################################################################
# 17. Windows Networking
################################################################################

# Place holder

################################################################################
# 18. Backups
################################################################################

# Place holder

################################################################################
# 19. Virtualization
################################################################################

# Place holder

################################################################################
# 20. Clustering
################################################################################

# Place holder

################################################################################
# 22. Other Useful Applications
################################################################################

# Gives a user access to a Chrooted directory
# $1 = username
function user_enable_strict_sftp {	
	sudo usermod -a -G sftp $1
	sudo chown root:root /home/$1
	sudo mkdir -p /home/$1/home/$1
	sudo chown $1:$1 /home/$1/home/$1
	sudo usermod -s /bin/false $1 
}

function user_set_passowrd_expiry {
	chage -M 60 -m 7 -W 7 userName
}

function find_world_writable_files {
	find /dir -xdev -type d \( -perm -0002 -a ! -perm -1000 \) -print
}