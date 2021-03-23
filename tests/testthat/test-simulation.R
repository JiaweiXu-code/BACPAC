test_that("simulation just runs", {

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

  r <- SIM(nMin, nMax, nByVec, phi, targetDelta, block, enr_mn, enr_sd, asc_mn, asc_sd, skp_mn, true_sd, true_mn,
           hst_n, hst_mn, hst_sd, nSims = 100, nSamp = 500)

  act = c(8.04088934,0.80306393,4.27774813,3.47468420,0.97554000,7.91694414,0.08855672,5.65469708,5.56614036,
          0.49698000,3.12000000,30.16000000,1.27000000,43.17000000,61.97000000,-0.00754563,5.83608791,0.01000000,
          0.83000000,0.77000000,8.00000000,0.00000000,5.50000000,0.75200000)
  res = unname(colMeans(as.matrix(r)));
  exp = round(res,digits = 8);
  expect_equal(act,exp);

  # a = c(1,2,3)
  # b = c(4,5,6)
  # expect_equal(a,b);

})

test_that("simulated mu0s are mostly within 3 standard deviations of the true value", {

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
  set.seed(132312);

  r <- SIM(nMin, nMax, nByVec, phi, targetDelta, block, enr_mn, enr_sd, asc_mn, asc_sd, skp_mn, true_sd, true_mn,
           hst_n, hst_mn, hst_sd, nSims = 100, nSamp = 500)


  true_mu0 <-r$true_mu0[[1]];
  true_sd <- r$true_sd;
  expect_gt(sum(abs(r$skp_mu0-true_mu0) < 3*true_sd)/length(true_mu0), 0.95);

})
