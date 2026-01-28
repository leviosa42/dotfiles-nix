<h1 align="center">:snowflake: dotfiles-nix :snowflake:</h1>

## Install Nix

```sh
# Install Nix via Determinate Nix
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

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
nix run nixpkgs#git clone https://github.com/leviosa42/dotfiles-nix
cd dotfiles-nix
nix flake update
nix run .#switch
```

[![CI](https://github.com/leviosa42/dotfiles-nix/actions/workflows/ci.yaml/badge.svg)](https://github.com/leviosa42/dotfiles-nix/actions/workflows/ci.yaml)
