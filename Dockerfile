FROM tomcat:8

ARG SOLR_URL

MAINTAINER  Adams Lee "adamslee@outlook.com"

RUN apt-get update

RUN apt-get install -y git

COPY solr.xml /usr/local/tomcat/conf/Catalina/localhost/

COPY solr-4.7.1.tgz /usr/local/solr-4.7.1.tgz

# download on building is slow. So changed to use the local file.
# RUN curl -L -o /usr/local/solr-4.7.1.tgz http://archive.apache.org/dist/lucene/solr/4.7.1/solr-4.7.1.tgz && \

RUN tar zxvf /usr/local/solr-4.7.1.tgz -C /usr/local/ && \  
    rm /usr/local/solr-4.7.1.tgz && \  
    cp /usr/local/solr-4.7.1/dist/solr-4.7.1.war /usr/local/tomcat/webapps/solr.war && \  
    /usr/local/tomcat/bin/startup.sh && \  
    cd /usr/local && \
    git clone https://github.com/WinRoad-NET/wrdoclet && \
    /usr/local/tomcat/bin/shutdown.sh && \  
    rm /usr/local/tomcat/webapps/solr.war && \  
    cp /usr/local/solr-4.7.1/dist/solrj-lib/*.jar /usr/local/tomcat/webapps/solr/WEB-INF/lib/ && \  
    cp solr-4.7.1/dist/*.jar /usr/local/tomcat/webapps/solr/WEB-INF/lib/ && \  
    mkdir /usr/local/tomcat/webapps/solr/WEB-INF/classes/ && \
    cp solr-4.7.1/example/resources/log4j.properties /usr/local/tomcat/webapps/solr/WEB-INF/classes/

COPY solrconfig.xml /usr/local/wrdoclet/wrdoclet-solr/apidocs/conf/

COPY ikanalyzer/ik-analyzer-4.7.1.jar /usr/local/tomcat/webapps/solr/WEB-INF/lib/

COPY ikanalyzer/config/ /usr/local/tomcat/webapps/solr/WEB-INF/classes/

COPY wrdoclethostsite/ /usr/local/tomcat/webapps/wrdoclethostsite/

RUN sed -i "s|%SOLR_URL%|$SOLR_URL|" /usr/local/tomcat/webapps/wrdoclethostsite/index.html

RUN apt-get install -y python2.7 && \
    apt-get update -qq && apt-get upgrade -y && apt-get install -y python-pip && \
    pip install beautifulsoup && \  
    pip install solrpy

VOLUME ["/usr/share/wrdocletdocdata", "/usr/share/wrdocletsolrdata"]

CMD ["catalina.sh", "run"]