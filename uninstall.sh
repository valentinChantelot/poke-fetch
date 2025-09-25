#!/usr/bin/env bash
set -euo pipefail

echo "🗑️ Désinstallation de poke-fetch..."

if [ -f "$HOME/.local/bin/poke-fetch" ]; then
  rm -f "$HOME/.local/bin/poke-fetch"
  echo "Script supprimé de ~/.local/bin"
fi

# Supprime le bloc ajouté dans .zshrc (backup .zshrc.bak)
if [ -f "$HOME/.zshrc" ]; then
  sed -i.bak '/# lancer fastfetch avec un Pokémon aléatoire/,+3d' "$HOME/.zshrc" || true
  echo "Bloc ajouté dans ~/.zshrc supprimé (backup .zshrc.bak créé)."
fi

echo "Si tu veux supprimer pokemon-colorscripts ou fastfetch, fais-le manuellement (selon comment tu les as installés)."
echo "✨ Désinstallation terminée."
