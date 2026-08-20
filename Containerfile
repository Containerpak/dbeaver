FROM ubuntu:26.04 AS source

ADD --checksum=sha256:0e8aa2008814c51c1d863f8fab9bce0343f5c1dfe0ef4eb86bb0e13bba4c1ef2 https://github.com/dbeaver/dbeaver/releases/download/26.1.5/dbeaver-ce-26.1.5-linux-x86_64.tar.gz /tmp/app.tar.gz

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
