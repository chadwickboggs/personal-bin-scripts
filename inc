#!/bin/bash

if [ $# != 0 ]; then
	echo "USAGE: $(dirname $0)"
	exit 1
fi

if [ -a /tmp/inc_tmp24_var24 ]; then
	inc_tmp24_var24="$(cat /tmp/inc_tmp24_var24)"
else
	inc_tmp24_var24='0'
fi

inc_tmp24_var24=$(dc -e "${inc_tmp24_var24} 1 + p")
echo "${inc_tmp24_var24}" > /tmp/inc_tmp24_var24

echo ${inc_tmp24_var24}

exit $?
