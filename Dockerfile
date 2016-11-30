FROM centos:7
MAINTAINER noel.oconnor@gmail.com

RUN yum install wget -y --setopt=tsflags=nodocs
RUN wget -q -O /etc/yum.repos.d/mosquitto-centos7.repo http://download.opensuse.org/repositories/home:/oojah:/mqtt/CentOS_CentOS-7/home:oojah:mqtt.repo
RUN yum install -y --setopt=tsflags=nodocs mosquitto mosquitto-clients libmosquitto1 libmosquitto-devel libmosquittopp1 libmosquittopp-devel python-mosquitto && yum -y update; yum clean all

RUN mkdir -p /opt/mqtt/data /opt/mqtt/log
RUN chown -R mosquitto:mosquitto /opt/mqtt

USER mosquitto
EXPOSE 1883 9001
CMD ["-c","/etc/mosquitto/mosquitto.conf"]
ENTRYPOINT ["/usr/sbin/mosquitto"]
