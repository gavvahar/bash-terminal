# ~/.bashrc

# ── Only run in interactive shells ────────────────────────────────────────────
case $- in
    *i*) ;;
      *) return;;
esac

# ── Config directory (where this repo is installed) ───────────────────────────
_BASH_TERMINAL_DIR="$HOME/.config/bash-terminal"

# ── History ───────────────────────────────────────────────────────────────────
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000

shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ── PATH ──────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
# Add fzf to PATH only if not already present
[[ ":$PATH:" != *":$HOME/.fzf/bin:"* ]] && [ -d "$HOME/.fzf/bin" ] && export PATH="$HOME/.fzf/bin:$PATH"

# ── AI theme — FRIDAY on Fridays, JARVIS all other days ──────────────────────
if [ "$(date +%u)" -eq 5 ]; then
    export JARVIS_MODE="FRIDAY"
    export STARSHIP_CONFIG="$_BASH_TERMINAL_DIR/starship-friday.toml"
    _AI_BOLD=$'\e[1;38;2;192;132;252m'
    _AI_NORM=$'\e[38;2;192;132;252m'
else
    export JARVIS_MODE="JARVIS"
    export STARSHIP_CONFIG="$_BASH_TERMINAL_DIR/starship.toml"
    _AI_BOLD=$'\e[1;36m'
    _AI_NORM=$'\e[36m'
fi
_AI_RESET=$'\e[0m'

# ── Color support for ls / grep ───────────────────────────────────────────────
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# ── Git aliases ───────────────────────────────────────────────────────────────
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'

# ── Bitwarden SSH agent (optional) ───────────────────────────────────────────
if [ -S "$HOME/.bitwarden-ssh-agent.sock" ]; then
    export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
fi

# ── Bash completion ───────────────────────────────────────────────────────────
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ── fzf ───────────────────────────────────────────────────────────────────────
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# ── Starship prompt ───────────────────────────────────────────────────────────
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

# ── Terminal title ────────────────────────────────────────────────────────────
_jarvis_set_title() {
    if [ "$JARVIS_MODE" = "FRIDAY" ]; then
        printf '\033]0;F.R.I.D.A.Y. — %s\007' "$(basename "$PWD")"
    else
        printf '\033]0;J.A.R.V.I.S. — %s\007' "$(basename "$PWD")"
    fi
}
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }_jarvis_set_title"

# ── Zoxide ────────────────────────────────────────────────────────────────────
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
fi

# ── Greeting ──────────────────────────────────────────────────────────────────
_jarvis_greeting() {
    local hour period datetime uptime_str mem_info cpu_load
    hour=$(date +%H)
    if   [ "$hour" -lt 12 ]; then period="morning"
    elif [ "$hour" -lt 17 ]; then period="afternoon"
    else                           period="evening"
    fi
    datetime=$(date "+%A, %B %d %Y — %I:%M %p")
    uptime_str=$(uptime -p 2>/dev/null | sed 's/^up //')
    mem_info=$(free -h 2>/dev/null | awk '/^Mem:/ {print $3 "/" $2}')
    cpu_load=$(awk '{print $1}' /proc/loadavg 2>/dev/null)

    local interior=60
    local sep hdr hdr_len hdr_fill
    sep=$(python3 -c "print('═' * $interior, end='')")

    local b="$_AI_BOLD" n="$_AI_NORM" r="$_AI_RESET"

    if [ "$JARVIS_MODE" = "FRIDAY" ]; then
        local msgs=("All systems green." "Ready when you are." "Standing by."
                    "Online and operational." "Good to go." "At your service." "Systems clear.")
        local status_msg="${msgs[$RANDOM % ${#msgs[@]}]}"
        hdr="══[ F.R.I.D.A.Y. ]"
        hdr_len=$(python3 -c "print(len('$hdr'))")
        hdr_fill=$(python3 -c "print('═' * ($interior - $hdr_len), end='')")

        printf "${b}\n  ╔%s%s╗\n" "$hdr" "$hdr_fill"
        printf "  ║${r}${n}%-${interior}s${b}║\n" "  Female Replacement Intelligent Digital Asst."
        printf "  ╠%s╣\n${r}${n}" "$sep"
        printf "  ║%-${interior}s${b}║\n${r}${n}" "  Hey, $(whoami). Good $period."
        printf "  ║%-${interior}s${b}║\n${r}${n}" "  $datetime"
        [ -n "$uptime_str" ] && printf "  ║%-${interior}s${b}║\n${r}${n}" "  Uptime: $uptime_str"
        [ -n "$mem_info" ]   && printf "  ║%-${interior}s${b}║\n" "  Memory: $mem_info   CPU: $cpu_load"
        printf "${b}  ╠%s╣\n" "$sep"
        printf "  ║${r}${n}%-${interior}s${b}║\n" "  ◈ $status_msg"
        printf "  ╚%s╝${r}\n\n" "$sep"
    else
        local msgs=("All systems operational." "Running at peak efficiency."
                    "No anomalies detected." "Diagnostics complete. All clear."
                    "Systems nominal. Standing by.")
        local status_msg="${msgs[$RANDOM % ${#msgs[@]}]}"
        hdr="══[ J.A.R.V.I.S. ]"
        hdr_len=$(python3 -c "print(len('$hdr'))")
        hdr_fill=$(python3 -c "print('═' * ($interior - $hdr_len), end='')")

        printf "${b}\n  ╔%s%s╗\n" "$hdr" "$hdr_fill"
        printf "  ║${r}${n}%-${interior}s${b}║\n" "  Just A Rather Very Intelligent System"
        printf "  ╠%s╣\n${r}${n}" "$sep"
        printf "  ║%-${interior}s${b}║\n${r}${n}" "  Good $period, $(whoami)."
        printf "  ║%-${interior}s${b}║\n${r}${n}" "  $datetime"
        [ -n "$uptime_str" ] && printf "  ║%-${interior}s${b}║\n${r}${n}" "  Uptime: $uptime_str"
        [ -n "$mem_info" ]   && printf "  ║%-${interior}s${b}║\n" "  Memory: $mem_info   CPU: $cpu_load"
        printf "${b}  ╠%s╣\n" "$sep"
        printf "  ║${r}${n}%-${interior}s${b}║\n" "  ◈ $status_msg"
        printf "  ╚%s╝${r}\n\n" "$sep"
    fi
}
_jarvis_greeting

# ── jarvis: system diagnostics ────────────────────────────────────────────────
jarvis() {
    local mem_info cpu_load disk_root ip_addr uptime_str
    mem_info=$(free -h 2>/dev/null | awk '/^Mem:/ {print $3 "/" $2}')
    cpu_load=$(awk '{print $1 "  " $2 "  " $3}' /proc/loadavg 2>/dev/null)
    disk_root=$(df -h / 2>/dev/null | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')
    ip_addr=$(ip route get 1 2>/dev/null | awk 'NR==1 {for(i=1;i<=NF;i++) if($i=="src"){print $(i+1); exit}}')
    uptime_str=$(uptime -p 2>/dev/null | sed 's/^up //')

    local interior=54
    local sep hdr hdr_len hdr_fill
    sep=$(python3 -c "print('═' * $interior, end='')")
    hdr="══[ J.A.R.V.I.S. DIAGNOSTICS ]"
    hdr_len=$(python3 -c "print(len('$hdr'))")
    hdr_fill=$(python3 -c "print('═' * ($interior - $hdr_len), end='')")

    local b="$_AI_BOLD" n="$_AI_NORM" r="$_AI_RESET"

    printf "${b}\n  ╔%s%s╗\n${r}${n}" "$hdr" "$hdr_fill"
    [ -n "$uptime_str" ] && printf "  ║%-${interior}s${b}║${r}${n}\n" "  Uptime:   $uptime_str"
    [ -n "$mem_info" ]   && printf "  ║%-${interior}s${b}║${r}${n}\n" "  Memory:   $mem_info"
    [ -n "$cpu_load" ]   && printf "  ║%-${interior}s${b}║${r}${n}\n" "  CPU Load: $cpu_load  (1m 5m 15m)"
    [ -n "$disk_root" ]  && printf "  ║%-${interior}s${b}║${r}${n}\n" "  Disk /:   $disk_root"
    [ -n "$ip_addr" ]    && printf "  ║%-${interior}s${b}║${r}${n}\n" "  Network:  $ip_addr"
    if [ -n "$CONDA_DEFAULT_ENV" ] && [ "$CONDA_DEFAULT_ENV" != "base" ]; then
        printf "  ║%-${interior}s${b}║${r}${n}\n" "  Conda:    $CONDA_DEFAULT_ENV"
    fi
    printf "${b}  ╚%s╝${r}\n\n" "$sep"
}

# ── brief: morning briefing with weather ─────────────────────────────────────
brief() {
    local hour period datetime uptime_str mem_info cpu_load disk_root ip_addr
    hour=$(date +%H)
    if   [ "$hour" -lt 12 ]; then period="morning"
    elif [ "$hour" -lt 17 ]; then period="afternoon"
    else                           period="evening"
    fi
    datetime=$(date "+%A, %B %d %Y — %I:%M %p")
    uptime_str=$(uptime -p 2>/dev/null | sed 's/^up //')
    mem_info=$(free -h 2>/dev/null | awk '/^Mem:/ {print $3 "/" $2}')
    cpu_load=$(awk '{print $1}' /proc/loadavg 2>/dev/null)
    disk_root=$(df -h / 2>/dev/null | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')
    ip_addr=$(ip route get 1 2>/dev/null | awk 'NR==1 {for(i=1;i<=NF;i++) if($i=="src"){print $(i+1); exit}}')

    local weather_lines=()
    local loc_file="$HOME/.config/bash/jarvis_locations"
    if command -v python3 &>/dev/null && [ -f "$_BASH_TERMINAL_DIR/get_weather.py" ]; then
        if [ -f "$loc_file" ] && [ -s "$loc_file" ]; then
            while IFS= read -r loc; do
                [ -z "$loc" ] && continue
                local w
                w=$(python3 "$_BASH_TERMINAL_DIR/get_weather.py" "$loc" 2>/dev/null)
                [ -n "$w" ] && weather_lines+=("$w")
            done < "$loc_file"
        else
            local w
            w=$(python3 "$_BASH_TERMINAL_DIR/get_weather.py" 2>/dev/null)
            [ -n "$w" ] && weather_lines+=("$w")
        fi
    fi

    local interior=60
    local sep hdr hdr_len hdr_fill
    sep=$(python3 -c "print('═' * $interior, end='')")
    if [ "$JARVIS_MODE" = "FRIDAY" ]; then
        hdr="══[ F.R.I.D.A.Y. BRIEF ]"
    else
        hdr="══[ J.A.R.V.I.S. BRIEF ]"
    fi
    hdr_len=$(python3 -c "print(len('$hdr'))")
    hdr_fill=$(python3 -c "print('═' * ($interior - $hdr_len), end='')")

    local b="$_AI_BOLD" n="$_AI_NORM" r="$_AI_RESET"

    printf "${b}\n  ╔%s%s╗\n${r}${n}" "$hdr" "$hdr_fill"
    printf "  ║%-${interior}s${b}║\n${r}${n}" "  Good $period. Here is your briefing."
    printf "  ║%-${interior}s${b}║\n${r}${n}" "  $datetime"

    if [ "${#weather_lines[@]}" -gt 0 ]; then
        printf "  ║%-${interior}s${b}║\n${r}${n}" ""
        printf "  ║%-${interior}s${b}║\n${r}${n}" "  Weather:"
        for w in "${weather_lines[@]}"; do
            local wloc wtime wcond
            wloc=$(echo "$w" | awk -F':::' '{printf "%-17.17s", $1}')
            wtime=$(echo "$w" | awk -F':::' '{print $2}')
            wcond=$(echo "$w" | awk -F':::' '{print $3}')
            printf "  ║%-${interior}s${b}║\n${r}${n}" "    $wloc  $wtime  $wcond"
        done
    fi

    printf "${b}  ╠%s╣\n${r}${n}" "$sep"
    printf "  ║%-${interior}s${b}║\n${r}${n}" "  Uptime:   $uptime_str"
    printf "  ║%-${interior}s${b}║\n${r}${n}" "  Memory:   $mem_info"
    printf "  ║%-${interior}s${b}║\n${r}${n}" "  CPU:      $cpu_load"
    printf "  ║%-${interior}s${b}║\n${r}${n}" "  Disk /:   $disk_root"
    [ -n "$ip_addr" ] && printf "  ║%-${interior}s${b}║\n${r}${n}" "  Network:  $ip_addr"
    printf "${b}  ╚%s╝${r}\n\n" "$sep"
}

# ── jarvis-locate: manage weather locations ───────────────────────────────────
_JARVIS_LOC_FILE="$HOME/.config/bash/jarvis_locations"

jarvis-locate() {
    local sub="${1:-list}"

    case "$sub" in
        list|"")
            if [ ! -f "$_JARVIS_LOC_FILE" ] || [ ! -s "$_JARVIS_LOC_FILE" ]; then
                printf "${_AI_NORM}  ◈ ${_AI_RESET}No locations set — using IP detection.\n"
            else
                printf "${_AI_BOLD}  Monitored locations:${_AI_RESET}\n"
                local i=1
                while IFS= read -r loc; do
                    [ -z "$loc" ] && continue
                    printf "${_AI_NORM}  %s. ${_AI_RESET}%s\n" "$i" "$loc"
                    ((i++))
                done < "$_JARVIS_LOC_FILE"
            fi
            ;;
        add)
            local loc="${*:2}"
            if [ -z "$loc" ]; then
                echo 'Usage: jarvis-locate add "City, State"'
                return 1
            fi
            mkdir -p "$(dirname "$_JARVIS_LOC_FILE")"
            echo "$loc" >> "$_JARVIS_LOC_FILE"
            printf "${_AI_NORM}  ◈ ${_AI_RESET}Added: %s\n" "$loc"
            ;;
        remove)
            local loc="${*:2}"
            if [ -f "$_JARVIS_LOC_FILE" ]; then
                local tmp
                tmp=$(grep -vxF "$loc" "$_JARVIS_LOC_FILE")
                printf '%s\n' "$tmp" > "$_JARVIS_LOC_FILE"
            fi
            printf "${_AI_NORM}  ◈ ${_AI_RESET}Removed: %s\n" "$loc"
            ;;
        clear)
            > "$_JARVIS_LOC_FILE"
            printf "${_AI_NORM}  ◈ ${_AI_RESET}All locations cleared. Falling back to IP detection.\n"
            ;;
        *)
            echo "Usage:"
            echo "  jarvis-locate                       — show monitored locations"
            echo '  jarvis-locate add "City, State"     — add a location'
            echo '  jarvis-locate remove "City, State"  — remove a location'
            echo "  jarvis-locate clear                 — clear all locations"
            ;;
    esac
}

# ── conda initialize (optional) ───────────────────────────────────────────────
_CONDA_BIN="$HOME/miniconda3/bin/conda"
if command -v conda &>/dev/null || [ -x "$_CONDA_BIN" ]; then
    __conda_setup="$("$_CONDA_BIN" 'shell.bash' 'hook' 2>/dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    elif [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
    unset __conda_setup
fi
unset _CONDA_BIN
