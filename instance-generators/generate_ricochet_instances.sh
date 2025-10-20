#!/bin/bash

mkdir -p instances

echo "Generating 10 random Ricochet Robots instances"

for i in $(seq 1 10); do
  min_board_size=$((RANDOM % 5 + 5))  
  max_board_size=$((RANDOM % 3 + min_board_size + 1))  
  max_steps=$((RANDOM % 5 + 5))       

  echo "Instance $i: Board size $min_board_size–$max_board_size, Steps $max_steps"
  python3 generate.py "$min_board_size" "$max_board_size" "$max_steps"
  mv p-*.* instances/ 2>/dev/null
done

echo " Finished. Instances stored in ./instances/"
