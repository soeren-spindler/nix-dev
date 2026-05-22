{
  description = "My Home Manager config for development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    common-modules = {
      url = "github:soeren-spindler/nix-common";
    };
  };

  outputs = { nixpkgs, home-manager, common-modules, ... }:
    let
      system = "x86_64-linux";
      user = "zoeren";
      home = "/home/zoeren";
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      homeConfigurations.${user} =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit pkgs;
            gitName = "zoeren";
            gitEmail = "";
          };

          modules = [	
            common-modules.homeManagerModules.zsh
            common-modules.homeManagerModules.git
            common-modules.homeManagerModules.neovim

            {
              home.username = user;
              home.homeDirectory = home;

              home.stateVersion = "25.05";

              home.packages = with pkgs; [
                lazygit
                tree-sitter
                nerd-fonts.jetbrains-mono
              ];
 
              programs.home-manager.enable = true;
            }
          ];
        };
    };
}
