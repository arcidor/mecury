# Shows the current memory usage in MB
function memory_current_usage {
	free -m
}

# Shows how much memory current processes are using (sorted largest-smallest)
function memory_running_usage {
	ps -eo pmem,pcpu,rss,vsize,args | sort -k 1 -r
}

##### IO

# Shows IO activity for the server
function io_activity {
	iostat -d -x 2 5
}

function remove_domain {

	#First disable domain and reload webserver
	echo "Disabling $DOMAIN_ENABLED_PATH"
	rm -rf $DOMAIN_ENABLED_PATH
	reload_webserver
	#Then delete all files and config files
	echo "Removing /etc/awstats/awstats.$DOMAIN.conf"
	rm -rf /etc/awstats/awstats.$DOMAIN.conf
	echo "Removing $DOMAIN_PATH"
	rm -rf $DOMAIN_PATH
	echo "Removing $DOMAIN_CONFIG_PATH"
	rm -rf $DOMAIN_CONFIG_PATH
	echo "Removing /etc/logrotate.d/$LOGROTATE_FILE"
	rm -rf /etc/logrotate.d/$LOGROTATE_FILE

}




function server_mysql_install {

	# Install MySQL
	echo "mysql-server-5.1 mysql-server/root_password password $config_mysql_root_password" | debconf-set-selections
	echo "mysql-server-5.1 mysql-server/root_password_again password $config_mysql_root_password" | debconf-set-selections
	aptitude -y install mysql-server mysql-client

	# Secure MySQL
	#mysql_secure_installation
	
	# Configure core settings
	sed -i 's/[mysqld]/[mysqld]\ndefault-storage-engine=InnoDB/g' /etc/mysql/my.cnf
	
	echo "REEEESTARRRTTTTING"
	
	service mysql stop

}

server_mysql_install