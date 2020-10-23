{
  allowUnfree = true;
  
  # Use nix-env -iA nixpkgs.tredontho
  packageOverrides = pkgs : with pkgs; {
    tredontho = pkgs.buildEnv {
      name = "tredontho";

      paths = [
        # dev
        nix-prefetch-git
	git
	neovim
	tmux

        # haskell
        # cabal2nix
        # cabal-install
        # ghc
        # haskellPackages.ghcid

        # purescript
        # nodejs-8_x
        # haskellPackages.purescript
        # nodePackages.pulp
        # nodePackages.grunt-cli
        # nodePackages.gulp
        # nodePackages.bower

        # games
        dwarf-fortress

        # misc

        pandoc
        slack
        okular
        scrot
        ytop
        wireshark
        openvpn

        # R
        # rstudio

        # latex
        texlive.combined.scheme-full

        # unity
        unity3d
      ];
      pathsToLink = [ "/share" "/bin" ];
    };
  };
}
