ARG APP_VERSION=3.2.1
ARG APP_SOURCE_SHA256=b9ce4789be7e2a7edb05bb9f89dabfe3380b299b9bd50e6ef5f595ce6fd7a861

ARG RUST_VERSION=1.99.1
ARG RUST_TARGET=x86_64-unknown-linux-gnu

####################################
FROM rust:${RUST_VERSION}-trixie AS builder

ARG RUST_TARGET
ARG APP_VERSION
ARG APP_SOURCE_SHA256

ADD --unpack=true --checksum=sha256:${APP_SOURCE_SHA256} \
    https://github.com/lstpsche/obsidian-mcp/archive/refs/tags/v${APP_VERSION}.tar.gz /build/

WORKDIR /build/obsidian-mcp-${APP_VERSION}

RUN cargo build --locked --release --features embeddings --target "$RUST_TARGET" && \
    mkdir -p /app && \
    cp "./target/${RUST_TARGET}/release/obsidian-mcp" "./target/${RUST_TARGET}/release/obsidian-semanticd" /app

###############################
FROM debian:trixie-slim AS main

ARG RUST_TARGET

RUN --mount=type=tmpfs,target=/var/lib/apt/lists \
    apt-get update && \
    apt-get install -y --no-install-recommends gosu

WORKDIR /app
RUN mkdir /vault /data

COPY --from=builder /app/obsidian-mcp /usr/local/bin/obsidian-mcp
COPY --from=builder /app/obsidian-semanticd /usr/local/bin/obsidian-semanticd
COPY entrypoint.sh /entrypoint.sh
RUN chown 755 /entrypoint.sh /usr/local/bin/obsidian-mcp /usr/local/bin/obsidian-semanticd

ENV PUID=1000
ENV PGID=1000

ENV OBSIDIAN_VAULT_PATH=/vault
ENV OBSIDIAN_MCP_DATA=/data
ENV OBSIDIAN_SEMANTIC_MODE=local
ENV OBSIDIAN_HTTP_PORT=37842
ENV OBSIDIAN_TRANSPORT=http

EXPOSE 37842

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/local/bin/obsidian-mcp"]
