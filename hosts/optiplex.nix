{ pkgs, config, ...}:
{
	# imports = [
	# ];

	networking.hostName = "optiplex"; # Define your hostname.

  services.openssh.enable = true;
  virtualisation.docker.enable = true;

    	environment.systemPackages = with pkgs; [
	  docker
	];
}