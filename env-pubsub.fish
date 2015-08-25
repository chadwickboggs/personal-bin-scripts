#!/usr/bin/env fish

set -x MB_HOSTS "oss.messagebus.hosts"
set -x MB_HOSTS_VALUE "localhost"

set -x MY_SUBMIT_QUEUE "rxjdbc.messagebus.my.request.queue.name"
set -x MY_SUBMIT_QUEUE_VALUE rxjdbc.request.(hostname -f)

set -x SUBMIT_HANDLER_QUEUES "rxjdbc.messagebus.request.queues.names"
set -x SUBMIT_HANDLER_QUEUES_VALUE rxjdbc.response.(hostname -f),rxjdbc.response.fedora22.local

set -x ER_PUBLISHER_QUEUES "rxjdbc.messagebus.response.queues.names"
set -x ER_PUBLISHER_QUEUES_VALUE rxjdbc.response.(hostname -f),rxjdbc.response.fedora22.local

set -x MY_ER_HANDLER_QUEUE "rxjdbc.messagebus.my.response.queue.name"
set -x MY_ER_HANDLER_QUEUE_VALUE rxjdbc.request.(hostname -f)

set -x CATALINA_OPTS_ENV " \
-D$MB_HOSTS=\"$MB_HOSTS_VALUE\" \
-D$MY_SUBMIT_QUEUE=\"$MY_SUBMIT_QUEUE_VALUE\" \
-D$SUBMIT_HANDLER_QUEUES=\"$SUBMIT_HANDLER_QUEUE_VALUES\" \
-D$ER_PUBLISHER_QUEUES=\"$ER_PUBLISHER_QUEUES_VALUE\" \
-D$MY_ER_HANDLER_QUEUE=\"$MY_ER_HANDLER_QUEUE_VALUE\" \
"

echo "CATALINA_OPTS_ENV=\"$CATALINA_OPTS_ENV\""

