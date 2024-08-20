{
  pkgs,
  lib,
  inputs,
  self,
  config,
  ...
}: {
  # weekly updated nix-index database
  # needed due to nix channels being disabled, breaking command-not-found
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  age.secrets."tokens/github".file = "${self}/secrets/tokens/github.age";

  # need git for flakes
  environment.systemPackages = [pkgs.git];

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    # pin the registry to avoid downloading and evaling a new nixpkgs verison every time
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    # set the path for channels compat
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

    settings = {
      # enable flakes and 'nix' command
      experimental-features = "nix-command flakes";
      # disable global registry
      flake-registry = "";

      # https://jackson.dev/post/nix-reasonable-defaults/
      connect-timeout = 5;
      log-lines = 25;
      min-free = 128000000;
      max-free = 1000000000;
      fallback = true;
      auto-optimise-store = true;
      warn-dirty = false;
    };

    # read-only github token for rate limit
    extraOptions = ''
      !include ${config.age.secrets."tokens/github".path}
    '';

    # Opinionated: disable channels
    channel.enable = false;
  };
}
