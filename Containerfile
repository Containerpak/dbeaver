FROM ubuntu:26.04 AS source

ADD --checksum=sha256:f504e70a74763aa02e0b63d6842b85ca64526f682be457b3f30e330cc10748ed https://github.com/dbeaver/dbeaver/releases/download/26.2.0/dbeaver-ce-26.2.0-linux-x86_64.tar.gz /tmp/app.tar.gz

RUN mkdir -p /out && \
    tar -xzf /tmp/app.tar.gz -C /out

FROM ghcr.io/containerpak/gtk3:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/dbeaver"

COPY --from=source /out/dbeaver /opt/dbeaver

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates libnss3 xdg-utils && \
    ln -sf /opt/dbeaver/dbeaver /usr/bin/dbeaver && \
    cpak-clean-junk

COPY icon.png /usr/share/icons/hicolor/128x128/apps/dbeaver.png
COPY dbeaver.desktop /usr/share/applications/dbeaver.desktop
