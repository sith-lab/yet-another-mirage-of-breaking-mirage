#!/bin/bash

# Check if both arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Error: Missing arguments."
    echo "Usage: $0 <profiled_key_dir> <victim_key_dir>"
    echo ""
    echo "Arguments:"
    echo "   profiled_key_dir   Path to the profiled key directory"
    echo "   victim_key_dir     Path to the victim key directory"
    exit 1
fi

profiled_key_dir=$1
victim_key_dir=$2

echo "Analyzing GE for ${profiled_key_dir} and ${victim_key_dir}"

for j in {100..3300..100}
do
    for i in {0..15}
    do 
	python3 /code/reproduction/analysis_scripts/fig1_4/analysis.py $i $j $profiled_key_dir $victim_key_dir >> ranks.txt
    done
    echo -n "For $j traces: GE = "
    python3 /code/reproduction/analysis_scripts/fig1_4/guessing_entropy.py
    rm ranks.txt
done
