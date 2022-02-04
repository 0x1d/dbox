FROM ubuntu

RUN apt update && apt install -y wget unzip &&\
    wget https://comet.sternenbauer.com/download/shiftr-io-cli/linux-zip && \
    unzip linux-zip && rm linux-zip && \
    mv shiftr-io-cli-linux-amd64 /bin/shiftr

CMD [ "shiftr", "broker" ]
