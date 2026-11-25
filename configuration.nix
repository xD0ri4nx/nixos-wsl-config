# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

let
  llm-agents = builtins.getFlake "github:numtide/llm-agents.nix";
in

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

# fixing wsl mnt issues
systemd.services.wsl-mnt-guard = {
    serviceConfig = {
      ExecStart = [
        "" # Clears the generated ExecStart=/bin/true line
        "${pkgs.coreutils}/bin/true"
      ];
    };
  };

# Permanent reliable DNS on NixOS-WSL (prevents parallel Nix build DNS drops
  wsl.wslConf.network.generateResolvConf = false;
  networking.resolvconf.enable = false;
  environment.etc."resolv.conf".text = ''
    nameserver 1.1.1.1
    nameserver 9.9.9.9
  '';

nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  }; 
nixpkgs.config.allowUnfree = true;

# programs
environment.systemPackages = with pkgs; [
    git
    tmux
    gh
    fastfetch
    cmatrix
    cbonsai
    #llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode2
    #llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-cli
  ];

#services
services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    config.common.default = [ "kde" ];
  };

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
