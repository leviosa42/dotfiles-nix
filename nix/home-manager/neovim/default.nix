{ config, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  pwd = "${config.home.homeDirectory}/dotfiles-nix/nix/home-manager/neovim";
in
{
  programs.neovim = {
    enable = true;
    withNodeJs = false;
    withPython3 = false;
    withRuby = false;
    # extraLuaConfig = builtins.readFile ./init.lua;
    extraPackages = with pkgs; [
      websocat # for typst-preview
      nil
      lua-language-server
      tinymist
      # copilot.lua
      curl
      nodejs-slim # v20 or higher
    ];
    plugins = with pkgs.vimPlugins; [ lazy-nvim ];
  };
  xdg.configFile."nvim" = {
    source = mkOutOfStoreSymlink pwd;
    recursive = true;
  };
}
