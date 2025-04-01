{ pkgs, config, ...}:
{
	imports = [
		../drivers/audio.nix
		# ./pia.nix
	];

	networking.hostName = "ryan-laptop"; # Define your hostname.
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

	# Install firefox.
	programs.firefox.enable = true;

	environment.sessionVariables.NIXOS_OZONE_WL = "1";

	
	# Allows logseq to work
	nixpkgs.config.permittedInsecurePackages = [
		"electron-27.3.11"
	];

	# Enable the X11 windowing system.
	services.xserver.enable = true;

	# Enable the GNOME Desktop Environment.
	services.xserver.displayManager.gdm.enable = true;
	services.xserver.desktopManager.gnome.enable = true;

	# Configure keymap in X11
	services.xserver.xkb = {
		layout = "us";
		variant = "";
	};

	# Enable CUPS to print documents.
	services.printing.enable = true;

	environment.systemPackages = with pkgs; [
	  vscode
	  discord
	  code-cursor
	  github-desktop
	  cloc
	  jetbrains.idea-ultimate
	  google-chrome
	  slack
	  proton-pass
	  bambu-studio
	  todoist-electron
	  zotero
	  logseq
      pdfarranger
	];
}
