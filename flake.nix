{
  description = "Subset of the os-tutorial, built with Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }: flake-parts.lib.mkFlake { inherit inputs; } ({ self, lib, ... }: {
    systems = [ "x86_64-linux" ];
    debug = true;

    imports = [
      inputs.devshell.flakeModule
    ];

    perSystem = { pkgs, pkgs-i386, system, config, ... }: {
      _module.args = {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              lib = prev.lib.extend (_: _: self.lib);
              inherit pkgs-i386;
            })
          ];
        };
        pkgs-i386 = (import nixpkgs {
          inherit system;
          crossSystem = {
            config = "i386-elf";
          };
        }).buildPackages;
      };

      packages = rec {
        inherit (pkgs-i386) gcc binutils gdb;

        xenia-i386 = pkgs.callPackage ./nix/kernel.nix { };

        default = xenia-i386;
      };

      apps = (import ./nix/run.nix {
        drv = config.packages.xenia-i386;
        inherit pkgs pkgs-i386;
      }) // { default = config.apps.curses; };

      devshells.default = {
        name = "xenia-i386";
        motd = "";

        commands = [{
          name = "run";
          command = "nix run $PRJ_ROOT";
        }];

        devshell.packages = (with pkgs; [
          nasm
          qemu
        ]) ++ (with pkgs-i386; [
          gcc
          binutils
          gdb
        ]);
      };

      checks = config.packages;
    };

    flake = {
      lib = import ./nix/lib.nix { inherit (nixpkgs) lib; };
    };
  });
}
