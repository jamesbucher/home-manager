{
  description = "Home Manager for Nix";

  outputs = { self, nixpkgs }: rec {
    nixosModules.home-manager = import ./nixos;

    darwinModules.home-manager = import ./nix-darwin;

    lib = {
      hm = import ./modules/lib { lib = nixpkgs.lib; };
      homeManagerConfiguration = { configuration, system, homeDirectory
        , username, extraSpecialArgs ? { }
        , pkgs ? builtins.getAttr system nixpkgs.outputs.legacyPackages
        , check ? true 
        , useGlobalPackages ? false}@args:
        import ./modules {
          inherit pkgs check extraSpecialArgs;
          useNixpkgsModule = !useGlobalPackages;
          configuration = { ... }: {
            imports = [ configuration ];
            home = { inherit homeDirectory username; };
          };
        };
    };
  };
}
