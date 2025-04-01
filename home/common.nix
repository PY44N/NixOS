{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "PY44N";
    userEmail = "pyan4444@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
    };

    lfs.enable = true;
  };
}