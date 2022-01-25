#!/bin/bash

# Install fish
FISH_CONFIG_DIR="${HOME}/.config/fish"
mkdir -p $FISH_CONFIG_DIR
cp -r shells/fish/config.fish ${FISH_CONFIG_DIR}/config.fish
