ARG PACKER_VERSION=1.15.1
ARG ALPINE_VERSION=3.21

FROM alpine:${ALPINE_VERSION}

ARG PACKER_VERSION
ARG TARGETARCH

RUN apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    git \
    openssh-client \
    unzip \
    && update-ca-certificates \
    && ARCH=$([ "${TARGETARCH}" = "arm64" ] && echo "arm64" || echo "amd64") \
    && curl -fsSL --proto '=https' --tlsv1.2 "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_${ARCH}.zip" \
       -o /tmp/packer.zip \
    && unzip /tmp/packer.zip -d /usr/local/bin/ \
    && rm /tmp/packer.zip \
    && adduser -D packer \
    && packer version

WORKDIR /workspace

USER packer

ENTRYPOINT ["packer"]
CMD ["--help"]
