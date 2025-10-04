{
  pkgs,
  plugins,
  ...
}: {
  imports = [
    ./options.nix
  ];

  opts = {
  };

  env = {
    NVIM_APPNAME = "astronixvim";
  };

  astronixvim = {
    enable = true;
    plugins =
      (with plugins; [
        lazy-nvim
        astronvim
        astrocommunity
      ])
      ++ (with pkgs.vimPlugins; [
        aerial-nvim
        astrocore
        astrolsp
        astrotheme
        astroui
        better-escape-nvim
        blink-cmp
        blink-compat
        cmp-dap
        friendly-snippets
        gitsigns-nvim
        guess-indent-nvim
        heirline-nvim
        lazydev-nvim
        (luasnip.overrideAttrs {customPathName = "LuaSnip";})
        mason-lspconfig-nvim
        mason-null-ls-nvim
        mason-tool-installer-nvim
        mason-nvim
        mason-nvim-dap-nvim
        mini-icons
        neo-tree-nvim
        neoconf-nvim
        none-ls-nvim
        nui-nvim
        nvim-autopairs
        nvim-dap
        nvim-dap-ui
        nvim-highlight-colors
        nvim-lspconfig
        nvim-nio
        nvim-treesitter
        nvim-treesitter-textobjects
        nvim-ts-autotag
        nvim-window-picker
        plenary-nvim
        resession-nvim
        smart-splits-nvim
        snacks-nvim
        todo-comments-nvim
        toggleterm-nvim
        vim-illuminate
        which-key-nvim
      ]);
  };

  plugins.lazy = {
    enable = true;
  };
}
