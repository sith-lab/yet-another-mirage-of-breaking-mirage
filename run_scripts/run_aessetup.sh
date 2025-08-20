#######
## Exp 1, 2, 4
#######

## Compile the AES benchmarks.
cd /code/aes/aes_profiled_key/C ; cmake . ; make all ;
cd /code/aes/aes_victim_key/C ; cmake . ; make all ;

## Create the gem5 AES configs.
cd /code/mirage/perf_analysis/gem5/configs/example ;

sed \
  's|/randomized_cache_hello_world/spurious_occupancy|/aes/aes_profiled_key/C/AES-TBOX|g' \
  spec06_config_multiprogram.py \
  > spec06_config_aes_profiled.py

sed \
  's|/randomized_cache_hello_world/spurious_occupancy|/aes/aes_victim_key/C/AES-TBOX|g' \
  spec06_config_multiprogram.py \
  > spec06_config_aes_victim.py

 
#######
## Exp 3
#######

for ct in ct1 ct2 ct3 ct4 ; do
    
    # apply patch to victim.cpp in AES folder, to fix plaintext-ciphertext pair.
    cp -r /code/aes/aes_profiled_key /code/aes/aes_profiled_key_fixed_${ct}
    patch --forward --silent /code/aes/aes_profiled_key_fixed_${ct}/C/victim.cpp < /code/reproduction/run_scripts/aessetup_patches/aes_victim_fixed${ct}.patch ;
    cd  /code/aes/aes_profiled_key_fixed_${ct}/C ; rm CMakeCache.txt ; cmake . ; make all ;
    # create gem5 AES configs.
    cd /code/mirage/perf_analysis/gem5/configs/example ;
    sed \
	"s|/randomized_cache_hello_world/spurious_occupancy|/aes/aes_profiled_key_fixed_${ct}/C/AES-TBOX|g" \
	spec06_config_multiprogram.py \
	> spec06_config_aes_fixed${ct}.py
done


