{
  description = "LaTeX Document Demo";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        compile = pkgs.writeShellApplication {
          name = "compile";
          runtimeInputs = [ pkgs.coreutils pkgs.pandoc ];
          text = "bash ${./compile.sh}";
        };
      in
      {
        apps.default = { type = "app"; program = "${compile}/bin/compile"; };
      }
    );
}
