FROM centos:7
MAINTAINER noel.oconnor@gmail.com

RUN yum install -y --setopt=tsflags=nodocs wget mercurial make cmake openssl-devel c-ares-devel libuuid-devel git gcc gcc-c++ && yum -y update; yum clean all

RUN mkdir -p /opt/mosquitto-build/ws
WORKDIR /opt/mosquitto-build/ws

RUN git clone https://github.com/warmcat/libwebsockets.git
RUN cd libwebsockets ;mkdir build;cd build;cmake .. -DLIB_SUFFIX=64;make;make install

WORKDIR /opt/mosquitto-build
RUN wget http://mosquitto.org/files/source/mosquitto-1.4.10.tar.gz && tar xvzf mosquitto-1.4.10.tar.gz; cd mosquitto-1.4.10/
WORKDIR /opt/mosquitto-build/mosquitto-1.4.10/
RUN sed -i 's/WITH_WEBSOCKETS:=no/WITH_WEBSOCKETS:=yes/' config.mk
RUN make && make install

RUN echo “/usr/local/lib64” | tee -a /etc/ld.so.conf.d/libwebsockets.conf && echo /usr/local/lib > /etc/ld.so.conf.d/local.conf
RUN ldconfig
ENV LD_LIBRARY_PATH=/usr/local/lib64

RUN adduser --system -u 10001 mosquitto

RUN mkdir -p /opt/mqtt/data
RUN chown -R mosquitto: /etc/mosquitto
RUN chown -R mosquitto: /opt/mqtt/

USER mosquitto
EXPOSE 1883 9001
CMD ["-c","/etc/mosquitto/ose-mosquitto.conf","-v"]
ENTRYPOINT ["/usr/local/sbin/mosquitto"]
