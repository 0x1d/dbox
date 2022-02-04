FROM debian:latest
RUN apt update && apt install -y wget
WORKDIR /opt
COPY sh .
RUN bash install

CMD ["bash", "run"]