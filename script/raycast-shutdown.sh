#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title Shut Down
# @raycast.mode fullOutput
# @raycast.packageName Power with Wi-Fi Off
# @raycast.description Turn off Wi-Fi, then shut down after a 3-second countdown.

exec /bin/bash "$(dirname "$0")/wifi-power-action.sh" shutdown
