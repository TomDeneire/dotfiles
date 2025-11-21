FROM ubuntu:22.04

# voorkom interactieve prompts (tzdata, etc.)
ENV DEBIAN_FRONTEND=noninteractive

# update en pakketbeheer
RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# kopieer jouw install script
COPY fresh-install.sh /fresh-install.sh
RUN chmod +x /fresh-install.sh

CMD ["/bin/bash"]

