{
  description = "Home Manager configuration of shafti";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dots-src = {
        url = "github:shafti-code/dots";
        flake = false;
    };
  };

  outputs =
    { nixpkgs, home-manager, dots-src, ... }:
    let
      system = "aarch64-darwin";
      overlay = final : prev: {
          dots = pkgs.stdenv.mkDerivation {
            name = "dots";
            src = dots-src;
            installPhase = ''
              mkdir -p $out
              cp -r * $out/
              cp -r .* $out/ 2>/dev/null || true
              ls -la
              false
            '';
          };
      };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ overlay ];
      };
    in
    {
      homeConfigurations."shafti" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];
        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
