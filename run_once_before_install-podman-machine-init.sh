#!/usr/bin/env sh

if [[ $(podman machine list | wc -l) -le 1 ]]; then
  echo "No machine present, running init"
else
  echo "Machine present, continuing..."
  exit 0
fi


podman machine init --now
