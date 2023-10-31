{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
      ];

      systems = [
        "x86_64-linux"
      ];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: with pkgs; {
        formatter = alejandra;
        packages = let
          f5fpc = callPackage ./. { };
        in {
          # default = f5fpc;
          # inherit f5fpc;
          f5fpc-start = callPackage ./f5fpc-start.nix { inherit f5fpc; };
        };
      };

      flake = {
      };
    };
}
