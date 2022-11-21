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
    firefox = {
      enable = true;
    };
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

    urxvt = {
      enable = true;
      keybindings = {
        "Shift-Control-C" = "eval:selection_to_clipboard";
        "Shift-Control-V" = "eval:paste_clipboard";
      };
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

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };

    xscreensaver = {
      enable = true;
    };
  };

  xresources.extraConfig = ''
    ! special
    *.foreground:   #d1d1d1
    ! *.background:   #221e2d
    *.cursorColor:  #d1d1d1

    ! black
    *.color0:       #272822
    *.color8:       #75715e

    ! red
    *.color1:       #f92672
    *.color9:       #f92672

    ! green
    *.color2:       #a6e22e
    *.color10:      #a6e22e

    ! yellow
    *.color3:       #f4bf75
    *.color11:      #f4bf75

    ! blue
    *.color4:       #66d9ef
    *.color12:      #66d9ef

    ! magenta
    *.color5:       #ae81ff
    *.color13:      #ae81ff

    ! cyan
    *.color6:       #a1efe4
    *.color14:      #a1efe4

    ! white
    *.color7:       #f8f8f2
    *.color15:      #f9f8f5

    Xft.dpi: 96
    Xft.antialias: true
    Xft.hinting: true
    Xft.rgba: rgb
    Xft.autohint: false
    Xft.hintstyle: hintslight
    Xft.lcdfilter: lcddefault
    Xcursor.theme: Chameleon-Pearl-Regular-0.5
    Xcursor.size:  0

    !XTerm*background: #272827
    !XTerm*foreground: #fdf6e3
    XTerm*reverseVideo: on
    XTerm*faceName: DejaVu Sans Mono:size=14:antialias=true
    XTerm*selectToClipboard: true

    URxvt.font: xft:terminus:size=8:antialias=true
    URxvt.depth: 32

    !! BACKGROUND TRANSPARENT
    ! URxvt.background: [80]#06060a

    ! URxvt*scrollBar:                      false
    URxvt*mouseWheelScrollPage:           false
    URxvt*cursorBlink:                    true
    URxvt*background:                     black
    !URxvt*foreground:                     grey
    URxvt*saveLines:                      5000

    ! for 'fake' transparency (without Compton) uncomment the following three lines
    ! URxvt*inheritPixmap:                  true
    ! URxvt*transparent:                    true
    ! URxvt*shading:                        138
  '';
}
