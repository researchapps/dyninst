{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/unstable";
    #nixpkgs.url = "github:NixOS/nixpkgs/21.11";

    utils.url = "github:numtide/flake-utils";
    utils.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, ... }@inputs: inputs.utils.lib.eachSystem [ 
      "x86_64-linux" "aarch64-linux" "i686-linux"
      ] (system: let pkgs = import nixpkgs {
          inherit system;
          inherit lib;

                   # Add overlays here if you need to override the nixpkgs
                   # official packages.
                   overlays = [];
                   
                   # Uncomment this if you need unfree software (e.g. cuda) for
                   # your project.
                   #
                   # config.allowUnfree = true;
                 };
          in {
               devShell = pkgs.mkShell rec {
                 name = "dyninst";

                 packages = with pkgs; [
                   # Development Tools
                   llvmPackages_14.openmp
                   boost
                   libiberty
                   elfutils
                   libdwarf
                   tbb
                   cmake
                 ];

                 # Setting up the environment variables you need during
                 shellHook = let
                   icon = "f121";
                 in ''
                    export PS1="$(echo -e '\u${icon}') {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} (${name}) \\$ \[$(tput sgr0)\]"
                 '';
               };
               defaultPackage = pkgs.callPackage ./default.nix {};
             });
}
