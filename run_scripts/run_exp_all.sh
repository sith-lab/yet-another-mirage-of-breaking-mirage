#!/bin/bash

REPRO_DIR=/code/reproduction

###################################
## Run Experiments For Fig 1, 2, 4.
###################################

echo "Running Experiments for Fig 1, 2, 4"

for i in {1..100}; do
    $REPRO_DIR/run_scripts/run_mirage.sh $i &
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

## Plot Fig4
cd $REPRO_DIR/analysis_scripts/fig1_4/fig4 ;

./plot_fig4.sh ;

## Plot Fig2
cd $REPRO_DIR/analysis_scripts/fig2 ;
./plot_fig2.sh ;

###################################
## Run Experiments For Fig 3.
###################################

echo "Running experiments for Figure 3" 
for i in {1..100}; do
    $REPRO_DIR/run_scripts/run_mirage_fixedCT.sh $i &
done

## Wait till all gem5 processes are over.
while true; do
    # sleep 0.5 minutes
    sleep 30 
    
    # Check for gem5.opt processes excluding the grep command itself
    count=$(ps aux | grep gem5.opt | grep -v grep | grep -v scons | wc -l)
    
    if [ "$count" -eq 0 ]; then
        echo "No gem5.opt processes running. Exiting loop."
        break
    fi
done

## Plot Fig3
cd $REPRO_DIR/analysis_scripts/fig3

echo "Plotting Figure 3"
python3 fig3.py ; 
cd $REPRO_DIR ;

