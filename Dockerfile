FROM debian:bookworm

RUN apt update && apt install -y --no-install-recommends gnupg

RUN echo "deb http://archive.raspberrypi.org/debian/ bookworm main" > /etc/apt/sources.list.d/raspi.list \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 82B129927FA3303E

RUN apt update && apt -y upgrade

RUN apt install -y --no-install-recommends \
    python3-pip python3-picamera2 \
    rpicam-apps vlc \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i 's/geteuid/getppid/' /usr/bin/vlc

ADD app/web-streaming-pi.py web-streaming-pi.py

CMD python3 web-streaming-pi.py

# CMD rpicam-vid -t 0 --inline -o - | cvlc stream:///dev/stdin --sout '#rtp{sdp=rtsp://:8554/stream1}' :demux=h264
