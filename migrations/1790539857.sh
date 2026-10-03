echo "Install Monologue, the webcam recorder"

if [[ ! -f $HOME/.local/state/apex/preinstalls-removed ]]; then
  apex-pkg-add monologue
fi
