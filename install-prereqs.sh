#!/bin/bash

set -e

echo "Installing prerequisites..."
sudo apt update
sudo apt install -y unzip curl git python3 fontconfig libatomic1
echo "✅ Prerequisites installed"
