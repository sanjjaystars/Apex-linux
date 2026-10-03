echo "Install basecamp (basecamp-cli) via mise wrapper"

if [[ ! -f $HOME/.local/state/apex/preinstalls-removed ]]; then
  apex-mise-install github:basecamp/basecamp-cli basecamp
fi
