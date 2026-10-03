echo "Relink agent skill symlinks to default/agents/skills/apex"

mkdir -p ~/.agents/skills ~/.claude/skills ~/.codex/skills ~/.pi/agent/skills
ln -sfn "$APEX_PATH/default/agents/skills/apex" ~/.agents/skills/apex
ln -sfn "$APEX_PATH/default/agents/skills/apex" ~/.claude/skills/apex
ln -sfn "$APEX_PATH/default/agents/skills/apex" ~/.codex/skills/apex
ln -sfn "$APEX_PATH/default/agents/skills/apex" ~/.pi/agent/skills/apex
