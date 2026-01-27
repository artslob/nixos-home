# Tmux Tutorial

A comprehensive guide to using your custom tmux setup.

## Table of Contents

1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [Core Concepts](#core-concepts)
4. [Essential Keybindings](#essential-keybindings)
5. [Practical Workflows](#practical-workflows)
6. [Mouse Support](#mouse-support)
7. [Tips and Tricks](#tips-and-tricks)
8. [Common Commands Reference](#common-commands-reference)
9. [Integration with i3wm](#integration-with-i3wm)
10. [Troubleshooting](#troubleshooting)
11. [Quick Reference Card](#quick-reference-card)

---

## Introduction

### What is tmux?

Tmux (terminal multiplexer) is a powerful tool that allows you to manage multiple terminal sessions from a single window. Think of it as a window manager specifically designed for your terminal.

### Why use tmux?

Your tmux configuration provides several key benefits:

- **Persistent Sessions**: Your work survives terminal crashes and SSH disconnections
- **Better Organization**: Split a single terminal window into multiple panes
- **Remote Development**: Keep long-running processes alive on remote servers
- **Context Switching**: Quickly switch between different projects without losing your setup
- **Efficiency**: Manage complex terminal workflows without creating dozens of i3 windows

### How it complements i3wm

Tmux and i3 work together beautifully:

- **i3** manages your graphical applications and overall desktop layout
- **tmux** manages terminal sessions within those windows
- Both use similar keybinding patterns (arrows, numbers, h/v splits)
- Visual consistency with matching colors (green active borders)

---

## Getting Started

### Starting tmux

Your configuration includes convenient shell aliases:

```bash
# Start anonymous session
t
# or
tmux

# Start named session (recommended)
tn myproject

# List all sessions
tl

# Attach to existing session
ta myproject
```

### Understanding the Interface

When you start tmux, you'll see:

```
┌─────────────────────────────────────────────────┐
│                                                 │
│            Your terminal content                │
│                                                 │
│                                                 │
└─────────────────────────────────────────────────┘
 [myproject] [1:bash]              [27 Jan 14:30]
 └─session──┘ └window┘             └─clock────────┘
```

- **Session name** (green): "myproject" - your current session
- **Window list** (center): Active window shown in green
- **Clock** (orange): Current date and time

### The Prefix Key

All tmux commands start with the **prefix key**: `Ctrl+Space`

Think of it like the Super key in i3. After pressing `Ctrl+Space`, tmux is ready to receive a command.

**Example**: To split horizontally, press:
1. `Ctrl+Space` (tmux is now listening)
2. `h` (execute the split command)

### Your First Session

Let's try it:

```bash
# 1. Start a named session
tn tutorial

# 2. Split horizontally (Ctrl+Space h)
# You now have two panes side by side

# 3. Navigate to the right pane (Ctrl+Space Right)

# 4. Split vertically (Ctrl+Space v)
# Now you have 3 panes total

# 5. Try navigating with Ctrl+Space + Arrow keys

# 6. When done, detach (Ctrl+Space d)

# 7. Reattach later
ta tutorial
```

Everything is exactly as you left it!

---

## Core Concepts

Tmux has a three-level hierarchy:

### Sessions (Top Level)

A session is a complete workspace for a project or task.

```
Session: "myproject"
├── Window 1: bash
├── Window 2: vim
└── Window 3: logs
```

**Use sessions for**:
- Different projects
- Different contexts (work, personal, monitoring)
- Long-running tasks that should survive disconnects

### Windows (Middle Level)

Windows are like tabs or i3 workspaces. Each session can have multiple windows.

```
Window 1: "editor"
├── Pane 1 (vim)
└── Pane 2 (shell)
```

**Use windows for**:
- Different aspects of the same project
- Separating concerns (editing, testing, logs)
- Quick switching with number keys (like i3 workspaces)

### Panes (Bottom Level)

Panes are splits within a window. This is where you actually work.

```
┌──────────┬──────────┐
│  Pane 1  │  Pane 2  │  Window 1
│  (vim)   │  (shell) │
└──────────┴──────────┘
```

**Use panes for**:
- Viewing multiple things simultaneously
- Editor + shell + output
- Side-by-side comparisons

### Visual Hierarchy

```
Session: "web-app"
│
├── Window 1: "dev"
│   ├── Pane 1: vim (editing code)
│   ├── Pane 2: bash (running commands)
│   └── Pane 3: npm run dev (development server)
│
├── Window 2: "git"
│   ├── Pane 1: git status
│   └── Pane 2: git log
│
└── Window 3: "logs"
    └── Pane 1: tail -f server.log
```

---

## Essential Keybindings

All commands start with the prefix: `Ctrl+Space`

### Working with Panes

| Action | Keybinding | Notes |
|--------|------------|-------|
| Split horizontally | `Ctrl+Space h` | Creates left/right split |
| Split vertically | `Ctrl+Space v` | Creates top/bottom split |
| Navigate panes | `Ctrl+Space Arrows` | Just like i3! |
| Resize pane | `Ctrl+Space Ctrl+Arrows` | Hold Ctrl, press repeatedly |
| Zoom pane | `Ctrl+Space z` | Toggle fullscreen for current pane |
| Close pane | `Ctrl+Space x` | Confirm with `y` |
| Swap panes | `Ctrl+Space o` | Cycle through panes |

**Pane Navigation Tips**:
- Arrow keys feel natural if you use i3
- Resizing is repeatable: hold Ctrl+Space, then tap Ctrl+Arrow multiple times
- Zoom is great for focusing on one pane temporarily

### Working with Windows

| Action | Keybinding | Notes |
|--------|------------|-------|
| Create window | `Ctrl+Space c` | Opens in current directory |
| Switch to window N | `Ctrl+Space 1-9` | Direct access, like i3 workspaces |
| Next window | `Ctrl+Space n` | Cycle forward |
| Previous window | `Ctrl+Space p` | Cycle backward |
| Rename window | `Ctrl+Space ,` | Give it a meaningful name |
| Kill window | `Ctrl+Space &` | Closes all panes in window |
| Last window | `Ctrl+Space l` | Toggle between two windows |

**Window Tips**:
- Name your windows! `Ctrl+Space ,` then type "editor", "tests", etc.
- Use 1-9 for instant access to your most-used windows
- Window names appear in the status bar

### Session Management

| Action | Keybinding | Command |
|--------|------------|---------|
| Detach session | `Ctrl+Space d` | Session keeps running |
| List sessions | `Ctrl+Space s` | Interactive picker |
| Switch session | `Ctrl+Space s` + arrows + Enter | While in tmux |
| Create session | - | `tn project-name` |
| Attach to session | - | `ta project-name` |
| Kill session | - | `tmux kill-session -t name` |

**Session Tips**:
- Always use named sessions (`tn name`) instead of anonymous ones
- Use project names: `frontend`, `backend`, `monitoring`
- Sessions persist until you explicitly kill them or reboot

### Copy Mode

Copy mode lets you scroll back, search, and copy text.

| Action | Keybinding | Notes |
|--------|------------|-------|
| Enter copy mode | `Ctrl+Space [` | Start scrolling/searching |
| Navigate | `h j k l` or `Arrows` | Vim-style or arrows |
| Search forward | `/` | Type search term, Enter |
| Search backward | `?` | Type search term, Enter |
| Next match | `n` | Jump to next result |
| Previous match | `N` | Jump to previous result |
| Start selection | `v` | Begin visual selection |
| Select rectangle | `Ctrl+v` | Block selection |
| Copy selection | `y` | Yank and exit copy mode |
| Quit copy mode | `q` or `Escape` | Return to normal mode |

**Copy Mode Tips**:
- Scroll with mouse wheel or `Ctrl+u`/`Ctrl+d` (page up/down)
- Search is incredibly useful for finding error messages
- Selection works like vim: `v` to start, move cursor, `y` to copy
- Buffer holds 100,000 lines (plenty for logs)

### Other Useful Commands

| Action | Keybinding |
|--------|------------|
| Reload config | `Ctrl+Space r` |
| Command prompt | `Ctrl+Space :` |
| Show time | `Ctrl+Space t` |
| List all bindings | `Ctrl+Space ?` |

---

## Practical Workflows

### Workflow 1: Single Project Development

Perfect for working on one project throughout the day.

```bash
# Morning: Start project session
tn myapp

# Create your layout
# Ctrl+Space h  (split horizontal)
# Ctrl+Space Left (go to left pane)
# Ctrl+Space v  (split vertical in left side)

# Now you have:
┌──────────┬────────────┐
│  editor  │            │
│  (vim)   │   tests    │
├──────────┤  (output)  │
│  shell   │            │
└──────────┴────────────┘

# Work all day...

# Lunch: Detach
# Ctrl+Space d

# Afternoon: Reattach
ta myapp

# Everything exactly as you left it!
```

### Workflow 2: Multiple Projects

Juggle several projects without mental overhead.

```bash
# Setup your projects
tn frontend   # Web UI project
tn backend    # API server project
tn database   # Database management

# See all sessions
tl
# Output:
# frontend: 3 windows (attached)
# backend: 2 windows
# database: 1 windows

# Switch between them:
# Ctrl+Space s (brings up session list)
# Use arrows to select, Enter to switch

# Or detach and reattach
# Ctrl+Space d
ta backend
```

**Organize by context**:
```bash
# Work projects
tn work-projectA
tn work-projectB

# Personal projects
tn blog
tn homelab

# System maintenance
tn monitoring
tn updates
```

### Workflow 3: Remote Development

Tmux shines for remote work - your session survives disconnections.

```bash
# On local machine: SSH to server
ssh myserver

# On server: Start or attach to session
tn dev

# Create your development environment
# Ctrl+Space h (split)
# Ctrl+Space v (split again)

┌─────────────┬─────────────┐
│   editor    │   server    │
│             │   logs      │
├─────────────┤             │
│   tests     │             │
└─────────────┴─────────────┘

# Connection drops? No problem!
# SSH back in:
ssh myserver
ta dev

# Everything is still running!
```

**Remote workflow tips**:
- Start long-running processes (builds, servers) in tmux
- They continue even if you disconnect
- Use named sessions for different services
- Keep a monitoring session always attached

### Workflow 4: System Monitoring

Create a dedicated monitoring dashboard.

```bash
# Create monitoring session
tn monitor

# Create 4-pane layout:
# Ctrl+Space v (split vertically)
# Ctrl+Space h (split horizontally)
# Ctrl+Space Up
# Ctrl+Space h (split horizontally again)

┌──────────────┬──────────────┐
│    htop      │  system log  │
│ (CPU/Memory) │   journalctl │
├──────────────┼──────────────┤
│  disk usage  │ network mon  │
│      df      │    iftop     │
└──────────────┴──────────────┘

# Set it up once, check anytime
# Detach: Ctrl+Space d
# Later: ta monitor
```

### Workflow 5: Development + Logs

Classic dev setup with separated concerns.

```bash
# Start project
tn webapp

# Window 1: Development
# (created automatically)
# Ctrl+Space h (split horizontal)

┌─────────────┬─────────────┐
│    vim      │   shell     │
│  editing    │  commands   │
└─────────────┴─────────────┘

# Window 2: Server + Logs
# Ctrl+Space c (new window)
# Ctrl+Space , (rename to "server")
# Ctrl+Space v (split vertical)
# Start server in top pane
# Tail logs in bottom pane

┌───────────────────────────┐
│  npm run dev              │
│  (development server)     │
├───────────────────────────┤
│  tail -f logs/app.log     │
│  (application logs)       │
└───────────────────────────┘

# Window 3: Git
# Ctrl+Space c (new window)
# Ctrl+Space , (rename to "git")

# Now switch instantly:
# Ctrl+Space 1 (development)
# Ctrl+Space 2 (server/logs)
# Ctrl+Space 3 (git)
```

---

## Mouse Support

Your tmux configuration has full mouse support enabled, providing a hybrid keyboard/mouse workflow.

### What You Can Do with the Mouse

**Select Panes**:
- Click anywhere in a pane to focus it
- No need to use Ctrl+Space + Arrows

**Resize Panes**:
- Hover over a pane border until cursor changes
- Click and drag to resize
- Great for fine-tuning layouts

**Scroll Through History**:
- Use mouse wheel to scroll up/down
- Automatically enters copy mode when scrolling up
- Scrolls back to normal mode when you reach the bottom

**Select Text** (in copy mode):
- Click and drag to select text
- Selection works like in a regular terminal

### When to Use Mouse vs Keyboard

**Use Mouse for**:
- Quick pane selection when you have many panes
- Fine-grained resizing
- Casual scrolling through output
- One-off operations

**Use Keyboard for**:
- Speed and precision
- Repetitive operations
- When hands are already on keyboard
- Remote sessions (over slow SSH)

**Pro tip**: You can mix both! Select panes with mouse, then use keyboard shortcuts for everything else.

---

## Tips and Tricks

### Naming Conventions

**Sessions**: Use project or context names
```bash
tn frontend-app      # Specific project
tn work-monitoring   # Work context
tn personal-blog     # Personal project
```

**Windows**: Use descriptive names for tasks
```bash
# Ctrl+Space , then type:
editor    # Code editing
tests     # Running tests
server    # Development server
logs      # Log monitoring
git       # Git operations
docs      # Documentation
```

### Scrollback Buffer

Your config has a 100,000-line buffer - use it!

```bash
# Search through thousands of log lines
# Ctrl+Space [
# /ERROR (search for errors)
# n (jump to next match)
```

### Command Mode

Access raw tmux commands:

```bash
# Ctrl+Space :
:split-window -h    # Alternative to Ctrl+Space h
:resize-pane -L 10  # Resize left by 10 cells
:set-option -g      # Change settings on the fly
```

### Automatic Layouts

Tmux can auto-arrange panes:

```bash
# Ctrl+Space :
:select-layout even-horizontal  # All panes equal width
:select-layout even-vertical    # All panes equal height
:select-layout main-vertical    # One main, others stacked
:select-layout tiled            # Grid layout
```

### Pane Synchronization

Type in all panes simultaneously (great for managing multiple servers):

```bash
# Ctrl+Space :
:setw synchronize-panes on

# Now everything you type goes to ALL panes
# Great for running same command on multiple servers

# Turn it off:
:setw synchronize-panes off
```

### Respawn a Dead Pane

If a process crashes:

```bash
# Ctrl+Space :
:respawn-pane
```

### Reload Configuration

After editing `home/common/tmux.nix`:

```bash
# Rebuild NixOS config
sudo nixos-rebuild test --flake .#loq

# Then in tmux:
# Ctrl+Space r (reload config)
```

---

## Common Commands Reference

### Shell Commands

```bash
# Session management
t                           # Start anonymous session
tn <name>                   # Start named session
ta <name>                   # Attach to session
tl                          # List sessions
tmux kill-session -t <name> # Kill session
tmux kill-server            # Kill all sessions

# Attach with detach others
tmux attach -dt <name>      # Attach and detach other clients

# Create session in background
tmux new -s <name> -d       # Create but don't attach

# Run command in new session
tmux new -s build "npm run build"
```

### Inside Tmux Commands

All start with `Ctrl+Space`:

```bash
# Quick reference
?   # List all keybindings
:   # Command mode
t   # Show clock
```

---

## Integration with i3wm

### How They Work Together

**i3wm manages**:
- Browser windows
- IDE windows
- Terminal windows (Alacritty)
- Overall screen layout
- Workspaces across monitors

**tmux manages**:
- Terminal sessions within Alacritty
- Panes within a single terminal window
- Persistent background processes
- Remote SSH sessions

### Visual Consistency

Both use matching design:

| Feature | i3 | tmux |
|---------|----|----|
| Active indicator | Green border | Green border |
| Background | Dark (#282A2E) | Dark (#282A2E) |
| Accent color | Orange (#FACD76) | Orange (#FACD76) |
| Split horizontal | Mod4+h | Ctrl+Space h |
| Split vertical | Mod4+v | Ctrl+Space v |
| Navigate | Mod4+Arrows | Ctrl+Space Arrows |
| Resize | Mod4+Ctrl+Arrows | Ctrl+Space Ctrl+Arrows |
| Direct select | Mod4+1-9 | Ctrl+Space 1-9 |

### When to Use i3 Splits vs Tmux Panes

**Use i3 splits for**:
- Different applications (browser + terminal)
- GUI applications
- Cross-application layouts
- Permanent workspace layouts

**Use tmux panes for**:
- Multiple terminals in one window
- Editor + shell + logs
- Remote development
- Layouts that change frequently

### Recommended Combined Workflow

```
i3 Workspace 1: Development
├── [i3 window] Browser (documentation)
└── [i3 window] Alacritty
    └── [tmux session: myapp]
        ├── [tmux window 1: dev]
        │   ├── [pane] vim
        │   └── [pane] shell
        └── [tmux window 2: server]
            └── [pane] npm run dev

i3 Workspace 2: Communication
├── [i3 window] Slack
└── [i3 window] Email

i3 Workspace 3: Monitoring
└── [i3 window] Alacritty (fullscreen)
    └── [tmux session: monitor]
        ├── [pane] htop
        ├── [pane] logs
        └── [pane] network stats
```

**Switching workflow**:
- `Mod4+1/2/3`: Switch i3 workspaces (coarse-grained)
- `Ctrl+Space 1-9`: Switch tmux windows (fine-grained)
- `Ctrl+Space Arrows`: Navigate tmux panes (micro-level)

---

## Troubleshooting

### "sessions should be nested with care"

**Problem**: Trying to start tmux inside tmux.

**Solution**:
```bash
# Check if already in tmux
echo $TMUX
# If it outputs something, you're already in tmux

# Exit the current session first
# Ctrl+Space d

# Then start your new session
tn newsession
```

### "session is already attached"

**Problem**: Session is attached elsewhere (another terminal or SSH connection).

**Solutions**:
```bash
# Option 1: Force detach others and attach
tmux attach -dt mysession

# Option 2: Share the session (both attached)
tmux attach -t mysession

# Option 3: Kill other clients from inside tmux
# Ctrl+Space D (capital D - choose which client to detach)
```

### Colors Not Displaying Correctly

**Problem**: Terminal colors look wrong, especially borders.

**Solution**:
```bash
# Check TERM variable
echo $TERM
# Should show: screen-256color (inside tmux)

# If not, your Alacritty config might need:
# (This is already configured in your setup)

# Inside tmux, verify:
# Ctrl+Space :
:display-message "#{client_termname}"
```

### Copy Not Working as Expected

**Problem**: Copied text not available outside tmux.

**Explanation**: Tmux has its own internal copy buffer, separate from system clipboard.

**Workaround**:
```bash
# For now, use mouse selection
# Hold Shift while selecting with mouse
# This bypasses tmux and selects directly

# Future enhancement: Install xclip for system clipboard integration
```

### Pane Size Won't Change

**Problem**: Resizing doesn't work.

**Check**:
1. Are you holding Ctrl? (`Ctrl+Space Ctrl+Arrows`)
2. Is the pane already at minimum size?
3. Try mouse resizing - drag the border

### Lost Sessions / Can't Find Session

**Problem**: Session disappeared or can't remember name.

**Solutions**:
```bash
# List all sessions
tl
# or
tmux ls

# If no sessions listed, they were killed
# Common causes:
# - System reboot (tmux doesn't survive reboots by default)
# - Accidentally ran 'tmux kill-server'

# Attach to any session
tmux attach  # Attaches to last session
```

### Escape Key Delay in Vim

**Problem**: Pressing Escape in vim has a delay.

**Already Fixed**: Your config has `escape-time 0` which eliminates this delay.

### Prefix Key Not Working

**Problem**: Ctrl+Space doesn't do anything.

**Check**:
1. Are you actually in tmux? (Look for status bar at bottom)
2. Try the default prefix: `Ctrl+b`
3. Check if config loaded: `Ctrl+Space r` to reload

---

## Quick Reference Card

### Prefix Key
All commands start with: **`Ctrl+Space`**

### Panes
```
Ctrl+Space h          Split horizontal (left/right)
Ctrl+Space v          Split vertical (top/bottom)
Ctrl+Space Arrows     Navigate panes
Ctrl+Space Ctrl+Arrow Resize pane (repeatable)
Ctrl+Space z          Zoom pane (fullscreen toggle)
Ctrl+Space x          Kill pane
Ctrl+Space o          Cycle through panes
Ctrl+Space q          Show pane numbers
```

### Windows
```
Ctrl+Space c        Create window
Ctrl+Space 1-9      Select window by number
Ctrl+Space n        Next window
Ctrl+Space p        Previous window
Ctrl+Space l        Last window (toggle)
Ctrl+Space ,        Rename window
Ctrl+Space &        Kill window
Ctrl+Space w        List windows
```

### Sessions
```
Ctrl+Space d        Detach from session
Ctrl+Space s        List and switch sessions
Ctrl+Space D        Choose client to detach
Ctrl+Space $        Rename session
```

### Copy Mode
```
Ctrl+Space [        Enter copy mode
v                   Begin selection (in copy mode)
y                   Copy selection and exit
q                   Exit copy mode
/                   Search forward
?                   Search backward
n/N                 Next/previous search result
Ctrl+u/Ctrl+d       Page up/down
```

### Other
```
Ctrl+Space r        Reload configuration
Ctrl+Space :        Command prompt
Ctrl+Space ?        List all keybindings
Ctrl+Space t        Show clock
```

### Shell Commands
```
t                   Start tmux
tn <name>           Start named session
ta <name>           Attach to session
tl                  List sessions
```

### Cheat Sheet for i3 Users

| Task | i3 | tmux |
|------|----|----|
| Horizontal split | Mod4+h | Ctrl+Space h |
| Vertical split | Mod4+v | Ctrl+Space v |
| Navigate | Mod4+Arrows | Ctrl+Space Arrows |
| Resize | Mod4+Ctrl+Arrows | Ctrl+Space Ctrl+Arrows |
| Workspace/Window 1-9 | Mod4+1-9 | Ctrl+Space 1-9 |
| Fullscreen | Mod4+f | Ctrl+Space z |
| Kill | Mod4+Shift+q | Ctrl+Space x |

---

## Learning Path

### Day 1: Basics
1. Start a session: `tn practice`
2. Split panes: `Ctrl+Space h` and `Ctrl+Space v`
3. Navigate: `Ctrl+Space Arrows`
4. Detach: `Ctrl+Space d`
5. Reattach: `ta practice`

### Day 2: Windows
1. Create windows: `Ctrl+Space c`
2. Name them: `Ctrl+Space ,`
3. Switch with numbers: `Ctrl+Space 1-9`

### Day 3: Copy Mode
1. Enter copy mode: `Ctrl+Space [`
2. Navigate and search: `/pattern`
3. Select and copy: `v` then `y`

### Week 2: Workflows
1. Create a project session with meaningful layout
2. Practice detaching/reattaching throughout the day
3. Try managing multiple projects in separate sessions

### Week 3: Advanced
1. Mouse support integration
2. Command mode experimentation
3. Remote development workflow
4. Create your own perfect layouts

---

## Next Steps

**Practice daily**: The best way to learn tmux is to use it for your actual work.

**Start small**: Begin with just sessions and basic splits. Add windows and copy mode when you're comfortable.

**Make it yours**: Modify `home/common/tmux.nix` to adjust colors, keybindings, or behavior. Then run `sudo nixos-rebuild test --flake .#loq` and `Ctrl+Space r` to reload.

**Combine with i3**: Use both tools for their strengths. I3 for cross-application management, tmux for terminal-based workflows.

Happy multiplexing!
