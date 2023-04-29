{ package }:
let 
  pkgs = import <nixpkgs> {};
  package_lint = import ./package-lint.nix;
  test = import ./run-test.nix;
  versions = import ./versions.nix;
  create_target = target: pkgs.lib.mapAttrs (version_name: emacs_version: target {
    inherit version_name;
    emacsWithPackages = emacs_version (_: []);
  }) versions;
  run_package_lint = config: package_lint (package // {
    emacsWithPackages = config.emacsWithPackages;
    name = "${package.name}-emacs-${config.version_name}-package-lint";
    test_target = package.test_target;
  });
  run_test = config: test (package // {
    emacsWithPackages = config.emacsWithPackages;
    name = "${package.name}-${config.version_name}-test";
    test_target = package.test_target;
  });
  in
rec {
  inherit versions;
  test = create_target run_test;
  package_lint = create_target run_test;
}
