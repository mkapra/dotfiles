#!/bin/bash

echo "## Cleanup old configuration/tools ##"

echo "-- Removing lazygit"
find "${HOME}" -type f -not -path "*/*dotfiles*/*" -name "*lazygit*" -exec rm {} + 2> /dev/null
