## usethis namespace: start
#' @importFrom Rcpp sourceCpp
#' @useDynLib trialsimulation, .registration = TRUE
## usethis namespace: end
NULL


#' Performs a simple trial simulation
#' @param nMin    minimum to trigger the analysis
#' @param nMax    upper limit of the sample size
#' @param nByVec  acrual rate
#' @param phi          Substantial Evidence Threshold 
#' @param targetDelta  Hypothesized treatment effect 
#' @param block0       Randomization information
#' @param enr_mn  mean, one patient per 4 weeks
#' @param enr_sd  standard deviation
#' @param asc_mn  mean, 8 weeks +/- 1 week
#' @param asc_sd  standard deviation
#' @param skp_mn       mean of skeptical prior  
#' @param true_sd  true standard deviation
#' @param true_mn  true mean change
#' @param hst_n   sample size
#' @param hst_mn  mean (also mean of normal power prior)
#' @param hst_sd  standard deviation
#' @param nSims  number of simulations 
#' @param nSamp  number of MCMC samples
#' 
#' @return a data frame with results 
#' - *skp_tau*   -- inverse of standard deviation   
#' - *skp_mu1*   -- effect of control arm 
#' - *skp_mu0*   -- effect of treated arm
#' - *skp_diff*  -- treatment effect
#' - *skp_pp*    -- posterior probability of activity
#' - *ent_tau*   -- inverse of standard deviation   
#' - *ent_mu1*   -- effect of control arm
#' - *ent_mu0*   -- effect of treated arm 
#' - *ent_diff*  -- treatment effect
#' - *ent_pp*    -- posterior probability of activity
#' - *analysis*  -- number of analysis performed
#' - *nInt*      -- Number of patients at interim where early stoppage takes place
#' - *nOngoing*  -- Number of patients at interim where early stoppage doesn't take place
#' - *nFin*      -- Number of patients currently enrolled    
#' - *essFin*    -- effective sample size   
#' - *y1Fin*     -- estimated effect of control group    
#' - *y2Fin*     -- estimated treatment effect    
#' - *fut*       -- percentage of futility stopping (interim only) 
#' - *effInt*    -- percentage of efficacy stopping (interim)  
#' - *effFin*    -- percentage of efficacy stopping (final)    
#' - *true_sd*   -- true standard deviation in data generation model  
#' - *true_mu1*  -- true mean change in control arm 
#' - *true_mu0*  -- true mean change in treated arm
#' - *a0*        -- deterministic power prior parameter  
#' 
#' @examples
#' ## Set simulation parameters
#' hst_n  = 25.0
#' hst_mn =  0.0
#' hst_sd =  8.0
#' nSims =   500
#' nSamp =   500
#' nMin   =   24
#' nMax   =   70
#' nByVec = c(nMin,8,8,8,8,14)
#' phi    = 0.025
#' targetDelta = 5.5
#' block  = c(1,1,2,2)   ## note 1 = treatment, 2 = control
#' block_size = length(block)
#' enr_mn = 4.0
#' enr_sd = 0.5
#' asc_mn = 8.00  ## 8 weeks +/- 1 week
#' asc_sd = 0.25
#' skp_mn = 0
#' ent_mn = targetDelta
#' true_sd = 8.0
#' tmu1 = 0.0
#' tmu2 = 5.5
#' true_mn = c(tmu1,tmu2)
#' 
#' set.seed(1)
#' sims = SIM(nMin, nMax, nByVec, phi, targetDelta, block, enr_mn, enr_sd, asc_mn, asc_sd, skp_mn, 
#'            true_sd, true_mn, hst_n, hst_mn, hst_sd, nSims, nSamp)
#'
#' @export 
SIM <- function(...){
    r <- SIM_RAW(...);
    results <- as.data.frame(r$results);
    cres = c("tau","mu1","mu0","diff","pp");
    names(results) <- c(paste("skp",cres,sep="_"),paste("ent",cres,sep="_"),c("analysis","nInt","nOngoing","nFin","essFin","y1Fin","y2Fin","fut","effInt","effFin","true_sd","true_mu1","true_mu0","a0"));
    colMeans(results)
}

#' Performs a Gibbs sampling
#' @param nSamp       number of samples to be simulated
#' @param y           response vector
#' @param x           covariate matrix
#' @param cov0        prior covariance matrix
#' @param beta0       prior mean
#' @param threshold   cutoff for posterior probability estimation
#' 
#' @return a vector containing:
#' - *sd* -- standard deviation of measurement error
#' - *control_y* -- expected response of control arm
#' - *treated_y* -- expected response of treated arm
#' - *effect* -- expected treatment effect
#' - *post_p* -- posterior probability that treatment works 
#' 
#' @examples
#' ## Set simulation parameters
#' nSamp = 1000
#' y  = c(21.9907344, -14.3731595, 4.6726170, -0.2820250, -5.0333173, -9.0296484, 3.4256872, 2.6770582,
#'        -11.4173409, 21.0090259, -0.5762417, -18.2302091, 4.5875939, 18.8148533, 18.2705664, 10.2195641,
#'        6.3117669, 9.1917231, -3.5045531, -6.5624561, -17.7835691, -3.9293795, -14.2620818, -2.4033531)
#' x = cbind(rep(1,24),c(1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1))
#' cov0 = matrix(c(5.333333, 0.000000, 0.000000, 7.874613), 2,2)
#' beta0 = c(0,0)
#' threshold = 0
#' 
#' set.seed(1)
#' sampler = gibbs_sampler(nSamp, y, x, cov0, beta0, threshold)
#'
gibbs_sampler <- function(nSamp, y, x, cov0, beta0, threshold){
    r <- gibbs_sampler_raw(nSamp, y, x, cov0, beta0, threshold);
    results <- as.data.frame(t(r));
    names(results) <- c("sd","control_y","treated_y","effect","post_p");
    results
}
