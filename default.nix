# The main homies file, where homies are defined. See the README.md for
# instructions.
# fetch allows for pinning packages to a specific version
# -> NixPkgs should always track the latest official released version similar to the update process enjoyed by Linux Distros
# -> Unstable is available via overlay
# -> Pinning of specific repo versions / nixpkg versions would be handled by 'fetch'
with { fetch = import ./nix/fetch.nix; };
let

  pkgs = import <nixpkgs> { overlays = [ (import ./overlays/package-sets.nix) (import ./overlays/upgrades.nix) (import ./overlays/python3/python3.nix) ]; };

  # The list of packages to be installed
  homies = with pkgs;
    [
      # Customized packages
      bashrc
      git
      vim

      pkgs.curl
      pkgs.fzf
      pkgs.gitAndTools.gitAnnex
      pkgs.gnupg
      pkgs.htop
      pkgs.jq
      pkgs.less
      pkgs.nix
      pkgs.pass
      pkgs.tree
      pkgs.xclip
      pkgs.pypi2nix
      # nodejs is available in 'slim' and standard, slim doesn't contain npm so its only suitable for use with node2nix and building docker containers
      pkgs.nodejs-8_x
      pkgs.nodePackages.node2nix
      pkgs.nodePackages.tern
    ];

  ## Some cunstomizations

  # A custom '.bashrc' (see bashrc/default.nix for details)
  bashrc = pkgs.callPackage ./bashrc {};

  # Git with config baked in
  git = import ./git (
    { inherit (pkgs) makeWrapper symlinkJoin;
      git = pkgs.git;
    });

  # snack example
  #snack = (import (fetch "snack")).snack-exe;
  python3 = pkgs.python36;
  node = pkgs.nodejs-8_x;
  vim = import ./vim (with pkgs;
  {inherit
        fetchGit
        symlinkJoin
        makeWrapper
        node
        vim_configurable
        pythonPackages
        python3
        python3Packages
        vimUtils
        vimPlugins;
    });

in
  if pkgs.lib.inNixShell
  then pkgs.mkShell
    { buildInputs = homies;
      shellHook = ''
        $(bashrc)
        '';
    }
  else homies
