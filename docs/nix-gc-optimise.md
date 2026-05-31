# Automatic garbage collection & store optimization

The Nix store grows over time: every `nixos-rebuild switch` keeps the previous
system generations (shown in the boot menu) and leaves behind store paths that
are no longer referenced. This config reclaims that space automatically via
systemd timers — no manual `nix-collect-garbage` needed.

Configured in `hosts/common/default.nix`, so it applies to all hosts.

## What it does

```nix
# Delete generations older than 3 months, weekly.
nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 90d";
  persistent = true;
};

# Deduplicate the store: hard-link identical files on every build, plus a weekly sweep.
nix.settings.auto-optimise-store = true;
nix.optimise = {
  automatic = true;
  dates = [ "weekly" ];
};
```

- **`nix.gc`** runs `nix-collect-garbage --delete-older-than 90d` once a week. It
  removes system-profile generations older than 90 days and then collects any
  unreferenced store paths. The **current** generation is always kept, even if
  it is older than 90 days.
- **`persistent = true`** means a missed run (laptop suspended or off at the
  scheduled time) fires shortly after the next boot instead of being skipped.
- **`auto-optimise-store`** hard-links identical files in the store on every
  build. **`nix.optimise`** adds a weekly `nix-store --optimise` sweep that also
  dedups paths created before this was enabled.

These generate the systemd timers `nix-gc.timer` and `nix-optimise.timer` — this
is NixOS's declarative equivalent of a cron job.

## Verify

Check the timers are scheduled:
```bash
systemctl list-timers | grep -E 'nix-gc|nix-optimise'
systemctl status nix-gc.timer nix-optimise.timer
```

List remaining system generations:
```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

## Manual operations

Run garbage collection or optimization immediately (don't wait for the timer):
```bash
sudo systemctl start nix-gc.service
sudo systemctl start nix-optimise.service
journalctl -u nix-gc.service -e
```

Run a one-off collection by hand:
```bash
# Delete everything not currently referenced
sudo nix-collect-garbage -d

# Same policy as the timer: drop generations older than 90 days
sudo nix-collect-garbage --delete-older-than 90d

# Deduplicate the store now
sudo nix-store --optimise
```
