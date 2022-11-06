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
    pkgs.nix
    pkgs.nodejs
    pkgs.ripgrep
    pkgs.brightnessctl
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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files";
    fileWidgetCommand = "rg --files";
  };

  programs.neovim = {
    enable = true;
    # coc.enable = true;
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

      " BEGIN nvim-metals
      "=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
      " These are example settings to use with nvim-metals and the nvim built in
      " LSP.  Be sure to thoroughly read the the help docs to get an idea of what
      " everything does.
      "
      " The below configuration also makes use of the following plugins besides
      " nvim-metals
      " - https://github.com/nvim-lua/completion-nvim
      "=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+

      "-----------------------------------------------------------------------------
      " nvim-lsp Mappings
      "-----------------------------------------------------------------------------
      nnoremap <silent> gd          <cmd>lua vim.lsp.buf.definition()<CR>
      nnoremap <silent> K           <cmd>lua vim.lsp.buf.hover()<CR>
      nnoremap <silent> gi          <cmd>lua vim.lsp.buf.implementation()<CR>
      nnoremap <silent> gr          <cmd>lua vim.lsp.buf.references()<CR>
      nnoremap <silent> gds         <cmd>lua vim.lsp.buf.document_symbol()<CR>
      nnoremap <silent> gws         <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
      nnoremap <silent> <leader>rn  <cmd>lua vim.lsp.buf.rename()<CR>
      nnoremap <silent> <leader>f   <cmd>lua vim.lsp.buf.formatting()<CR>
      nnoremap <silent> <leader>ca  <cmd>lua vim.lsp.buf.code_action()<CR>
      nnoremap <silent> <leader>ws  <cmd>lua require'metals'.worksheet_hover()<CR>
      nnoremap <silent> <leader>a   <cmd>lua require'metals'.open_all_diagnostics()<CR>
      nnoremap <silent> <space>d    <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
      nnoremap <silent> [c          <cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>
      nnoremap <silent> ]c          <cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>

      "-----------------------------------------------------------------------------
      " nvim-lsp Settings
      "-----------------------------------------------------------------------------
      " If you just use the latest stable version, then setting this isn't necessary
      let g:metals_server_version = '0.9.8+10-334e402e-SNAPSHOT'

      "-----------------------------------------------------------------------------
      " nvim-metals setup with a few additions such as nvim-completions
      "-----------------------------------------------------------------------------
      :lua << EOF
        metals_config = require'metals'.bare_config()
        metals_config.settings = {
           showImplicitArguments = true,
           excludedPackages = {
             "akka.actor.typed.javadsl",
             "com.github.swagger.akka.javadsl"
           }
        }

        metals_config.on_attach = function()
          require'completion'.on_attach();
        end

        metals_config.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
          vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = {
              prefix = '',
            }
          }
        )
      EOF

      if has('nvim-0.5')
        augroup lsp
          au!
          au FileType scala,sbt lua require('metals').initialize_or_attach(metals_config)
        augroup end
      endif

      "-----------------------------------------------------------------------------
      " completion-nvim settings
      "-----------------------------------------------------------------------------
      " Use <Tab> and <S-Tab> to navigate through popup menu
      inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
      inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

      "-----------------------------------------------------------------------------
      " Helpful general settings
      "-----------------------------------------------------------------------------
      " Needed for compltions _only_ if you aren't using completion-nvim
      autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc

      " Set completeopt to have a better completion experience
      set completeopt=menuone,noinsert,noselect

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

  programs.sioyek = {
    enable = true;
    bindings = {
      "move_up" = "k";
      "move_down" = "j";
      "move_left" = "h";
      "move_right" = "l";
      "screen_down" = [ "d" "<C-d>" ];
      "screen_up" = [ "u" "<C-u>" ];
    };
  };

  programs.texlive = {
    enable = true;
    # packageSet = pkgs.texlive.combined.scheme-full;
    extraPackages = tpkgs: {inherit (tpkgs) collection-fontsrecommended scheme-full; };
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
