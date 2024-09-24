# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM debian AS base
RUN apt-get update \
	&& apt install --no-install-recommends --no-install-suggests -y ca-certificates wget unzip git gcc make libncurses5-dev zlib1g-dev zlib1g libzstd-dev git build-essential debhelper libusb-1.0-0-dev librtlsdr-dev librtlsdr0 pkg-config libncurses5-dev zlib1g-dev zlib1g
	
FROM --platform=$BUILDPLATFORM base AS runtime
WORKDIR /publish
RUN wget -q -O master.zip https://github.com/wiedehopf/feed1090/archive/master.zip \
	&& unzip -q -o master.zip \
	&& cd feed1090-master \
	&& bash readsb-nopackage.sh "/usr/local/share/feed1090/bin"
RUN rm -rf /tmp/feed1090-master /tmp/feed1090-test
RUN mkdir /run/feed1090
COPY run.sh /root/

WORKDIR /root
USER 0		
CMD ["/bin/bash", "run.sh"]