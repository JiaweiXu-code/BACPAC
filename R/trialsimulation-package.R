## usethis namespace: start
#' @importFrom Rcpp sourceCpp
#' @useDynLib trialsimulation, .registration = TRUE
## usethis namespace: end
NULL


#' Perform a simple trial simulation
#' @param phi         -- Substantial Evidence Threshold 
#' @param targetDelta -- Hypothesized treatment effect 
#' @param block0      -- Randomization information; note 1 = treatment, 2 = control
#' @param skp_mn      -- mean of skeptical prior 
#' @param nMin   -- minimum to trigger the analysis
#' @param nMax   -- upper limit of the sample size
#' @param nByVec -- acrual rate
#' @param enr_mn -- mean, one patient per 4 weeks
#' @param enr_sd -- standard deviation
#' @param asc_mn -- mean, 8 weeks +/- 1 week
#' @param asc_sd -- standard deviation 
#' @param true_sd -- true standard deviation
#' @param true_mn -- true mean change
#' @param nSims -- number of simulations 
#' @param nSamp -- number of MCMC samples
#' @param hst_n  -- sample size
#' @param hst_mn -- mean (also mean of normal power prior)
#' @param hst_sd -- standard deviation
#' @return a data frame with results
#' @param skp_tau  -- inverse of standard deviation   
#' @param skp_mu1  -- effect of control arm 
#' @param skp_mu0  -- effect of treated arm
#' @param skp_diff -- treatment effect
#' @param skp_pp   -- posterior probability of activity
#' @param ent_tau  -- inverse of standard deviation   
#' @param ent_mu1  -- effect of control arm
#' @param ent_mu0  -- effect of treated arm 
#' @param ent_diff -- treatment effect
#' @param ent_pp   -- posterior probability of activity
#' @param analysis -- number of analysis performed
#' @param nInt     -- Number of patients at interim where early stoppage takes place
#' @param nOngoing -- Number of patients at interim where early stoppage doesn't take place
#' @param nFin     -- Number of patients currently enrolled    
#' @param essFin   -- effective sample size   
#' @param y1Fin    -- estimated effect of control group    
#' @param y2Fin    -- estimated treatment effect    
#' @param fut      -- percentage of futility stopping [interim only]  
#' @param effInt   -- percentage of efficacy stopping [interim]   
#' @param effFin   -- percentage of efficacy stopping [final]     
#' @param true_sd  -- true standard deviation in data generation model  
#' @param true_mu1 -- true mean change in control arm 
#' @param true_mu0 -- true mean change in treated arm
#' @param a0       -- deterministic power prior parameter  
#' @export 
SIM <- function(...){
    r <- SIM_RAW(...);
    results <- as.data.frame(r$results);
    cres = c("tau","mu1","mu0","diff","pp");
    names(results) <- c(paste("skp",cres,sep="_"),paste("ent",cres,sep="_"),c("analysis","nInt","nOngoing","nFin","essFin","y1Fin","y2Fin","fut","effInt","effFin","true_sd","true_mu1","true_mu0","a0"));
    results
}

