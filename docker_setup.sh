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

## 2. Compile Docker
./docker/dockerrun.sh 0

## 3. Run Docker Container (compile gem5)
./docker/dockerrun.sh 1
