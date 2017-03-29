FROM node:6.9.1-alpine
MAINTAINER mist.io <support@mist.io>

RUN apk add --update --no-cache git nginx

RUN npm install -g polymer-cli bower

COPY mist_components/ /ui/bower_components

WORKDIR /ui

COPY bower.json /ui/bower.json

RUN bower install --config.interactive=false --allow-root

COPY . /ui

RUN node --max_old_space_size=4096 /usr/local/bin/polymer build

COPY ./container/nginx.conf /etc/nginx/nginx.conf

COPY ./container/entry.sh /entry.sh

ARG build_tag

ENV BUILD_TAG=$build_tag

RUN cd /ui/build && ln -s . $BUILD_TAG && ln -s /ui/assets/ /ui/build/bundled/ && \
    ln -s /ui/assets/ /ui/build/ && \
    ln -s /ui/bower_components /ui/build

EXPOSE 80
