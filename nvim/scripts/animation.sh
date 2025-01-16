#!/bin/bash

frames=(
  "../static/header1.cat"
  "../static/header2.cat"
  "../static/header3.cat"
  "../static/header4.cat")

while true; do
  for frame in "${frames[@]}"; do
    tput cup 0 0
    lolcat "$frame" -f
    sleep 0.08
  done
done
