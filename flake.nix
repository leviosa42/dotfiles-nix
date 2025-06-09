{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    vscode-server.url = "github:nix-community/nixos-vscode-server";

    flake-parts.url = "github:hercules-ci/flake-parts";

    systems.url = "github:nix-systems/default";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
        ## REF: https://flake.parts/options/treefmt-nix.html
        inputs.treefmt-nix.flakeModule
      ];

      flake = {
        ## TODO: Add NixOS configuration (NixOS and NixOS-WSL)
        nixosConfigurations = {
          "NixOS-WSL" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ## NixOS-WSL
              inputs.nixos-wsl.nixosModules.default
              inputs.vscode-server.nixosModules.default
              (
                { config, pkgs, ... }:
                {
                  system.stateVersion = "24.11";
                  wsl.enable = true;
                  ## REF: https://nix-community.github.io/NixOS-WSL/options.html
                  wsl = {
                    defaultUser = "nimado";
                    interop.includePath = false;
                  };
                  environment.systemPackages = with pkgs; [
                    wget # for vscode-server
                    wslu
                  ];
                  services.vscode-server.enable = true;
                  # for chomosuke/typst-preview.nvim
                  programs.nix-ld.enable = true;
                }
              )
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
                  backupFileExtension = "bak";
                };
              }
            ];
          };
          ## GMKtec M7 Pro
          "NixOS-Desktop" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./nix/machines/NixOS-Desktop/hardware-configuration.nix
              ./nix/machines/NixOS-Desktop/configuration.nix
            ];
          };
        };
        homeConfigurations = {
          "Home" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { system = "x86_64-linux"; };
            modules = [
              rec {
                home.username = "nimado";
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
                statix = {
                  # Lints and suggests improvements to Nix code
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
                ## NOTE: priority?
                ## REF: https://flake.parts/options/git-hooks-nix.html#opt-perSystem.pre-commit.settings.hooks.treefmt
                treefmt = {
                  enable = true;
                  packageOverrides.treefmt = config.treefmt.build.wrapper; # # use built treefmt by perSystem.treefmt
                  before = [
                    "statix"
                    "deadnix"
                  ];
                };
                ## --- custom hooks ---
              };
            };
          };

          treefmt = {
            ## REF: https://github.com/numtide/treefmt-nix/blob/1f3f7b784643d488ba4bf315638b2b0a4c5fb007/flake-module.nix#L70-L75
            flakeCheck = true; # # Add a flake check to run `treefmt`. default: true
            flakeFormatter = true; # # Enable `treefmt` the default formatter used by `nix fmt` command.
            programs = {
              nixfmt.enable = true;
              stylua = {
                enable = true;
                settings = {
                  column_width = 120;
                  indent_type = "Spaces";
                  indent_width = 2;
                  line_endings = "Unix";
                  quote_style = "AutoPreferSingle";
                };
              };
            };
          };

          apps = {
            switch = {
              type = "app";
              ## display runned commadn to switch configurations with cyan color
              program = toString (
                pkgs.writeShellScript "switch-script" ''
                  set -e
                  hostname=$(uname -n)
                  system=${system}
                  distro=$(cat /etc/os-release | grep ^ID= | cut -d '=' -f 2)
                  is_wsl() {
                    grep -q "Microsoft" /proc/version || grep -q "WSL" /proc/version
                  }
                  run_command() {
                    echo -e "\\033[36m> $1\\033[0m"
                    eval "$1"
                  }
                  echo "info:"
                  echo "  hostname: $hostname"
                  echo "  system: $system"
                  echo "  distro: $distro"
                  echo "  is_wsl: $(is_wsl && echo true || echo false)"

                  ## NOTE: inf loop?
                  # run_command "nix flake update"
                  # git add flake.nix
                  # git commit -m "update(deps): flake.lock by `nix run .#switch`"

                  if [[ "$distro" == "nixos" ]]; then
                    if is_wsl; then
                      run_command "sudo nixos-rebuild switch --flake .#NixOS-WSL"
                    else
                      run_command "sudo nixos-rebuild switch --flake .#NixOS-Desktop"
                    fi
                  else
                    case "$system" in
                      "x86_64-linux")
                         run_command "home-manager switch --flake .#Home -b bak"
                        ;;
                      "aarch64-linux")
                        run_command "home-manager switch --flake .#rpi5-waltz -b bak"
                        ;;
                      *)
                        echo "Unknown system: $system"
                        exit 1
                        ;;
                    esac
                  fi
                ''
              );
            };
          };

          devShells = {
            default = pkgs.mkShell {
              inputsFrom = [
                config.pre-commit.devShell
                config.treefmt.build.devShell
              ];
              packages = with pkgs; [
                # home-manager.packages.${system}.default
                home-manager
              ];
            };
          };
        };
    };
}
