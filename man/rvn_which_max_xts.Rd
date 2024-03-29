% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rvn_utilities.R
\name{rvn_which_max_xts}
\alias{rvn_which_max_xts}
\title{which.max for xts objects}
\usage{
rvn_which_max_xts(x)
}
\arguments{
\item{x}{xts object to apply which.max to}
}
\value{
{xts object with max value and corresponding date}
}
\description{
Applies the which.max function and returns an xts object
with the maximum value and associated date.
}
\details{
Acts as the which.max function, applicable
to xts objects and returning values in an xts format.

Note that when deploying the rvn_apply_wyearly function, the dates are overwritten
and the dates of the water year ending periods are displayed rather than the event dates.
In order to obtain the corresponding dates when using the \code{\link{rvn_apply_wyearly}}
function, please use \code{\link{rvn_apply_wyearly_which_max_xts}}.
}
\examples{
data(rvn_hydrograph_data)

# obtain the peak observed flow and the corresponding date
rvn_which_max_xts(rvn_hydrograph_data$hyd$Sub43_obs)

# note that the usual rvn_apply_wyearly does not provide the correct dates with this function
rvn_apply_wyearly(rvn_hydrograph_data$hyd$Sub43_obs, rvn_which_max_xts)

}
\seealso{
\code{\link{which.max}} base which.max function
\code{\link{rvn_apply_wyearly_which_max_xts}} for using apply_wyearly with the rvn_which_max_xts function
}
