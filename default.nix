{ 
  pkgs ? import ./nix/pkgs.nix {}
}:

with pkgs;
let
  elixir = beam.packages.erlangR25.elixir_1_14;
in
buildEnv {
  name = "builder";
  paths = [
    elixir
    nodejs-16_x
  ];
}
