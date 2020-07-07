FROM tomcat:8.5.56-jdk14-openjdk-oracle
MAINTAINER sibvisions

RUN yum install -y mc

ENV TOMCAT_HTTP_PORT 8080
ENV TOMCAT_HTTPS_PORT 443
ENV TOMCAT_AJP_PORT 8019
ENV TOMCAT_PORT 8015

ENV TOMCAT_XMX 768M
ENV TOMCAT_USER admin
ENV TOMCAT_PWD admin

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["catalina.sh", "run"]
