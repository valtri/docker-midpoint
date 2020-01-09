FROM debian:stretch
MAINTAINER František Dvořák <valtri@civ.zcu.cz>

ENV tomcat tomcat8
ENV tomcat_user tomcat8

EXPOSE 8009 8080

WORKDIR /root

# graphviz - for GUI features
# xmlstarlet - for docker image scripts
# tomcat additional packages (to prevent warnings), native package
RUN apt-get update && apt-get install -y --no-install-recommends \
    gzip \
    graphviz \
    libmysql-java \
    mc \
    openjdk-8-jdk \
    $tomcat libservlet3.1-java libcommons-dbcp-java libcommons-pool-java libtcnative-1 \
    wget \
    xmlstarlet \
 && rm -rf /var/lib/apt/lists/*

# mc (cosmetics)
RUN mkdir -p ~/.config/mc/ \
 && echo 'ENTRY "/var/lib/${tomcat}/webapps/midpoint/WEB-INF" URL "/var/lib/${tomcat}/webapps/midpoint/WEB-INF"' >> ~/.config/mc/hotlist \
 && echo 'ENTRY "/var/log/${tomcat}" URL "/var/log/${tomcat}"' >> ~/.config/mc/hotlist \
 && echo 'ENTRY "/var/opt/midpoint" URL "/var/opt/midpoint"' >> ~/.config/mc/hotlist \
 && ln -s /usr/lib/mc/mc.csh /etc/profile.d/ \
 && ln -s /usr/lib/mc/mc.sh /etc/profile.d/

# tomcat
RUN service tomcat8 stop \
 && echo 'JAVA_OPTS="${JAVA_OPTS} -Xms256m -Xmx1024m -Xss1m -Dmidpoint.home=/var/opt/midpoint -Djavax.net.ssl.trustStore=/var/opt/midpoint/keystore.jceks -Djavax.net.ssl.trustStoreType=jceks"' >> /etc/default/${tomcat} \
 && sed -i '/Service name="Catalina".*/a \\n    <Connector port="8009" protocol="AJP/1.3"/>' /etc/${tomcat}/server.xml
RUN mkdir /var/opt/midpoint \
 && chown ${tomcat_user}:${tomcat_user} /var/opt/midpoint

ENV v 3.9

# zip - clearing war
RUN apt-get update && apt-get install -y --no-install-recommends zip \
 && rm -rf /var/lib/apt/lists/*

# midpoint
RUN wget -nv https://evolveum.com/downloads/midpoint/${v}/midpoint-${v}-dist.tar.gz \
 && tar xzf midpoint-${v}-dist.tar.gz \
 && cp -vp midpoint-${v}/lib/midpoint.war /var/lib/${tomcat}/webapps/ \
 && zip -v -d /var/lib/${tomcat}/webapps/midpoint.war WEB-INF/lib-provided/\* \
 && rm -rf midpoint-${v}-dist.tar.gz midpoint-${v}/

# deployment
# (tomcat8 startup is OK, but returns non-zero code)
RUN service tomcat8 start || : \
 && while ! test -f /var/opt/midpoint/config.xml; do sleep 0.5; done \
 && sleep 60 \
 && service tomcat8 stop \
 && rm -fv /var/opt/midpoint/midpoint*.db /var/log/${tomcat}/* \
 && rm -rf /var/lib/${tomcat}/webapps/ROOT/ /var/lib/${tomcat}/webapps/midpoint/ /var/lib/${tomcat}/work/Catalina/
RUN ln -L /usr/share/java/mysql-connector-java.jar /var/lib/${tomcat}/lib/
RUN wget -nv -P /var/opt/midpoint/icf-connectors/ http://nexus.evolveum.com/nexus/content/repositories/openicf-releases/org/forgerock/openicf/connectors/scriptedsql-connector/1.1.2.0.em3/scriptedsql-connector-1.1.2.0.em3.jar

COPY docker-entry.sh /
CMD /docker-entry.sh /bin/bash -l
