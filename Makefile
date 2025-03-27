.DEFAULT_GOAL := help
.PHONY := help switch

HOST := $(shell hostname)
## help: Show this help message
help:
	@grep -E "^## [a-zA-Z_-]+: .*$$" $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = "^##|: "}; {printf "\033[36m%-30s\033[0m %s\n", $$2, $$3}' \
		| sort

## switch: Switch home-manager configuration for .#(HOST)
switch:
	nix flake update
ifeq ($(HOST),nixos)
	sudo nixos-rebuild switch --flake .#$(HOST)
else
	home-manager switch --flake .#$(HOST)
endif

## format: Format files
format:
	nix fmt *
