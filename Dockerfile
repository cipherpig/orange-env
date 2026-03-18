FROM ubuntu:latest

RUN apt update && apt install -y zsh

SHELL ["/bin/zsh", "-c"]

WORKDIR /app

COPY setup.sh .

RUN chmod +x setup.sh
RUN ./setup.sh
