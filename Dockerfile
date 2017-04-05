# Creates pseudo distributed hadoop 2.6.0 on Ubuntu 14.04
#
# docker build -t sequenceiq/hadoop-ubuntu:2.6.5 .

FROM sequenceiq/pam:ubuntu-14.04
MAINTAINER SequenceIQ

USER root

# install dev tools
RUN apt-get update
RUN apt-get install -y curl tar sudo openssh-server openssh-client rsync maven openjdk-7-jdk

# java
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV PATH $PATH:$JAVA_HOME/bin

# hadoop
RUN curl -s http://www.eu.apache.org/dist/hadoop/common/hadoop-2.6.5/hadoop-2.6.5.tar.gz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s ./hadoop-2.6.5 hadoop

ENV HADOOP_PREFIX /usr/local/hadoop
RUN echo $JAVA_HOME
RUN sed -i "/^export JAVA_HOME/ s:.*:export JAVA_HOME=${JAVA_HOME}\nexport HADOOP_PREFIX=/usr/local/hadoop\nexport HADOOP_HOME=/usr/local/hadoop\n:" $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
RUN sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
#RUN . $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

RUN mkdir $HADOOP_PREFIX/input
RUN cp $HADOOP_PREFIX/etc/hadoop/*.xml $HADOOP_PREFIX/input
