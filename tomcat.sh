#!/bin/sh -xe
export CATALINA_HOME=/usr/share/tomcat9
export CATALINA_BASE=/var/lib/tomcat9
export CATALINA_TMPDIR=/tmp
envs=CATALINA_HOME,CATALINA_BASE,CATALINA_TMPDIR

/usr/libexec/tomcat9/tomcat-update-policy.sh
su -w $envs -s /bin/sh -g tomcat - tomcat -c /usr/libexec/tomcat9/tomcat-start.sh
