#!/bin/bash
# install_fq_codel.sh
# This script sets up a systemd service to automatically apply fq_codel
# to the eth0 interface on boot. Requires root.

INTERFACE="eth0"
SET_SCRIPT="/usr/local/bin/set_fq_codel.sh"
SERVICE_FILE="/etc/systemd/system/fq_codel.service"

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

echo "Creating helper script to configure fq_codel on ${INTERFACE}..."
cat << 'EOF' > "$SET_SCRIPT"
#!/bin/bash
# Remove existing qdisc (if any) and apply fq_codel on eth0
tc qdisc del dev eth0 root 2>/dev/null
tc qdisc add dev eth0 root fq_codel
EOF

chmod +x "$SET_SCRIPT"

echo "Creating systemd service to auto-apply fq_codel on boot..."
cat << EOF > "$SERVICE_FILE"
[Unit]
Description=Set fq_codel on ${INTERFACE}
After=network.target

[Service]
Type=oneshot
ExecStart=${SET_SCRIPT}
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF

echo "Reloading systemd and enabling fq_codel service..."
systemctl daemon-reload
systemctl enable fq_codel.service
systemctl start fq_codel.service

echo "Done! fq_codel has been applied to ${INTERFACE} and will persist across reboots."
