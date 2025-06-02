<h1 align="center">:snowflake: dotfiles-nix :snowflake:</h1>

## Installation

### NixOS

#### NixOS-WSL

1. First, you have to change the defalut username from `nixos` to `nimado`.
  - ref: https://nix-community.github.io/NixOS-WSL/how-to/change-username.html
2. Run below this script.
    ```sh
    nix-shell -p git
    git clone https://github.com/leviosa42/dotfiles-nix && cd dotfiles-nix

    sudo nixos-rebuild switch --flake .#WSL
    exit # to exit nix-shell
    exec $SHELL # to apply home-manager configuration.
    ```

### non-NixOS

```sh
git clone https://github.com/leviosa42/dotfiles-nix && cd dotfiles-nix
nix flake update
nix develop

# for my main pc (x86_64-linux)
home-manager switch --flake .#Home
# for Raspberry Pi (aarch64)
home-manager switch --flake .#rpi5-waltz

exit # to exit nix-shell
exec $SHELL # to apply home-manager configuration
```

[![CI](https://github.com/leviosa42/dotfiles-nix/actions/workflows/ci.yaml/badge.svg?branch=develop)](https://github.com/leviosa42/dotfiles-nix/actions/workflows/ci.yaml)
