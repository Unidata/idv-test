#!/bin/bash
set -e

if [ "$1" = 'bootstrap.sh' ]; then

    chown -R ${CUSER}:${CUSER} ${HOME}
    sync

    exec gosu ${CUSER} "$@"
fi

exec "$@"

