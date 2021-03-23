## usethis namespace: start
#' @importFrom Rcpp sourceCpp
#' @useDynLib trialsimulation, .registration = TRUE
## usethis namespace: end
NULL


#' Perform a simple trial simulation
#' @param phi         -- Substantial Evidence Threshold 
#' @param targetDelta -- Hypothesized treatment effect (T:P increase from week 6 to week 8) 
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
#' @param true_mn -- true mean change from week 6 to week 8 in T:T arm
#' @param nSims -- number of simulations 
#' @param nSamp -- number of MCMC samples
#' @param hst_n  -- sample size
#' @param hst_mn -- azm cfb mean (also mean of normal power prior)
#' @param hst_sd -- azm sd for cfb
#' @return a data frame with results
#' @export 
SIM <- function(...){
    r <- SIM_RAW(...);
    results <- as.data.frame(r$results);
    cres = c("tau","mu1","mu0","diff","pp");
    names(results) <- c(paste("skp",cres,sep="_"),paste("ent",cres,sep="_"),c("analysis","nInt","nOngoing","nFin","essFin","y1Fin","y2Fin","fut","effInt","effFin","true_sd","true_mu1","true_mu0","a0"));
    results
}

