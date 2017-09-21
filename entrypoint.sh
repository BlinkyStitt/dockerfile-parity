#!/bin/bash
set -e

# this if will check if the first argument is a flag
# but only works if all arguments require a hyphenated flag
# -v; -SL; -f arg; etc will work, but not arg1 arg2
if [ "${1:0:1}" = '-' ]; then
    set -- parity "$@"
fi

# TODO: i keep copypastaing this around. we should include it in the base image
if [ -n "$TOR_HOSTNAME" ] || [ -n "$TOR_IP" ]; then
    # torsocks does not support name resolution so we do it here
    TORSOCKS_CONF_FILE=/etc/tor/torsocks.conf
    until [ -n "$TOR_IP" ]; do
        TOR_IP=$(getent hosts "$TOR_HOSTNAME" | cut -f1 -d' ')

        # TODO: max wait?
        if [ -z "$TOR_IP" ]; then
            echo "Tor is not yet running at $TOR_HOSTNAME! Sleeping..."
            sleep 10
        fi
    done
    echo "TorAddress $TOR_IP" > "$TORSOCKS_CONF_FILE"
    echo "AllowInbound 1" > "$TORSOCKS_CONF_FILE"

    # torify everything
    export TORSOCKS_CONF_FILE
    export LD_PRELOAD=/usr/lib/torsocks/libtorsocks.so

    echo "torsocks loaded..."
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
