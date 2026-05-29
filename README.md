# Bash Terminal Config

My personal bash configuration — JARVIS on weekdays, F.R.I.D.A.Y. on Fridays.

Works on **Linux**, **macOS**, and **Windows** (Git Bash / WSL2).

## Platform notes

| Platform | Notes |
| --- | --- |
| Linux | Fully supported, including ble.sh autosuggestions |
| macOS | Requires bash 5 from Homebrew — macOS ships bash 3.2 |
| Windows (WSL2) | Fully supported, behaves like Linux |
| Windows (Git Bash) | Supported; ble.sh unavailable — Up/Down history search used instead |

## One-line setup

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gavvahar/bash-terminal/main/setup.sh)
```

Then reload:

```bash
source ~/.bashrc
```

---

## Step-by-step install

### 1. Prerequisites

```bash
curl -fsSL https://raw.githubusercontent.com/gavvahar/bash-terminal/main/install-prereqs.sh | bash
```

macOS only — install a modern bash and add it as your default shell:

```bash
brew install bash
echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells
chsh -s "$(brew --prefix)/bin/bash"
```

### 2. Starship, Zoxide & Fzf

```bash
curl -fsSL https://raw.githubusercontent.com/gavvahar/bash-terminal/main/install-tools.sh | bash
```

Installs:
- [Starship](https://starship.rs) — cross-shell prompt
- [Zoxide](https://github.com/ajeetdsouza/zoxide) — smarter `cd`
- [fzf](https://github.com/junegunn/fzf) — fuzzy finder (`Ctrl+R` for history, `Ctrl+T` for files)
- [ble.sh](https://github.com/akinomyoga/ble.sh) — inline autosuggestions *(Linux/macOS/WSL2 only)*

On Git Bash, ble.sh is skipped. Up/Down arrow keys provide case-insensitive prefix history search instead, and `~/.inputrc` enables case-insensitive tab completion with Tab/Shift+Tab cycling.

### 3. Miniconda (optional)

```bash
curl -fsSL https://raw.githubusercontent.com/gavvahar/bash-terminal/main/install-conda.sh | bash
```

Skips automatically if conda is already installed. On Windows, detects system-wide installs under `C:\ProgramData\miniconda3` in addition to the default user path.

### 4. Bitwarden SSH Agent (optional)

Enable the SSH agent in Bitwarden desktop app settings. The config picks it up automatically if `~/.bitwarden-ssh-agent.sock` exists.

### 5. Install config

```bash
curl -fsSL https://raw.githubusercontent.com/gavvahar/bash-terminal/main/install.sh | bash
```

Symlinks `~/.bashrc` and `~/.inputrc` to the cloned config. Falls back to copy if symlinks are unavailable (some Windows setups require Developer Mode for symlinks).

Then reload:

```bash
source ~/.bashrc
```

## Manual install

```bash
git clone https://github.com/gavvahar/bash-terminal.git ~/.config/bash-terminal
ln -sf ~/.config/bash-terminal/.bashrc ~/.bashrc
ln -sf ~/.config/bash-terminal/inputrc ~/.inputrc
# macOS only:
echo '[ -f ~/.bashrc ] && source ~/.bashrc' >> ~/.bash_profile
source ~/.bashrc
```

## Commands

| Command | Description |
| --- | --- |
| `jarvis` | System diagnostics panel |
| `brief` | Morning briefing with weather |
| `jarvis-locate add "City, State"` | Add a weather location |
| `jarvis-locate remove "City, State"` | Remove a location |
| `jarvis-locate` | List saved locations |
| `jarvis-locate clear` | Clear all, fall back to IP detection |

## Keyboard shortcuts

| Key | Action |
| --- | --- |
| `Up` / `Down` | Case-insensitive prefix history search (cycles through matches) |
| `Ctrl+R` | fzf fuzzy history search |
| `Ctrl+T` | fzf file search |
| `Tab` / `Shift+Tab` | Cycle through tab completions |

## Update

```bash
cd ~/.config/bash-terminal && git pull
source ~/.bashrc
```
