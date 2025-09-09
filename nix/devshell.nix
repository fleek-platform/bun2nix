{ pkgs, ... }:
let
  inherit (pkgs) lib stdenv;

  # Setup hook for using the mold linker
  moldHook = (
    pkgs.makeSetupHook
      ({
        name = "mold-hook";

        propagatedBuildInputs = (
          with pkgs;
          [
            mold
          ]
        );
      })
      (
        pkgs.writeText "moldHook.sh" ''
          export RUSTFLAGS="-C link-arg=-fuse-ld=mold"
        ''
      )
  );
in
pkgs.mkShell {
  packages = with pkgs; [
    # Rust dependencies
    rustc
    cargo
    rustfmt
    clippy

    # Docs
    mdbook

    # Javascript dependencies
    bun

    (lib.optional (!stdenv.isDarwin) moldHook)
  ];
}
