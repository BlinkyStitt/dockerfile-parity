# TODO: debian? does it matter for this?
FROM bwstitt/ubuntu:16.04

RUN docker-apt-install \
    ca-certificates \
    wget

ENTRYPOINT ["/entrypoint.sh"]

ENV PARITY_VERSION 1.7.2
ENV PARITY_PACKAGE parity_${PARITY_VERSION}_amd64
ENV PARITY_DEB ${PARITY_PACKAGE}.deb
ENV PARITY_RELEASE http://parity-downloads-mirror.parity.io/v${PARITY_VERSION}/x86_64-unknown-linux-gnu/${PARITY_DEB}
ENV PARITY_SHA256 4c82d7e8a9d53b0020cbc761c39a8f889672093d47b6016516bedc070149eca7

# TODO: verify checksum
RUN set -eux; \
    \
    wget "$PARITY_RELEASE"; \
    sha256sum "./$PARITY_DEB" | grep "$PARITY_SHA256"; \
    docker-apt-install "./$PARITY_DEB"; \
    rm "$PARITY_DEB"

RUN mkdir -p /home/abc/.local/share/io.parity.ethereum; \
    chown -R abc:abc /etc/tor/torsocks.conf /home/abc/.local/

USER abc
ENV HOME /home/abc
WORKDIR /home/abc
VOLUME "/home/abc/.local/share/io.parity.ethereum/"

ADD /entrypoint.sh /
