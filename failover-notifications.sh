#!/bin/sh

### Config ###

# Telegram Bot Token
telegram_bot_API_Token="YOUR_TELEGRAM_BOT_API_TOKEN"
# Telegram Chat ID
telegram_chat_id="YOUR_TELEGRAM_CHAT_ID"
# Destenation Host IP
echo_server_ip="1.1.1.1"
# Interval between checks (in seconds)
run_interval=60
### End Config ###

# funtion to return the current WAN interface name
get_current_wan_interface_name() {
  local current_wan_interface_name
  current_wan_interface_name=$(ip route get $echo_server_ip | grep -o "dev.*" | awk '/dev/ { print $2}')
  if [ $current_wan_interface_name ]; then
    echo $current_wan_interface_name
  else
    echo "None"
  fi
}

get_current_wan_interface_external_ip() {
  current_wan_interface_ip=$(curl -s -X GET https://checkip.amazonaws.com --max-time 10)
  if [ $current_wan_interface_ip ]; then
    echo $current_wan_interface_ip
  else
    echo "None"
  fi
}

# Set initial interface name to the current WAN interface name
interface_name=$(get_current_wan_interface_name)

# Prints the current WAN interface name and ip address
start_message="$(hostname): Starting failover notifications. Current interface: $(get_current_wan_interface_name) with external IP: $(get_current_wan_interface_external_ip)"
echo $start_message

# Send the start message to Telegram
telegram_notification=$(
  curl -s -X GET "https://api.telegram.org/bot${telegram_bot_API_Token}/sendMessage?chat_id=${telegram_chat_id}" \
    --data-urlencode "text=$start_message"
)
# if [[ ${telegram_notification=} == *"\"ok\":false"* ]]; then
#   echo "Error! Telegram notification failed"
#   echo ${telegram_notification=}
# fi

case "$telegram_notification" in
*"\"ok\":false"*)
  echo "Error! Telegram notification failed"
  echo ${telegram_notification}
  ;;
*) ;;
esac

# Loop to check if the current WAN interface name has changed
while true; do
  current_wan_interface_name=$(get_current_wan_interface_name)

  # if the current wan interface name is none then exit this loop and start over
  if [ "$current_wan_interface_name" = "None" ]; then
    echo "Error! Network is unreachable"
    interface_name=$current_wan_interface_name
    sleep $run_interval
    continue
  fi

  # if the current WAN interface name is not the same as the initial interface name, then send a message to the Telegram chat
  if [ "$current_wan_interface_name" != "$interface_name" ]; then
    current_wan_interface_external_ip=$(get_current_wan_interface_external_ip)
    # if the current WAN external ip is none then exit this loop and start over
    if [ $current_wan_interface_external_ip == "None" ]; then
      echo "Can't get external IP"
      sleep $run_interval
      continue
    fi
    message="$(hostname): Failover: WAN interface changed from $interface_name to: $current_wan_interface_name with external IP: $current_wan_interface_external_ip"
    echo $message
    telegram_notification=$(
      curl -s -X GET "https://api.telegram.org/bot${telegram_bot_API_Token}/sendMessage?chat_id=${telegram_chat_id}" \
        --data-urlencode "text=$message"
    )
    case "$telegram_notification" in
    *"\"ok\":false"*)
      echo "Error! Telegram notification failed"
      echo ${telegram_notification}
      ;;
    *) ;;
    esac
    interface_name=$current_wan_interface_name
  fi
  sleep $run_interval
done
