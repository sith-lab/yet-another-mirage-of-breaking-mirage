## Compile the AES benchmarks.
cd /code/aes/aes_profiled_key/C ; cmake . ; make all ;
cd /code/aes/aes_victim_key/C ; cmake . ; make all ;

## Create the spec AES configs.
cd /code/mirage/perf_analysis/gem5/configs/example ;

sed \
  's|/randomized_cache_hello_world/spurious_occupancy|/aes/aes_profiled_key/C/AES-TBOX|g' \
  spec06_config_multiprogram.py \
  > spec06_config_aes_profiled.py

sed \
  's|/randomized_cache_hello_world/spurious_occupancy|/aes/aes_victim_key/C/AES-TBOX|g' \
  spec06_config_multiprogram.py \
  > spec06_config_aes_victim.py

 
