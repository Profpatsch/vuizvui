# Example of how to push simple overrides to a type dhall setting
{ dhall-nix, pkgs, lib }:

let
  dhallToNix = import ./dhall-to-nix.nix { inherit dhall-nix; inherit (pkgs) stdenv; inherit pkgs; };

  # import our function from dhall-land
  f = (dhallToNix ./override-nix.dhall);

  # helper that removes all null fields from attrset
  rmNulls = lib.filterAttrs (_: v: v != null);

in
  f
    # the Pkg type (irrelevant which nix value we pass
    {}
    # dynamically get a package (Text -> Pkg)
    (pkg: pkgs.${pkg})
    # how to apply overrides to a package
    (pkg: override: pkg.overrideAttrs (_: (rmNulls override)))
