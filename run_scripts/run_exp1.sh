#!/bin/bash

REPRO_DIR=/code/reproduction

###################################
## Run Experiments For Fig 1
###################################

echo "Running Experiments for Fig 1"

## Saving existing files in this 
if [ -d "${REPRO_DIR}/repro_results/L1512B.SeedFixed" ]; then
    echo "WARNING: moving existing $REPRO_DIR/repro_results/L1512B.SeedFixed to $REPRO_DIR/repro_results/L1512B.SeedFixed_old"
    echo "To avoid future data loss, please move this to a different location as this will be clobbered in future runs."
    rm -rf $REPRO_DIR/repro_results/L1512B.SeedFixed_old ; 
    mv "${REPRO_DIR}/repro_results/L1512B.SeedFixed" "$REPRO_DIR/repro_results/L1512B.SeedFixed_old" >/dev/null 2>&1
fi

for i in {1..100}; do
    $REPRO_DIR/run_scripts/run_mirage_repro.sh $i &
done


# Wait till all gem5 processes are over.
while true; do
    # sleep 5 minutes
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
