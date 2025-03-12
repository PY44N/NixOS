{
  description = "Ryan's NixOS Config";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.ryan-laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./hardware/laptop-hardware-configuration.nix
        ./configuration.nix
        ./home.nix
        ./hosts/laptop.nix
        # nix-flatpak.nixosModules.nix-flatpak
      ];
      specialArgs = { inherit self inputs; };
    };
  };
}
