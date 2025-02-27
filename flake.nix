{
  description = "Home Manager configuration of motch";

  inputs = {
# Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
# flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ self, nixpkgs, home-manager, ... }:
    let
      # system = "aarch64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."motch" = home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages."aarch64-linux";
        modules = [ ./home.nix ];
      };
    };
}
