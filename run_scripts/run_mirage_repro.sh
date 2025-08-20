#!/bin/bash

export BASE_DIR=/code
export SPEC_DIR=/code

###
## Run Mirage Simulations for Exp-1.
## Configs: == Fixed Seed, 512B
###

## Run 10 serial simulations
for j in {1..10}; do

    for all_configs in "512B Fixed"; do
	parts=($all_configs)
	cache=${parts[0]}
	seed=${parts[1]}

	CONFIG="L1${cache}.Seed${seed}"

	seed_str=""
	if [ "$seed" == "Rand" ]; then
	    seed_str="--randseed-global-evictions"
	fi
	
	## for both PROFILE and VICTIM keys
	for key in profiled victim ; do 
    
	    stats=stats_${1}_${j}
	    OUTDIR=${BASE_DIR}/reproduction/repro_results/${CONFIG}/${key}
	    mkdir -p $OUTDIR/$stats

	    # Run Mirage
	    /code/mirage/perf_analysis/gem5/build/X86/gem5.opt --outdir ${OUTDIR}/${stats} /code/mirage/perf_analysis/gem5/configs/example/spec06_config_aes_${key}.py --num-cpus=1 --mem-size=8GB \
							       --mem-type=DDR4_2400_8x8 --cpu-type TimingSimpleCPU --caches --l2cache \
							       --l1d_size=${cache}  ${seed_str} \
							       --l1i_size=32kB --l2_size=16MB --l1d_assoc=8 --l1i_assoc=8 --l2_assoc=16 \
							       --mirage_mode=skew-vway-rand --l2_numSkews=2 --l2_TDR=1.75 --l2_EncrLat=3 | tee ${OUTDIR}/${stats}/output.txt

	    #grep "Round 10" ${OUTDIR}/${stats}/output.txt >> ${OUTDIR}/run_results.txt
	    grep "Attacker access" ${OUTDIR}/${stats}/output.txt >> ${OUTDIR}/run_results.txt

	done
    done
done
