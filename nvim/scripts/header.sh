#!/usr/bin/env bash

counter=0

while :; do
  counter=$((counter + 2))
  tput cup 0 0
  # clear
  lolcat $1 -S $counter -f
  sleep 0.06
done
