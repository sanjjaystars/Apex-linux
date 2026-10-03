echo "Activate the Apex theme for existing T3 Code installs"

apex-pkg-present t3code-bin || exit 0
apex-install-ai-t3-code
