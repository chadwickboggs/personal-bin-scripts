#!/usr/bin/env bash

if [[ $# < 1 ]]; then
        echo "DB name must be provided on the command line."

        exit 1
fi

db_name=${@:$#}
mysql_args=${@:1:$#-1}
shift

mysql -Ns ${mysql_args} -e 'show tables' ${db_name} | while read table; do mysql ${mysql_args} -e "SET FOREIGN_KEY_CHECKS=0; truncate table \`${table}\`" ${db_name}; done

