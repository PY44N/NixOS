{ pkgs, config, ...}:
{
	imports = [
		../drivers/audio.nix
	];

	networking.hostName = "ryan-laptop"; # Define your hostname.
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


	environment.systemPackages = with pkgs; [
	  rofi-wayland
	  font-awesome # waybar styling requires this
	  pavucontrol # pulse audio volume control (triggered by clicking volume in waybar)	
      swaynotificationcenter
      grim # screenshot tool
      dunst # cli tool to send notifications (dunstify for screenshot)
	  vscode
	];
}
