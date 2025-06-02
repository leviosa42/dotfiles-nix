{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "leviosa42";
    userEmail = "101305426+leviosa42@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
    ignores = [
      "*.swp"
    ];
    aliases = {
      br = "branch";
      co = "checkout";
      cm = "commit";
      st = "status";
      sw = "switch";
    };
    delta = {
      enable = true;
    };
  };
}
