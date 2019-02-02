FROM ubuntu:16.04
MAINTAINER phm87
ARG REPOSITORY=https://github.com/gobytecoin/gobyte/releases/download/v0.12.2.4/GoByteCore-0.12.2.4_Linux64.tar.gz
ARG coin_folder_a=gobyte

ENV coin_folder=coin_folder_a
ENV PORT=9322

RUN apt-get -y update \
 && apt-get -y install git build-essential libtool autotools-dev wget \
 && apt-get -y install automake pkg-config libssl-dev libevent-dev \
 && apt-get -y install bsdmainutils libboost-all-dev \
 && apt-get -y install software-properties-common \
 && add-apt-repository -y ppa:bitcoin/bitcoin \
 && apt-get -y update \
 && apt-get -y install libdb4.8-dev libdb4.8++-dev \
 && apt-get -y install libminiupnpc-dev libzmq3-dev \
 && wget https://github.com/gobytecoin/gobyte/releases/download/v0.12.2.4/GoByteCore-0.12.2.4_Linux64.tar.gz

RUN mkdir /root/coind && tar -C /root/coind -xvf GoByteCore-0.12.2.4_Linux64.tar.gz \
 && cd /root/coind/GoByteCore-0.12.2.4_Linux64/usr/local/bin \
 && cp gobyted /root/coind && cp gobyte-cli /root/coind && cp gobyte-tx /root/coind

RUN apt-get install bash && cd /root/coind/GoByteCore-0.12.2.4_Linux64/usr/local/bin \
 && cp gobyted /opt && cp gobyte-cli /opt && cp gobyte-tx /opt && mkdir /root/.gobytecore

COPY gobyte.conf /root/.gobytecore
COPY entry.sh /root/coind
RUN chmod +x /root/coind/entry.sh

#VOLUME ["/root/.gobytecore"]

WORKDIR /root/coind

#ENTRYPOINT ["/root/coind/entry.sh"]
CMD ["bash", "entry.sh"]
#CMD "bash"


EXPOSE 12454 12455
