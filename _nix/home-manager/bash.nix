{ config, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyFileSize = 100000;
    shellAliases = {
      q = "exit";
      cls = "clear";
      ls = "eza";
      lt = "eza -T";
      g = "git";
    };
  };
}
