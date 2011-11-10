################################################################################
# 2. System Info
################################################################################

function number_of_processors {
	cat /proc/cpuinfo | grep -c processor
}

function system_memory_check {
	free -m
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
	apt-get update
	apt-get upgrade
	apt-get install $1
}

# $1=package name
function pm_uninstall {
	apt-get remove $1
}

function pm_help {
	apt-get help
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

	username = `lower $1`
	full_name = $2
	password = $3

	# Create the user and change the account password
	sudo adduser --shell /bin/bash --disabled-password --gecos "$full_name,,," $username
	echo "$username:$password" | chpasswd

	# Set the password expiry to 90 days and the warning to 14 days
	chage -M 90 -W 14 $username

}

# $1=username
function sum_user_delete {
	sudo mkdir /home/.archived_users/
	sudo mv /home/$1 
	sudo chown -R root:root /home/archived_users/$1/
	
	sudo /home/$1/rm ssh/authorized_keys
}

# $1=username
function user_lock {
	sudo passwd -l $1
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

function password_check_crackable {
	# This function will check to see if any password are crackable by various
	# software applications available.
	
	# John  the Ripper, L0phtCrack, Crack
	
	# Copy the /etc/passwd and /etc/shadow
	# run program off the production server
}

function password_check_empty {
	awk -F: '($2 == "") {print}' /etc/shadow
}

function find_unowned_files {
	find / -xdev \( -nouser -o -nogroup \) -print
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
	touch /etc/apache2/sites-available/$1

	# Output the template to the virtual host file
	cat > /etc/apache2/sites-available/$1 <<EOF
<VirtualHost $setting_ip:80>

	ServerAdmin admin@$1
	ServerName $1
	ServerAlias *.$1
	
	DocumentRoot /srv/www/$1/public/

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
	
	CustomLog /srv/www/$1/logs/access.log combined
	ErrorLog /srv/www/$1/logs/error.log
	
	LogLevel warn

</VirtualHost>
EOF

}

function apache_enable_domain {

	# Enable the domain and restart Apache
	sudo a2ensite $1
	sudo /etc/init.d/apache2 restart

}

function apache_disable_domain {
	
	# Disable the domain and restart Apache
	sudo a2dissite mynewsite
	sudo /etc/init.d/apache2 restart
	
}

function apache_ssl_enable {
	
	sudo a2enmod ssl
	
	sed -i "s/# SSLEngine on/SSLEngine on/" /etc/apache2/sites-available/$1
	sed -i "s/# SSLOptions +StrictRequire/ SSLOptions +StrictRequire/" /etc/apache2/sites-available/$1
	sed -i "s/# SSLCertificateFile \/etc\/ssl\/certs\/server.crt/ SSLCertificateFile \/etc\/ssl\/certs\/server.crt/" /etc/apache2/sites-available/$1
	sed -i "s/# SSLCertificateKeyFile \/etc\/ssl\/private\/server.key/SSLCertificateKeyFile \/etc\/ssl\/private\/server.key/" /etc/apache2/sites-available/$1

}





function server_apache_configure_domain {

	
	
	


	# Create the required directory structure
	mkdir -p /srv/www/$domain/private
	mkdir -p /srv/www/$domain/backup
	mkdir -p /srv/www/$domain/log
	mkdir -p /srv/www/$domain/public
	mkdir -p /srv/www/$domain/public/css
	mkdir -p /srv/www/$domain/public/img
	mkdir -p /srv/www/$domain/public/js
	mkdir -p /srv/www/$domain/public/temp
	
	# Create a default welcome page
	cat > /srv/www/$domain/public/index.html <<EOF
Welcome to the default placeholder!
Overwrite or remove index.html when uploading your site. 
EOF
	
	# Create a robot.txt file
	cat > /srv/www/$domain/public/robots.txt <<EOF
User-agent: *
Disallow: /public/temp/
Sitemap: http://www.$domain/sitemap.xml
EOF

	# Check permissions are correct
	chown -R $setting_domain_owner:$setting_domain_owner /srv/www/
	
	# Enable the site
	a2ensite $domain > $directory_logs/server_apache_settingure_domain.log
	
}



################################################################################
# 11. Databases
################################################################################

function mysql_check_database {
	mysqlcheck -p -u root virtual
}

function mysql_repair {
	mysqlcheck -p -u root –repair –quick virtual	
}

function mysql_backup {
	mysqldump -p -u root –opt virtual > /backup/virtual-2010-10-24
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

# Place holder




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









