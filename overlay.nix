{inputs, ...}: final: prev: let
  inherit (inputs.twist.overlays.default final prev) emacsTwist;
  inherit (inputs.org-babel.overlays.default final prev) tangleOrgBabelFile;
  inherit (inputs.emacs-overlay.overlays.emacs final prev) emacs-pgtk;
  registries = import ./registries.nix inputs;
  emacsPackage =
    prev.runCommand "emacs" {
      buildInputs = [prev.makeWrapper];
    } ''
      mkdir $out
      ln -s ${prev.emacs-pgtk}/* $out
      rm $out/bin
      mkdir $out/bin
      ln -s ${prev.emacs-pgtk}/bin/* $out/bin
      rm $out/bin/emacs
      rm $out/bin/emacsclient
      makeWrapper ${prev.emacs-pgtk}/bin/emacs $out/bin/emacs \
        --set GTK_IM_MODULE gtk-im-context-simple
      makeWrapper ${prev.emacs-pgtk}/bin/emacs $out/bin/emacsclient \
        --set GTK_IM_MODULE gtk-im-context-simple
    '';
in {
  emacs-config = emacsTwist {
    inherit emacsPackage;
    initFiles = [(tangleOrgBabelFile "init.el" ./init.org {})];
    lockDir = ./lock;
    inherit registries;
  };
}