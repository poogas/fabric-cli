{
  description = "A rock-solid, simple flake for the Fabric CLI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          default = pkgs.buildGoModule {
            pname = "fabric-cli";
            version = "unstable-${self.shortRev or "dirty"}";

            src = self;

            vendorHash = "sha256-3ToIL4MmpMBbN8wTaV3UxMbOAcZY8odqJyWpQ7jkXOc=";
          };
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/fabric-cli";
          meta.description = "A command-line interface for Fabric";
        };
      });
}
