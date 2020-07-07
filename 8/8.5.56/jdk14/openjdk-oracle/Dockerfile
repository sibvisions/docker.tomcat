FROM tomcat:8.5.56-jdk14-openjdk-oracle 

RUN echo "export JAVA_OPTS=\"-Xmx768M\"" > /usr/local/tomcat/bin/setenv.sh 
RUN mv /usr/local/tomcat/webapps.dist/manager /usr/local/tomcat/webapps/manager

RUN sed -i 's/52428800/104857600/g' /usr/local/tomcat/webapps/manager/WEB-INF/web.xml

ENV TOMCAT_USER admin
ENV TOMCAT_PWD admin

RUN echo -e "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\
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

RUN echo -e "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\
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

RUN yum install -y mc

CMD ["catalina.sh", "run"]
