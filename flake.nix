{
  inputs.nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";

  outputs = {
    self,
    nixpkgs-stable,
  }: {
    apps.x86_64-linux = let
      pkgs = nixpkgs-stable.legacyPackages.x86_64-linux;
    in {
      git-gui = {
        type = "app";
        program = "${pkgs.gitFull}/libexec/git-core/git-gui";
      };
      gitk = {
        type = "app";
        program = "${pkgs.gitFull}/bin/gitk";
      };
    };

    packages.x86_64-linux = let
      pkgs = nixpkgs-stable.legacyPackages.x86_64-linux;
      selfPkgs = self.packages.x86_64-linux;
    in {
      git-tk = pkgs.buildEnv {
        name = "git-tk";
        paths = [];
        postBuild = ''
          mkdir -p $out/bin
          ln -s ${pkgs.gitFull}/libexec/git-core/git-gui $out/bin/git-gui
          ln -s ${pkgs.gitFull}/bin/gitk $out/bin/gitk
        '';
      };

      default = selfPkgs.git-tk;
    };
  };
}
