FROM alpine:3.1
MAINTAINER Jaeho Lee <jhlee@appsoulute.com>

RUN apk --update add nodejs && npm install -g coffee-script@1.10.0 && rm -rf /var/cache/apk/*
RUN apk --update add mosquitto
#RUN service mosquitto start
RUN mkdir /work
VOLUME /work
COPY conf/mosquitto.conf /etc/mosquitto/mosquitto.conf
COPY conf/passwd /etc/mosquitto/passwd
WORKDIR /work
EXPOSE 1883