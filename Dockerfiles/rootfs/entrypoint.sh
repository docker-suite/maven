#!/usr/bin/env bash

# Run every files in /etc/entrypoint.d
for file in $( find /etc/entrypoint.d/ -name '*.sh' -type f | sort -u ); do
    [ -x "${file}" ] && sudo -E bash "${file}"
done

# Run maven entrypoint
exec /sbin/tini -- /usr/local/bin/mvn-entrypoint.sh "$@"
