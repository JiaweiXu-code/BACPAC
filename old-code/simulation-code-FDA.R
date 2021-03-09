
source("C:/D/R-package/gibbs.R");
#source("/pine/scr/j/i/jiawei/Rpackage/gibbs.R");


## set seet for reproducibility;
set.seed(1);	

## Historical Data (to define power prior);
hst_n  = 25.0;                ## sample size;
hst_mn =  0.0;                ## azm cfb mean (also mean of normal power prior);
hst_sd =  8.0;                ## azm sd for cfb;
fb_sd  =  hst_sd/sqrt(hst_n); ## posterior standard deviation under full borrowing;


## Simulation Precision Inputs
nSims =   500;
nSamp =   500;

## Sample Size / Monitoring Inputs
nMin   =   24;
nMax   =   70;
nByVec = c(nMin,8,8,8,8,14);

## Substantial Evidence Threshold
ec     = 1-0.025;

## Hypothesized treatment effect (T:P increase from week 6 to week 8);
targetDelta = 5.5;

## Randomization information;
## note 1 = treatment, 2 = control;
block  = c(1,1,2,2);
block_size = length(block);


## Parameters for enrollment distribution (interarrival times);
enr_mn = 4.0; ## one patient per 4 weeks;
enr_sd = 0.5;

## Parameters for outcome ascertainment distribution;
asc_mn = 8.00; ## 8 weeks +/- 1 week;
asc_sd = 0.25;

## skeptical prior;
skp_mn = 0;                     ## mean;
skp_sd = targetDelta/qnorm(ec)  ## standard deviation;
skp_vr = skp_sd^2;              ## variance;

## enthusiastic prior;
ent_mn = targetDelta;           ## mean;
ent_sd = targetDelta/qnorm(ec)  ## standard deviation;
ent_vr = ent_sd^2;              ## variance;


## True parameters in data generation model;
true_sd = 8.0;

## True mean change from week 6 to week 8 in T:T arm;
tmu1 = 0.0;
tmu2 = 5.5;
true_mn = c(tmu1,tmu2);

###############################################################################################################
###############################################################################################################
## begin code for simulation studies;

## create simulation results container;
results=matrix(0,nrow=nSims,ncol=24);

## loop for simulation studies;
start_time <- Sys.time()
for(sim in (1:nSims))
{
	############# begin simulation code;

		## simulation results containers;
		stop_enrollment	 = 0;      ## Indicator for early stoppage of enrollment (or trial if futility criteria met)
		final_analysis   = 0;      ## Indicator for final analysis; Note that final analysis may occur after ongoing patients are followed-up;  
		n		             = 0;      ## Number of patients currently enrolled 
		nInt             = 0;      ## Number of patients at interim where early stoppage takes place
		analysis         = 0;      ## Number of analyses performed 
		time_of_analysis = c(0,0); ## vector for time of analyses [interim, final]
		eff              = c(0,0); ## indicator vector for efficacy criterion being met [interim, final] 
		fut              = 0;      ## indicator futility stopping criterion being met [interim only];


	######## Generate data for the full hypothetical trial;

		## Generate enrollment times and outcome ascertainment times;
		r = cumsum(rnorm(nMax,mean=enr_mn,sd=enr_sd));  ## cumulative enrollment times;
		w = rnorm(nMax,mean=asc_mn,sd=asc_sd);          ## ascertainment times;         
		e = r + w;					            ## [study start] --> [outcome ascertainment] times


		## Simulate treatment group assignments;
		z = rep(0,nMax);
		totalZ = 0;
		while(totalZ<nMax)
		{
			start = totalZ + 1;
			stop  = min(totalZ + block_size,nMax);
			totalZ = totalZ + block_size;
			z[start:stop] = sample(block,block_size,replace=FALSE)[1:(stop-start+1)];
		}

		## Simulate outcomes;
		y = rnorm(nMax,mean=true_mn[z],sd=true_sd);

	######## Order patient data based on calendar time-to-outcome ascertainment;

		## create a data matrix and order by 
		dat = cbind(r,w,e,z,y); 
 		dat = dat[order(dat[,3]),];

		## re-extract ordered data vectors;
		r = dat[,1];
		w = dat[,2];
		e = dat[,3];
		z = dat[,4];
		y = dat[,5];
		x = cbind(matrix(1,nrow=nMax,ncol=1),(z==2));

		## destroy temporary data container;
		rm(dat);

	loopNumber = 0;
	######## Sequentially analyze study data;
	repeat
	{
		
		if (stop_enrollment==0) {  ## indicator trial should continue;
			## increment number of outcomes ascertained;
			loopNumber = loopNumber + 1;
			n = n + nByVec[loopNumber];

			## if minimum sample size is reached, increment sample size;
			if (n >= nMin) { analysis = analysis + 1 }

			## identify time of most recent interim analysis
			time_of_analysis[1] = e[n];

			## extract current observed data;
			yDat = y[1:n];
			zDat = z[1:n];
			xDat = x[1:n,];
			nREF = sum((z==1)[1:n]);

			## determine how many subjects are ongoing in the study; 
			nOngoing = sum(r<time_of_analysis[1])-n;

		} else  ## final analysis (to take place one interim stoppage criteria are met and ongoing patients are followed up;
		{  
			final_analysis = 1;

			## store number of outcomes ascertained at interim analysis;
			nInt           = n;
			
			if (fut==0) ## perform final data aggregation only if futility criterion has NOT been met;
			{ 
				## determine how many subjects are currently already enrolled 
				enrolled_set = (r<time_of_analysis[1]);

				## identify time of final analysis
				time_of_analysis[2]     = max(e[enrolled_set]);

				## extract final data;
				yDat = y[enrolled_set];
				zDat = z[enrolled_set];
				xDat = x[enrolled_set,];
				nREF = sum((z==1)[1:n]);
				n    = length(yDat);
							
			} else  ## no further analysis if futility criterion HAS been met;
			{
				time_of_analysis[2]     = time_of_analysis[1];
			}
		}



		## Perform data analysis once minimum number of outcomes are ascertained;
		if (n >= nMin) 
		{	
			## compute deterministic power prior parameter and associated SD;
			a0   = min(1,nREF/hst_n);

			## compute prior variance and effective sample size;
			hvr  = hst_sd^2/(hst_n*a0);
			ess = n + a0*hst_n;

			## skeptical prior analysis;

				## construct covariance matrix (skeptical prior)
				cov0  = matrix(c(hvr,0,0,skp_vr),nrow=2,ncol=2);
				beta0 = c(hst_mn,skp_mn); 

				## perform gibbs sampler;
				skeptical_results = gibbs_sampler(nSamp,yDat,xDat,cov0,beta0);
				skp_pp            = skeptical_results[5];

			## enthusiastic prior analysis;

				## construct covariance matrix (enthusiastic prior)
				cov0  = matrix(c(hvr,0,0,ent_vr),nrow=2,ncol=2);
				beta0 = c(hst_mn,ent_mn); 

				## perform gibbs sampler;
				enthusiastic_results = gibbs_sampler(nSamp,yDat,xDat,cov0,beta0,targetDelta);
				ent_pp               = enthusiastic_results[5];

			## maximum sample size reached (stop trial, considered final analysis);
			if (n>= nMax)                              {stop_enrollment = 1; final_analysis = 1; }

			## evaluate futility criterion (stop trial, considered final analysis);
			if ((ent_pp<(1-ec)) & (final_analysis==0)) { stop_enrollment=1; fut=1;           final_analysis=1; }

			## evaluate efficacy criterion (stop trial + consider follow-up on ongoing patients);
			if ((skp_pp>ec) & (final_analysis==0))     { stop_enrollment=1;        eff[1]=1;                   }
			if ((skp_pp>ec) & (final_analysis==1))     {                      eff[2]=1;                   }


		}

		## write out final results data from study;
		if (stop_enrollment==1 & final_analysis==1) 
		{ 
			betaHat = solve(t(xDat)%*%xDat)%*%t(xDat)%*%yDat
			#betaHat = ginv(t(xDat)%*%xDat)%*%t(xDat)%*%yDat
			muHat   = c(betaHat[1],sum(betaHat)); 
			results[sim,1:5]  = skeptical_results;
			results[sim,6:10] = enthusiastic_results;
			results[sim,11:24] = c(analysis,nInt,nOngoing,n,ess,betaHat,fut,eff,true_sd,true_mn,a0)
			break; 
		}
	}	
}
end_time <- Sys.time()
end_time - start_time


cres    = c("tau","mu1","mu0","diff","pp");
colnames(results) <- c(paste("skp",cres,sep="_"),paste("ent",cres,sep="_"),c("analysis","nInt","nOngoing","nFin","essFin","y1Fin","y2Fin","fut","effInt","effFin","true_sd","true_mu1","true_mu0","a0"));
#head(results);

results2 = matrix(colMeans(results),nrow=1);
colnames(results2) <- c(paste("skp",cres,sep="_"),paste("ent",cres,sep="_"),c("analysis","nInt","nOngoing","nFin","essFin","y1Fin","y2Fin","fut","effInt","effFin","true_sd","true_mu1","true_mu0","a0"))
#head(results2)

write.csv(results2, file = "C:/D/R-package/R-results.csv")
write.csv(results2, file = "/pine/scr/j/i/jiawei/Rpackage/R-results.csv")

