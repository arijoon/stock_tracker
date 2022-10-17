{
  sources ? import ./sources.nix,
  # Override nixpgks config.
  config ? {},
  system ? builtins.currentSystem,
  overlays ? []
}:
let
  nixpgks = import sources.nixpkgs;
  allOverlays =
    [
      (self: super: { elixir = super.beam.packages.erlangR25.elixir_1_14; })
    ]
    ++ overlays
  ;
in
  nixpgks { inherit config system; overlays = allOverlays; }
