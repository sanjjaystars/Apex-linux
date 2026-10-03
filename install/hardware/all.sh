run_logged "$APEX_INSTALL/hardware/asus-rog.sh" "ASUS ROG Hardware"
run_logged "$APEX_INSTALL/hardware/framework16.sh" "Framework 16 Hardware"
run_logged "$APEX_INSTALL/hardware/dell-xps-touchpad-haptics.sh" "Dell XPS Touchpad Haptics"
run_logged "$APEX_INSTALL/hardware/surface.sh" "Microsoft Surface Hardware"

run_logged "$APEX_INSTALL/hardware/network.sh" "Network Hardware"
run_logged "$APEX_INSTALL/hardware/set-wireless-regdom.sh" "Wireless Regulatory Domain"
run_logged "$APEX_INSTALL/hardware/fix-fkeys.sh" "F-Keys Configuration"
run_logged "$APEX_INSTALL/hardware/fix-synaptic-touchpad.sh" "Synaptics Touchpad Fix"
run_logged "$APEX_INSTALL/hardware/bluetooth.sh" "Bluetooth Setup"
run_logged "$APEX_INSTALL/hardware/nvidia.sh" "NVIDIA Graphics"
run_logged "$APEX_INSTALL/hardware/vulkan.sh" "Vulkan Support"

run_logged "$APEX_INSTALL/hardware/intel/video-acceleration.sh" "Intel Video Acceleration"
run_logged "$APEX_INSTALL/hardware/intel/lpmd.sh" "Intel LPMD Setup"
run_logged "$APEX_INSTALL/hardware/intel/thermald.sh" "Intel Thermald Setup"
run_logged "$APEX_INSTALL/hardware/intel/ipu7-camera.sh" "Intel IPU7 Camera"
run_logged "$APEX_INSTALL/hardware/intel/fred.sh" "Intel FRED Setup"
run_logged "$APEX_INSTALL/hardware/intel/fix-wifi7-eht.sh" "Intel Wi-Fi 7 EHT Fix"
run_logged "$APEX_INSTALL/hardware/intel/sof-firmware.sh" "Intel SOF Firmware"

run_logged "$APEX_INSTALL/hardware/fix-elgato-camlink-4k.sh" "Elgato Cam Link 4K Fix"

# Rebuilds the boot image, so it follows camera module setup.
run_logged "$APEX_INSTALL/hardware/dell-xps13-sidecar-amps.sh" "Dell XPS 13 Sidecar Amps"

run_logged "$APEX_INSTALL/hardware/asus/fix-asus-ptl-display-backlight.sh" "ASUS PTL Display Backlight"
run_logged "$APEX_INSTALL/hardware/asus/fix-asus-ptl-b9406-display.sh" "ASUS PTL B9406 Display"
run_logged "$APEX_INSTALL/hardware/asus/fix-asus-ptl-b9406-touchpad.sh" "ASUS PTL B9406 Touchpad"
run_logged "$APEX_INSTALL/hardware/asus/fix-z13-touchpad.sh" "ASUS Z13 Touchpad"

run_logged "$APEX_INSTALL/hardware/framework/qmk-hid.sh" "Framework QMK HID"

run_logged "$APEX_INSTALL/hardware/apple/fix-spi-keyboard.sh" "Apple SPI Keyboard Fix"
run_logged "$APEX_INSTALL/hardware/apple/fix-suspend-nvme.sh" "Apple NVMe Suspend Fix"
run_logged "$APEX_INSTALL/hardware/apple/fix-t2.sh" "Apple T2 Security Chip Fix"
run_logged "$APEX_INSTALL/hardware/apple/fix-brcmfmac-supplicant.sh" "Apple Broadcom Wi-Fi Supplicant"

run_logged "$APEX_INSTALL/hardware/lenovo/fix-yoga-pro7-bass-speakers.sh" "Lenovo Yoga Pro 7 Speakers"

run_logged "$APEX_INSTALL/hardware/fix-bcm43xx.sh" "Broadcom BCM43xx Fix"
run_logged "$APEX_INSTALL/hardware/fix-surface-keyboard.sh" "Surface Keyboard Fix"
run_logged "$APEX_INSTALL/hardware/fix-yt6801-ethernet-adapter.sh" "YT6801 Ethernet Adapter Fix"
run_logged "$APEX_INSTALL/hardware/fix-tuxedo-backlight.sh" "Tuxedo Backlight Fix"
run_logged "$APEX_INSTALL/hardware/speaker-tuning.sh" "Speaker Tuning Setup"
run_logged "$APEX_INSTALL/hardware/pacman.sh" "Hardware Pacman Tweaks"
