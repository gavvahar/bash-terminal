# Bash Terminal Config

My personal bash configuration — JARVIS on weekdays, F.R.I.D.A.Y. on Fridays.

## Dependencies

### Prerequisites

```bash
curl -fsSL https://raw.githubusercontent.com/gavvahar/bash-terminal/main/install-prereqs.sh | bash
```

### Starship, Zoxide & Fzf

```bash
curl -fsSL https://raw.githubusercontent.com/gavvahar/bash-terminal/main/install-tools.sh | bash
```

### Miniconda (optional)

```bash
curl -fsSL https://raw.githubusercontent.com/gavvahar/bash-terminal/main/install-conda.sh | bash
```

### Bitwarden SSH Agent (optional)

Enable the SSH agent in Bitwarden desktop app settings.

## Install

Once dependencies are installed:

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
