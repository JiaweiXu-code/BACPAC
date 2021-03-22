# BACPAC
An R package for BACPAC

Inputs for function SIM

phi         -- Substantial Evidence Threshold 

targetDelta -- Hypothesized treatment effect (T:P increase from week 6 to week 8) 

block0      -- Randomization information; note 1 = treatment, 2 = control

skp_mn      -- mean of skeptical prior 


Sample Size / Monitoring Inputs:

nMin   -- minimum to trigger the analysis

nMax   -- upper limit of the sample size

nByVec -- acrual rate
 
 
Parameters for enrollment distribution (interarrival times):

enr_mn -- mean, one patient per 4 weeks

enr_sd -- standard deviation


Parameters for outcome ascertainment distribution:

asc_mn -- mean, 8 weeks +/- 1 week

asc_sd -- standard deviation 


True parameters in data generation model:

true_sd -- true standard deviation

true_mn -- true mean change from week 6 to week 8 in T:T arm


Simulation Precision Inputs:

nSims -- number of simulations 

nSamp -- number of MCMC samples
    	
Historical Data (to define power prior):

hst_n  -- sample size

hst_mn -- azm cfb mean (also mean of normal power prior)

hst_sd -- azm sd for cfb
