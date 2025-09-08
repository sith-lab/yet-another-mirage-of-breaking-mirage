# Yet Another Mirage of Breaking Mirage
## **Debunking Occupancy Based Side-Channel Attacks on Fully Associative Randomized Caches**

Authors: Chris Cao, Gururaj Saileshwar.

Code for reproducing our results in the paper: [https://gururaj-s.github.io/assets/pdf/Yet-Another-Mirage.pdf](https://gururaj-s.github.io/assets/pdf/Yet-Another-Mirage.pdf).

## Requirements
1. SW: Docker
2. HW: 200 compute cores, 500GB of memory.
3. Time:
   - 8 hours for reproducing just the RCO paper [SEC'25] result (Fig 1 in our Yet Another Mirage paper)
   - 25 hours for reproducing all our results (Fig 1 to 4 in our Yet Another Mirage paper).


## Steps

### Clone the Repo.

```
git clone https://github.com/sith-lab/yet-another-mirage-of-breaking-mirage.git rco_reproduction
```


### For Full Reproduction (Figures 1 to 4) - 25 hours

1. Build the docker container and gem5 *with* our fixes. 
```
cd rco_reproduction
./docker_setup.sh
```

2. Inside the docker container:
```
cd /code/reproduction/run_scripts 
./run_exp_all.sh 
```

All the figures are generated in `/code/reproduction/analysis_scripts/fig*`

Notes:
* This will fire 200 AES simulations in parallel (assuming 200 cores), and takes around 25 hours to complete.
* Please clear `/code/reproduction/repro_results` before running, if you ran any experiments previously.


### For Reproducing RCO AES Cache Occupancy Attack (Our Figure 1) - 8 hours

This only reproduces our Figure 1. i.e., the results of Systematic Evaluation of Randomized Cache Designs against Cache Occupancy (RCO) published at SEC'25,

1. Build the docker container and gem5 *without* our fixes. 
```
cd rco_reproduction
./docker_setup.sh 1
```

2. Inside the docker container:
```
cd /code/reproduction/run_scripts 
./run_exp1.sh 
```

Figure 1 will be generated in `/code/reproduction/analysis_scripts/fig1_4/fig1`

Notes:
* This will fire 200 AES simulations in parallel (assuming 200 cores), and takes around 8 hours to complete.
* Please clear `/code/reproduction/repro_results/L1512B.SeedFixed` before running, if you ran any experiments previously.




