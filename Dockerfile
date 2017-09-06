# TODO: debian? does it matter for this?
FROM bwstitt/ubuntu:16.04

RUN docker-apt-install \
    ca-certificates \
    torsocks \
    wget

ENTRYPOINT ["/entrypoint.sh"]

ENV PARITY_VERSION 1.7.0
ENV PARITY_PACKAGE parity_${PARITY_VERSION}_amd64
ENV PARITY_DEB ${PARITY_PACKAGE}.deb
ENV PARITY_RELEASE http://parity-downloads-mirror.parity.io/v${PARITY_VERSION}/x86_64-unknown-linux-gnu/${PARITY_DEB}
ENV PARITY_MD5 266fe720450bf2e3301c62ab69d647f2

# TODO: verify checksum
RUN set -eux; \
    \
    wget "$PARITY_RELEASE"; \
    md5sum "./$PARITY_DEB" | grep "$PARITY_MD5"; \
    docker-apt-install "./$PARITY_DEB"; \
    rm "$PARITY_DEB"

RUN mkdir -p /home/abc/.local/share/io.parity.ethereum; \
    chown -R abc:abc /etc/tor/torsocks.conf /home/abc/.local/

USER abc
ENV HOME /home/abc
VOLUME "/home/abc/.local/share/io.parity.ethereum/"

ADD /entrypoint.sh /
