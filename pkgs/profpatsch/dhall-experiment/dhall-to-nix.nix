# copied from nixkps
{ stdenv, dhall-nix, pkgs }:

let
  dhallToNix = file :
    let
      drv = stdenv.mkDerivation {
        name = "dhall-compiled.nix";

        buildCommand = ''
          ${dhall-nix}/bin/dhall-to-nix <<< "${file}" > $out
        '';

        buildInputs = [ dhall-nix ];
      };

    in
      import "${drv}";
in
  dhallToNix
