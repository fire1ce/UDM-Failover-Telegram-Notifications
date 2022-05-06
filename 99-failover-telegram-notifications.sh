#!/bin/sh

# Start the Script at boot
nohup "/mnt/data/UDMP-Failover-Telegram-Notifications/failover-notifications.sh" >/tmp/output.log &
