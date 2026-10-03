# Set identification from install inputs
if [[ -n ${APEX_USER_NAME//[[:space:]]/} ]]; then
  git config --global user.name "$APEX_USER_NAME"
fi

if [[ -n ${APEX_USER_EMAIL//[[:space:]]/} ]]; then
  git config --global user.email "$APEX_USER_EMAIL"
fi
