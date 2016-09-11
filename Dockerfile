FROM maven:3.3.3

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME



ENV TOMCAT_TGZ_URL mirrors.aliyun.com/apache/tomcat/tomcat-8/v8.0.37/bin/apache-tomcat-8.0.37.tar.gz

RUN set -x \
        && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
        && curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
        && gpg --verify tomcat.tar.gz.asc \
        && tar -xvf tomcat.tar.gz --strip-components=1 \
        && rm bin/*.bat \
        && rm -rf webapps/* \
        && rm tomcat.tar.gz*

ADD pom.xml /tmp/build/
RUN cd /tmp/build && mvn -q dependency:resolve

ADD src /tmp/build/src
        #构建应用
RUN cd /tmp/build && mvn -q -DskipTests=true package \
        #拷贝编译结果到指定目录
        && rm -rf $CATALINA_HOME/webapps/* \
        && mv target/*.war $CATALINA_HOME/webapps/ROOT.war \
        #清理编译痕迹
        && cd / && rm -rf /tmp/build

EXPOSE 8080
CMD ["catalina.sh","run"]