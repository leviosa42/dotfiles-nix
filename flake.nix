{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

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
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        ## REF: https://flake.parts/options/git-hooks-nix.html
        inputs.git-hooks-nix.flakeModule
        ## REF: https://flake.parts/options/home-manager.html
        inputs.home-manager.flakeModules.home-manager
      ];

      flake = {
        ## TODO: Add NixOS configuration (NixOS and NixOS-WSL)
        nixosConfigurations = {
          "NixOS-WSL" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ## NixOS-WSL
              inputs.nixos-wsl.nixosModules.default
              {
                system.stateVersion = "24.11";
                wsl.enable = true;
                ## REF: https://nix-community.github.io/NixOS-WSL/options.html
                wsl = {
                  defaultUser = "nimado";
                  interop.includePath = false;
                };
              }
              ## home-manager
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  ## TODO: commented out because of this warning:
                  ##   > $ nix flake check
                  ##   > evaluation warning: nimado profile: You have set either `nixpkgs.config` or `nixpkgs.overlays` while using `home-manager.useGlobalPkgs`.
                  ## REF: https://apribase.net/2023/08/22/nix-home-manager-qa/
                  ## REF: https://nix-community.github.io/home-manager/index.xhtml#sec-install-nixos-module
                  # useGlobalPkgs = true;
                  # useUserPackages = true;
                  users."nimado" = import ./nix/home-manager;
                };
              }
            ];
          };
        };
        ## GMKtec M7 Pro
        "NixOS-Desktop" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/machines/NixOS-Desktop/homeConfigurations
            ./nix/machines/NixOS-Desktop/configuration.nix
          ];
        };
        homeConfigurations = {
          "Home" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { system = "x86_64-linux"; };
            modules = [
              rec {
                home.username = "motch";
                home.homeDirectory = "/home/${home.username}";
              }
              ./nix/home-manager
            ];
          };
          "rpi5-waltz" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { system = "aarch64-linux"; };
            modules = [
              rec {
                home.username = "nimado";
                home.homeDirectory = "/home/${home.username}";
              }
              ./nix/home-manager
            ];
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
                      "hardware-configuration.nix"
                      "configuration.nix"
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
              packages = with pkgs; [
                # home-manager.packages.${system}.default
                home-manager
              ];
            };
          };
        };
    };
}
