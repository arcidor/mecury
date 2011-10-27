function mysql_check_database {
	mysqlcheck -p -u root virtual
}


function mysql_repair {
	mysqlcheck -p -u root –repair –quick virtual	
}

function mysql_backup {
	mysqldump -p -u root –opt virtual > /backup/virtual-2010-10-24
}

function system_memory_check {
	free -m
}






alias free="free -m"
alias update="sudo aptitude update"
alias install="sudo aptitude install"
alias upgrade="sudo aptitude safe-upgrade"
alias remove="sudo aptitude remove"