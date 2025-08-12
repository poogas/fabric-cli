{
  description = "A flake for the Fabric CLI";

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
          default = pkgs.stdenv.mkDerivation {
            pname = "fabric-cli";
            version = "unstable-${self.shortRev or "dirty"}";

            src = self;

            nativeBuildInputs = [ pkgs.meson pkgs.ninja pkgs.go ];

            meta = with pkgs.lib; {
              description = "An alternative CLI for fabric";
              license = licenses.agpl3Only;
              platforms = platforms.linux;
            };
          };
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/fabric-cli";
        };
      });
}
