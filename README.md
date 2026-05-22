# Bash Terminal Config

My personal bash configuration — JARVIS on weekdays, F.R.I.D.A.Y. on Fridays.

Works on **Linux**, **macOS**, and **Windows** (Git Bash / WSL2).

## Platform notes

| Platform | Notes |
| --- | --- |
| Linux | Fully supported |
| macOS | Requires bash 5 from Homebrew — macOS ships bash 3.2 |
| Windows (WSL2) | Fully supported, behaves like Linux |
| Windows (Git Bash) | Supported; memory/CPU stats may be limited |

## Quick install

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

### 3. Miniconda (optional)

```bash
curl -fsSL https://raw.githubusercontent.com/gavvahar/bash-terminal/main/install-conda.sh | bash
```

### 4. Bitwarden SSH Agent (optional)

Enable the SSH agent in Bitwarden desktop app settings.

### 5. Install config

```bash
curl -fsSL https://raw.githubusercontent.com/gavvahar/bash-terminal/main/install.sh | bash
```

Then reload:

```bash
source ~/.bashrc
```

## Manual install

```bash
git clone https://github.com/gavvahar/bash-terminal.git ~/.config/bash-terminal
ln -sf ~/.config/bash-terminal/.bashrc ~/.bashrc
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

## Update

```bash
cd ~/.config/bash-terminal && git pull
source ~/.bashrc
```
