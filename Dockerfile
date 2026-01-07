# Base image
FROM ruby:4.0.0-slim-trixie

COPY Aptfile ./Aptfile
RUN apt-get update -qq && \
    grep -v '^#' Aptfile | grep -v '^$' | xargs -r apt-get install --no-install-recommends -y && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives Aptfile

# Enable jemalloc via LD_PRELOAD (symlink to arch-independent path)
RUN JEMALLOC=$(find /usr/lib -name "libjemalloc.so.2" | head -1) && \
    [ -n "$JEMALLOC" ] && ln -sf "$JEMALLOC" /usr/lib/libjemalloc.so.2 || \
    (echo "ERROR: libjemalloc2 not found" && exit 1)
ENV LD_PRELOAD=/usr/lib/libjemalloc.so.2

# Install Bun
ARG BUN_VERSION=1.3.5
ENV BUN_INSTALL=/usr/local/bun
ENV PATH=/usr/local/bun/bin:$PATH
RUN curl -fsSL https://bun.sh/install | bash -s -- "bun-v${BUN_VERSION}"
