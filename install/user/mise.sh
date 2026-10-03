# Upgrades must not delete the version a running process is executing from:
# mise up would prune the old install dir out from under a live session.
mise settings set upgrade.auto_prune false

apex-mise-install codex
apex-mise-install claude
apex-mise-install crush
apex-mise-install antigravity-cli agy
apex-mise-install gh
apex-mise-install copilot
apex-mise-install opencode
apex-mise-install npm:playwright playwright
apex-mise-install pi
apex-mise-install github:can1357/oh-my-pi omp
apex-mise-install grok
# Cursor's own installer links the same path, so a re-provision keeps it.
apex-cmd-missing cursor-agent && apex-mise-install cursor-agent
apex-mise-install npm:@kitlangton/ghui ghui
apex-mise-install aqua:modem-dev/hunk hunk
apex-mise-install github:basecamp/hey-cli hey
apex-mise-install github:basecamp/basecamp-cli basecamp
apex-mise-install npm:cf cf
apex-mise-install github:OpenRouterLabs/ori-releases ori
if apex-cmd-missing muse; then
  apex-mise-install "http:muse[url=https://api.meta.ai/muse-launcher.sh,bin=muse,version_list_url=https://api.meta.ai/muse-code/channels/muse-stable,version_json_path=.version]" muse
fi
