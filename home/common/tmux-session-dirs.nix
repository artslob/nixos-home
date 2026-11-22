# Persist each tmux session's working directory (session_path: set by
# `prefix P`, used as the cwd of new windows) across tmux-resurrect
# save/restore. tmux-resurrect only saves pane directories; on restore a
# session's dir would otherwise become the dir of its first pane.
#
# Evaluates to a tmux config snippet. It is appended to the resurrect plugin's
# extraConfig in tmux.nix so the hooks are set before continuum.tmux starts
# its background auto-restore.
{ pkgs }:
let
  # Set session $1's working dir to $2 without a real client. attach-session -c
  # is the only command that changes session_path; run from a client with no
  # terminal it applies -c and then fails with "open terminal failed: not a
  # terminal" (tmux 3.7b cmd-attach-session.c sets s->cwd before
  # server_client_open), so no client is attached or switched and no client's
  # last session changes. -c is format-expanded, hence # -> ##. Exits non-zero
  # if the dir did not take effect.
  setDir = pkgs.writeShellScript "tmux-set-session-dir" ''
    TMUX= tmux -S "''${TMUX%%,*}" attach-session -t "=$1:" -c "''${2//\#/##}" </dev/null >/dev/null 2>&1
    [ "$(tmux display-message -p -t "=$1:" '#{session_path}' 2>/dev/null)" = "$2" ]
  '';

  # post-save-layout hook, $1 = resurrect file being written. Runs before
  # resurrect compares it with the previous save, so a changed session dir
  # yields a new snapshot. restore.sh ignores line types it doesn't know.
  saveDirs = pkgs.writeShellScript "tmux-save-session-dirs" ''
    tab=$'\t'
    tmux list-sessions -F "session_dir$tab#{session_name}$tab#{session_path}" >> "$1"
  '';

  # post-restore-all hook, $1 = restored resurrect file, $2 = resurrect's
  # $RESTORING_FROM_SCRATCH. Only acts on a fresh-server restore, so a manual
  # restore (prefix C-r) never rolls back dirs of sessions already running.
  restoreDirs = pkgs.writeShellScript "tmux-restore-session-dirs" ''
    [ "$2" = true ] || exit 0
    [ -f "$1" ] || exit 0
    failed=
    while IFS=$'\t' read -r kind name dir; do
      [ "$kind" = session_dir ] || continue
      tmux has-session -t "=$name" 2>/dev/null || continue
      ${setDir} "$name" "$dir" </dev/null || failed="$failed $name"
    done < "$1"
    [ -z "$failed" ] || tmux display-message "tmux-session-dirs: could not restore dir of:$failed"
  '';
in
''
  set -g @resurrect-hook-post-save-layout '${saveDirs}'
  # resurrect evals hooks inside restore.sh, so its last_resurrect_file and
  # RESTORING_FROM_SCRATCH are available here
  set -g @resurrect-hook-post-restore-all '${restoreDirs} "$(last_resurrect_file)" "$RESTORING_FROM_SCRATCH"'

  # prefix P: set session working dir (used by new windows) to current pane's
  # path. Via setDir rather than a plain attach-session -c, which would set the
  # client's last session to the current one and break prefix L. #{q:} escapes
  # the values for the shell; run-shell without -b blocks, so display shows the
  # new dir.
  bind P run-shell '${setDir} #{q:session_name} #{q:pane_current_path}' \; display "Session dir: #{session_path}"
''
