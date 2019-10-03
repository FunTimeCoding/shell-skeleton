FROM debian
MAINTAINER Alexander Reitzel
RUN apt-get --quiet 2 update
RUN apt-get --quiet 2 install openssh-server
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
