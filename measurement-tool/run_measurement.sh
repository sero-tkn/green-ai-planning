#!/bin/bash

PLANNER_NAME="cerberus_agl"     
DURATION=300
RUNS=30                          

# List of all variants
MODS=(
  ORG  
  SV-PDU1 SV-PDU2 SV-PDA1 SV-PDA2
  SV-OEF1 SV-OEF2 SV-ONE1 SV-ONE2
  SV-OPR1 SV-OPR2 SV-OPA1 SV-OPA2
  SV-ORA1 SV-ORA2 SV-OAN1 SV-OAN2
  SV-PRA1 SV-PRA2 SV-EFA1 SV-EFA2
  MI-ROB MI-RPD MI-RPA MI-ROP
  MI-ROA MI-RPR2 MI-REF2
  SC-DEF SC-RPD SC-APD SC-COP  
)

# Prefixes of all domain names
DOMAINS=(
  ricochet-robots
)

# Build full domain+variant names
MOD_VARIANTS=()

# Append all 31 modifications + ORG variant for each domain
for domain in "${DOMAINS[@]}"; do
  for mod in "${MODS[@]}"; do
    MOD_VARIANTS+=("${domain}-${mod}")
  done
done

echo "Waiting 30 seconds before starting..."
sleep 30

# Run the planner for each full domain variant
for variant in "${MOD_VARIANTS[@]}"; do
  echo "Running planner for domain variant: $variant"

  python3 main.py run-planner \
    --planner "$PLANNER_NAME" \
    --domain "$variant" \
    --time-limit $DURATION \
    --runs $RUNS <<< "n"  # Skip Apptainer build

  echo "Finished $variant"
  echo "-----------------------------"
done

echo "All ${#MOD_VARIANTS[@]} runs completed."