# NixOS Migration Guide

Generated 2026-05-09. Snapshot of preparation state and remaining steps for migrating from Fedora 42 to NixOS on tnkpd.

## Current state

### NixOS configuration (in dotfiles repo)

- 35 nix files at `~/dotfiles/{flake.nix,nix/,secrets/}`
- Multi-host flake supporting `tnkpd` (laptop) and `apd-iii` (desktop)
- Hybrid approach: home-manager manages packages/services, raw configs symlinked via `mkOutOfStoreSymlink`
- Encrypted secrets at `~/dotfiles/secrets/secrets.yaml` (sops-nix, age key)
- Age public key: `age1gux5nsff6rgrez7ec2fsl34dvspt038qcnr7l3meeweyg8alqdqq5qff8f`
- Age private key location: `~/.config/sops/age/keys.txt`

### USB

- Device: `/dev/sda` (Kingston DataTraveler, 115 GB)
- Flashed with NixOS minimal 25.05 (`nixos-minimal-25.05.813814.ac62194c3917-x86_64-linux.iso`)
- SHA256: `38dee38fd5b5f2429c35aef7d9cc039a21cafbd93809adf061d29149e3583c94`
- **Age key copied to USB EFIBOOT partition** at `/age-keys.txt` (so it's available during install without copying from another machine)

### Disk layout

| Partition | Size | Filesystem | Mount | Purpose |
|-----------|------|------------|-------|---------|
| `nvme0n1p1` | 600 MB | vfat (FAT32) | `/boot/efi` | EFI System Partition (will be shared with NixOS) |
| `nvme0n1p2` | 1 GB | ext4 | `/boot` | Fedora /boot (BLS, kernel images) |
| `nvme0n1p3` | 415.4 GB | btrfs | `/` and `/home` | Fedora root + home (45 GB free inside) |
| `nvme0n1p4` | 59.9 GB | unformatted | -- | Reserved for NixOS install |

### What was done to prepare

1. Cleaned up ~50 GB from `~/.cache/uv`, `~/.npm`, `~/.cache/{yarn,Cypress,google-chrome,puppeteer,chromium,pip,phpactor}`, `~/.local/share/Trash`
2. Ran `btrfs balance start -dusage=50 -musage=50 /` to consolidate sparsely-used chunks (returned 24 GB to the unallocated pool)
3. Shrunk btrfs filesystem by 61 GiB: `btrfs filesystem resize -61G /` (now 414.35 GiB)
4. Shrunk partition with 1 GiB safety buffer: `parted /dev/nvme0n1 -- unit GiB resizepart 3 417`
5. Created new partition: `parted /dev/nvme0n1 -- mkpart NixOS btrfs 417GiB 100%`

## Install steps (when ready)

### 1. Boot from USB

Reboot, hit `F12` (ThinkPad boot menu), select the Kingston USB. You land in a TTY as user `nixos`.

```bash
sudo loadkeys es                     # Spanish keyboard

# IMPORTANT: NixOS minimal does NOT have NetworkManager/nmcli.

# Option A: ethernet (easiest -- DHCP is automatic)
ip addr show                         # verify you got an IP
ping -c 3 1.1.1.1

# Option B: WiFi via wpa_supplicant (iwd is NOT included in minimal 25.05)
ip link show                                     # find your wifi interface (e.g. wlan0)
wpa_passphrase "SSID" "password" | sudo tee /etc/wpa_supplicant.conf
sudo wpa_supplicant -B -i <wlan-device> -c /etc/wpa_supplicant.conf
sudo dhcpcd <wlan-device>
ping -c 3 1.1.1.1                                # verify connectivity
```

### 1.5. Enable SSH (HIGHLY RECOMMENDED)

Doing the rest of the install over SSH from another machine means you get copy-paste, scrollback, and survival across disconnects (with tmux). Skipping this step means debugging from the TTY by retyping everything by hand. Do it.

```bash
sudo passwd nixos                # set a password for the live user
sudo systemctl start sshd        # not started by default on minimal
ip -4 addr show | grep inet      # find your IP
```

Then from your other machine:

```bash
ssh nixos@<ip>
tmux new -s install              # so the install survives a dropped connection
```

### 2. Bring in dotfiles and age key

The age key is already on the USB's EFIBOOT partition (copied during prep on Fedora). Mount that partition and grab it:

```bash
# the USB itself is the boot device, but the EFIBOOT partition is still mountable
# find your USB device (it's the one you booted from)
lsblk -f

# mount the EFIBOOT partition (likely /dev/sda2 or /dev/sdb2)
sudo mkdir -p /tmp/usbefi
sudo mount /dev/sda2 /tmp/usbefi      # adjust device if needed

# copy the key into the user's expected location
mkdir -p ~/.config/sops/age
sudo cp /tmp/usbefi/age-keys.txt ~/.config/sops/age/keys.txt
sudo chown $(id -u):$(id -g) ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
sudo umount /tmp/usbefi

# clone dotfiles
git clone https://github.com/miermontoto/dotfiles /tmp/dotfiles
```

`git` is included in the NixOS minimal installer so no `nix-env -i` needed.

### 3. Format and mount the new partition

```bash
sudo mkfs.btrfs -L nixos /dev/nvme0n1p4

# create subvolumes (matches the layout in flake's hardware-configuration.nix)
sudo mount /dev/nvme0n1p4 /mnt
sudo btrfs subvolume create /mnt/@
sudo btrfs subvolume create /mnt/@home
sudo btrfs subvolume create /mnt/@nix
sudo umount /mnt

# remount with subvolume options
sudo mount -o subvol=@,compress=zstd,noatime /dev/nvme0n1p4 /mnt
sudo mkdir -p /mnt/{home,nix,boot}
sudo mount -o subvol=@home,compress=zstd,noatime /dev/nvme0n1p4 /mnt/home
sudo mount -o subvol=@nix,compress=zstd,noatime /dev/nvme0n1p4 /mnt/nix
sudo mount -o fmask=0077,dmask=0077 /dev/nvme0n1p1 /mnt/boot   # SHARED ESP with Fedora; restrictive masks so the random-seed file isn't world-readable
```

### 4. Generate hardware config

```bash
sudo nixos-generate-config --root /mnt
```

This auto-detects everything currently mounted under `/mnt` (root, home, nix, boot) and writes a complete `hardware-configuration.nix` with the real UUIDs and the exact mount options you set in step 3. No manual filesystem blocks needed.

Replace the placeholder in the flake with the generated file:

```bash
sudo cp /mnt/etc/nixos/hardware-configuration.nix \
        /tmp/dotfiles/nix/hosts/tnkpd/hardware-configuration.nix
```

Quick sanity check — open the file and verify:
- The four `fileSystems."/"`, `."/home"`, `."/nix"`, `."/boot"` blocks are present.
- The three btrfs ones share the same UUID with different `subvol=` options.
- `/boot` points to `nvme0n1p1` (the shared ESP) AND its `options` include `"fmask=0077"` and `"dmask=0077"` (otherwise systemd-boot will warn that the random-seed file is world-readable).

If anything looks off, re-run `nixos-generate-config` after fixing the live mounts.

### 5. Stage the age key for the new install

```bash
sudo mkdir -p /mnt/home/mier/.config/sops/age
sudo cp ~/.config/sops/age/keys.txt /mnt/home/mier/.config/sops/age/keys.txt
sudo chmod 600 /mnt/home/mier/.config/sops/age/keys.txt
# permissions will be fixed by home-manager activation, but it's good practice
```

### 6. Install

```bash
sudo nixos-install --flake /tmp/dotfiles#tnkpd --no-root-passwd
```

Expected duration: 15-45 minutes (downloads everything declared in the flake). The `--no-root-passwd` skips the prompt -- user `mier` is configured via home-manager.

### 6.5. Stage dotfiles in the installed home BEFORE reboot

`/tmp` on the live installer is tmpfs — it's gone the moment you reboot, so step 8's old `mv /tmp/dotfiles /home/mier/dotfiles` will fail because `/tmp/dotfiles` won't exist on the installed system. Copy the repo into the installed home now (mier's UID is 1000, group `users` is GID 100):

```bash
sudo cp -a /tmp/dotfiles /mnt/home/mier/dotfiles
sudo chown -R 1000:100 /mnt/home/mier        # also fixes the staged age key from step 5
```

The `1000:100` is intentional — on the live installer the user `nixos` happens to be UID 1000, but `chown -R nixos:users` would be wrong-by-coincidence. Use the numeric UID/GID so it doesn't depend on which user-name owns 1000 in whatever shell you're in.

### 6.7. Set mier's password (REQUIRED before reboot)

`users.users.mier` is declared `isNormalUser` but with no `hashedPassword` / `initialPassword`, which means `!` in `/etc/shadow`. Combined with greetd autologin you'd boot fine into the desktop, but `sudo` would fail (nothing to authenticate against) and you can't `passwd` without sudo. Catch-22 — set the password now via chroot:

```bash
sudo nixos-enter --root /mnt --command "passwd mier"
```

Prompts twice for the new password. (Long term: consider declaring `users.users.mier.hashedPasswordFile` pointing at a sops secret, so this isn't needed on future installs.)

### 7. Reboot

```bash
sudo reboot
```

Remove the USB. systemd-boot's menu should appear. NixOS will be the default; older Fedora-from-grub may or may not appear (see caveat below).

### 8. First boot

Dotfiles are already at `/home/mier/dotfiles` (step 6.5) and the password is set (step 6.7). If the seed warning appeared during install, the corrected `hardware-configuration.nix` is already in place — apply it with:

```bash
sudo nixos-rebuild switch --flake ~/dotfiles#tnkpd
sudo reboot
```

Future rebuilds:

```bash
sudo nixos-rebuild switch --flake ~/dotfiles#tnkpd
```

### 9. Post-install (one-time)

```bash
# add Flathub for the apps that stayed as Flatpak (Postman, Android Studio, BurpSuite, OBS, Flatseal)
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# log into 1Password (then SSH agent works)
1password
```

## Caveats and troubleshooting

### "Random seed file is world readable" warning from systemd-boot

`nixos-generate-config` reads the live mount options for `/mnt/boot` and bakes them into `hardware-configuration.nix`. The minimal installer mounts vfat with `fmask=0022,dmask=0022` (world-readable), and that gets propagated. systemd-boot then complains that `/loader/random-seed` is world-public, defeating its purpose (an attacker reading the previous seed can predict early-boot entropy).

Fix: in the generated `hardware-configuration.nix`, change the `/boot` block to `options = ["fmask=0077" "dmask=0077"];`. Either edit before copying it into the flake, or fix it after install and run `nixos-rebuild switch`. The system boots either way — the warning is non-fatal.

### Bootloader: Fedora may disappear from menu

systemd-boot does not auto-detect non-NixOS bootloaders. After installing, you may only see NixOS entries. Two fixes:

**Option A: add manual loader entry** -- create `/boot/loader/entries/fedora.conf`:

```
title Fedora
efi /EFI/fedora/grubx64.efi
```

**Option B: chainload via Fedora's GRUB** -- boot Fedora once, run `sudo grub2-mkconfig -o /boot/grub2/grub.cfg`. GRUB will detect the NixOS systemd-boot loader and add an entry. Then in BIOS, set Fedora's grubx64.efi as the primary boot loader.

### Hyprland machine profile

The `/home/mier/dotfiles/.config/hypr/machines/setup.sh` script creates `machines/current` -> `machines/tnkpd` symlink based on hostname. The greetd session script in `nix/system/desktop.nix` runs this before launching Hyprland, so the symlink exists when Hyprland starts.

### sops-nix

The flake's `nix/home/secrets.nix` checks `builtins.pathExists ../../secrets/secrets.yaml`. If the file is missing, sops is skipped and fish secrets aren't loaded. The encrypted file IS in the repo, so this should work after install. Decryption needs `~/.config/sops/age/keys.txt` (staged in step 5).

### To update `anthropic_api_key`

It's a placeholder right now (was empty in `fish_variables`):

```bash
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops --config ~/dotfiles/secrets/.sops.yaml ~/dotfiles/secrets/secrets.yaml
```

Then `sudo nixos-rebuild switch --flake ~/dotfiles#tnkpd` to apply.

### Reverting the partition shrink (if you bail on NixOS)

To give the 60 GB back to Fedora:

```bash
# from a live USB (NOT while Fedora is running)
sudo parted /dev/nvme0n1 -- rm 4
sudo parted /dev/nvme0n1 -- unit GiB resizepart 3 100%
# then boot Fedora
sudo btrfs filesystem resize max /
```

## Reference

### File locations

- Flake root: `~/dotfiles/flake.nix`
- System modules: `~/dotfiles/nix/system/`
- Home modules: `~/dotfiles/nix/home/`
- Host configs: `~/dotfiles/nix/hosts/{tnkpd,apd-iii}/`
- Encrypted secrets: `~/dotfiles/secrets/secrets.yaml`
- Sops config: `~/dotfiles/secrets/.sops.yaml`
- Age private key: `~/.config/sops/age/keys.txt` (NEVER commit, never sync via Syncthing)

### Decisions taken (for future reference)

- Hybrid configs (raw files via `mkOutOfStoreSymlink`, not converted to nix)
- Two hosts from start: tnkpd + apd-iii
- Migrated to nixpkgs: Slack, Discord, Obsidian, Spotify (via spicetify-nix)
- Stayed Flatpak: Postman, Android Studio, BurpSuite, OBS, Flatseal
- Nix-managed langs: Go, Ruby, JDK 21, PHP 8.4, Python 3
- External version managers kept: fnm (Node), rustup (Rust)
- Auto-login via greetd (no display manager), hyprlock for locking
- sops-nix with age for secrets
- nixpkgs-unstable for Hyprland (not the external Hyprland flake)
- Steam/Proton/gamemode on apd-iii only
- Both machines: AMD GPU (amdgpu)
