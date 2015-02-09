#!/bin/bash

nwt_extract_msg.sh \
	~/mnt/nwtapp-ch2-a13p.sys/apache-tomcat-7.0.54/logs/$1 \
	| grep -v 'Compilation classpath initialized' \
	| grep -v '^[^a-zA-Z0-9]' \
	| parallel grep -v "{}" ~/mnt/nwtapp-dt-a1s.ula/apache-tomcat-7.0.54/logs/$1

