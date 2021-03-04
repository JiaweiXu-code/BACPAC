
#source("C:/D/R-package/gibbs.R")
source("C:/D/R-package/Rcpp/simulation-test.rcpp")



## Historical Data (to define power prior);
hst_n  = 25.0;                ## sample size;
hst_mn =  0.0;                ## azm cfb mean (also mean of normal power prior);
hst_sd =  8.0;                ## azm sd for cfb;
fb_sd  =  hst_sd/sqrt(hst_n); ## posterior standard deviation under full borrowing;

## Sample Size / Monitoring Inputs
nMin   =   24;
nMax   =   70;
nByVec = c(nMin,8,8,8,8,14);

## Substantial Evidence Threshold
phi    = 0.025;

## Hypothesized treatment effect (T:P increase from week 6 to week 8);
targetDelta = 5.5;

## Randomization information;
## note 1 = treatment, 2 = control;
block  = c(1,1,2,2);


## Parameters for enrollment distribution (interarrival times);
enr_mn = 4.0; ## one patient per 4 weeks;
enr_sd = 0.5;

## Parameters for outcome ascertainment distribution;
asc_mn = 8.00; ## 8 weeks +/- 1 week;
asc_sd = 0.25;

## skeptical prior;
skp_mn = 0;                     ## mean;

## enthusiastic prior;
ent_mn = targetDelta;           ## mean;

## True parameters in data generation model;
true_sd = 8.0;

## True mean change from week 6 to week 8 in T:T arm;
tmu1 = 0.0;
tmu2 = 5.5;
true_mn = c(tmu1,tmu2);

## set seet for reproducibility;
set.seed(1);	

sims = SIM(nMin, nMax, nByVec, phi, targetDelta, block, enr_mn, enr_sd, asc_mn, asc_sd, skp_mn, true_sd, true_mn,
           hst_n, hst_mn, hst_sd, nSims = 1, nSamp = 500)

results = colMeans(sims$results)
write.csv(results, file = "C:/D/R-package/Rcpp/Rcpp-results.csv")
write.csv(results, file = "/pine/scr/j/i/jiawei/Rpackage/R-results.csv")
