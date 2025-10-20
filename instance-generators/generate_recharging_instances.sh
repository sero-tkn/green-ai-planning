#!/bin/bash

mkdir -p instances

echo "Generating 10 valid problem instances for scenario: covers"

count=1
attempts=0
max_instances=10
max_attempts=100

while [ $count -le $max_instances ] && [ $attempts -lt $max_attempts ]; do
  attempts=$((attempts + 1))

  num_robots=$((RANDOM % 4 + 1))            
  min_cover=$((RANDOM % 3 + 2))              
  num_areas=$((RANDOM % 2 + 1))              
  num_obstacles=$((RANDOM % 3 + 1))          
  num_viewpoints=$((RANDOM % 5 + 6))         
  charge_multiplier=$(LC_NUMERIC=C awk -v min=1.1 -v max=1.9 'BEGIN{srand(); printf "%.2f", min+rand()*(max-min)}')
  output_file="instances/problem${count}.pddl"
  plan_file="instances/plan${count}.plan"

  echo "Attempt $attempts → Instance $count:"
  echo "Robots=$num_robots, MinCover=$min_cover, Areas=$num_areas, Obstacles=$num_obstacles, Viewpoints=$num_viewpoints, Charge=$charge_multiplier"
  python3 generator.py covers \
    $num_robots $min_cover $num_areas $num_obstacles $num_viewpoints $charge_multiplier \
    $output_file $plan_file

  if [ $? -eq 0 ]; then
    echo "Success: problem${count}.pddl created."
    count=$((count + 1))
  else
    echo "Failed – retrying with different parameters."
    rm -f "$output_file" "$plan_file"
  fi
done

echo "Generated $((count - 1)) valid instances in $attempts attempts."

