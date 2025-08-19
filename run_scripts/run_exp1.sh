#!/bin/bash

REPRO_DIR=/code/reproduction

## Run Experiments
for i in {1..100}; do
    $REPRO_DIR/run_scripts/run_mirage.sh $i &
done

## Wait till all gem5 processes are over.
while true; do
    # sleep 5 minuts
    sleep 300 
    
    # Check for gem5.opt processes excluding the grep command itself
    count=$(ps aux | grep gem5.opt | grep -v grep | grep -v scons | wc -l)

    if [ "$count" -eq 0 ]; then
        echo "No gem5.opt processes running. Exiting loop."
        break
    fi
done

## Analyze GE
#mirage (rco)
$REPRO_DIR/analysis_scripts/run_analysis.sh /code/aes/analysis/mirage/key1 /code/aes/analysis/mirage/key2

#sass (rco)
$REPRO_DIR/analysis_scripts/run_analysis.sh /code/aes/analysis/sass/key1 /code/aes/analysis/sass/key2

#scatter
$REPRO_DIR/analysis_scripts/run_analysis.sh /code/aes/analysis/scatter/key1 /code/aes/analysis/scatter/key2

#ceaser
$REPRO_DIR/analysis_scripts/run_analysis.sh /code/aes/analysis/ceaser/key1 /code/aes/analysis/ceaser/key2

#mirage (reproduction)
$REPRO_DIR/analysis_scripts/run_analysis.sh $REPRO_DIR/repro_results/L1512B.SeedFixed/profiled $REPRO_DIR/repro_results/L1512B.SeedFixed/victim
$REPRO_DIR/analysis_scripts/run_analysis.sh $REPRO_DIR/repro_results/L1512B.SeedRand/profiled $REPRO_DIR/repro_results/L1512B.SeedRand/victim
$REPRO_DIR/analysis_scripts/run_analysis.sh $REPRO_DIR/repro_results/L164kB.SeedRand/profiled $REPRO_DIR/repro_results/L164kB.SeedRand/victim


