# Yet Another Mirage of Breaking Mirage
## **Debunking Occupancy Based Side-Channel Attacks on Fully Associative Randomized Caches**

Authors: Chris Cao, Gururaj Saileshwar.

Code for reproducing our results in the paper: [https://gururaj-s.github.io/assets/pdf/Yet-Another-Mirage.pdf](https://gururaj-s.github.io/assets/pdf/Yet-Another-Mirage.pdf).

## Requirements
1. SW: Docker
2. HW: 100 compute cores, 200GB of memory.
3. Time:
   - 4 hours for reproducing just the RCO paper [SEC'25] result (Fig 1 in our Yet Another Mirage paper)
   - 15 hours for reproducing all our results (Fig 1 to 4 in our Yet Another Mirage paper).


## Steps

### Clone the Repo.

`git clone https://github.com/sith-lab/yet-another-mirage-of-breaking-mirage.git rco_reproduction`


### For Full Reproduction (including our fixes).

For full reproduction of all our figures 1 to 4:

1. Build the docker container and gem5 *with* our fixes. 
```
cd rco_reproduction;
./docker_setup.sh;
```

2. Inside the docker container:
* Navigate to `run_scripts`:
`cd /code/reproduction/run_scripts`
* Run all experiments:
`./run_exp_all.sh`

Notes:
* This will fire 100 AES runs in parallel (assuming 100 cores), and  will take around 15 hours for all three configurations to complete.
* Please clear the `/code/reproduction/repro_results` folder before running, if you ran any experiments previously.

3. Figures:
All the figures are generated in `/code/reproduction/analysis_scripts/fig*``

### For Reproduction Of Only RCO (SEC'25)

For only reproducing our figure 1:
1. Build the docker container and gem5 *without* our fixes. 
```
cd rco_reproduction;
./docker_setup.sh 1;
```

2. Inside the docker container:
* Navigate to `run_scripts`:
`cd /code/reproduction/run_scripts`
* Run only experiments for figure 1:
`./run_exp1.sh`

Notes:
* This will fire 100 AES runs in parallel (assuming 100 cores), and  will take around 5 hours for the experiment to complete.
* Please clear the `/code/reproduction/repro_results/L1512B.SeedFixed` folder before running, if you ran any experiments previously.


3. Figures:
Figure 1 will be generated in `/code/reproduction/analysis_scripts/fig1_4/fig1``



