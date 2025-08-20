#!/bin/bash

REPRO_DIR=/code/reproduction

## Run Experiments For Fig 1, 2, 4.

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

## Plot Fig1
cd $REPRO_DIR/analysis_scripts/fig1_4/fig1 ;
./plot_fig1.sh ;
cd $REPRO_DIR ; 

## Plot Fig4
cd $REPRO_DIR/analysis_scripts/fig1_4/fig4 ;
./plot_fig4.sh ;
cd $REPRO_DIR ; 



