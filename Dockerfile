FROM alpine:3.7
MAINTAINER Alexander Reitzel
WORKDIR /usr/src
COPY lib lib
COPY bin bin
CMD ["/usr/src/bin/ss"]
