FROM alpine:latest

COPY files /tmp

RUN cd /tmp && \
    mv /tmp/aria2-daemon.conf /etc && \
    mv /tmp/aria2d /usr/bin && \
    chmod a+x /usr/bin/aria2d && \
    mkdir -p /aria2 && \
    apk --no-cache add --virtual build-dependencies \
        git autoconf automake build-base \
        c-ares-dev cppunit-dev expat-dev \
        libxml2-dev gettext-dev gnutls-dev \
        libtool sqlite-dev && \
    apk --no-cache add c-ares ca-certificates expat gmp \
        gnutls libgcc libstdc++ libxml2 musl nettle sqlite-libs && \
    git clone https://github.com/aria2/aria2 && \
    cd aria2 && \
    sed -i "s/\"1\", 1, 16,/\"1\", 1, 65535,/g" src/OptionHandlerFactory.cc && \
    sed -i "s/TEXT_MIN_SPLIT_SIZE, \"20M\", 1_m, 1_g, 'k'/TEXT_MIN_SPLIT_SIZE, \"16M\", 1_k, 1_g, 'k'/g" \
        src/OptionHandlerFactory.cc && \
    sed -i "s/TEXT_PIECE_LENGTH, \"1M\", 1_m, 1_g/TEXT_PIECE_LENGTH, \"1M\", 1_k, 1_g/g" \
        src/OptionHandlerFactory.cc && \
    autoreconf -i && \
    ./configure --disable-option-checking \
        '--prefix=/usr'  \
        '--build=x86_64-alpine-linux-musl' \
        '--host=x86_64-alpine-linux-musl' \
        '--sysconfdir=/etc' \
        '--mandir=/usr/share/man' \
        '--infodir=/usr/share/info' \
        '--localstatedir=/var' \
        '--disable-nls' \
        '--with-ca-bundle=/etc/ssl/certs/ca-certificates.crt' \
        'build_alias=x86_64-alpine-linux-musl' \
        'host_alias=x86_64-alpine-linux-musl' \
        'CC=gcc' \
        'CFLAGS=-Os -fomit-frame-pointer' \
        'LDFLAGS=-Wl,--as-needed' \
        'CPPFLAGS=-Os -fomit-frame-pointer' \
        'CXXFLAGS=-Os -fomit-frame-pointer' \
        --cache-file=/dev/null \
        --srcdir=. && \
    make -j2 && \
    make install && \
    cd /tmp && \
    rm -rf /tmp/* && \
    apk del build-dependencies

CMD '/usr/bin/aria2d'
