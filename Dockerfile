# TODO: debian? does it matter for this?
FROM bwstitt/ubuntu:17.04

RUN docker-install \
    ca-certificates \
    wget

ENTRYPOINT ["/entrypoint.sh"]

ENV PARITY_VERSION 1.7.7
ENV PARITY_PACKAGE parity_${PARITY_VERSION}_amd64
ENV PARITY_DEB ${PARITY_PACKAGE}.deb
ENV PARITY_RELEASE https://parity-downloads-mirror.parity.io/v${PARITY_VERSION}/x86_64-unknown-linux-gnu/${PARITY_DEB}
ENV PARITY_SHA256 efaea25ee0dd7a3317b7fde9d006d31abb6da453a5f8dc38af0c2a4493460e53

# TODO: verify checksum
RUN set -eux; \
    \
    wget "$PARITY_RELEASE"; \
    sha256sum "./$PARITY_DEB" | grep "$PARITY_SHA256"; \
    docker-install "./$PARITY_DEB"; \
    rm "$PARITY_DEB"

RUN mkdir -p /home/abc/.local/share/io.parity.ethereum; \
    chown -R abc:abc /home/abc/.local/

USER abc
ENV HOME /home/abc
WORKDIR /home/abc
VOLUME "/home/abc/.local/share/io.parity.ethereum/"

ADD /entrypoint.sh /
