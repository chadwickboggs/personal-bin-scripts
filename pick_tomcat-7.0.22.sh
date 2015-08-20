#!/usr/bin/env bash

tc_version="7.0.22"

export CATALINA_HOME="/opt/dev/apache/tomcat/instances/$tc_version"

export PATH="$CATALINA_HOME/bin:$PATH"

export CATALINA_OPTS="-XX:-UseLWPSynchronization -Dhttp.keepAlive=true -XX:PermSize=256m -XX:MaxPermSize=512m -Xms2G -Xmx2G -XX:MaxGCPauseMillis=850 -XX:+UseConcMarkSweepGC -Djava.awt.headless=true -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9095 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=true -Dcom.sun.management.jmxremote.password.file=$CATALINA_HOME/conf/jmxremote.password -Dcom.sun.management.jmxremote.access.file=$CATALINA_HOME/conf/jmxremote.access -Dorg.apache.tomcat.util.http.ServerCookie.ALLOW_EQUALS_IN_VALUE=true -Dorg.apache.tomcat.util.http.ServerCookie.ALLOW_HTTP_SEPARATORS_IN_V0=true"
export JPDA_TRANSPORT=dt_socket
export JPDA_ADDRESS=5005
export JPDA_SUSPEND=n
export CATALINA_OPTS="-agentlib:jdwp=transport=${JPDA_TRANSPORT},server=y,suspend=${JPDA_SUSPEND},address=${JPDA_ADDRESS} ${CATALINA_OPTS}"

exit $?
