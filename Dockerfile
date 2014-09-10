# Docker Register image.
#
# VERSION 0.0.1
#
# BUILD-USING: docker build -rm -t ncarlier/docker-register .

FROM debian:jessie

MAINTAINER Nicolas Carlier <https://github.com/ncarlier>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y curl python python-pip python-dev libssl-dev libffi-dev

RUN mkdir /app
WORKDIR /app

ENV DOCKERGEN_URL https://github.com/jwilder/docker-gen/releases/download/0.3.3/docker-gen-linux-amd64-0.3.3.tar.gz
RUN (cd /tmp && curl -L -o docker-gen.tgz $DOCKERGEN_URL && tar -C /usr/local/bin -xvzf docker-gen.tgz)

RUN pip install python-etcd

ADD . /app

ENV DOCKER_HOST unix:///var/run/docker.sock

CMD docker-gen -interval 10 -watch -notify "python /tmp/register.py" etcd.tmpl /tmp/register.py
