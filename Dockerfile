FROM ubuntu:14.04

#Installing NODE and .Net Core 2

RUN apt-get update
RUN apt-get install curl wget -y
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install nodejs -y
RUN wget -q https://packages.microsoft.com/config/ubuntu/14.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get install apt-transport-https -y
RUN apt-get update
RUN apt-get install dotnet-sdk-2.0 -y
RUN apt-get install zip unzip

#Installing Python, PiP

RUN apt-get update && \
    apt-get install -y \
        python3 \
        python3-pip \
        python3-setuptools \
        groff \
        less \
    && pip3 install --upgrade pip \
    && apt-get clean

#Installing AWS CLI
#This is needed for running custom aws cli commands from a buildspec.yml file

RUN pip3 --no-cache-dir install --upgrade awscli