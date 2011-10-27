function number_of_processors {
	cat /proc/cpuinfo | grep -c processor
}