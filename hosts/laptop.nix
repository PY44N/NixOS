{ pkgs, config, ...}:
{
	imports = [
		../drivers/audio.nix
		# ./pia.nix
	];

	networking.hostName = "ryan-laptop"; # Define your hostname.
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

	# services.flatpak.enable = true;
		
	# services.flatpak.packages = [
	# 	"com.todoist.Todoist"
	# ];

	environment.systemPackages = with pkgs; [
	  rofi-wayland
	  font-awesome # waybar styling requires this
	  pavucontrol # pulse audio volume control (triggered by clicking volume in waybar)	
      swaynotificationcenter
      grim # screenshot tool
      dunst # cli tool to send notifications (dunstify for screenshot)
	  vscode
	  discord
	  code-cursor
	  networkmanagerapplet
	  networkmanager-openvpn
	  github-desktop
	  cloc
	  wl-clipboard-rs # provides wl-copy and wl-paste for screenshots
	  jetbrains.idea-ultimate
	  google-chrome
	  slack
	  proton-pass
	  
      # neovim required a lot of these to run properly
      gnumake
      unzip
      jdk21
	];
}
