# Yet Another Mirage of Breaking Mirage
## **Debunking Occupancy Based Side-Channel Attacks on Fully Associative Randomized Caches**

Authors: Chris Cao, Gururaj Saileshwar.

Code for reproducing our results in the paper: [https://gururaj-s.github.io/assets/pdf/Yet-Another-Mirage.pdf](https://gururaj-s.github.io/assets/pdf/Yet-Another-Mirage.pdf).

## Requirements
1. *SW*: Docker
2. *HW*: 100 compute cores, 200GB of memory.
3. *Time*:
   - 5 hours for reproducing just the RCO paper [SEC'25] result (Fig 1 in our Yet Another Mirage paper)
   - 15 hours for reproducing all our results (Fig 1 to 4 in our Yet Another Mirage paper).


## Steps

### Clone the Repo.

```
git clone https://github.com/sith-lab/yet-another-mirage-of-breaking-mirage.git rco_reproduction
```


### For Full Reproduction (including our fixes).

For full reproduction of all our figures 1 to 4:

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

3. Figures:
All the figures are generated in `/code/reproduction/analysis_scripts/fig*`

Notes:
* This will fire 100 AES simulations in parallel (assuming 100 cores), and takes around 15 hours to complete.
* Please clear `/code/reproduction/repro_results` before running, if you ran any experiments previously.


### For Reproduction Of Just RCO (SEC'25) Results

For only reproducing our Figure 1, i.e., just the results of Systematic Evaluation of Randomized Cache Designs against Cache Occupancy (RCO) published at SEC'25,

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

3. Figures:
Figure 1 will be generated in `/code/reproduction/analysis_scripts/fig1_4/fig1`

Notes:
* This will fire 100 AES simulations in parallel (assuming 100 cores), and takes around 5 hours to complete.
* Please clear `/code/reproduction/repro_results/L1512B.SeedFixed` before running, if you ran any experiments previously.




