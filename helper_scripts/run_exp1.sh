## Run Experiments
for i in {1..100}; do
    ./run_mirage.sh $i &
done

## Wait till all gem5 processes are over.
while true; do
    # Check for gem5.opt processes excluding the grep command itself
    count=$(ps aux | grep gem5.opt | grep -v grep | grep -v scons | wc -l)

    if [ "$count" -eq 0 ]; then
        echo "No gem5.opt processes running. Exiting loop."
        break
    else
        echo "$count gem5.opt process(es) still running. Sleeping 5 minutes..."
        sleep 300  # 5 minutes
    fi
done

## Analyze GE
#mirage (rco)
./repro_results/analysis_scripts/run_analysis.sh /code/aes/analysis/mirage/key1 /code/aes/analysis/mirage/key2

#sass (rco)
./repro_results/analysis_scripts/run_analysis.sh /code/aes/analysis/sass/key1 /code/aes/analysis/sass/key2

#scatter
./repro_results/analysis_scripts/run_analysis.sh /code/aes/analysis/scatter/key1 /code/aes/analysis/scatter/key2

#ceaser
./repro_results/analysis_scripts/run_analysis.sh /code/aes/analysis/ceaser/key1 /code/aes/analysis/ceaser/key2

#mirage (reproduction)
./repro_results/analysis_scripts/run_analysis.sh /code/repro_results/L1512B.SeedFixed/profiled /code/repro_results/L1512B.SeedFixed/victim
./repro_results/analysis_scripts/run_analysis.sh /code/repro_results/L1512B.SeedRand/profiled /code/repro_results/L1512B.SeedRand/victim
./repro_results/analysis_scripts/run_analysis.sh /code/repro_results/L164kB.SeedRand/profiled /code/repro_results/L164kB.SeedRand/victim


