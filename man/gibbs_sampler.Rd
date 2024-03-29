% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trialsimulation-package.R
\name{gibbs_sampler}
\alias{gibbs_sampler}
\title{Performs a Gibbs sampling}
\usage{
gibbs_sampler(nSamp, y, x, cov0, beta0, threshold)
}
\arguments{
\item{nSamp}{number of samples to be simulated}

\item{y}{response vector}

\item{x}{covariate matrix}

\item{cov0}{prior covariance matrix}

\item{beta0}{prior mean}

\item{threshold}{cutoff for posterior probability estimation}
}
\value{
a vector containing:
\itemize{
\item \emph{sd} -- standard deviation of measurement error
\item \emph{control_y} -- expected response of control arm
\item \emph{treated_y} -- expected response of treated arm
\item \emph{effect} -- expected treatment effect
\item \emph{post_p} -- posterior probability that treatment works
}
}
\description{
Performs a Gibbs sampling
}
\examples{
## Set simulation parameters
nSamp = 1000
y  = c(21.9907344, -14.3731595, 4.6726170, -0.2820250, -5.0333173, -9.0296484, 3.4256872, 2.6770582,
       -11.4173409, 21.0090259, -0.5762417, -18.2302091, 4.5875939, 18.8148533, 18.2705664, 10.2195641,
       6.3117669, 9.1917231, -3.5045531, -6.5624561, -17.7835691, -3.9293795, -14.2620818, -2.4033531)
x = cbind(rep(1,24),c(1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1))
cov0 = matrix(c(5.333333, 0.000000, 0.000000, 7.874613), 2,2)
beta0 = c(0,0)
threshold = 0

set.seed(1)
sampler = gibbs_sampler(nSamp, y, x, cov0, beta0, threshold)

}
