FROM debian
MAINTAINER Alexander Reitzel
RUN apt-get --quiet 2 update
RUN apt-get --quiet 2 install ansible
ENTRYPOINT ["/usr/bin/ansible-playbook"]
