  self: super: {
    pkgsUnstable = import (
      fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz
    ) { config = { allowUnfree = true; }; };
    pkgsMaster = import (
      fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz
    ) { config = { allowUnfree = true; }; };
#    pkgsLocal = import (
#      fetchTarball https://github.com/moaxcp/nixpkgs/archive/local.tar.gz
#    ) { config = pkgsConfig; };
  }

