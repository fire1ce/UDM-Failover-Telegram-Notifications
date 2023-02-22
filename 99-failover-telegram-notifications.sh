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

# Start the Script at boot
nohup "$DATA_DIR/UDMP-Failover-Telegram-Notifications/failover-notifications.sh" >/tmp/output.log &
