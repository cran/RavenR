#' @title Extract function for Raven Hydrograph object
#'
#' @description
#' rvn_hyd_extract is used for extracting data from the Raven hydrograph object.
#' Works for objects passed from rvn_hyd_read function (which reads the
#' Hydrographs.csv file produced by the modelling framework Raven).
#'
#' @details
#' Extracts the modelled and observed data from a Raven
#' hydrograph object by name reference. It is also easy to create plots of
#' modelled and observed data using this function. The simulated and observed
#' files are outputted regardless of whether a plot is created, for the
#' specified period.
#'
#' The subs input is the name of the column desired for use; the most common
#' use of this will be for subbasin outflows, where the names will be of the
#' form "subXX", for example "sub24".
#'
#' The hyd object is the full hydrograph object (hyd and units in one data
#' frame) created by the rvn_hyd_read function. Both the hyd and units are
#' required, since the units are placed onto the plots if one is created. This
#' is useful to at least see the units of the plotted variable, even if the
#' plot is later modified.
#'
#' The prd input is used to specify a period for the plot and/or the data
#' output. The period should be specified as a string start and end date, of
#' the format "YYYY-MM-DD/YYYY-MM-DD", for example, "2006-10-01/2010-10-01". If
#' no period is supplied, the entire time series will be used.
#'
#' @param subs column name for plotting/extracting
#' @param hyd full hydrograph data frame (including units) produced by rvn_hyd_read
#' @param prd time period for plotting, as string. See details
#' @param rename_cols boolean for whether to rename columns to generic terms (sim, obs, etc.) or leave
#' column names as they appear in hyd
#' @return returns an xts object with sim, obs, inflow, and obs_inflow time series (if available)
#'  \item{sim}{model simulation for specified column and period}
#'  \item{obs}{observed data for specified column and period}
#'  \item{inflow}{inflow simulation for specified column and period}
#'  \item{obs_inflow}{observed inflow simulation for specified column and period}
#'
#' @seealso \code{\link{rvn_hyd_read}} for reading in the Hydrographs.csv file and
#' creating the object required in this function.
#' \code{\link{rvn_hyd_plot}} for conveniently plotting the output object contents onto the same figure.
#'
#' @examples
#' # read in hydrograph sample csv data from RavenR package
#' ff <- system.file("extdata","run1_Hydrographs.csv", package="RavenR")
#'
#' # read in Raven Hydrographs file, store into myhyd
#' myhyd <- rvn_hyd_read(ff)
#'
#' # no plot or observed data, specified period
#' flow_36 <- rvn_hyd_extract(subs="Sub36",myhyd)
#'
#' attributes(flow_36)
#'
#' # extract simulated and observed flows
#' sim <- flow_36$sim
#' obs <- flow_36$obs
#'
#' # extract precipitation forcings
#' myprecip <- rvn_hyd_extract(subs="precip",hyd=myhyd)
#' myprecip <- myprecip$sim
#'
#' # plot all components using rvn_hyd_plot
#' rvn_hyd_plot(sim,obs,precip=myprecip)
#'
#' @export rvn_hyd_extract
rvn_hyd_extract <- function(subs=NA, hyd=NA, prd=NULL, rename_cols=TRUE) {

  if (missing(subs)) {
    stop("subs is required for this function.")
  }
  if (missing(hyd)) {
    stop("hyd is required for this function; please supply the full output file from rvn_hyd_read.")
  }

  mysub <- ind <- NULL

  hydrographs <- hyd$hyd
  units <- hyd$units
  mycols <- colnames(hydrographs)
  subID <- gsub("[^0-9]", "", subs)
  mysub.sim <- sprintf("\\b%s\\b",subs)
  mysub.obs <- sprintf("\\b%s_obs\\b",subs)
  mysub.inflow <- sprintf("\\b%s_resinflow\\b",subs)
  mysub.obsinflow <- sprintf("\\b%s_obs_resinflow\\b",subs)

  tempgrep <- function(pattern, x) {
    xx <- grep(pattern, x)
    if (length(xx) == 0) {
      return(NA)
    } else {
      return(xx)
    }
  }

  ind.sim <- tempgrep(mysub.sim,mycols)
  ind.obs <- tempgrep(mysub.obs,mycols)
  ind.inflow <- tempgrep(mysub.inflow,mycols)
  ind.obsinflow <- tempgrep(mysub.obsinflow,mycols)

  ind_names <- c("sim","obs","resinflow","obs_resinflow")
  ind <- c(ind.sim,ind.obs,ind.inflow,ind.obsinflow)

  dfnames <- data.frame("ind_names"=ind_names,
             "ind"=c(ind.sim,ind.obs,ind.inflow,ind.obsinflow))
  dfnames <- dfnames[!is.na(dfnames$ind),]

  if (nrow(dfnames)==0) {
    stop(sprintf("%s not found in the columns, check the supplied subs argument.",mysub))
  } else if (nrow(dfnames) > 4) {
    stop(sprintf("There are %i matches for %s, expect a maximum of 4.",length(ind),mysub))
  }

  prd <- rvn_get_prd(hydrographs[,dfnames$ind[1]], prd)
  res <- hydrographs[prd,dfnames$ind]

  if (rename_cols) {
    colnames(res) <- dfnames$ind_names
  }

  return(res)
}

