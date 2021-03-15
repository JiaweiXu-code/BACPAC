#include <sims.h>
   
//------------------------------------ Class Specific Functions -------------------------------------------//
glm_mcmc::glm_mcmc(int & nSamp0)
{
	nSamp     = nSamp0;
}

arma::vec glm_mcmc::gibbs_sampler(const arma::vec & y, const arma::mat & x, const arma::mat & cov0, const arma::vec & beta0, const double & theshold)
	{
	    // compute summary statistics;
		arma::mat xtx     = x.t()*x;
		arma::vec betaHat = inv(xtx)*x.t()*y;		
		double n          = (double) x.n_rows;

		// initialize chain 
		double tau     = 1/R::runif(1,20);
		arma::vec beta = Rcpp::rnorm(2,50,10);
		
		arma::mat samples(nSamp,5);
		for (int i=-100;i<nSamp;i++)
		{
			// update tau | beta
			double a0  = 0.5*n;
			double sse = sum(pow(y - x*beta,2));
			double b0  = 0.5*sse;
			
			tau = R::rgamma(a0,1.0/b0);

			// update beta | tau			
			arma::mat SigmaFC = inv(inv(cov0) + tau*xtx);
			arma::mat BetaFC  = SigmaFC*( inv(cov0)*beta0 + tau*xtx*betaHat );
			
			beta = Rcpp::rnorm(2,0,1);
			beta = arma::chol(SigmaFC)*beta + BetaFC;
			
			if (i>=0)
			{
				samples(i,0) = pow(tau,-0.5);
				samples(i,1) = beta[0];
				samples(i,2) = beta[0]+beta[1];
				samples(i,3) = beta[1];
				samples(i,4) = (samples(i,3)>theshold);
			}
		}
		arma::vec summary = mean(samples).t();
		return summary;	
    }	