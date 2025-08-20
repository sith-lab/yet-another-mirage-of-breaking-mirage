#!/bin/bash

PROJECT_DIR="NimishMishra-randomized_caches-fc07ea6"

cd ../$PROJECT_DIR ; 

## Copy Patch for Global Random Evictions Random RNG Seed
patch --forward --silent mirage/perf_analysis/gem5/src/mem/cache/tags/vway_tags.cc < ../src_randseed_patch/vway_tags.cc.patch
patch --forward --silent mirage/perf_analysis/gem5/src/mem/cache/tags/Tags.py      < ../src_randseed_patch/Tags.py.patch        
patch --forward --silent mirage/perf_analysis/gem5/src/mem/cache/Cache.py 	       < ../src_randseed_patch/Cache.py.patch
patch --forward --silent mirage/perf_analysis/gem5/configs/common/Options.py       < ../src_randseed_patch/Options.py.patch
patch --forward --silent mirage/perf_analysis/gem5/configs/common/CacheConfig.py   < ../src_randseed_patch/CacheConfig.py.patch

cd - > /dev/null 2>&1
