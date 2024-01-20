{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    twist.url = "github:emacs-twist/twist.nix";
    org-babel.url = "github:emacs-twist/org-babel";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nixpkgs-emacs.url = "github:NixOS/nixpkgs";

    melpa = {
      url = "github:melpa/melpa";
      flake = false;
    };
    gnu-elpa = {
      url = "git+https://git.savannah.gnu.org/git/emacs/elpa.git?ref=main";
      flake = false;
    };
    nongnu = {
      url = "git+https://git.savannah.gnu.org/git/emacs/nongnu.git?ref=main";
      flake = false;
    };
    epkgs = {
      url = "github:emacsmirror/epkgs";
      flake = false;
    };
    emacs = {
      url = "github:emacs-mirror/emacs";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-emacs,
    flake-parts,
    twist,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [
        flake-parts.flakeModules.easyOverlay
      ];

      flake = {
        homeModules.emacs-config = {
          imports = [
            twist.homeModules.emacs-twist
            # custom home module goes here
          ];
        };
      };

      perSystem = {
        config,
        system,
        pkgs,
        final,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            self.overlays.default
          ];
        };

        overlayAttrs = import ./overlay.nix {inherit inputs;} final pkgs;

        packages = {
          inherit (pkgs) emacs-config;
        };

        formatter = pkgs.alejandra;
      };
    };
}
