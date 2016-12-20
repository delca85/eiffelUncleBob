
FROM debian:jessie-slim
MAINTAINER Mattia Monga <monga@debian.org>

USER root
ENV DEBIAN_FRONTEND noninteractive
RUN REPO=http://cdn-fastly.deb.debian.org && \
    echo "deb $REPO/debian jessie main\ndeb $REPO/debian-security jessie/updates main" > /etc/apt/sources.list && \
    apt-get -yq update && apt-get -yq upgrade && \
    apt-get -yq install curl bzip2 make gcc libxtst-dev libgtk2.0-dev && apt-get clean && rm -rf /var/lib/apt/*
RUN curl -L https://ftp.eiffel.com/pub/download/16.05/Eiffel_16.05_gpl_98969-linux-x86-64.tar.bz2 | tar xj -C /opt

# Define Eiffel environment variables
ENV ISE_EIFFEL /opt/Eiffel_16.05
ENV ISE_PLATFORM linux-x86-64
ENV ISE_LIBRARY $ISE_EIFFEL
ENV PATH $PATH:$ISE_EIFFEL/studio/spec/$ISE_PLATFORM/bin

RUN useradd -ms /bin/bash eiffel

USER eiffel
WORKDIR /home/eiffel
CMD estudio