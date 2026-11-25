# nixos-wsl-config

Single-file declarative NixOS-WSL configuration (`configuration.nix`) set up for terminal-native agentic coding, reliable WSL networking, and Flatpak desktop app support.

## What's Included

- **Agentic Coding CLIs** (via [`numtide/llm-agents.nix`](https://github.com/numtide/llm-agents.nix) + `cache.numtide.com` binary cache):
  - `claude-code`
  - `opencode`
  - `codex`
  - `gemini-cli`
- **Core CLI & Dev Tools:** `git`, `gh`, `tmux`, `fastfetch`, `cmatrix`, `cbonsai`
- **WSL2 Reliability Fixes:**
  - Static `/etc/resolv.conf` (`1.1.1.1`, `9.9.9.9`) with `wsl.wslConf.network.generateResolvConf = false` to prevent DNS drops during parallel Nix fetches.
  - `wsl-mnt-guard` service override for clean systemd activation.
- **Desktop / GUI Support:** Flatpak enabled with `xdg-desktop-portal-kde` (`pkgs.kdePackages.xdg-desktop-portal-kde`) configured as the default portal backend for WSLg.

## Repository Layout

This repository lives at `~/nixos-wsl-config` and is symlinked directly to `/etc/nixos/configuration.nix` so edits and Git operations do not require `sudo`:

```text
/etc/nixos/configuration.nix -> /home/nixos/nixos-wsl-config/configuration.nix
