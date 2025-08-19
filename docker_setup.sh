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
cp -r helper_scripts $PROJECT_DIR/.
mkdir -p $PROJECT_DIR/repro_results
cp -r analysis_scripts $PROJECT_DIR/repro_results/.

## 3. Copy Patch for Global Random Evictions Random RNG Seed
cp src_randseed_patch/vway_tags.cc $PROJECT_DIR/mirage/perf_analysis/gem5/src/mem/cache/tags/vway_tags.cc
cp src_randseed_patch/Tags.py      $PROJECT_DIR/mirage/perf_analysis/gem5/src/mem/cache/tags/Tags.py 
cp src_randseed_patch/Cache.py     $PROJECT_DIR/mirage/perf_analysis/gem5/src/mem/cache/Cache.py 
cp src_randseed_patch/Options.py   $PROJECT_DIR/mirage/perf_analysis/gem5/configs/common/Options.py
cp src_randseed_patch/CacheConfig.py $PROJECT_DIR/mirage/perf_analysis/gem5/configs/common/CacheConfig.py

## 4. Compile Docker
./docker/dockerrun.sh 0

## 5. Run Docker Container (compile gem5)
./docker/dockerrun.sh 1
