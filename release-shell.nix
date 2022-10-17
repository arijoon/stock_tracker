{ 
  pkgs ? import ./nix/pkgs.nix {}
}:
with pkgs;
let
  inherit (lib) optional optionals;
in

mkShell {
  buildInputs = [
    postgresql
  ] ++ optional stdenv.isLinux inotify-tools;
}
