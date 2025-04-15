# FQ_Codel Autorun

This repository contains a script to automatically apply the `fq_codel` queuing discipline to the `eth0` network interface on boot. It is especially useful on HiveOS setups, ensuring that the fq_codel configuration persists across reboots using a systemd service.

## Overview

The script performs the following tasks:
- Creates a helper shell script (`/usr/local/bin/set_fq_codel.sh`) that removes any existing queuing discipline and applies `fq_codel` on the `eth0` interface.
- Sets up a systemd service (`/etc/systemd/system/fq_codel.service`) that runs the helper script on system startup.
- Reloads systemd and enables the service so that the configuration is automatically applied on each boot.

## Requirements

- **Operating System:** HiveOS (or any Linux distribution with systemd)
- **Privileges:** You need to run the script as `root` (or using `sudo`).

## Installation

To install, execute the following single command in your terminal:

```bash
git clone https://github.com/m1nuzz/fq_codel_autorun.git && cd fq_codel_autorun && chmod +x install_fq_codel.sh && sudo ./install_fq_codel.sh
```

This command will:
- Clone the repository.
- Change to the repository directory.
- Make the `install_fq_codel.sh` script executable.
- Run the script with root privileges.

## Verification

To verify that `fq_codel` is active on `eth0`, run:

```bash
tc qdisc show dev eth0
```

You should see an output similar to:

```
qdisc fq_codel 8001: root refcnt 2 limit 10240p flows 1024 quantum 1514 target 5.0ms interval 100.0ms ecn
```

To check the status of the systemd service, run:

```bash
systemctl status fq_codel.service
```

## Usage on HiveOS

On HiveOS:
1. Connect to your rig via SSH or open a terminal session.
2. Use the installation command above.
3. After a reboot, the service will automatically apply `fq_codel` on the `eth0` interface.
4. You can also manually restart the service if needed:
   ```bash
   sudo systemctl restart fq_codel.service
   ```

## Troubleshooting

- **Script Not Running as Root:**  
  Make sure to run the script with `sudo` or as the `root` user.

- **Service Issues:**  
  If the systemd service fails to start, check its logs for more details with:
  ```bash
  sudo journalctl -u fq_codel.service
  ```
