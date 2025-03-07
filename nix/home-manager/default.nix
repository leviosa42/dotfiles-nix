{ config, pkgs, ... }: 
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
rec {
  imports = [
    ./bash.nix
    ./starship.nix
  ];

  # required to use home-manager
  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
  home.username = "motch";
  home.homeDirectory = "/home/${home.username}";

  xdg.enable = true;
  home.packages = with pkgs; [
    bat
    eza
    delta
    dust
    fzf
    ripgrep
    tealdeer

    neovim

    git
    gh

    deno

    era
    theme-sh
  ];

  home.file = {
    ".vimrc".source =
      mkOutOfStoreSymlink "${home.homeDirectory}/dotfiles-nix/.vimrc";
    ".config/nvim".source = mkOutOfStoreSymlink "${home.homeDirectory}/dotfiles-nix/.config/nvim";
    ".config/git".source = mkOutOfStoreSymlink "${home.homeDirectory}/dotfiles-nix/.config/git";
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
    EDITOR = "vim";
  };

}
