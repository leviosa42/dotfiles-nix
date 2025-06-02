{ config, pkgs, ... }:
{
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      traces-vim
    ];
    extraConfig = builtins.readFile ./vimrc;
  };
}
