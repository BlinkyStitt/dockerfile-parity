#!/bin/bash
set -e

# this if will check if the first argument is a flag
# but only works if all arguments require a hyphenated flag
# -v; -SL; -f arg; etc will work, but not arg1 arg2
if [ "${1:0:1}" = '-' ]; then
    set -- parity "$@"
fi

# check for the expected command
if [ "$1" = 'parity' ]; then
    # TODO: if the config has "rpc-login=monero:changeme", change it automatically

    # TODO: handle adding multiple peers
    if [ -n "$PARITY_PEER" ]; then
        echo $PARITY_PEER > "$HOME/reserved_peers"

        set -- "$@" --reserved-peers "$HOME/reserved_peers"
    fi

    # TODO: optional numactl

    # keep config outside the volume
    exec "$@"
fi

# otherwise, don't get in their way
exec "$@"
