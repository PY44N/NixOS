{ config, pkgs, ... }:

{
  imports = [
  	./hyprland
	./terminal.nix
  ];

  home.packages = with pkgs ; [
          # neovim required a lot of these to run properly
      gnumake
      unzip
      jdk21
      tree-sitter
      nodejs_23
	  wl-clipboard-rs # provides wl-copy and wl-paste for screenshot
    ripgrep
    fd
  ];

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
