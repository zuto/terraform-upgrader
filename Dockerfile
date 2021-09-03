FROM alpine:3.14

RUN wget https://releases.hashicorp.com/terraform/0.12.31/terraform_0.12.31_linux_amd64.zip
RUN unzip terraform_0.12.31_linux_amd64.zip && rm terraform_0.12.31_linux_amd64.zip
RUN mkdir -p /usr/bin/terraform/0.12.31/
RUN mv terraform /usr/bin/terraform/0.12.31/terraform

RUN wget https://releases.hashicorp.com/terraform/0.13.7/terraform_0.13.7_linux_amd64.zip
RUN unzip terraform_0.13.7_linux_amd64.zip && rm terraform_0.13.7_linux_amd64.zip
RUN mkdir -p /usr/bin/terraform/0.13.7/
RUN mv terraform /usr/bin/terraform/0.13.7/terraform

RUN wget https://releases.hashicorp.com/terraform/0.14.11/terraform_0.14.11_linux_amd64.zip
RUN unzip terraform_0.14.11_linux_amd64.zip && rm terraform_0.14.11_linux_amd64.zip
RUN mkdir -p /usr/bin/terraform/0.14.11/
RUN mv terraform /usr/bin/terraform/0.14.11/terraform

ENV TF_VER_LATEST=1.0.5

RUN wget https://releases.hashicorp.com/terraform/$TF_VER_LATEST/terraform_${TF_VER_LATEST}_linux_amd64.zip
RUN unzip terraform_${TF_VER_LATEST}_linux_amd64.zip && rm terraform_${TF_VER_LATEST}_linux_amd64.zip
RUN mkdir -p /usr/bin/terraform/$TF_VER_LATEST/
RUN mv terraform /usr/bin/terraform/$TF_VER_LATEST/terraform

RUN apk update
RUN apk add git openssh

ADD upgrade.sh upgrade.sh

ENTRYPOINT ["sh","upgrade.sh"]