echo "Install missing headers for the Apex or T2 kernel"

# Fresh ISO installs mark earlier migrations complete, so the kernel migration
# cannot repair headers omitted by those installers. Package installation is
# idempotent when another user has already applied this repair.
for kernel in linux-apex linux-t2; do
  if apex-pkg-present "$kernel"; then
    apex-pkg-add "$kernel-headers"
  fi
done
