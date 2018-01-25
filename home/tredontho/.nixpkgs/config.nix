{
  allowUnfree = true;
  
  packageOverrides = pkgs_ : with pkgs_; {
    all = with pkgs; buildEnv {
      name = "all";

      paths = [
        # haskell
        cabal2nix
        nix-prefetch-git
        cabal-install
        # games
        dwarf-fortress
      ];
    };
  };
}
