echo "Install cf (Cloudflare CLI) via mise wrapper"

if [[ ! -f $HOME/.local/state/apex/preinstalls-removed ]]; then
  apex-mise-install npm:cf cf
fi
