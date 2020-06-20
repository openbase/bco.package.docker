#!/bin/bash

# setup script environment
# set -x
set -euo pipefail

# configure script to call original entrypoint
#set -- tini -- ${BCO_BINARY} "$@"

# Add bco user
BCO_USER_ID=${USER_ID:-9002}
BCO_GROUP_ID=${GROUP_ID:-$BCO_USER_ID}
echo "Starting with bco user id: $BCO_USER_ID and group id: $BCO_GROUP_ID"
if ! id -u bco >/dev/null 2>&1; then
  if [ -z "$(getent group $BCO_GROUP_ID)" ]; then
    echo "Create group bco with id ${BCO_GROUP_ID}"
    groupadd -g $BCO_GROUP_ID bco
  else
    group_name=$(getent group $BCO_GROUP_ID | cut -d: -f1)
    echo "Rename group $group_name to bco"
    groupmod --new-name bco $group_name
  fi
  echo "Create user bco with id ${BCO_USER_ID}"
  adduser -u $BCO_USER_ID --disabled-password --gecos '' --home "${BCO_USER_HOME}" --gid $BCO_GROUP_ID bco
fi

# Set bco directory permission
chown -R bco:bco "${BCO_USER_HOME}"
sync

# Add call to gosu to drop from root user to bco user
# when running original entrypoint
set -- gosu bco "$@"

# replace the current pid 1 with original entrypoint
exec "$@"