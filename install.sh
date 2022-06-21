#!/bin/sh

rm -rf /mnt/data/UDMP-Failover-Telegram-Notifications
mkdir /mnt/data/UDMP-Failover-Telegram-Notifications

on_boot_script="/mnt/data/on_boot.d/99-failover-telegram-notifications.sh"
failover_notifications_script="/mnt/data/UDMP-Failover-Telegram-Notifications/failover-notifications.sh"

curl -O https://raw.githubusercontent.com/fire1ce/UDM-Failover-Telegram-Notifications/main/99-failover-telegram-notifications.sh
mv 99-failover-telegram-notifications.sh $on_boot_script
chmod +x $on_boot_script
echo "$on_boot_script installed"

curl -O https://raw.githubusercontent.com/fire1ce/UDM-Failover-Telegram-Notifications/main/failover-notifications.sh
mv failover-notifications.sh $failover_notifications_script
chmod +x $failover_notifications_script
echo "$failover_notifications_script installed"

echo "Set your Telegram Chat ID and Bot API Key at $failover_notifications_script"
exit 0
