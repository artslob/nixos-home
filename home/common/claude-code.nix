{ pkgs, ... }: {
  # Create settings.local.json with ONLY the hooks configuration
  # This file will be public in the NixOS config
  # Personal settings (permissions, etc.) should be in settings.json (private)
  xdg.configFile."claude/settings.local.json" = {
    source = pkgs.writeText "claude-settings-local.json" (builtins.toJSON {
      # Audio notification hooks
      hooks = {
        # Play "what?" sound when Claude asks for permission/input
        PermissionRequest = [{
          hooks = [{
            type = "command";
            command = "pw-play ${./peon-what.mp3}";
          }];
        }];

        # Play "job done" sound when Claude finishes responding
        Stop = [{
          hooks = [{
            type = "command";
            command = "pw-play ${./peon-job-done.wav}";
          }];
        }];
      };
    });
  };
}
