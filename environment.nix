{ exec, name, emacs, targets, test_target }:
let
  pkgs = import <nixpkgs> {};
  link_step = (with pkgs.lib.strings; concatMapStringsSep "\n" (target: "ln -s ${target.file} ${target.name}") targets);
  install_step = (with pkgs.lib.strings; concatMapStringsSep "\n" (target: ''(package-install-file "${target.name}")'') targets);
  require_step = (with pkgs.lib.strings; concatMapStringsSep "\n" (target: ''(load-file  "${target.file}")'') targets);
  emacs_start = pkgs.writeText "run-test.el" (''
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(package-refresh-contents)
${install_step}
${require_step}
'');
  build_targets = pkgs.writeShellScript "generate_targets.sh" link_step;
in rec {
  inherit name;
  inherit emacs;
  baseInputs = [];
  builder = "${pkgs.bash}/bin/bash";
  args = [ ./builder.sh ];
  setup = exec;
  inherit build_targets;
  inherit emacs_start;
  inherit test_target;
  buildInputs = [emacs pkgs.coreutils];
  system = builtins.currentSystem;
}
