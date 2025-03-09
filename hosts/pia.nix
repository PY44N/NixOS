{ pkgs, config, ...}:
{
    imports = [
		../modules/pia.nix
    ];

	# TODO: Make this a real vpn connection at some point (not just downloading the configs)
	services.privateInternetAccess = {
       enable = true;
       autoStart = true;
       username = "";
       password = "";
       region = "US East"; # Choose from regions in vpn-hosts.txt
       protocol = "udp";
       port = 1198;
     };
}