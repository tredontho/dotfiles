{
  allowUnfree = true;
  
  # Use nix-env -iA nixpkgs.all
  packageOverrides = pkgs_ : with pkgs_; {
    all = with pkgs; buildEnv {
      name = "all";

      paths = [
        # dev
        nix-prefetch-git

        # haskell
        cabal2nix
        cabal-install

        # purescript
        nodejs
        haskellPackages.purescript
        nodePackages.pulp
        nodePackages.grunt-cli
        nodePackages.gulp
        nodePackages.bower

        # games
        dwarf-fortress

        # misc

        pandoc
      ];
    };
  };
}
