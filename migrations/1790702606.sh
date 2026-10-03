echo "Link the apex-app agent skill for building apps"

# apex-provision-user links every skill, but only once per user, so
# existing installs get the new one here, in the same places. A skill of the
# user's own by that name is left where it is.
skill="$APEX_PATH/default/agents/skills/apex-app"

link_skill() {
  mkdir -p "$1"
  if [[ -e $1/apex-app && ! -L $1/apex-app ]]; then
    echo "Leaving your own $1/apex-app in place"
  else
    ln -sfn "$skill" "$1/apex-app"
  fi
}

if [[ -d $skill ]]; then
  for skills_dir in ~/.agents/skills ~/.claude/skills ~/.codex/skills ~/.pi/agent/skills ~/.gemini/config/skills ~/.hermes/skills; do
    link_skill "$skills_dir"
  done

  if [[ -d ~/.hermes/profiles ]]; then
    for profile in ~/.hermes/profiles/*/; do
      [[ -d $profile ]] || continue
      link_skill "$profile/skills"
    done
  fi
fi
