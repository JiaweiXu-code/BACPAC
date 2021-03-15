// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>
#include <RcppArmadilloExtensions/sample.h>  

class glm_mcmc{

    public:
	int nSamp;
	
	// public member functions;
	glm_mcmc(int & nSamp0);
	
	arma::vec gibbs_sampler(const arma::vec & y, const arma::mat & x, const arma::mat & cov0, const arma::vec & beta0, const double & theshold);
};
