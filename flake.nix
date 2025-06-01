{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    systems.url = "github:nix-systems/default";

    # treefmt-nix = {
    #   url = "github:numtide/treefmt-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      home-manager,
      systems,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;

      imports = [
        ## REF: https://flake.parts/options/git-hooks-nix.html
        inputs.git-hooks-nix.flakeModule
        ## REF: https://flake.parts/options/home-manager.html
        inputs.home-manager.flakeModules.home-manager
      ];

      flake = {
        ## TODO: Add NixOS configuration (NixOS and NixOS-WSL)
        homeConfigurations = {
          "Home" = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { system = "x86_64-linux"; };
            modules = [ ./nix/home-manager ];
          };
          "rpi5-waltz" = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { system = "aarch64-linux"; };
            modules = [ ./nix/home-manager ];
          };
        };
      };

      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        {
          pre-commit = {
            check.enable = true; # perform the pre-commit checks in `nix flake check`
            settings = {
              # src = ./.;
              ## REF: https://flake.parts/options/git-hooks-nix.html#opt-perSystem.pre-commit.settings.hooks
              hooks = {
                ## --- predefined hooks ---
                deadnix = {
                  # Scan Nix files for dead code (unused variables bindings)
                  enable = true;
                  settings = {
                    noLambdaPatternNames = true; # Don’t check lambda pattern names (don’t break nixpkgs callPackage).
                  };
                };
                # detect-private-keys.enable = true; # Detect the presence of private keys
                fix-byte-order-marker.enable = true; # Remove UTF-8 BOM
                flake-checker.enable = true; # Run health checks on flake-powered Nix projects
                # nixfmt-rfc-style.enable = true; # Format nixfmt-rfc-style
                # shellcheck.enable = true; # Format shell scripts
                statix = { # Lints and suggests improvements to Nix code
                  enable = true;
                  verbose = true; # Show all warnings
                  settings = {
                    ignore = [
                      "_*"
                    ];
                  };
                };
                ## REF: https://flake.parts/options/git-hooks-nix.html#opt-perSystem.pre-commit.settings.hooks.treefmt
                # treefmt.enable = true;
                ## --- custom hooks ---
              };
            };
          };

          devShells = {
            default = pkgs.mkShell {
              inputsFrom = [ config.pre-commit.devShell ];
            };
          };
        };
    };
}
