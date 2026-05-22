#!/bin/bash

set -e

CONDA="$HOME/miniconda3/bin/conda"

if command -v conda &>/dev/null || [[ -x "$CONDA" ]]; then
    echo "✅ Conda already installed"
else
    echo "Installing Miniconda..."
    case "$(uname -s)-$(uname -m)" in
        Darwin-arm64)
            curl -fsSL -o /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh ;;
        Darwin-*)
            curl -fsSL -o /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "On Windows, download and run the Miniconda installer from:"
            echo "  https://docs.conda.io/en/latest/miniconda.html"
            exit 0 ;;
        *)
            curl -fsSL -o /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh ;;
    esac
    bash /tmp/miniconda.sh -b -p "$HOME/miniconda3"
    rm /tmp/miniconda.sh
    echo "✅ Miniconda installed"
fi

if ! grep -q "conda initialize" "$HOME/.bashrc" 2>/dev/null; then
    echo "Initializing conda for bash..."
    "$CONDA" init bash
    echo "✅ Conda initialized"
else
    echo "✅ Conda already initialized for bash"
fi

if "$CONDA" config --show auto_activate_base 2>/dev/null | grep -q "True"; then
    "$CONDA" config --set auto_activate_base false
    "$CONDA" config --set changeps1 false
    echo "✅ Auto-activate base disabled"
else
    echo "✅ Auto-activate base already off"
fi

echo ""
echo "Restart your shell or run: source ~/.bashrc"
