FROM alpine:3.7
MAINTAINER Alexander Reitzel
WORKDIR /usr/src
COPY lib shell-skeleton/lib
COPY bin shell-skeleton/bin
WORKDIR /usr/src/shell-skeleton
CMD ["bin/ss"]
