FROM debian
MAINTAINER Alexander Reitzel
RUN apt-get --quiet 2 update
RUN apt-get --quiet 2 install ansible
COPY hosts.txt /etc/ansible/hosts
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /roles
ENTRYPOINT ["/usr/bin/ansible-playbook"]
