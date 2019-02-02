FROM ubuntu:16.04
MAINTAINER phm87
ARG REPOSITORY=https://github.com/gobytecoin/gobyte.git
ARG BINARY=gobyte
ARG FOLDER=gobytecore
ARG PORT_A=9322
ARG STR_PORT_A=4233

ENV user=user
#ENV port=4233
#ENV password=tu8tu5
ENV coin_folder=coin_folder_a
ENV coin_binary=coin_binary_a
ENV PORT=PORT_a
ENV STR_PORT=STR_PORT_A

RUN apt-get -y update \
 && apt-get -y install git build-essential libtool autotools-dev \
 && apt-get -y install automake pkg-config libssl-dev libevent-dev \
 && apt-get -y install bsdmainutils libboost-all-dev \
 && apt-get -y install software-properties-common \
 && add-apt-repository -y ppa:bitcoin/bitcoin \
 && apt-get -y update \
 && apt-get -y install libdb4.8-dev libdb4.8++-dev \
 && apt-get -y install libminiupnpc-dev libzmq3-dev \
 && mkdir ~/coin && cd ~/coin

RUN git clone --progress https://github.com/tpruvot/yiimp.git ~/yiimp \
 && mkdir /root/coind && cd ~/yiimp/blocknotify && make && cp blocknotify /root/coind

RUN git clone --progress ${REPOSITORY} ~/coin \
 && ./autogen.sh && ./configure && make \
 && cp ~/coin/src/${BINARY}d /root/coind \
 && cp ~/coin/src/${BINARY}-cli /root/coind \
 && cp ~/coin/src/${BINARY}-tx /root/coind

RUN apt-get install bash && mkdir /root/.${FOLDER}

COPY ${BINARY}.conf /root/.${FOLDER}
COPY entry.sh /root/coind
RUN chmod +x /root/coind/entry.sh

COPY blocknotify.sh /root/coind
RUN chmod +x /root/coind/blocknotify.sh

WORKDIR /root/coind

CMD ["bash", "entry.sh"]

EXPOSE ${PORT} ${STR_PORT}
