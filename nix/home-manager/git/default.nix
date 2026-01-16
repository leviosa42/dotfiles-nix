{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    ignores = [
      "*.swp"
    ];
    settings = {
      user.name = "leviosa42";
      user.email = "101305426+leviosa42@users.noreply.github.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
      aliases = {
        br = "branch";
        co = "checkout";
        cm = "commit";
        st = "status";
        sw = "switch";
      };
      commit.template = "${./commit-template.txt}";
    };
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
