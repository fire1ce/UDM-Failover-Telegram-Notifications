# UDM Failover Telegram Notifications

## Persistence on Reboot

This script need to run every time the system is rebooted since the UDM overwrites crons every boot.
This can be accomplished with a boot script. Flow this guide: [UDM / UDMPro Boot Script](https://github.com/boostchicken-dev/udm-utilities/tree/master/on-boot-script)

## Compatibility

- Tested on UDM PRO

## Installation

```bash
curl https://raw.githubusercontent.com/fire1ce/UDM-Failover-Telegram-Notifications/main/install.sh | sh
```

Set your Telegram Chat ID and Bot API Key at

```bash
/mnt/data/UDMP-Failover-Telegram-Notifications/failover-notifications.sh
```

### Config

| Parameters             | Description                                                       |
| ---------------------- | ----------------------------------------------------------------- |
| telegram_bot_API_Token | Telegram Bot API Token                                            |
| telegram_chat_id       | Chat ID of the Telegram Bot                                       |
| echo_server_ip         | IP of a server to test what interface is active (Default 1.1.1.1) |
| run_interval           | Interval to run a failover check (Default 60 seconds)             |

## Uninstall

Delete the **UDMP-Failover-Telegram-Notifications** folder

```bash
rm -rf /mnt/data/UDMP-Failover-Telegram-Notifications
```

Delete on boot script file

```bash
rm -rf /mnt/data/on_boot.d/99-failover-telegram-notifications.sh
```

## Usage

At boot the script with create a cronjob that will run once. This is done to prevent boot blocking.

Manual run to test notifications:

```bash
/mnt/data/UDMP-Failover-Telegram-Notifications/failover-notifications.sh
```

**It's strongly recommended to perform a reboot in order to check the on boot initialization of the notifications**
