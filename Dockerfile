FROM jenkinsci/jnlp-slave:3.27-1
LABEL MAINTAINER="Eren ATAS <@erenatas>"

USER root

RUN echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/chrome.list && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    set -x && \
    apt-get update -qq && apt-get install -y -qq --no-install-recommends \
    g++ \
    build-essential \
    gcc \
    libc6-dev \
    make \
    google-chrome-stable \
    xvfb \
    cowsay \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV CHROME_BIN /usr/bin/google-chrome
ENV DISPLAY=:99.0

# xvfb
COPY init.d/xvfb /etc/init.d/xvfb
RUN chmod +x /etc/init.d/xvfb
