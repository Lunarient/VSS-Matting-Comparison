#!/bin/bash
# Create and install per-model virtual environments using Python 3.8 from pyenv if available

set -e

# Determine which Python to use
if command -v pyenv >/dev/null 2>&1; then
  if pyenv versions --bare | grep -q '^3\.8'; then
    PYTHON_BIN="$(pyenv root)/versions/$(pyenv versions --bare | grep '^3\.8' | head -n 1)/bin/python"
    echo "🐍 Using Python from pyenv: $PYTHON_BIN"
  else
    echo "⚠️  pyenv found, but no Python 3.8 version installed. Falling back to system python3.8."
    PYTHON_BIN="$(command -v python3.8 || command -v python3)"
  fi
else
  echo "⚠️  pyenv not found. Using system Python."
  PYTHON_BIN="$(command -v python3.8 || command -v python3)"
fi

# Check Python availability
if [ -z "$PYTHON_BIN" ]; then
  echo "❌ No suitable Python interpreter found. Please install Python 3.8 or pyenv with 3.8."
  exit 1
fi

# Loop through each model directory and set up a venv
for model_dir in Models/*; do
  if [ -d "$model_dir" ]; then
    echo "🔧 Setting up $(basename "$model_dir")..."
    "$PYTHON_BIN" -m venv "$model_dir/venv"
    source "$model_dir/venv/bin/activate"

    if [ -f "$model_dir/requirements.txt" ]; then
      echo "📦 Installing requirements for $(basename "$model_dir")..."
      pip install --upgrade pip
      pip install -r "$model_dir/requirements.txt"
    else
      echo "⚠️  No requirements.txt found in $model_dir"
    fi

    deactivate
  fi
done

echo "✅ All model environments created successfully!"
