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
    # REF: https://blog-a2e.pages.dev/p/2026%E5%B9%B4-6%E6%9C%88-%E7%AC%AC%E4%BA%8C%E9%80%B1/
    # use sideloadInitLua = true; for using symlinking to nvim dir
    sideloadInitLua = true;
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
