if true; then
  cat <<-EOF | sudo tee /etc/apex/indented.conf >/dev/null
	helper=$HOME/.local/share/apex/bin/apex-agent
	EOF
fi
