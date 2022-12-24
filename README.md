# Atlas cli binary
https://github.com/ariga/atlas

# Example usage:

flake.nix
``` nix
{
  inputs =
    {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      flake-utils.url = "github:numtide/flake-utils";
      atlas.url = "github:DGollings/nix-atlas";
    };

  outputs = { self, nixpkgs, flake-utils, atlas }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bashInteractive ];
          buildInputs = [
            atlas.packages.${system}.atlas
          ];
        };
      });
}
```
