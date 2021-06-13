FROM alpine

ENV RSPAMD_VERSION=2.7

RUN apk add --no-cache glib hyperscan icu-libs libsodium sqlite-libs lua-libs

RUN wget -qO- https://github.com/rspamd/rspamd/archive/refs/tags/${RSPAMD_VERSION}.tar.gz | tar -xz && \
    mkdir /rspamd.build && \
    cd /rspamd.build && \
    apk add --no-cache --virtual build-deps openssl-dev make cmake gcc g++ perl glib-dev sqlite-dev harfbuzz-dev libsodium-dev ragel lua-dev hyperscan-dev && \
    cmake ../rspamd-${RSPAMD_VERSION} -LA -DENABLE_LUAJIT=OFF -DENABLE_LUA_REPL=OFF -DENABLE_OPTIMIZATION=ON -DENABLE_HYPERSCAN=ON && \
    make -j4 && \
    make install && \
    apk del build-deps && \
    rm -r /rspamd.build && \
    adduser -S -u 113 rspamd && \
    addgroup -S -g 120 rspamd && \
    addgroup rspamd ntp && \
    mkdir /var/log/rspamd
ENTRYPOINT ["rspamd", "-u", "rspamd", "-g", "rspamd", "-f"]
