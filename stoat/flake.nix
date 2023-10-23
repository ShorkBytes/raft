{
  description = "Ubuntu server with Docker and user setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Enable Nix Flakes
        nixpkgs.nixosModules.nixFlakes

        # Set up Docker
        ({ config, pkgs, ... }: {
          services.docker.enable = true;
          users.users.alex = {
            isNormalUser = true;
            extraGroups = [ "docker" ];
            openssh.authorizedKeys.keys =
              config.users.users.root.openssh.authorizedKeys.keys
              ++ [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILr/HiH0Z8GImHlDEtRNELEni6IMVZZUqn93OYDP8eI8"
              ];
          };
        })
      ];
      # Set the hostname
      networking.hostName = "stoat";
      domain = "otter.foo";
      time.timeZone = "Europe/Paris";
      i18n.defaultLocale = "en_US.UTF-8";
      console.keyMap = "de";
    };
  };
}