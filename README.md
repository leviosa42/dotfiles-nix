<h1 align="center">:snowflake: dotfiles-nix :snowflake:</h1>

## Installation

### NixOS (NixOS-WSL)

```sh
sudo nix-channel --update

mkdir -p ~/.config/nix
echo "experimental-features = nix-commands flakes" >> ~/.config/nix/nix.conf

nix-shell -p git
git clone https://github.com/leviosa42/dotfiles-nix && cd dotfiles-nix

nix flake update
nix run .#switch
```

### non-NixOS

```sh
git clone https://github.com/leviosa42/dotfiles-nix && cd dotfiles-nix
nix flake update
nix run .#switch
```

[![CI](https://github.com/leviosa42/dotfiles-nix/actions/workflows/ci.yaml/badge.svg?branch=develop)](https://github.com/leviosa42/dotfiles-nix/actions/workflows/ci.yaml)
