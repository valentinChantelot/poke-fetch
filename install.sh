#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Installation de poke-fetch..."

# Installer fastfetch si absent (utilise yay si présent)
if ! command -v fastfetch >/dev/null 2>&1; then
  if command -v yay >/dev/null 2>&1; then
    echo "Installation de fastfetch via yay..."
    yay -S --noconfirm --needed fastfetch
  else
    echo "Warning: fastfetch absent et 'yay' introuvable. Installe fastfetch manuellement." >&2
  fi
fi

# Installer pokemon-colorscripts si absent (depuis le repo GitLab)
if ! command -v pokemon-colorscripts >/dev/null 2>&1; then
  echo "Installation de pokemon-colorscripts depuis GitLab..."
  tmpd=$(mktemp -d)
  git clone https://gitlab.com/phoneybadger/pokemon-colorscripts.git "$tmpd/pokemon-colorscripts"
  cd "$tmpd/pokemon-colorscripts"
  sudo ./install.sh || { echo "L'installation automatique a échoué. Installe manuellement."; exit 1; }
  cd -
  rm -rf "$tmpd"
fi

# Installer le script dans ~/.local/bin (pas besoin de sudo)
mkdir -p "$HOME/.local/bin"
cp poke-fetch "$HOME/.local/bin/poke-fetch"
chmod +x "$HOME/.local/bin/poke-fetch"
echo "Script installé dans ~/.local/bin/poke-fetch"

# Ajouter un snippet dans ~/.zshrc si pas déjà présent
if ! grep -Fq 'poke-fetch' "$HOME/.zshrc" 2>/dev/null; then
  cat >> "$HOME/.zshrc" <<'EOF'

# lancer fastfetch avec un Pokémon aléatoire
if [[ $- == *i* ]]; then
  poke-fetch
fi
EOF
  echo "Snippet ajouté à ~/.zshrc (ouvre un nouveau terminal pour tester)."
fi

echo "✅ Installation terminée."
