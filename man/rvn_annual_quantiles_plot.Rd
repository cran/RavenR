% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rvn_annual_quantiles_plot.R
\name{rvn_annual_quantiles_plot}
\alias{rvn_annual_quantiles_plot}
\title{Plot of Annual Median, Upper and Lower Quantiles of Flow}
\usage{
rvn_annual_quantiles_plot(
  qdat,
  mediancolor = "black",
  ribboncolor = "grey60",
  ribbonalpha = 0.5,
  explot = NULL
)
}
\arguments{
\item{qdat}{Time series object generated by \code{\link{rvn_annual_quantiles}}}

\item{mediancolor}{Color for the median line}

\item{ribboncolor}{Color for the lower/upper quantile ribbon}

\item{ribbonalpha}{Transparency of lower/upper quantile ribbon}

\item{explot}{Existing ggplot object to which median line and quantile ribbon should be added}
}
\value{
p1 ggplot object of quantiles plot
}
\description{
Creates a plot of the annual flow quantiles provided by the \code{\link{rvn_annual_quantiles}} function.
}
\examples{
system.file("extdata","run1_Hydrographs.csv", package="RavenR") \%>\%
rvn_hyd_read(.) \%>\%
rvn_hyd_extract(subs="Sub36",.) ->
hyd_data

# Calculate quantiles for the simulated hydrograph
qdat <- rvn_annual_quantiles(hyd_data$sim)
head(qdat)

# Plot
p <- rvn_annual_quantiles_plot(qdat)
p  # view plot

# Add a second hydrograph to compare
qdat_sim <- rvn_annual_quantiles(hyd_data$sim)

p1 <- rvn_annual_quantiles_plot(qdat_sim, mediancolor = 'blue', ribboncolor = 'red', explot = p)
p1 # view plot

}
\author{
Leland Scantlebury, \email{leland@scantle.com}
}
