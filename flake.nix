{
  description = "Home Manager configuration of shafti";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dots = {
        url = "git+https://github.com/shafti-code/dots.git?ref=main";
        flake = false;
    };
  };

  outputs =
    { nixpkgs, home-manager, dots, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."shafti" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit dots; };
        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
