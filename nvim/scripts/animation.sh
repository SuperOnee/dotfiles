#!/bin/bash

frames=(
  "/Users/heisenberg/.config/nvim/static/header1.cat"
  "/Users/heisenberg/.config/nvim/static/header2.cat"
  "/Users/heisenberg/.config/nvim/static/header3.cat"
  "/Users/heisenberg/.config/nvim/static/header4.cat"
)

while true; do
  for frame in "${frames[@]}"; do
    tput cup 0 0
    lolcat "$frame" -f
    sleep 0.08
  done
done
