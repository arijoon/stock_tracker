{ 
  pkgs ? import ./nix/pkgs.nix {}
}:
with pkgs;
let
  inherit (lib) optional optionals;
in

mkShell {
  buildInputs = [
    (import ./default.nix { inherit pkgs; })
    mix2nix
  ] ++ optional stdenv.isLinux inotify-tools;
}
