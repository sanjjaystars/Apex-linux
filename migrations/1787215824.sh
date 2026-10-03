echo "Install hey (hey-cli) via mise wrapper"

if [[ ! -f $HOME/.local/state/apex/preinstalls-removed ]]; then
  apex-mise-install github:basecamp/hey-cli hey
fi
