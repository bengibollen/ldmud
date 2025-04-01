FROM debian:bookworm

# Add user/group arguments
ARG UID=1000
ARG GID=1000

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential ca-certificates git bison autoconf autogen automake wget \
    pkg-config libgcrypt20-dev libgnutls28-dev libpq-dev python3-dev \
    libxml2-dev zlib1g-dev libpcre3-dev libc-ares-dev python3-hunspell \
    python3-pip hunspell-de-de help2man gdb

# Create mud user/group
RUN groupadd -g $GID mud \
 && useradd -u $UID -g mud -m mud

COPY . /build
RUN cd /build/src && \
    ./autogen.sh && \
    ./configure --with-setting=sblib --prefix=/usr/local --libdir=/mud/sblib && \
    make install-all && \
    if [ -d "python" ]; then \
        cd python && python3 setup.py install; \
    else \
        echo "Python module directory not found, skipping installation"; \
    fi && \
    cd / && rm -rf /build

# Set up the mud directory and startup scripts
RUN mkdir -p /mud && chown mud:mud /mud
COPY --chown=mud:mud mud/ /mud/
COPY --chown=mud:mud mud/startup /usr/local/bin/startup/

RUN apt-get clean \
 && apt-mark manual libgnutls30 libpq5 libpython3.11 libxml2 libpcre3 \
 && apt-get remove --purge -y build-essential ca-certificates git bison autoconf autogen automake wget pkg-config libgcrypt20-dev libgnutls28-dev libsqlite3-dev python3-dev libxml2-dev zlib1g-dev libpcre3-dev \
 && apt-get autoremove -y 

# Add environment variables
ENV PYTHONUNBUFFERED=1

ADD driver.sh /usr/local/bin/

USER mud
EXPOSE 4040 4041/udp
VOLUME /mud

CMD [ "/usr/local/bin/driver.sh" ]
