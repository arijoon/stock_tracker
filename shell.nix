{ sources ? import ./nix/sources.nix
, pkgs ? import sources.nixpkgs { }
}:
with pkgs;
let
  inherit (lib) optional optionals;
in

mkShell {
  buildInputs = [
    (import ./default.nix { inherit pkgs sources; })
    mix2nix
  ] ++ optional stdenv.isLinux inotify-tools;
}
