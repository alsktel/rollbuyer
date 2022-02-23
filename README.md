# Rollbuyer
MASSA ROLLs auto-buy script that aims to hold 1 ROLL on MASSA node. It is a systemd unit that also has opportunity for manual control via `/bin/rollbuyerd`.

## Installation
To install rollbuyer follow these steps:
1. Download tar archive from releases
2. Go to directory in which MASSA was installed
3. Extract archve `tar -xvf rollbuyer.tar`
4. Make installation script executable `sudo chmod +x rollbuyer/install.sh`
5. Run installation script `sudo rollbuyer/install.sh`
6. Make sure that rollbuyer is installed `rollbuyerd help`

# Usage
* View help: `rollbuyerd` or `rollbuyerd help`
* Start script: `rollbuyerd start`
* Stop script: `rollbuyerd stop`
* Restart script: `rollbuyerd restart`
* View log: `rollbuyerd log`

# Ininstallation
To uninstall rollbuyer run `rollbuyerd uninstall` and make sure that script was stopped (by log message).
