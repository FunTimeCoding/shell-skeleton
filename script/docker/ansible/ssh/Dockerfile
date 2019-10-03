FROM debian
MAINTAINER Alexander Reitzel
RUN apt-get --quiet 2 update
RUN apt-get --quiet 2 install openssh-server
COPY start.sh /
RUN chmod +x /start.sh
CMD ["/start.sh"]
EXPOSE 22
