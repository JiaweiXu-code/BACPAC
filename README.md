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

targetDelta -- Hypothesized treatment effect (T:P increase from week 6 to week 8) 

block0      -- Randomization information; note 1 = treatment, 2 = control

skp_mn      -- mean of skeptical prior 

### Sample Size / Monitoring Inputs:

nMin   -- minimum to trigger the analysis

nMax   -- upper limit of the sample size

nByVec -- acrual rate
 
 
### Parameters for enrollment distribution (interarrival times):

enr_mn -- mean, one patient per 4 weeks

enr_sd -- standard deviation


### Parameters for outcome ascertainment distribution:

asc_mn -- mean, 8 weeks +/- 1 week

asc_sd -- standard deviation 


### True parameters in data generation model:

true_sd -- true standard deviation

true_mn -- true mean change from week 6 to week 8 in T:T arm


### Simulation Precision Inputs:

nSims -- number of simulations 

nSamp -- number of MCMC samples
    	
### Historical Data (to define power prior):

hst_n  -- sample size

hst_mn -- azm cfb mean (also mean of normal power prior)

hst_sd -- azm sd for cfb
