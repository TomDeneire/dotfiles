FROM ubuntu:22.04

# prevent interactive installation (tzdata, etc.)
ENV DEBIAN_FRONTEND=noninteractive

# update and install packages
RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# copy install script
COPY fresh-install.sh /fresh-install.sh
RUN chmod +x /fresh-install.sh

CMD ["/bin/bash"]

