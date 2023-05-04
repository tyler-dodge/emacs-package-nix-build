{ emacsWithPackages, name, targets, test_target }:
let
  pkgs = import <nixpkgs> {};
  emacs_packages = (epkgs: with epkgs; [
    ert-runner
    ert-async
    el-mock
  ]);
  emacs = import ./environment.nix {
    inherit name;
    inherit targets;
    inherit test_target;
    emacs = emacsWithPackages emacs_packages;
    exec = ./run-test.sh;
  };
in derivation emacs
