{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyFile = "$XDG_STATE_HOME/bash/history";
    historyFileSize = 100000;
    initExtra = lib.mkIf (builtins.elem pkgs.theme-sh config.home.packages) ''
      theme.sh nord
      if [[ -e $HOME/.bashrc.local ]]; then
        source $HOME/.bashrc.local
      fi
    '';

    shellAliases = {
      q = "exit";
      cls = "clear";
      ls = "eza";
      lt = "eza -T";
      g = "git";
    };
  };
}
