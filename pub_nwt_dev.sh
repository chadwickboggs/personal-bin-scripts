#!/usr/bin/env bash

TOMCAT_INSTANCES_FOLDER="/opt/dev/apache/tomcat/instances"
TOMCAT_VERSIONS=($(ls "${TOMCAT_INSTANCES_FOLDER}"))

echo 'Publishing NWT...'

exit_code=0

for tomcat_version in "${TOMCAT_VERSIONS[@]}"; do

	tomcat_home="${TOMCAT_INSTANCES_FOLDER}/${tomcat_version}"
	echo
	echo "	tomcat_home=\"${tomcat_home}\""
	echo

	#
	# Deploy Application WAR Files
	#

	echo 'Deploying application WAR files...'
	lspf "{}" -name '*.war'|parallel cp -v "{}" "${tomcat_home}/webapps/."
	(( exit_code += $? ))
	echo 'Deploying application WAR files Complete.'

	#
	# Configure JMX Remote
	#

	echo
	echo 'Configuring JMX Remote...'
	cp -v "NWT_Core_Processes/NWT_Core_GridController/src/main/resourcesDir/jmxremote.access.dev"	"${tomcat_home}/conf/jmxremote.access"
	(( exit_code += $? ))
	cp -v "NWT_Core_Processes/NWT_Core_GridController/src/main/resourcesDir/jmxremote.password.dev"	"${tomcat_home}/conf/jmxremote.password"
	(( exit_code += $? ))
	chmod og-rwx "${tomcat_home}/conf/jmxremote.password"
	(( exit_code += $? ))
	echo 'Configuring JMX Remote Complete.'

	#
	# Enable Cross Context
	#

	echo
	echo 'Enabling Cross Context...'
	replace '<Context>' '<Context crossContext="true">' -- "${tomcat_home}/conf/context.xml"
	(( exit_code += $? ))
	echo 'Enabling Cross Context Complete.'

done

echo
echo 'Publishing NWT Complete.'

exit ${exit_code}
