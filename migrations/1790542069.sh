echo "Install Hype, the Markdown presentation app"

if [[ ! -f $HOME/.local/state/apex/preinstalls-removed ]]; then
  apex-pkg-add hype
fi
