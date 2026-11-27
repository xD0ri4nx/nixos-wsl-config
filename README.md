nixos-wsl-config

Single-file declarative NixOS-WSL configuration (configuration.nix) set up for terminal-native agentic coding, reliable WSL networking, and Flatpak desktop app support.

What's Included

Agentic Coding CLIs (via numtide/llm-agents.nix + cache.numtide.com binary cache):

opencode2 / antigravity-cli (plus commented slots for claude-code and codex)

Core CLI & Dev Tools: neovim, micro, git, gh, tmux, wget, fastfetch, cmatrix, cbonsai

WSL2 Reliability & Interop:

Static /etc/resolv.conf (1.1.1.1, 9.9.9.9) with wsl.wslConf.network.generateResolvConf = false to prevent DNS drops during parallel Nix fetches.

wsl-mnt-guard service override for clean systemd activation.

programs.nix-ld.enable = true for VS Code Remote-WSL compatibility and wsl.interop.includePath = false to prevent Windows PATH binaries from shadowing Linux tools.

Desktop / GUI Support: Flatpak enabled with xdg-desktop-portal-kde (pkgs.kdePackages.xdg-desktop-portal-kde) configured as the default portal backend for WSLg.

Repository Layout

This repository lives at ~/nixos-wsl-config and is symlinked directly to /etc/nixos/configuration.nix so edits and Git operations do not require sudo:

/etc/nixos/configuration.nix -> /home/nixos/nixos-wsl-config/configuration.nix


Fresh Setup on a New NixOS-WSL Instance

Clone this repository:

git clone https://github.com/xD0ri4nx/nixos-wsl-config.git ~/nixos-wsl-config


Point /etc/nixos/configuration.nix to the repo:

sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak
sudo ln -s ~/nixos-wsl-config/configuration.nix /etc/nixos/configuration.nix


Set temporary DNS (in case WSL's default DNS drops during initial fetch) and run the first-time bootstrap rebuild:

echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf
sudo nixos-rebuild switch --impure \
  --option extra-experimental-features "nix-command flakes" \
  --option extra-substituters "https://cache.numtide.com" \
  --option extra-trusted-public-keys "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="


Why these flags are needed on the first run: configuration.nix evaluates builtins.getFlake during the build, before NixOS has written nix.settings.experimental-features and the Numtide binary cache keys into /etc/nix/nix.conf. Passing them on the CLI bootstraps flakes and pulls prebuilt agent binaries from cache.numtide.com immediately. Once this first rebuild finishes, plain sudo nixos-rebuild switch --impure works on all subsequent runs.

Restart WSL once from Windows PowerShell so /etc/wsl.conf (generateResolvConf = false and includePath = false) takes full effect:

wsl --shutdown


Daily Usage

Apply configuration changes or update coding agents to the latest release:

sudo nixos-rebuild switch --impure


Commit and push changes:

cd ~/nixos-wsl-config
git add configuration.nix README.md
git commit -m "Update configuration"
git push
