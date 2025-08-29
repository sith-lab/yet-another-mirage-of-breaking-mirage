#!/bin/bash

REPRO_DIR=/code/reproduction

###########
## Get Data
###########
mkdir -p ./data_old
mkdir -p ./data

echo "Data analysis for Figure 1"

#######
## Old Analysis Script.
########

rm -rf /code/aes/analysis/mirage_repro ; 
cp -r /code/aes/analysis/mirage /code/aes/analysis/mirage_repro ;
rm -rf /code/aes/analysis/mirage_repro/key1/* /code/aes/analysis/mirage_repro/key2/* ;
cp $REPRO_DIR/repro_results/L1512B.SeedFixed/profiled/run_results.txt  /code/aes/analysis/mirage_repro/key1/. ;
cp $REPRO_DIR/repro_results/L1512B.SeedFixed/victim/run_results.txt  /code/aes/analysis/mirage_repro/key2/. ;

# Set the ranges for run.sh
sed -i 's/for j in {100..20000..1000}/for j in {100..3300..100}/' /code/aes/analysis/mirage_repro/run.sh ;
sed -i 's/for j in {100..20000..1000}/for j in {100..3300..100}/' /code/aes/analysis/mirage/run.sh ;
sed -i 's/for j in {100..20000..1000}/for j in {100..3300..100}/' /code/aes/analysis/sass/run.sh ;
sed -i 's/for j in {100..20000..1000}/for j in {100..3300..100}/' /code/aes/analysis/scatter/run.sh ;
sed -i 's/for j in {100..20000..1000}/for j in {100..3300..100}/' /code/aes/analysis/ceaser/run.sh ;

# mirage (reproduction)
cd /code/aes/analysis/mirage_repro ; bash run.sh > $REPRO_DIR/analysis_scripts/fig1_4/fig1/data_old/ge_mirage_repro.csv &  cd - ;
#mirage, sass, scatter, ceaser (rco)
cd /code/aes/analysis/mirage       ; bash run.sh > $REPRO_DIR/analysis_scripts/fig1_4/fig1/data_old/ge_mirage_rco.csv  & cd - ;
cd /code/aes/analysis/sass         ; bash run.sh > $REPRO_DIR/analysis_scripts/fig1_4/fig1/data_old/ge_sass_rco.csv    & cd - ;
cd /code/aes/analysis/scatter      ; bash run.sh > $REPRO_DIR/analysis_scripts/fig1_4/fig1/data_old/ge_scatter_rco.csv & cd - ;
cd /code/aes/analysis/ceaser       ; bash run.sh > $REPRO_DIR/analysis_scripts/fig1_4/fig1/data_old/ge_ceasers_rco.csv & cd - ;

#######
## Updated Analysis Script.
########
#mirage, sass, scatter, ceaser (rco)
$REPRO_DIR/analysis_scripts/fig1_4/run_analysis.sh /code/aes/analysis/mirage/key1 /code/aes/analysis/mirage/key2 > $REPRO_DIR/analysis_scripts/fig1_4/fig1/data/ge_mirage_rco.csv
$REPRO_DIR/analysis_scripts/fig1_4/run_analysis.sh /code/aes/analysis/sass/key1 /code/aes/analysis/sass/key2 > $REPRO_DIR/analysis_scripts/fig1_4/fig1/data/ge_sass_rco.csv
$REPRO_DIR/analysis_scripts/fig1_4/run_analysis.sh /code/aes/analysis/scatter/key1 /code/aes/analysis/scatter/key2 > $REPRO_DIR/analysis_scripts/fig1_4/fig1/data/ge_scatter_rco.csv
$REPRO_DIR/analysis_scripts/fig1_4/run_analysis.sh /code/aes/analysis/ceaser/key1 /code/aes/analysis/ceaser/key2 > $REPRO_DIR/analysis_scripts/fig1_4/fig1/data/ge_ceasers_rco.csv
# mirage (reproduction)
$REPRO_DIR/analysis_scripts/fig1_4/run_analysis.sh $REPRO_DIR/repro_results/L1512B.SeedFixed/profiled $REPRO_DIR/repro_results/L1512B.SeedFixed/victim > $REPRO_DIR/analysis_scripts/fig1_4/fig1/data/ge_mirage_repro.csv

###########
## Plot Fig 1
###########

echo "Plotting Figure 1"
python3 fig1.py
