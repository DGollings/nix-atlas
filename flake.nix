{
  description = "Atlas CLI is an open source tool that helps developers manage their database schemas by applying modern DevOps principles";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-22.11";

  outputs = { self, nixpkgs }:
    let

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = "0.13.0";

      # System types to support.
      supportedSystems = [ "x86_64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

    in
    {

      packages = forAllSystems (system:
        with import nixpkgs { system = "x86_64-linux"; };
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          atlas = stdenv.mkDerivation {
            pname = "atlas";
            version = version;

            src = fetchurl {
              url = "https://release.ariga.io/atlas/atlas-linux-amd64-v${version}";
              sha256 = "sha256-bp8br7GW53dPt7MZnZJ8zhhGA9x5w8vKud2d7dl39CQ";
            };

            nativeBuildInputs = [
              autoPatchelfHook
            ];

            unpackPhase = "true";

            installPhase = ''
              mkdir -p $out/bin
              cp $src $out/bin/atlas
              chmod 755 $out/bin/atlas
            '';

            meta = with nixpkgs.lib; {
              homepage = "https://github.com/ariga/atlas";
              # description = description;
              platforms = platforms.linux;
            };
          };
        });

      # The default package for 'nix build'. This makes sense if the
      # flake provides only one package or there is a clear "main"
      # package.
      defaultPackage = forAllSystems (system: self.packages.${system}.atlas);
    };
}
