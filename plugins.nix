{pkgs}: {
  lazy-nvim =
    (pkgs.vimUtils.buildVimPlugin rec {
      pname = "lazy.nvim";
      version = "11.17.1";
      nvimSkipModules = [
        "lazy.view.commands"
        "lazy.build"
        "lazy.manage.task.init"
        "lazy.manage.init"
        "lazy.manage.checker"
        "lazy.manage.runner"
      ];
      src = pkgs.fetchFromGitHub {
        owner = "folke";
        repo = "lazy.nvim";
        rev = "v${version}";
        sha256 = "sha256-nQ8PR9DTdzg6Z2rViuVD6Pswc2VvDQwS3uMNgyDh5ls=";
      };
      meta.homepage = "https://github.com/folke/lazy.nvim";
    }).overrideAttrs {
      patches = [(pkgs.replaceVars ./patches/lazy.nvim.patch {})];
    };
  astronvim = pkgs.vimUtils.buildVimPlugin rec {
    pname = "AstroNvim";
    version = "5.3.12";
    dependencies = [pkgs.vimPlugins.astrocore];
    nvimSkipModules = [
      "astronvim.plugins._astrocore"
    ];
    src = pkgs.fetchFromGitHub {
      owner = "AstroNvim";
      repo = "AstroNvim";
      rev = "v${version}";
      sha256 = "sha256-dTDSS9x2UiuBYB+tQo8BdaZfvhs2GU6ZOYloJKjLRE8=";
    };
    meta.homepage = "https://github.com/AstroNvim/AstroNvim/";
  };
  astrocommunity = pkgs.vimUtils.buildVimPlugin rec {
    pname = "astrocommunity";
    version = "19.0.0";
    nvimSkipModules = ["astrocommunity.debugging.nvim-bqf.init"];
    src = pkgs.fetchFromGitHub {
      owner = "AstroNvim";
      repo = "astrocommunity";
      rev = "v${version}";
      sha256 = "sha256-Spl93+rGlQ22S2pG+T5vIBsEJfEnCglkJFYRJcadRKs=";
    };
    meta.homepage = "https://github.com/AstroNvim/astrocommunity/";
  };
}
