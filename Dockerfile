FROM alpine:latest

ENV ANSIBLE_VERSION 2.8.3

ENV BUILD_PACKAGES \
  bash \
  curl \
  tar \
  openssh-client \
  sshpass \
  git \
  python \
  py-boto \
  py-dateutil \
  py-httplib2 \
  py-jinja2 \
  py-paramiko \
  py-pip \
  py-yaml \
  libxslt-dev \
  libxml2-dev \
  rpm \
  ca-certificates

# If installing ansible@testing
#RUN \
#       echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> #/etc/apk/repositories

RUN set -x && \
    \
    echo "==> Adding build-dependencies..."  && \
    apk --update add --virtual build-dependencies \
      gcc \
      musl-dev \
      libffi-dev \
      openssl-dev \
      python-dev && \
    \
    echo "==> Upgrading apk and system..."  && \
    apk update && apk upgrade && \
        \
    echo "==> Adding Python runtime..."  && \
    apk add --no-cache ${BUILD_PACKAGES} && \
    pip install --upgrade pip && \
    pip install setuptools==1.4.1 && \
    pip install python-keyczar docker-py && \
    pip install 'ansible[azure]' && \
    pip install --upgrade tornado chardet requests docopt cryptography f5-sdk bigsuds netaddr objectpath isoparser lxml deepdiff git+https://github.com/F5Networks/f5-common-python.git && \
    \
    echo "==> Installing Ansible..."  && \
    pip install ansible==${ANSIBLE_VERSION} && \
    \
    echo "==> Cleaning up..."  && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* && \
    \
    echo "==> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible /ansible && \
    echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts && \
    \
    echo "==> Galaxy install F5 app services..."  && \
    ansible-galaxy --roles-path=/ansible.galaxy install f5devcentral.f5app_services_package && \
    \
    echo "==> Galaxy install F5 ATC deploy..." && \
    ansible-galaxy --roles-path=/ansible.galaxy install f5devcentral.atc_deploy

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_CONFIG /ansible/ansible.cfg
ENV ANSIBLE_ROLES_PATH /ansible/roles:/ansible.galaxy
ENV ANSIBLE_SSH_PIPELINING True
ENV PYTHONPATH /ansible/lib
ENV PATH /ansible/bin:$PATH
ENV ANSIBLE_LIBRARY /ansible/library

WORKDIR /ansible/

ENTRYPOINT ["ansible-playbook"]
