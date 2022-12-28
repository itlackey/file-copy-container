FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    cifs-utils \
    jq \
    wget


# Install azcopy
RUN wget -O azcopy.tar.gz https://aka.ms/downloadazcopy-v10-linux
RUN tar -xf azcopy.tar.gz --strip-components 1 -C /bin
RUN rm azcopy.tar.gz
RUN rm /bin/NOTICE.txt


# Copy the config files
COPY config.json /root
COPY keys/ /root/keys
RUN chmod 600 -R /root/keys
COPY run.sh /root

WORKDIR /root
#CMD [ "./run.sh" ]
ENTRYPOINT [ "bash" ]
