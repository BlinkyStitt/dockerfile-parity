FROM bwstitt/ubuntu:16.04

RUN docker-apt-install \
    ca-certificates \
    wget

ENTRYPOINT ["parity"]

ENV PARITY_VERSION 1.7.0
ENV PARITY_PACKAGE parity_${PARITY_VERSION}_amd64
ENV PARITY_DEB ${PARITY_PACKAGE}.deb
ENV PARITY_RELEASE http://d1h4xl4cr1h0mo.cloudfront.net/v${PARITY_VERSION}/x86_64-unknown-linux-gnu/${PARITY_DEB}

RUN wget "$PARITY_RELEASE" \
 && docker-apt-install "./$PARITY_DEB" \
 && rm "$PARITY_DEB"
