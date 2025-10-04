{
  config,
  options,
  lib,
  pkgs,
  plugins,
  ...
}: let
  # https://github.com/nix-community/nixvim/blob/main/plugins/pluginmanagers/lazy.nix
  cfg = config.astronixvim;
  lazyPlugins = cfg.plugins;
  processPlugin = plugin: let
    mkEntryFromDrv = p:
      if lib.isDerivation p
      then {
        name =
          if builtins.hasAttr "customPathName" p
          then p.customPathName
          else "${lib.getName p}";
        path = p;
      }
      else {
        name = "${lib.getName p.pkg}";
        path = p.pkg;
      };
    processDependencies =
      if plugin ? dependencies && plugin.dependencies != null
      then builtins.concatMap processPlugin plugin.dependencies
      else [];
  in
    [(mkEntryFromDrv plugin)] ++ processDependencies;

  processedPlugins = builtins.concatLists (builtins.map processPlugin lazyPlugins);
  lazyPath = pkgs.linkFarm "lazy-plugins" processedPlugins;
in {
  options.astronixvim = with lib; {
    enable = mkEnableOption "enable astronixvim";
    plugins = options.plugins.lazy.plugins;
  };

  config = lib.mkIf cfg.enable {
    plugins.lazy = {
      enable = true;
      package = plugins.lazy-nvim;
    };

    extraConfigLua = ''
      require("lazy").setup({
        {
          "AstroNvim/AstroNvim",
          -- version = "^5", -- Remove version tracking to elect for nightly AstroNvim
          import = "astronvim.plugins",
          opts = { -- AstroNvim options must be set here with the `import` key
            mapleader = " ", -- This ensures the leader key must be configured before Lazy is set up
            maplocalleader = ",", -- This ensures the localleader key must be configured before Lazy is set up
            icons_enabled = true, -- Set to false to disable icons (if no Nerd Font is available)
            pin_plugins = nil, -- Default will pin plugins when tracking `version` of AstroNvim, set to true/false to override
            update_notifications = true, -- Enable/disable notification about running `:Lazy update` twice to update pinned plugins
          },
        },
        {
          "AstroNvim/astrocommunity",
          { import = "astrocommunity.pack.lua" },
        }
      },
      {
        -- Configure any other `lazy.nvim` configuration options here
        install = { colorscheme = { "astrotheme", "habamax" } },
        dev = {
          path = "${lazyPath}",
          patterns = {"."},
          fallback = false
        },
        ui = { backdrop = 100 },
        performance = {
          rtp = {
            -- disable some rtp plugins, add more to your liking
            disabled_plugins = {
              "gzip",
              "netrwPlugin",
              "tarPlugin",
              "tohtml",
              "zipPlugin",
            },
          },
        },
      })
    '';
  };
}
