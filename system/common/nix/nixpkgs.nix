{
  lib,
  config,
  ...
}: {
  options.nix-files.nix.nixpkgs.enable = lib.mkEnableOption "Nixpkgs config";

  config = lib.mkIf config.nix-files.nix.nixpkgs.enable {
    nixpkgs = {
      config.allowUnfree = true;

      overlays = [];
    };

    environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  };
}
