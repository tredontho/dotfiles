{
  allowUnfree = true;
  
  # Use nix-env -iA nixpkgs.tredontho
  packageOverrides = pkgs_ : with pkgs_; {
    tredontho = with pkgs; buildEnv {
      name = "tredontho";

      paths = [
        # dev
        nix-prefetch-git

        # haskell
        cabal2nix
        cabal-install
        ghc

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
        slack
      ];
    };
  };
}
