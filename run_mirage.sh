#!/bin/bash

export BASE_DIR=/code
export SPEC_DIR=/code

###
## Default: Fixed Seed, 512B
###

for j in {1..10}; do

    ## for both PROFILE and VICTIM keys
    for key in profiled victim ; do 
    
	stats=stats_${1}_${j}
	CONFIG=L1512B.SeedFixed
	OUTDIR=results/${CONFIG}/${key}
	mkdir -p $OUTDIR/$stats
    
	mirage/perf_analysis/gem5/build/X86/gem5.opt --outdir ${OUTDIR}/${stats} mirage/perf_analysis/gem5/configs/example/spec06_config_aes_${key}.py --num-cpus=1 --mem-size=8GB --mem-type=DDR4_2400_8x8 \
						     --cpu-type TimingSimpleCPU --caches --l2cache --l1d_size=512B --l1i_size=32kB --l2_size=16MB --l1d_assoc=8 --l1i_assoc=8 --l2_assoc=16 \
						     --mirage_mode=skew-vway-rand --l2_numSkews=2 --l2_TDR=1.75 --l2_EncrLat=3 | tee ./${OUTDIR}/${stats}/output.txt

	#grep "Round 10" ${OUTDIR}/${stats}/output.txt >> ${OUTDIR}/run_results.txt
	grep "Attacker access" ${OUTDIR}/${stats}/output.txt >> ${OUTDIR}/run_results.txt

    done
done


## Fixed Seeds.
#for i in HIGH1 HIGH2 LOW1 LOW2 ; do
    
#    OUTDIR=fixedPT/L1512B.SeedF
#    mkdir -p $OUTDIR/$stats
#    ../mirage/perf_analysis/gem5/build/X86/gem5.opt --outdir ${OUTDIR}/${stats} ../mirage/perf_analysis/gem5/configs/example/spec06_config_aes_${i}.py --num-cpus=1 --mem-size=8GB --mem-type=DDR4_2400_8x8 --cpu-type TimingSimpleCPU --caches --l2cache --l1d_size=512B --l1i_size=32kB --l2_size=16MB --l1d_assoc=8 --l1i_assoc=8 --l2_assoc=16 --mirage_mode=skew-vway-rand --l2_numSkews=2 --l2_TDR=1.75 --l2_EncrLat=3 | tee ./${OUTDIR}/${stats}/output.txt

 #   grep "Round 10" ${OUTDIR}/${stats}/output.txt >> ${OUTDIR}/run_results.txt
 #   grep "Attacker access" ${OUTDIR}/${stats}/output.txt >> ${OUTDIR}/run_results.txt
#done
