{inputs, ...}: final: prev: let
  inherit (inputs.twist.overlays.default final prev) emacsTwist;
  inherit (inputs.org-babel.overlays.default final prev) tangleOrgBabelFile;
  inherit (inputs.emacs-overlay.overlays.emacs final prev) emacs-pgtk;
  registries = import ./registries.nix inputs;
  emacsPackage =
    emacs-pgtk;
in {
  emacs-config = emacsTwist {
    inherit emacsPackage;
    initFiles = [(tangleOrgBabelFile "init.el" ./init.org {})];
    lockDir = ./lock;
    inherit registries;
  };
}
