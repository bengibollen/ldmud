#! /bin/sh

if [ ! -e /mud/sblib/secure/master.c ]; then
    tar -zxf /mud/lib.tar.gz -C /mud/sblib --no-same-owner
fi

export PYTHONUNBUFFERED=1

exec /usr/local/bin/ldmud -m /mud/sblib -M secure/master.c --python-script ../startup/__main__.py
