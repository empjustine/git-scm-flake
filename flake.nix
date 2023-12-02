{
  inputs.nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";

  outputs = {
    self,
    nixpkgs-stable,
  }: let
    system = "x86_64-linux";
  in {
    apps.${system} = {
      git-gui = {
        type = "app";
        program = "${nixpkgs-stable.legacyPackages.${system}.gitFull}/libexec/git-core/git-gui";
      };

      gitk = {
        type = "app";
        program = "${nixpkgs-stable.legacyPackages.${system}.gitFull}/bin/gitk";
      };
    };

    packages.${system} = {
      git-tk = nixpkgs-stable.legacyPackages.${system}.buildEnv {
        name = "git-tk";
        paths = [];
        postBuild = ''
          mkdir -p $out/bin
          ln -s ${nixpkgs-stable.legacyPackages.${system}.gitFull}/libexec/git-core/git-gui $out/bin/git-gui
          ln -s ${nixpkgs-stable.legacyPackages.${system}.gitFull}/bin/gitk $out/bin/gitk
        '';
      };

      default = self.packages.${system}.git-tk;
    };
  };
}
