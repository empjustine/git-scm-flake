{
  inputs.nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
  outputs = {
    self,
    nixpkgs-stable,
  }: {
    apps.x86_64-linux.git-gui = {
      type = "app";
      program = "${nixpkgs-stable.legacyPackages.x86_64-linux.gitFull}/libexec/git-core/git-gui";
    };
    apps.x86_64-linux.gitk = {
      type = "app";
      program = "${nixpkgs-stable.legacyPackages.x86_64-linux.gitFull}/bin/gitk";
    };

    packages.x86_64-linux.git-tk = nixpkgs-stable.legacyPackages.x86_64-linux.buildEnv {
      name = "git-tk";
      paths = with nixpkgs-stable.legacyPackages.x86_64-linux; [
        git-doc
      ];
      pathsToLink = ["/share/man" "/share/doc" "/share/info" "/bin" "/etc"];
      extraOutputsToInstall = ["man" "doc" "info"];
      postBuild = ''
        ln -s ${nixpkgs-stable.legacyPackages.x86_64-linux.gitFull}/libexec/git-core/git-gui $out/bin/git-gui
        ln -s ${nixpkgs-stable.legacyPackages.x86_64-linux.gitFull}/bin/gitk $out/bin/gitk

        # info
        if [ -x $out/bin/install-info -a -w $out/share/info ]; then
          shopt -s nullglob
          for i in $out/share/info/*.info $out/share/info/*.info.gz; do
              $out/bin/install-info $i $out/share/info/dir
          done
        fi
      '';
    };

    packages.x86_64-linux.default = self.packages.x86_64-linux.git-tk;
  };
}
