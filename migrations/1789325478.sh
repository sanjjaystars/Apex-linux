echo "Install the Apex kernel and make it the first Limine boot entry"

# linux-apex is an x86_64 kernel. T2 Macs must keep their specialized kernel,
# including when other kernels are installed or the running T2 package is gone.
[[ $(uname -m) == "x86_64" ]] || exit 0
running_kernel=$(uname -r)
if apex-pkg-present linux-t2 || [[ ${running_kernel,,} == *-t2* ]]; then
  exit 0
fi

limine_conf="${APEX_KERNEL_LIMINE_CONF:-/etc/default/limine}"
rebuild_marker="${APEX_KERNEL_REBUILD_MARKER:-/var/lib/apex/migrations/1789325478}"
kernel="linux-apex"

# Completion is machine-wide even though migrations run once per user. Leave
# the old kernel installed so it remains available if the new one cannot boot.
# The new filename and marker also reach users who completed 1789095456.
[[ ! -e $rebuild_marker ]] || exit 0
apex-pkg-add "$kernel" "$kernel-headers"

# /etc/default/limine has priority over every drop-in, including old Dell
# settings and customized package files whose updates landed in a .pacnew.
# Set the exact kernel first: linux-apex-* only matches its older variants.
# Preserve unrelated settings, especially the root filesystem's kernel cmdline.
sudo mkdir -p "$(dirname "$limine_conf")"
sudo touch "$limine_conf"
sudo sed -i -E '/^[[:space:]]*BOOT_ORDER[[:space:]]*=/d' "$limine_conf"
printf '\n%s\n' 'BOOT_ORDER="linux-apex, linux-apex-*, *, *fallback, Snapshots"' | sudo tee -a "$limine_conf" >/dev/null

# Package hooks ran before the config repair. Rebuild the new kernel's image
# and boot entry explicitly, including on retries after a failed rebuild.
sudo limine-mkinitcpio "$kernel"

# limine-mkinitcpio can return success after skipping a failed kernel build.
# Do not mark the migration complete unless the new kernel is in the menu.
if ! sudo limine-entry-tool --tree | grep -E "(^|[^[:alnum:]_-])$kernel([^[:alnum:]_-]|$)" >/dev/null; then
  echo "The Apex kernel has no Limine boot entry; rerun apex-migrate after fixing the boot image build." >&2
  exit 1
fi

# Keeping the running kernel installed prevents the updater from detecting a
# kernel replacement, so request the reboot explicitly.
apex-state set reboot-required
sudo install -Dm644 /dev/null "$rebuild_marker"
