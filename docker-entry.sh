#! /bin/bash -e

service apache2 start
service tomcat8 start || :
exec "$@"
