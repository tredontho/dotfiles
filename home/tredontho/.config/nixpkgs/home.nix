{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "tredontho";
  home.homeDirectory = "/home/tredontho";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.bottom
    pkgs.cacert
    pkgs.coursier # needed for scala dev
    pkgs.dwarf-fortress
    pkgs.fzf
    pkgs.nix
    pkgs.nodejs
  ];

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.neovim = {
    enable = true;
    coc.enable = true;
    extraConfig = ''
      set number
      set ruler

      " Indentation/tab related settings
      set tabstop=2
      set softtabstop=2
      set shiftwidth=0 " use same value as tabstop
      set expandtab
      set autoindent

      syntax enable
      set background=dark

      " Some split settings
      set splitbelow
      set splitright
      
      colorscheme solarized

      " Avoid showing message extra message when using completion
      set shortmess+=c

      " Ensure autocmd works for Filetype
      set shortmess-=F

    '';
    plugins = with pkgs.vimPlugins; [
      fzf-vim
      nvim-metals # can this be installed as a flake or something instead?
      plenary-nvim
      vim-colors-solarized
      vim-fugitive
      vim-scala # can this be installed as a flake or something instead?
      vim-tmux-navigator
    ];
    vimdiffAlias = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # defaultKeymap = "vicmd";
    defaultKeymap = "viins";

    history = {
      ignoreDups = true;
      save = 50000;
      size = 50000;
    };

    initExtra = ''
      export EDITOR=nvim
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "direnv" "vi-mode" "fzf" ];
      theme = "robbyrussell";
    };
  };
}
