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
    pkgs.ripgrep
  ];

  xdg.configFile.nvim = {
    source = ./config-nvim;
    recursive = true;
  };

  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "rg --files";
      fileWidgetCommand = "rg --files";
    };

    git = {
      enable = true;
      aliases = {
        last = "log -1 --stat";
        cp = "cherry-pick";
        co = "checkout";
        cl = "clone";
        ci = "commit";
        st = "status -sb";
        br = "branch";
        dc = "diff --cached";
        # lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %Cblue<%an>%Creset' --abbrev-commit --date=relative ";
        # lga = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %Cblue<%an>%Creset' --abbrev-commit --date=relative --all";
        # lol = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
        please = "push --force-with-lease";
      };
      userEmail = "tredontho@gmail.com";
      userName = "tredontho";
      extraConfig = {
        push = {
          default = "current";
        };
        log.date = "iso-local";
        rerere.enabled = true;
        rebase.autoSquash = true;
      };
    };

    neovim = {
      enable = true;
      extraConfig = ''
        :luafile ~/.config/nvim/lua/init.lua
      '';
      plugins = with pkgs.vimPlugins; [
        cmp-nvim-lsp
        cmp-nvim-lsp-signature-help
        fzf-vim
        legendary-nvim
        nvim-cmp
        nvim-lspconfig
        tmux-navigator
        vim-fugitive
        vim-illuminate
        vim-monokai-pro
        vim-nix
        vim-sensible
      ];
      extraPackages = with pkgs; [
        haskellPackages.haskell-language-server
        sumneko-lua-language-server
      ];
      vimAlias = true;
      vimdiffAlias = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      prefix = "C-a";
      historyLimit = 50000;
      customPaneNavigationAndResize = true;
      plugins = with pkgs; [
        tmuxPlugins.vim-tmux-navigator
      ];
      extraConfig = ''
       bind u attach-session -t . -c '#{pane_current_path}'
       bind '"' split-window -v -c "#{pane_current_path}"
       bind '%' split-window -h -c "#{pane_current_path}"
      '';
    };

    zsh = {
      enable = true;
      enableCompletion = false; # disable for now because it causes some sort of issue?

      # defaultKeymap = "vicmd";
      defaultKeymap = "viins";

      history = {
        ignoreDups = true;
        save = 50000;
        size = 50000;
      };

      sessionVariables = {
        EDITOR = "nvim";
      };

      shellAliases = {
        ll = "ls -l";
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}
