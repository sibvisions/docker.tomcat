#!/bin/sh
set -euo pipefail

function prop {
  if [ ! -e "/env/tomcat.properties" ]; then
    echo $2;
  else
    declare value=`grep -w "${1}" /env/tomcat.properties|cut -d'=' -f2`

    if [ -z "$value" ]; then
      echo $2;
    else
      echo $value;
    fi;
  fi
}

# check to see if this file is being run or sourced from another script
_is_sourced() 
{
  # https://unix.stackexchange.com/a/215279
  [ "${#FUNCNAME[@]}" -ge 2 ] \
    && [ "${FUNCNAME[0]}" = '_is_sourced' ] \
    && [ "${FUNCNAME[1]}" = 'source' ]
}

_main() 
{
  if [ "$1" = 'catalina.sh' ]; then

    if [ -d "/usr/local/tomcat/webapps.dist/manager" ]; then
      mv /usr/local/tomcat/webapps.dist/manager /usr/local/tomcat/webapps/manager
      sed -i 's/52428800/104857600/g' /usr/local/tomcat/webapps/manager/WEB-INF/web.xml

      echo -e "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\
<!--\n\
  Licensed to the Apache Software Foundation (ASF) under one or more\n\
  contributor license agreements.  See the NOTICE file distributed with\n\
  this work for additional information regarding copyright ownership.\n\
  The ASF licenses this file to You under the Apache License, Version 2.0\n\
  (the "License"); you may not use this file except in compliance with\n\
  the License.  You may obtain a copy of the License at\n\
\n\
      http://www.apache.org/licenses/LICENSE-2.0\n\
\n\
  Unless required by applicable law or agreed to in writing, software\n\
  distributed under the License is distributed on an "AS IS" BASIS,\n\
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n\
  See the License for the specific language governing permissions and\n\
  limitations under the License.\n\
-->\n\
<Context antiResourceLocking=\"false\" privileged=\"true\">\n\
  <!--\n\
  <Valve className=\"org.apache.catalina.valves.RemoteAddrValve\"\n\
         allow=\"127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1\" />\n\
  -->\n\
  <Manager sessionAttributeValueClassNameFilter=\"java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)\n\?|java\.util\.(?:Linked)?HashMap\"/>\n\
</Context>" > /usr/local/tomcat/webapps/manager/META-INF/context.xml

      echo
      echo 'Manager application deployed;'
      echo
    fi

    echo -e "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\
<!--\n\
  Licensed to the Apache Software Foundation (ASF) under one or more\n\
  contributor license agreements.  See the NOTICE file distributed with\n\
  this work for additional information regarding copyright ownership.\n\
  The ASF licenses this file to You under the Apache License, Version 2.0\n\
  (the "License"); you may not use this file except in compliance with\n\
  the License.  You may obtain a copy of the License at\n\
\n\
      http://www.apache.org/licenses/LICENSE-2.0\n\
\n\
  Unless required by applicable law or agreed to in writing, software\n\
  distributed under the License is distributed on an "AS IS" BASIS,\n\
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n\
  See the License for the specific language governing permissions and\n\
  limitations under the License.\n\
-->\n\
<tomcat-users>\n\
  <role rolename=\"manager-gui\"/>\n\
  <role rolename=\"manager-script\"/>\n\
\n\
  <user username=\"$TOMCAT_USER\" password=\"$TOMCAT_PWD\" roles=\"manager-gui,manager-script\"/>\n\
</tomcat-users>" > /usr/local/tomcat/conf/tomcat-users.xml

#    if [ ! -z "$TOMCAT_SSL_CERT_PKCS7" ]; then
#      echo "-----BEGIN PKCS7-----" > /usr/local/tomcat/conf/certificate.pkcs
#      echo "$TOMCAT_SSL_CERT_PKCS7" | sed 's/\s\+/\n/g' | head -n -2 | tail -n +3 >> /usr/local/tomcat/conf/certificate.pkcs
#      echo "-----END PKCS7-----" >> /usr/local/tomcat/conf/certificate.pkcs
#
#      openssl pkcs7 -print_certs -in /usr/local/tomcat/conf/certificate.pkcs -out /usr/local/tomcat/conf/certificate.cert
#      keytool -import -trustcacerts -alias tomcat -file /usr/local/tomcat/conf/certificate.cert -keystore /usr/local/tomcat/conf/keystore -storepass $TOMCAT_SSL_CERT_PWD -noprompt
#
#      rm /usr/local/tomcat/conf/certificate.pkcs
#
#      declare oldValue="<!--\n    <Connector port=\"8443\""
#      declare newValue="<Connector port=\"8443\" protocol=\"HTTP\/1.1\" SSLEnabled=\"true\" maxThreads=\"150\" scheme=\"https\" secure=\"true\" keystoreFile=\"conf\/keystore\" keystorePass=\"$TOMCAT_SSL_CERT_PWD\" keyAlias=\"tomcat\" clientAuth=\"false\" sslProtocol=\"TLS\" \/>\n<!--\n    <Connector port=\"8443\""
#            
#      sed -z 's/'"$oldValue"'/'"$newValue"'/g' -i /usr/local/tomcat/conf/server.xml 
#
#      export TOMCAT_SSL_CERT_PKCS7=""
#      export TOMCAT_SSL_CERT_PWD=""
#    fi

    if [ ! -z "$TOMCAT_KEYSTORE" ]; then

      echo $TOMCAT_KEYSTORE | base64 -d > /usr/local/tomcat/conf/keystore

      declare oldValue="<!--\n    <Connector port=\"8443\""
      declare newValue="<Connector port=\"8443\" protocol=\"HTTP\/1.1\" SSLEnabled=\"true\" maxThreads=\"150\" scheme=\"https\" secure=\"true\" keystoreFile=\"conf\/keystore\" keystorePass=\"$TOMCAT_KEYSTORE_PWD\" keyAlias=\"tomcat\" clientAuth=\"false\" sslProtocol=\"TLS\" \/>\n<!--\n    <Connector port=\"8443\""

      sed -z 's/'"$oldValue"'/'"$newValue"'/1' -i /usr/local/tomcat/conf/server.xml 

    fi

    declare r1=$(prop 'http' 8080)
    declare r2=$(prop 'https' 8443)
    declare r3=$(prop 'ajp' 8009)
    declare r4=$(prop 'server' 8005)

    sed -i 's/'"$r1"'/'"$TOMCAT_HTTP_PORT"'/g' /usr/local/tomcat/conf/server.xml
    sed -i 's/'"$r2"'/'"$TOMCAT_HTTPS_PORT"'/g' /usr/local/tomcat/conf/server.xml
    sed -i 's/'"$r3"'/'"$TOMCAT_AJP_PORT"'/g' /usr/local/tomcat/conf/server.xml
    sed -i 's/'"$r4"'/'"$TOMCAT_PORT"'/g' /usr/local/tomcat/conf/server.xml

    # Save for next startup replacement
    if [ ! -d "/env" ]; then
      mkdir /env
    fi

    echo "http=$TOMCAT_HTTP_PORT" > /env/tomcat.properties
    echo "https=$TOMCAT_HTTPS_PORT" >> /env/tomcat.properties
    echo "ajp=$TOMCAT_AJP_PORT" >> /env/tomcat.properties
    echo "server=$TOMCAT_PORT" >> /env/tomcat.properties

    echo "export JAVA_OPTS=\"-Xmx$TOMCAT_XMX\"" > /usr/local/tomcat/bin/setenv.sh

    echo
    echo 'Tomcat init process complete; ready for start up.'
    echo

  fi

  exec "$@"
}

# If we are sourced from elsewhere, don't perform any further actions
if ! _is_sourced; then
  _main "$@"
fi
