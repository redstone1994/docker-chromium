FROM ghcr.io/linuxserver/baseimage-kasmvnc:alpine318

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=Chromium
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-2.35-r1.apk
RUN apk --no-cache --force-overwrite add glibc-2.35-r1.apk && rm -rf glibc-2.35-r1.apk

RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-bin-2.35-r1.apk
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-i18n-2.35-r1.apk
RUN apk --no-cache --force-overwrite add glibc-bin-2.35-r1.apk glibc-i18n-2.35-r1.apk
RUN /usr/glibc-compat/bin/localedef -i zh_CN -f UTF-8 zh_CN.UTF-8
RUN rm -rf glibc-bin-2.35-r1.apk glibc-i18n-2.35-r1.apk

ENV LANG=zh_CN.utf8
RUN apk add --update busybox-extras fontconfig ttf-dejavu
RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    chromium && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
