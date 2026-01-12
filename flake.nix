{
  description = "A PyQt6 application to dynamically modify Pipewire and Wireplumber settings";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    jack_delay.url = "github:SanderVocke/jack_delay-nix";
    jack_delay.inputs.nixpkgs.follows = "nixpkgs";
    jack_client.url = "github:SanderVocke/jack-client-nix";
    jack_client.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, utils, jack_delay, jack_client }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    in
    utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        packages = rec {
           cable = pkgs.callPackage ./cable.nix {
             jack_delay = jack_delay.packages.${system}.default;
             jack-client = jack_client.packages.${system}.default;
           };
           default = cable;
        };

        apps.default = utils.lib.mkApp {
          drv = self.packages.${system}.cable;
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ self.packages.${system}.cable ];
        };
      }
    ) // {
      overlays.default = final: prev: {
        cable = final.callPackage ./cable.nix { };
      };
    };
}
