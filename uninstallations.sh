#!/bin/bash

echo "## Cleanup old configuration/tools ##"

echo "-- Removing lazygit"
find "${HOME}" -type f -not -path "*/*dotfiles*/*" -name "*lazygit*" -exec rm {} + 2> /dev/null

echo "-- Removing nvim"
rm -rf "${HOME}/.config/nvim" "${HOME}/.cache/*nvim*" "${HOME}/.local/share/nvim"
