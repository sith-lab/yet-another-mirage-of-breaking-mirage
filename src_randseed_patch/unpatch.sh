#!/bin/bash

PROJECT_DIR="NimishMishra-randomized_caches-fc07ea6"

cd ../$PROJECT_DIR ; 
if patch --dry-run -R --silent mirage/perf_analysis/gem5/src/mem/cache/tags/vway_tags.cc <../src_randseed_patch/vway_tags.cc.patch > /dev/null 2>&1; then
    patch --reverse --silent mirage/perf_analysis/gem5/src/mem/cache/tags/vway_tags.cc <../src_randseed_patch/vway_tags.cc.patch
fi
if patch --dry-run -R --silent mirage/perf_analysis/gem5/src/mem/cache/tags/Tags.py <../src_randseed_patch/Tags.py.patch > /dev/null 2>&1; then
    patch --reverse --silent mirage/perf_analysis/gem5/src/mem/cache/tags/Tags.py   <../src_randseed_patch/Tags.py.patch
fi
if patch --dry-run -R --silent mirage/perf_analysis/gem5/src/mem/cache/Cache.py <../src_randseed_patch/Cache.py.patch > /dev/null 2>&1; then
    patch --reverse --silent mirage/perf_analysis/gem5/src/mem/cache/Cache.py <../src_randseed_patch/Cache.py.patch
fi
if patch --dry-run -R --silent mirage/perf_analysis/gem5/configs/common/Options.py <../src_randseed_patch/Options.py.patch > /dev/null 2>&1; then
    patch --reverse --silent mirage/perf_analysis/gem5/configs/common/Options.py <../src_randseed_patch/Options.py.patch
fi
if patch --dry-run -R --silent mirage/perf_analysis/gem5/configs/common/CacheConfig.py <../src_randseed_patch/CacheConfig.py.patch > /dev/null 2>&1; then
    patch --reverse --silent mirage/perf_analysis/gem5/configs/common/CacheConfig.py <../src_randseed_patch/CacheConfig.py.patch
fi

cd - > /dev/null 2>&1
