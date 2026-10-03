echo "Install oh-my-pi (omp) via mise wrapper"

if [[ ! -f $HOME/.local/state/apex/preinstalls-removed ]]; then
  apex-mise-install github:can1357/oh-my-pi omp
fi
