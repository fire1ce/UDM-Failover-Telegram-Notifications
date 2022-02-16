#!/bin/bash

# Creat a cronjob to start the script
touch /etc/cron.d/failover-telegram-notifications
echo "@reboot /bin/bash /mnt/data/UDMP-Failover-Telegram-Notifications/failover-notifications.sh" >/etc/cron.d/failover-telegram-notifications

# Reaload the cron daemon to start the script once in background
/etc/init.d/crond reload /etc/cron.d/failover-telegram-notifications
/etc/init.d/crond restart

exit 1
