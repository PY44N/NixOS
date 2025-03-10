{config, pkgs, ...}:

{
	programs.starship = {
		enable = true;
	};

	programs.alacritty = {
		enable = true;
		settings = {
			font = {
				size = 12;	
			};
		};
	};

	programs.bash = {
		enable = true;
		enableCompletion = true;
	};
}
