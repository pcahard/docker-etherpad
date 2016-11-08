# Stable version of etherpad doesn't support npm 2
FROM ubuntu:yakkety
MAINTAINER Pierre Cahard <pcahard@gmail.com>

ENV ETHERPAD_VERSION 1.6.0

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y libreoffice abiword curl unzip nodejs-legacy npm mysql-client && \
    rm -r /var/lib/apt/lists/*

WORKDIR /opt/

RUN curl -SL \
    https://github.com/ether/etherpad-lite/archive/${ETHERPAD_VERSION}.zip \
    > etherpad.zip && unzip etherpad && rm etherpad.zip && \
    mv etherpad-lite-${ETHERPAD_VERSION} etherpad-lite

WORKDIR etherpad-lite

RUN bin/installDeps.sh && rm settings.json
COPY entrypoint.sh /entrypoint.sh
RUN sed -i 's/#prepare the enviroment/sh install_plugins.sh/g' bin/run.sh

RUN sed -i 's/^node/exec\ node/' bin/run.sh

VOLUME /opt/etherpad-lite/var
RUN ln -s var/settings.json settings.json

EXPOSE 9001
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bin/run.sh", "--root"]
