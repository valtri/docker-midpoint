#!/bin/sh -e
export CATALINA_HOME=/usr/share/tomcat9
export CATALINA_BASE=/var/lib/tomcat9
export CATALINA_TMPDIR=/tmp
envs=CATALINA_HOME,CATALINA_BASE,CATALINA_TMPDIR

if test -f /etc/${tomcat}/.docker-first-launch; then
	if test -n "$AJP_SECRET"; then
		info="with secret"
		secret="`echo $AJP_SECRET | sed 's,\\([\\\\"]\),\\\\\\1,g'`"
		AJP_SECRET_OPTION="secret=\"${secret}\""
	else
		info="without secret"
		AJP_SECRET_OPTION='secretRequired="false"'
	fi
	sed -i "/Service name=\"Catalina\".*/a \\\\n    <Connector port=\"8009\" protocol=\"AJP/1.3\" allowedRequestAttributesPattern=\".*\" ${AJP_SECRET_OPTION}/>" /etc/${tomcat}/server.xml
	rm -f /etc/${tomcat}/.docker-first-launch
	echo "/etc/${tomcat}/server.xml updated (AJP $info)"
fi

/usr/libexec/tomcat9/tomcat-update-policy.sh
su -w $envs -s /bin/sh -g tomcat - tomcat -c /usr/libexec/tomcat9/tomcat-start.sh
