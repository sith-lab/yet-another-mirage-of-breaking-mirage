#!/bin/bash

REPRO_DIR=/code/reproduction

###########
## Get Data
###########
mkdir -p ./data/profiled
mkdir -p ./data/victim

#copy output files
cp $REPRO_DIR/repro_results/L1512B.SeedFixed/profiled/run_results.txt ./data/profiled/Profiled_Key,_Fixed_Seeds.txt
cp $REPRO_DIR/repro_results/L1512B.SeedFixed/victim/run_results.txt   ./data/victim/Victim_Key,_Fixed_Seeds.txt
cp $REPRO_DIR/repro_results/L1512B.SeedRand/profiled/run_results.txt  ./data/profiled/Profiled_Key,_Random_Seeds.txt
cp $REPRO_DIR/repro_results/L1512B.SeedRand/victim/run_results.txt    ./data/victim/Victim_Key,_Random_Seeds.txt

###########
## Plot Fig 4
###########

echo "Plotting Figure 2"
python3 fig2.py
