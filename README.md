* Emacs Package Nix Build Recommended Usage

default.nix
```
let
  pkgs = import <nixpkgs> {};
  lib = pkgs.fetchFromGitHub {
    owner = "tyler-dodge";
    repo = "emacs-package-nix-build";
    rev = "217c28bda09c76ca17c11918ee29e4041c572229";
    hash = "sha256-Ip+JJg03FT+dKjxTtQYIlZ8TqpFtzQSq3WnxokQssio=";
  };
in import lib {
  package = {
    name = "org-assistant";
    test_target = ./test;
    targets = [{
      name = "org-assistant.el";
      file = ./org-assistant.el;
    }];
  };
}
```

shell.nix
```
{ pkgs ? import <nixpkgs> {} }:

let
  versions = (import ./default.nix).versions;
in pkgs.mkShell {
  packages = [
    (versions.latest (epkgs: []) (epkgs: []))
  ];
}
```
