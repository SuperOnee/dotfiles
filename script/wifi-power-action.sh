#!/bin/bash
set -euo pipefail

action="${1:-}"
case "$action" in
  shutdown|restart) ;;
  *) printf 'Usage: %s {shutdown|restart}\n' "$0" >&2; exit 2 ;;
esac

if [[ "${POWER_ACTION_DRY_RUN:-0}" == 1 ]]; then
  printf '[Dry run] Wi-Fi would be turned off before %s.\n' "$action"
else
  wifi_device=$(/usr/sbin/networksetup -listallhardwareports | /usr/bin/awk '
    /^Hardware Port: Wi-Fi$/ { getline; if ($1 == "Device:") { print $2; exit } }
  ')
  if [[ -z "$wifi_device" ]]; then
    printf 'Wi-Fi interface not found; %s cancelled.\n' "$action" >&2
    exit 1
  fi

  /usr/sbin/networksetup -setairportpower "$wifi_device" off
  power_state=$(/usr/sbin/networksetup -getairportpower "$wifi_device")
  if [[ "$power_state" != *': Off' ]]; then
    printf 'Could not confirm Wi-Fi is off; %s cancelled.\n' "$action" >&2
    exit 1
  fi
  printf 'Wi-Fi is off.\n'
fi

for remaining in 3 2 1; do
  printf '%s in %s...\n' "$action" "$remaining"
  /bin/sleep 1
done

if [[ "${POWER_ACTION_DRY_RUN:-0}" == 1 ]]; then
  printf '[Dry run] %s was not triggered.\n' "$action"
elif [[ "$action" == shutdown ]]; then
  /usr/bin/osascript -e 'tell application "System Events" to shut down'
else
  /usr/bin/osascript -e 'tell application "System Events" to restart'
fi
