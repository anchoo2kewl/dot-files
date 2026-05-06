# dot-files

Personal dotfiles: zsh, Starship, Tmux, Vim/Neovim, Alacritty.

## Setup

```bash
git clone https://github.com/anchoo2kewl/dot-files ~/projects/dot-files
~/projects/dot-files/init.sh
```

`init.sh` installs CLI tools (via Homebrew on macOS, package manager on Linux) and symlinks `.zshrc`, `starship.toml`, `.tmux.conf`, `alacritty.toml`, `init.vim`, `.aliasrc`, `.vimrc` into the right places.

---

## AI profiles (work / personal)

Three shell contexts, all running as the same macOS user:

| Profile    | Enter with | Starship badge          | State root                |
|------------|------------|-------------------------|---------------------------|
| `default`  | (default)  | none                    | `~/` (untouched)          |
| `work`     | `work`     | white on **red**        | `~/.profiles/work/`       |
| `personal` | `personal` | white on **blue**       | `~/.profiles/personal/`   |

Each profile is a child `zsh` that pins these env vars at the per-profile root so Claude / Codex / Gemini read and write isolated state:

| CLI    | Env var             | Per-profile path                          |
|--------|---------------------|-------------------------------------------|
| Claude | `CLAUDE_CONFIG_DIR` | `~/.profiles/<name>/.claude`              |
| Codex  | `CODEX_HOME`        | `~/.profiles/<name>/.codex`               |
| Gemini | `GEMINI_CLI_HOME`   | `~/.profiles/<name>` (Gemini reads `$GEMINI_CLI_HOME/.gemini`) |

`exit` returns to the default shell. Profiles do not nest — entering one always unsets the other badge variable.

### First-time setup per profile

```bash
work
claude         # /login with your work account (e.g. abiswas@elastio.com)
codex login    # log in to Codex with the work account
gemini         # log in to Gemini with the work account
exit
```

Repeat with `personal` for your personal accounts.

### `whoami-ai`

Shows the active profile and which account is logged in to each CLI in the **current** shell:

```
$ whoami-ai
profile    default     root: /Users/you
claude     you@work.com               /Users/you/.claude
codex      you@work.com (chatgpt)     /Users/you/.codex
gemini     you@personal.com           /Users/you/.gemini
```

### Caveats

- **Claude OAuth token lives in the macOS Keychain** (one slot, machine-wide). `CLAUDE_CONFIG_DIR` only isolates `~/.claude/` state — to actually swap the active token you must run `/logout` then `/login` inside Claude after switching profiles. `whoami-ai` reports the email cached in each profile's `.claude.json`, which can lag behind the keychain until next login.
- Codex and Gemini store their tokens inside their respective config dirs, so they isolate cleanly with no extra steps.
- The default shell is untouched: no env vars, no badge — the system is fully opt-in.

### How it's wired

- `.zshrc` defines `_ai_profile_enter`, `work`, and `personal`.
- `starship.toml` adds `${env_var.TAI_WORK}` and `${env_var.TAI_PERSONAL}` to the format string and two `[env_var.*]` modules that render only when the matching variable is set.
- `bin/whoami-ai` parses each CLI's config (`.claude.json`, Codex `auth.json` id_token JWT, Gemini `google_accounts.json`).
