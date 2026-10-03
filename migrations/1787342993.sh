echo "Install ori (OpenRouter's agent harness) via mise wrapper"

if [[ ! -f $HOME/.local/state/apex/preinstalls-removed ]]; then
  apex-mise-install github:OpenRouterLabs/ori-releases ori
fi
