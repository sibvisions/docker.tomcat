FROM tomcat:9.0.105-jdk21-temurin-jammy
MAINTAINER sibvisions

RUN apt-get update
RUN apt-get --assume-yes install mc openssl postgresql

ENV TOMCAT_HTTP_PORT 8080
ENV TOMCAT_HTTPS_PORT 8443
ENV TOMCAT_AJP_PORT 8009
ENV TOMCAT_PORT 8005

ENV TOMCAT_XMX 768M
ENV TOMCAT_USER admin
ENV TOMCAT_PWD admin

ENV TOMCAT_LOGDAYS 30

ENV TOMCAT_KEYSTORE ""
ENV TOMCAT_KEYSTORE_PWD ""

ENV TOMCAT_EXTRA_JAVA_OPTS ""

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["catalina.sh", "run"]
