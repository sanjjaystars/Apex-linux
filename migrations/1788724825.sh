echo "Install Muse Code via mise wrapper"

if apex-cmd-missing muse && [[ ! -f $HOME/.local/state/apex/preinstalls-removed ]]; then
  apex-mise-install "http:muse[url=https://api.meta.ai/muse-launcher.sh,bin=muse,version_list_url=https://api.meta.ai/muse-code/channels/muse-stable,version_json_path=.version]" muse
fi
