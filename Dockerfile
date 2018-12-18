# Starter environment for Artificial Intelligence and Big Data using docker. 
# Includes: Kafka for Pub/Sub, Spark for computation, Cassandra for storing, ElasticSearch for indexing, Kibana for visualization, Anaconda for data-science with python, Jupyter Notebook for coding, Selenium for scraping.

FROM centos:centos6


# ===============================================
# INSTALL BASIC TOOLS
# ===============================================
RUN yum -y update;
RUN yum -y clean all;
RUN yum install -y wget dialog curl sudo lsof vim axel telnet nano openssh-server openssh-clients bzip2 passwd tar bc git unzip
RUN yum install -y gcc openssl-devel bzip2-devel yum-utils 
RUN yum groupinstall -y "Development Tools"
RUN yum install -y epel-release
RUN yum install -y jq


# ===============================================
# INSTALL PYTHON 3.6
# ===============================================
RUN yum -y install https://centos6.iuscommunity.org/ius-release.rpm
RUN yum -y install python36u python36u-pip python36u-devel
RUN yum -y install python36-numpy scipy
RUN echo "alias python=python3.6" >> ~/.bashrc
RUN echo "alias pip=pip3.6" >> ~/.bashrc
RUN source ~/.bashrc
RUN pip3.6 install --upgrade pip


# ===============================================
# INSTALL PYTHON 2.7 (required for cqlsh)
# ===============================================
RUN yum -y install scl-utils
RUN yum -y install centos-release-scl-rh
RUN yum -y install python27
RUN yum -y install python27-pip
RUN export PYTHONPATH="/usr/lib/python2.7/site-packages/":$PYTHONPATH
RUN pip2.7 install cassandra-driver
ENV CQLSH_NO_BUNDLED=true


# ===============================================
# INSTALL JAVA
# ===============================================
RUN yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel 


# ===============================================
# CREATE GUEST USER. IMPORTANT: Change here UID 1000 to your host UID if you plan to share folders.
# ===============================================
RUN useradd guest -u 1000
RUN echo guest | passwd guest --stdin
ENV HOME /home/guest
WORKDIR $HOME


##################################################################################
# SWITCH TO guest USER 
##################################################################################
# USER guest


# ===============================================
# INSTALL SPARK
# ===============================================
#Install Spark (Spark 2.1.1 - 02/05/2017, prebuilt for Hadoop 2.7 or higher)
RUN wget https://d3kbcqa49mib13.cloudfront.net/spark-2.1.1-bin-hadoop2.7.tgz
RUN tar xvzf spark-2.1.1-bin-hadoop2.7.tgz
RUN mv spark-2.1.1-bin-hadoop2.7 spark
RUN rm -f spark-2.1.1-bin-hadoop2.7.tgz
ENV SPARK_HOME $HOME/spark

# ===============================================
# INSTALL APACHE KAFKA
# ===============================================
# RUN wget https://www-eu.apache.org/dist/kafka/2.1.0/kafka_2.11-2.1.0.tgz
# RUN tar xvzf kafka_2.11-2.1.0.tgz
# RUN mv kafka_2.11-2.1.0 kafka
# ===============================================
# INSTALL KAFKA CONFLUENT
# ===============================================
# RUN wget http://packages.confluent.io/archive/5.0/confluent-5.0.1-2.11.tar.gz
# RUN yum -y install confluent-platform-2.11
# ADD confluent-5.1.0.tar.gz kafka
ADD confluent-5.1.0 kafka
RUN printf "\ndelete.topic.enable=true" >> /home/guest/kafka/etc/kafka/server.properties

# ===============================================
# SET ENVIRONMENT VARIABLES FOR SPARK + KAFKA + MAVEN
# ===============================================
ENV PATH $HOME/spark/bin:$HOME/spark/sbin:$HOME/kafka/bin:$PATH

# ===============================================
# ===============================================
# RUN wget https://repo.continuum.io/archive/Anaconda2-5.3.1-Linux-x86_64.sh
# RUN bash Anaconda2-5.3.1-Linux-x86_64.sh -b
# ENV PATH $HOME/anaconda2/bin:$PATH
# RUN conda install python=2.7.10 -y


##################################################################################
# SWITCH TO root USER 
##################################################################################

USER root


# ===============================================
# INSTALL JUPYTER NOTEBOOK
# ===============================================
# RUN conda install jupyter -y
RUN pip3.6 install jupyter

# ===============================================
# INSTALL SOME DATA SCIENCE PYTHON TOOLS
# ===============================================
RUN pip3.6 install kaggle numpy scipy plotly matplotlib pandas statsmodels
RUN pip3.6 install -U scikit-learn[alldeps]
RUN pip3.6 install xgboost


# ===============================================
# INSTALL MINIMAL WEB SERVER PYTHON TOOLS (could use Django instead)
# ===============================================
RUN pip3.6 install starlette uvicorn aiofile


# ===============================================
# INSTALL KAFKA PYTHON PACKAGE
# ===============================================
RUN pip3.6 install kafka-python


# ===============================================
# INSTALL kafka-connect-spooldir FOR KAFKA (to source and sink CSV, JSON & TSV)
# ===============================================
# RUN wget http://central.maven.org/maven2/com/github/jcustenborder/kafka/connect/kafka-connect-spooldir/1.0.31/kafka-connect-spooldir-1.0.31.tar.gz
# RUN mv kafka-connect-spooldir-1.0.31.tar.gz kafka
# RUN tar xvzf kafka-connect-spooldir-1.0.31.tar.gz
# RUN mv kafka/usr/share/doc kafka/share/doc
# RUN mv kafka/usr/share/kafka-connect/kafka-connect-spooldir kafka/share/java
# RUN rm -r kafka/usr
# RUN rm kafka/kafka-connect-spooldir-1.0.31.tar.gz
# RUN export CLASSPATH="$(find kafka/share/java/kafka-connect-spooldir -type f -name '*.jar' | tr '\n' ':')"

# ===============================================
# INSTALL WEBSCRAPING PACK: FIREFOX + GECKODRIVER + SELENIUM
# ===============================================
RUN yum install -y firefox-60.3.0-1.el6.centos
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.23.0/geckodriver-v0.23.0-linux64.tar.gz
RUN tar -xvzf geckodriver*
RUN chmod +x geckodriver
RUN mv geckodriver /usr/local/bin/
RUN rm geckodriver*

# ===============================================
# INSTALL CASSANDRA
# ===============================================
ADD datastax.repo /etc/yum.repos.d/datastax.repo
RUN yum install -y datastax-ddc
# RUN echo "/usr/lib/python2.7/site-packages" |tee /home/guest/anaconda2/lib/python2.7/site-packages/cqlshlib.pth

# ===============================================
# INSTALL ELASTICSEARCH
# ===============================================
ADD elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo
RUN yum install -y elasticsearch
ADD elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

# ===============================================
# INSTALL KIBANA
# ===============================================
ADD kibana.repo /etc/yum.repos.d/kibana.repo
RUN yum install -y kibana
ADD kibana.yml /etc/kibana/kibana.yml





# ===============================================
# ENVIRONMENT VARIABLES FOR SPARK & JAVA
# ===============================================
ADD setenv.sh /home/guest/setenv.sh
RUN chown guest:guest setenv.sh
RUN echo . ./setenv.sh >> .bashrc

# ===============================================
# SCRIPT TO START SERVICES (SSH, Cassandra, Zookeeper, Kafka producer...)
# ===============================================
ADD startup_script.sh /usr/bin/startup_script.sh
RUN chmod +x /usr/bin/startup_script.sh

# ===============================================
# INIT CASSANDRA 
# ===============================================
ADD init_cassandra.cql /home/guest/init_cassandra.cql
RUN chown guest:guest init_cassandra.cql

# ===============================================
# ADD SAMPLE NOTEBOOKS
# ===============================================
ADD notebooks /home/guest/notebooks
RUN chown -R guest:guest notebooks


# ===============================================
# USED PORTS
# ===============================================
# Not mandatory to expose ports here 
# Keeping it as a comment for log purposes
# EXPOSE 22 2181 4040 5601 7199 8888 9092 9200 9300
# 22 = ssh
# 2181 = zookeeper
# 4040 = spark UI
# 5601 = kibana
# 7199 = cassandra
# 8888 - jupyter notebook
# 9092 = kafka broker 1
# 9200 + 9300 = elasticsearch
# ===============================================

