FROM ubuntu:latest

RUN apt-get update &&\
    apt-get dist-upgrade -y &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -y install \
    tzdata \
    sudo \
    net-tools \
    apt-utils \
    iproute2 \
    iputils-ping \
    openvpn \
    dialog \
    python3-pip \
    python3-setuptools \
    transmission-cli \
    transmission-daemon \
    && useradd -ms /bin/bash user \
    && usermod -a -G sudo user \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && pip3 install protonvpn-cli \
    && mkdir -p /home/user/Downloads \
    && mkdir -p /home/user/.transmission \
    && chown -R user /home/user/.transmission

COPY settings.json /home/user/.transmission/
COPY docker_entry.sh /usr/local/bin

WORKDIR /home/user

USER user

ENTRYPOINT ["/usr/local/bin/docker_entry.sh"]
