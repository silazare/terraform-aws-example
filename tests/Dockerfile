ARG GOLANG_VERSION=1.14.2

FROM golang:${GOLANG_VERSION}-alpine

RUN set -ex && \
    apk add --update --no-cache \
        curl \
        git \
        gcc \
        libc-dev

ARG TERRAFORM_VERSION=0.13.6

RUN set -ex && \
    cd /usr/local/bin && \
    curl -s -k -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
        -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN set -ex && \
    curl -s -k https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

WORKDIR ${GOPATH}/src/terratest
