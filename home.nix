{ inputs, host, ...}:
{
  imports = [inputs.home-manager.nixosModules.home-manager];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    users.ryan = {
      imports = [./home/laptop];

      home = {
        username = "ryan";
        homeDirectory = "/home/ryan";
        stateVersion = "24.11";
      };

      programs.home-manager.enable = true;
    };
  };
}
