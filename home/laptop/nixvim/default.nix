{inputs, config, pkgs, ...}:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./lsp.nix
    ./completion.nix
    ./tree-sitter.nix
    ./telescope.nix
    ./nix.nix
  ];

  programs.nixvim = {
    enable = true;

    colorschemes.gruvbox.enable = true;
    plugins.lualine.enable = true;
  };
}