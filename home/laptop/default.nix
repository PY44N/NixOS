{ config, pkgs, ... }:

{
  imports = [
  	./hyprland
	./terminal.nix
  ];

  home.packages = with pkgs ; [
    neofetch
  ];

  programs.git = {
    enable = true;
    userName = "PY44N";
    userEmail = "pyan4444@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
    };

    lfs.enable = true;
  };

  programs.neovim = {
    enable = true;
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
