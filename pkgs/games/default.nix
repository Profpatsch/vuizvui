{ config ? null, pkgs ? import <nixpkgs> {} }:

let
  configFilePath = let
    xdgConfig = builtins.getEnv "XDG_CONFIG_HOME";
    fallback = "${builtins.getEnv "HOME"}/.config";
    basedir = if xdgConfig == "" then fallback else xdgConfig;
  in "${basedir}/nixgames.nix";

  configFile = if !builtins.pathExists configFilePath then throw ''
    The config file "${configFilePath}" doesn't exist! Be sure to create it and
    put your HumbleBundle email address and password in it, like this:

    {
      humblebundle.email = "fancyuser@example.com";
      humblebundle.password = "my_super_secret_password";
    }
  '' else configFilePath;

  baseModule = { lib, ... }: {
    options = {
      packages = lib.mkOption {
        type = lib.types.attrsOf lib.types.unspecified;
        default = {};
        description = "Available collections of games.";
      };
    };

    config._module.args.pkgs = let
      mkBuildSupport = super: let
        self = import ./build-support {
          inherit (super) config;
          callPackage = lib.callPackageWith (super // self);
        };
      in self;
    in pkgs // (mkBuildSupport pkgs) // {
      pkgsi686Linux = pkgs.pkgsi686Linux
                   // (mkBuildSupport pkgs.pkgsi686Linux);
    };
  };

in (pkgs.lib.evalModules {
  modules = [
    (if config == null then configFilePath else config)
    baseModule ./humblebundle ./steam ./itch
  ];
}).config.packages
