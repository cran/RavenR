#' @title EC Climate Gauge Record Overlap Visualization
#'
#' @description
#' This function plots the length of Environment Canada climate station records,
#' accessed via the \pkg{weathercan} package, to identify periods in which multiple
#' station records overlap.
#'
#' @details
#' Accepts outputs from either the \code{stations_search()} or \code{weather_dl()} functions
#' from the \pkg{weathercan} package and extracts the start and end dates of the record
#' from each station for plotting.
#'
#' Outputs from \code{stations_search()} indicate when data collection at a station generally
#' began but do not contain information for specific climate variables and thus should
#' only be used for a "first look". Plots created with station metadata do not refer to
#' specific climate variables.
#'
#' Station records are plotted chronologically on a timeline, and can be colored
#' according to either the station's elevation (default, works for both types of inputs)
#' or the station's distance from a point of interest (works only when supplying
#' \code{stations_search()} results as metadata input).
#'
#' The timeline plot is accompanied by a bar plot counting the number of stations with
#' available data year by year.
#'
#' Large differences in elevation between stations may point towards consideration for
#' the effect of lapse rates on climate forcings driving a model response.
#'
#' @param metadata tibble of the station meta-data from \code{weathercan::stations_search()}
#' @param stndata tibble of the station data from \code{weathercan::weather_dl()}. Used in conjunction with \code{variables} argument.
#' @param variables if using \code{weathercan::weather_dl()}, column names for variables of interest (currently only accepts 1 per call)
#' @param colorby column name by which to color station records. Set to 'elev' (elevation) by default. Can be set to
#' "dist" (distance from coordinates of interest) if supplying \code{weathercan::stations_search} results.
#'
#' @return returns a 2x1 plot object containing 2 ggplot objects
#'   \item{top:}{A chronological horizontal bar plot depicting each station's record period}
#'   \item{bottom:}{A vertical bar plot depicting the number of station records available each year}
#'
#' @examples
#' # load metadata from RavenR sample data
#' data(rvn_weathercan_metadata_sample)
#'
#' ## code that would be used to download metadata using weathercan
#' # library(weathercan)
#' #
#' # metadata = stations_search(coords=c(50.109,-120.787),
#' #    dist=150, # EC stations 150 km of Merritt, BC
#' #   interval='day'
#' # )
#' # metadata = metadata[metadata$start>=2000,] # subset stations with recent data
#' # metadata = metadata[1:3,] # take only the first 3 stations for brevity
#'
#' # plot line colours by station elevation
#' rvn_met_recordplot(metadata=rvn_weathercan_metadata_sample, colorby='elev')
#'
#' # plot line colours by distance to specified co-ordinates
#' rvn_met_recordplot(metadata=rvn_weathercan_metadata_sample, colorby='distance')
#'
#' ## load sample weathercan::weather_dl() with single station
#' data(rvn_weathercan_sample)
#'
#' # compare records for a specific variable
#' rvn_met_recordplot(stndata=rvn_weathercan_sample, variables = "total_precip")
#'
#' @importFrom ggplot2 geom_point geom_rect geom_col xlab ylab ggtitle scale_x_continuous scale_color_continuous theme_bw theme
#' @importFrom cowplot plot_grid
#' @importFrom stats na.omit
#' @export rvn_met_recordplot
#'
rvn_met_recordplot <- function(metadata=NULL,stndata=NULL,variables=NULL,colorby=NULL)
{

  start <- station_name <- nstations <- station_label <- NA

  # ensure there is a list of stations to read
  if(!is.null(metadata) & !is.null(stndata)){
    stop('Please supply either one of the outputs from weathercan::weather_dl() OR weathercan::stations_search(), not both')}

  # prevent user from searching climate variable records from stations_search( ) results
  if(!is.null(metadata) & !is.null(variables)){
    stop(paste("Metadata argument returns overall station record periods (which may not reflect the record period for a specific climate variable observed at that station).",
               "If looking for records pertaining to a specific climate variable, please use the 'stndata' and 'variables' arguments together.",sep='\n'
    ))
  }

  # restrict user to only plotting a subset of climate variables (not all at once)
  if(!is.null(stndata) & is.null(variables)){
    stop('Please specify which variable you would like to view record lengths for')
  }

  if(!is.null(stndata) & !is.null(variables)){
    stndata = stndata[,c('station_name','station_id','climate_id','year','elev',variables)] # subset only the variable of interest

    # extract start/end years for specified variables where data actually exists
    metadata = do.call('rbind',lapply(unique(stndata$station_id),function(sid){
      onestation = stndata[stndata$station_id==sid,]
      metadata = data.frame(station_name=unique(onestation$station_name),
                            climate_id = unique(onestation$climate_id),
                             start=as.numeric(min(onestation$year[!is.na(onestation[,variables])])),
                             end = as.numeric(max(onestation$year[!is.na(onestation[,variables])])),
                             elev= unique(onestation$elev[onestation$station_id==sid]))
      # add plotting label
      metadata$station_label = paste0(metadata$station_name," (Climate ID: ",metadata$climate_id,")")
      return(metadata)
    }))
  }

  if(!is.null(metadata)){
    # reorder chronologically by start of record
    #metadata$station_name=factor(metadata$station_name,levels=metadata$station_name[order(-metadata$start)])
    metadata$station_label = paste0(metadata$station_name," (Climate ID: ",metadata$climate_id,")")
    metadata$station_label = factor(metadata$station_label,levels=metadata$station_label[order(-metadata$start)])

    # plot records to show overlap
    xmax = max(na.omit(metadata$end))
    xmin = min(na.omit(metadata$start))

    # dynamic spacing (x-label) and text size (y-label)
    xbreaks = ifelse( (xmax - xmin) > 30, 10, 2) # control year label spacing on plot
    ylab_size = ifelse(nrow(metadata)>=30,3,ifelse(nrow(metadata)>=20,6,8))

    if(is.null(variables)){variables = 'overall station records'} # plot title

    if(!is.null(colorby)){                                        # coloring parameter
      if(sum(colnames(metadata)==colorby)<1){                     # Check if parameter exists in generated metadata dataframe.

        stop("Coloring parameter not found. Please specify either 'elev' or 'distance'.
           Note that 'distance' only works when supplying weathercan::stations_search results.")

        }else if(colorby=='distance'){
          colorname = 'distance from point of interest [km]'
        }else if(colorby=='elev'){
         colorby = 'elev'
         colorname = 'elevation [m]'
        }
    }else{                                                        # if no input, default coloring is by elevation
      colorby='elev'
      colorname='elevation [m]'
    }

    overlapPlot <- ggplot(data=metadata)+
      geom_point(aes(x=start,y=station_label))+
      geom_point(aes(x=end,y=station_label))+
      geom_rect(aes(xmin=start,xmax=end,ymin=station_label,ymax=station_label,color=get(colorby)))+
      ggtitle('climate station record periods',subtitle = variables)+
      scale_color_continuous(name=colorname, high = "#56B4E9", low = "#D55E00")+
      scale_x_continuous(limits=c(xmin,xmax),breaks=seq(xmin,xmax,xbreaks))+
      theme_bw()+
      theme(plot.title=element_text(hjust=0.5),plot.subtitle=element_text(hjust = 0.5),
            legend.position = 'bottom',axis.title.y=element_blank(),axis.text.x=element_text(angle=90),
            axis.text.y=element_text(size=ylab_size))
  }

  # Count number of station records available for each year
  year = min(na.omit(metadata$start)):max(na.omit(metadata$end))
  recordsum = do.call('rbind',lapply(year,function(y){
    n = sum(metadata$start <= y & metadata$end >= y,na.rm=T)
    return(data.frame(year=y,nstations=n))
  }))

  # plot station count per year
  stncount = ggplot(recordsum,aes(x=year,y=nstations))+
    geom_col()+
    ggtitle('Data availablity by year')+
    xlab('year')+
    ylab('stations')+
    scale_x_continuous(breaks=seq(xmin,xmax,xbreaks))+
    theme_bw()+
    theme(plot.title=element_text(hjust = 0.5),axis.text.x=element_text(angle=90))

  out <- plot_grid(overlapPlot,stncount,nrow=2 )
  return(out)
}
