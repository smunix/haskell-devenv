{ inputs, pkgs, ... }:
with pkgs.haskell.lib;
let
  hpkgs = pkgs.haskellPackages.override ({
    overrides = hfinal: hprevious:
      with hfinal; {
        haskell-ical = callCabal2nix "haskell-ical" inputs.haskell-ical { };
        haskell-devenv = callCabal2nix "haskell-devenv" inputs.self { };
      };
  });
in {
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [ pkgs.git (hpkgs.ghcWithPackages (p: [ p.haskell-devenv ])) ];

  # https://devenv.sh/scripts/
  scripts.hello.exec = "echo hello from $GREET";

  enterShell = ''
    git --version
  '';

  # https://devenv.sh/languages/
  # languages.nix.enable = true;

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;
  pre-commit.hooks = {
    nixfmt.enable = true;
    hpack.enable = true;
    fourmolu.enable = true;
  };

  # https://devenv.sh/processes/
  # processes.ping.exec = "ping example.com";

  # See full reference at https://devenv.sh/reference/options/
}
