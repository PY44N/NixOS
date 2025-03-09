{config, pkgs, ...}:

{
	programs.starship = {
		enable = true;
	};

	programs.alacritty = {
		enable = true;
		settings = {
			font = {
				size = 14;	
			};
		};
	};

	programs.bash = {
		enable = true;
		enableCompletion = true;
	};
}
