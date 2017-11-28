# Scala and sbt Dockerfile
FROM  openjdk:8u151-jdk-slim

ENV SCALA_VERSION 2.12.4
ENV SBT_VERSION 1.0.4

# Scala expects this file
RUN touch /usr/lib/jvm/java-8-openjdk-amd64/release

# Dependecies
RUN apt-get update &&\
    apt-get install -y curl git jq unzip xz-utils libfontconfig zlib1g libfreetype6 libxrender1 libxext6 libx11-6 &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# Install Scala
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt -y && \
  apt-get clean &&\
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
  sbt sbtVersion

# Add jenkins user
RUN \
    adduser --home /var/jenkins_home --disabled-password --uid 1000 jenkins

# Add Wkhtmltopdf
ENV PATH $PATH:/opt/wkhtmltox/bin
ENV WKHTMLTOX_VERSION 0.12.4

RUN curl -L -o wkhtmltopdf.tar.xz  "https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/${WKHTMLTOX_VERSION}/wkhtmltox-${WKHTMLTOX_VERSION}_linux-generic-amd64.tar.xz" &&\
    tar -xvJ -f wkhtmltopdf.tar.xz -C /opt &&\
    rm -rf /opt/wkhtmltox/lib &&\
    rm -rf /opt/wkhtmltox/include &&\
    rm -rf /opt/wkhtmltox/share &&\
    rm wkhtmltopdf.tar.xz

# Define working directory
WORKDIR /root
