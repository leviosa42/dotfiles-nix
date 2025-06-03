{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    withNodeJs = false;
    withPython3 = false;
    withRuby = false;
    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
