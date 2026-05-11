{ config, pkgs, ... }:
{
  programs.mise = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.direnv.mise.enable = true;
}
