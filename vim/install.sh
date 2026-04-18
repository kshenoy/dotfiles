#!/bin/sh
set -e

PACK="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/vim/pack/plugins/start"
mkdir -p "$PACK"

clone() {
  local url="$1" dest="$2"
  if [ -d "$dest" ]; then
    echo "Updating $(basename $dest)..."
    git -C "$dest" pull --ff-only
  else
    echo "Installing $(basename $dest)..."
    git clone --depth=1 "$url" "$dest"
  fi
}

clone https://github.com/catppuccin/vim       "$PACK/catppuccin"
clone https://github.com/tpope/vim-surround    "$PACK/vim-surround"
clone https://github.com/tpope/vim-commentary  "$PACK/vim-commentary"
clone https://github.com/tpope/vim-unimpaired  "$PACK/vim-unimpaired"
clone https://github.com/tpope/vim-repeat      "$PACK/vim-repeat"

echo "Generating helptags..."
vim -u NONE -c 'helptags ALL' -c 'quit'
echo "Done."
