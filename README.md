# Clinical Trial Simulation via Gibbs Sampling

This project contains an implementation of a gibbs sampler and a
Rcpp/Armadillo wrapper for simulating a simple clinical trial.

The long term goal is to develop a larger framework for simulating
general clinical trials.

# Development

See DESCRIPTION for a list of dependencies that you'll need to build
the package.

This is a `usethis` style R package so to experiment with the package,
start R in this directory and say:

    devtools::load_all();
    
To build the package locally:

    devtools::document(); devtools::build();
    
Most of the code of interest is in `src/code.cpp`.
    
# Usage

You can install this package via 

1. `devtools::install_local(<location of package as built above>);`
2. `devtools::install_git(<path to repo>)`
3. `devtools::install_github("JiaweiXu-code/BACPAC.git")`

## Running Some Code

The package currently exports just one function: `SIM`. Sim simulates
a simple clinical trial with the following parameters.

### Basic Parameters

phi         -- Substantial Evidence Threshold 

targetDelta -- Hypothesized treatment effect 

block0      -- Randomization information; note 1 = treatment, 2 = control

skp_mn      -- mean of skeptical prior 

### Sample Size / Monitoring Inputs:

nMin   -- minimum to trigger the analysis

nMax   -- upper limit of the sample size

nByVec -- accrual rate
 
 
### Parameters for enrollment distribution (interarrival times):

enr_mn -- mean, one patient per 4 weeks

enr_sd -- standard deviation


### Parameters for outcome ascertainment distribution:

asc_mn -- mean, 8 weeks +/- 1 week

asc_sd -- standard deviation 


### True parameters in data generation model:

true_sd -- true standard deviation

true_mn -- true mean change 


### Simulation Precision Inputs:

nSims -- number of simulations 

nSamp -- number of MCMC samples
    	
### Historical Data (to define power prior):

hst_n  -- sample size

hst_mn -- mean (also mean of normal power prior)

hst_sd -- standard deviation

### Interpretation of outputs

### Estiamtes under skeptical prior:

skp_tau  -- inverse of standard deviation

skp_mu1  -- effect of control arm 

skp_mu0  -- effect of treated arm

skp_diff -- treatment effect

skp_pp   -- posterior probability of activity
   
### Estimates under enthusiastic prior:

ent_tau  -- inverse of standard deviation

ent_mu1  -- effect of control arm

ent_mu0  -- effect of treated arm 

ent_diff -- treatment effect

ent_pp   -- posterior probability of activity

### Estimates based on observed data:

analysis -- number of analysis performed

nInt     -- Number of patients at interim where early stoppage takes place

nOngoing -- Number of patients at interim where early stoppage doesn't take place

nFin     -- Number of patients currently enrolled   

essFin   -- effective sample size

y1Fin    -- estimated effect of control group 

y2Fin    -- estimated treatment effect 

fut      -- percentage of futility stopping [interim only] 

effInt   -- percentage of efficacy stopping [interim] 

effFin   -- percentage of efficacy stopping [final] 

true_sd  -- true standard deviation in data generation model

true_mu1 -- true mean change in control arm 

true_mu0 -- true mean change in treated arm

a0       -- deterministic power prior parameter  
