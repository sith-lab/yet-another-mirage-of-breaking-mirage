#!/bin/bash

# Usage: ./docker_setup.sh [mode]
# mode options:
#   default (no argument) → Apply Patch + run_exp_all
#   0 → Apply Patch + run_exp_all
#   1 → Skip Patch + run_exp_1 

MODE=${1:-0}   # default is 0

## 1. Set up RCO [SEC'25] repository
PROJECT_DIR="NimishMishra-randomized_caches-fc07ea6"
ZIP_FILE="randomized_caches-v2.0.zip"
ZIP_URL="https://zenodo.org/records/14869981/files/NimishMishra/randomized_caches-v2.0.zip?download=1"

if [ ! -d "$PROJECT_DIR" ]; then
    if [ ! -f "$ZIP_FILE" ]; then
	echo "$ZIP_FILE not found, downloading..."
	wget -O "$ZIP_FILE" "$ZIP_URL" || { echo "Download failed!"; exit 1; }
    fi
    echo "Unzipping $ZIP_FILE..."
    unzip -q "$ZIP_FILE" || { echo "Unzip failed!"; exit 1; }
fi

## 2. Copy scripts
mkdir -p $PROJECT_DIR/reproduction 
cp -r run_scripts $PROJECT_DIR/reproduction/.
cp -r analysis_scripts $PROJECT_DIR/reproduction/.


if [[ "$MODE" == "0" ]]; then
    cd $PROJECT_DIR ; 
    ## 3. Copy Patch for Global Random Evictions Random RNG Seed
    patch --forward --silent mirage/perf_analysis/gem5/src/mem/cache/tags/vway_tags.cc < ../src_randseed_patch/vway_tags.cc.patch
    patch --forward --silent mirage/perf_analysis/gem5/src/mem/cache/tags/Tags.py      < ../src_randseed_patch/Tags.py.patch        
    patch --forward --silent mirage/perf_analysis/gem5/src/mem/cache/Cache.py 	       < ../src_randseed_patch/Cache.py.patch               
    patch --forward --silent mirage/perf_analysis/gem5/configs/common/Options.py       < ../src_randseed_patch/Options.py.patch             
    patch --forward --silent mirage/perf_analysis/gem5/configs/common/CacheConfig.py   < ../src_randseed_patch/CacheConfig.py.patch
    cd -;
else
    echo "Skipping Patch to src files."
    ## Make sure to unpatch if previously patched.
    cd src_randseed_patch ;
    ./unpatch.sh ;
    cd .. ;
fi
    
## 4. Compile Docker
cd docker;
./dockerrun.sh 0

## 5. Run Docker Container (compile gem5)
./dockerrun.sh 1
