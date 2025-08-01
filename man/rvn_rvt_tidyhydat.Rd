% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rvn_rvt_tidyhydat.R
\name{rvn_rvt_tidyhydat}
\alias{rvn_rvt_tidyhydat}
\title{EC Streamgauge File Conversion from tidyhydat}
\usage{
rvn_rvt_tidyhydat(
  indata,
  rvt_type = "ObservationData",
  data_type = "HYDROGRAPH",
  subIDs,
  prd = NULL,
  stnNames = NULL,
  write_redirect = FALSE,
  flip_number = FALSE,
  remove_number = FALSE,
  rd_file = "flow_stn_redirect_text.rvt",
  filename = NULL
)
}
\arguments{
\item{indata}{tibble of WSC flow data from tidyhydat's hy_daily_flows() function}

\item{rvt_type}{type of rvt file to write (e.g. ObservationData, BasinInflowHydrograph, etc.)}

\item{data_type}{Raven-syntax data type for flow data (default 'HYDROGRAPH')}

\item{subIDs}{vector of subbasin IDs to correspond to the stations in indata}

\item{prd}{(optional) data period to use in .rvt file}

\item{stnNames}{(optional) character vector of alternative station names to use}

\item{write_redirect}{(optional) write the :RedirectToFile commands in a separate .rvt file}

\item{flip_number}{(optional) put the subID first in the .rvt filename}

\item{remove_number}{(optional) remove the subID from the .rvt filename entirely}

\item{rd_file}{(optional) name of the redirect file created (if \code{write_redirect=TRUE})}

\item{filename}{specified name of file(s) to write to (optional)}
}
\value{
\item{TRUE}{return TRUE if the function is executed properly}
}
\description{
rvn_rvt_tidyhydat converts Environment Canada historical streamgauge data,
accessed via the tidyhydat package, into .rvt format files usable in
Raven.
}
\details{
Takes a single flow tibble generated from tidyhydat and converts the flow data for
each station in the file into .rvt formatted files for a Raven model. If
multiple stations exist in indata, multiple observation files are created. This function
is a wrapper for \code{rvn_rvt_write}, with the benefit of automatically parsing the
tidyhydat download for possibly multiple stations in xts formats before passing
to the rvt writing function.

rvt_type is the specified rvt file type to write to (see the Raven User's Manual
or the \code{rvn_rvt_mappings} function for more rvt types). This should be a flow-based
rvt type, such as ObservationData, BasinInflowHydrograph, ReservoirExtraction, etc.
Most applications of this will likely write the tidyhydat observations as
ObservedData for use in model evaluation to historic records.

data_type is the type of Raven input data type, likely 'HYDROGRAPH', for the corresponding
flow data. If the flow is used as a reservoir-related flow, the data_type may be
RESERVOIR_INFLOW or RESERVOIR_NETINFLOW.

subIDs is required and should correspond to the subID to be used in the .rvt
file for each station in the ff file, in the order in which it will be read
in.

prd is used by the xts formatted-data to restrict the data reported in .rvt
files, for each station, to this period. The prd should be defined in
"YYYY-MM-DD/YYYY-MM-DD" string format. If the period supplied results in an
empty time series (i.e. non-overlapping time periods), an error will be
thrown.

stnNames is an optional character vector to replace the EC station codes
found in the HYDAT database. If supplied, the vector must be of the same length
as the number of stations supplied and the subIDs vector. If not supplied,
the EC station codes will be used. Note that this does not impact model
function, only filename readability and station recognition.

write_redirect will print out the :RedirectToFile commands in a separate
file called, "flow_stn_redirect_text.rvt". These commands can be copied into
the main model's .rvt file to redirect to the produced time series files.

flip_number is a useful option to place the subID first in the filename.
This is often cleaner for organizing files in a folder, since the
alphabetized order is not dependent on the station name, and the observed
files will be in one set.

remove_number will tell RavenR to just use the station name as the rvt file name,
for example 01AA001 becomes 01AA001.rvt.

The function will write to name generated from the station name(s), otherwise
the .rvt filename may be specified with the filename argument (full path to
the filename, including .rvt extension). If multiple stations are provided,
the filename argument may be a vector of filenames.

Note that the function uses
\code{sort(unique(indata$STATION_NUMBER))} to determine the order of stations,
thus the filenames and stnNames should correspond to the sorted vector of station numbers as well.

Note that only daily flow data is supported, as tidyhydat only allows for the
download of daily (or coarser resolution) flow data. Hourly data that is obtained
must be first processed into xts format and then written with \code{\link{rvn_rvt_write}}.

If the data is found to have an inconsistent timestep, the function will attempt to correct it
by infilling missing time steps with \code{\link{rvn_ts_infill}}. If successful, a warning is issued
to the user and the function will proceed, else an error will be raised.
}
\examples{

# note: example modified to avoid using tidyhydat directly, uses saved
## tidyhydat data from RavenR package sample data
# library(tidyhydat)
stations <- c("05CB004","05CA002")

# Gather station data/info using tidyhydat functions
# hd <- tidyhydat::hy_daily_flows(station_number = stations,
#  start_date = "1996-01-01", end_date = "1997-01-01")
data(rvn_tidyhydat_sample)
hd <- rvn_tidyhydat_sample

# station_info <- hy_stations(stations)

tf1 <- file.path(tempdir(), "station1.rvt")
tf2 <- file.path(tempdir(), "station2.rvt")

# Create RVT file
rvn_rvt_tidyhydat(hd, subIDs=c(3,11),
  filename=c(tf1,tf2))

}
