#! /bin/bash -e

if grep -q 'encryptionKeyAlias.*default' /var/opt/midpoint/config.xml; then
  echo 'Generating midPoint key'
  keytool -genseckey -alias strong -keystore /var/opt/midpoint/keystore.jceks -storetype jceks -storepass changeit -keyalg AES -keysize 256 -keypass midpoint
  chown tomcat8:tomcat8 /var/opt/midpoint/keystore.jceks
  xmlstarlet ed --inplace --update '/configuration/midpoint/keystore/encryptionKeyAlias' --value strong /var/opt/midpoint/config.xml
  xmlstarlet ed --inplace --append '/configuration/midpoint/keystore/encryptionKeyAlias' --type elem --name xmlCipher --value 'http://www.w3.org/2001/04/xmlenc#aes256-cbc' /var/opt/midpoint/config.xml
fi
service apache2 start
service tomcat8 start || :
exec "$@"
