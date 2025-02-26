#!/bin/sh

# Get DataDir location
DATA_DIR="$DATA_DIR"
case "$(ubnt-device-info firmware || true)" in
1*)
  DATA_DIR="$DATA_DIR"
  ;;
2*)
  DATA_DIR="/data"
  ;;
3*)
  DATA_DIR="/data"
  ;;
*)
  echo "ERROR: No persistent storage found." 1>&2
  exit 1
  ;;
esac

rm -rf $DATA_DIR/UDMP-Failover-Telegram-Notifications
mkdir $DATA_DIR/UDMP-Failover-Telegram-Notifications

on_boot_script="$DATA_DIR/on_boot.d/99-failover-telegram-notifications.sh"
failover_notifications_script="$DATA_DIR/UDMP-Failover-Telegram-Notifications/failover-notifications.sh"

curl -sO https://raw.githubusercontent.com/highTowerSU/UDM-Failover-Telegram-Notifications/main/99-failover-telegram-notifications.sh
mv 99-failover-telegram-notifications.sh $on_boot_script
chmod +x $on_boot_script
echo "==> $on_boot_script installed"

curl -sO https://raw.githubusercontent.com/highTowerSU/UDM-Failover-Telegram-Notifications/main/failover-notifications.sh
mv failover-notifications.sh $failover_notifications_script
chmod +x $failover_notifications_script
echo "==> $failover_notifications_script installed"

echo "==> Set your Telegram Chat ID and Bot API Key at $failover_notifications_script"
exit 0
