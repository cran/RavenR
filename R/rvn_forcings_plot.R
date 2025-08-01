#' @title Plots summary of watershed forcing functions
#'
#' @description
#' rvn_forcings_plot generates a set of 5 plots (precip,temperature,PET,radiation,
#' and potential melt), which summarize the watershed-averaged forcings. Returns a list with the individual plots.
#'
#' @details
#' Creates multiple plots from a ForcingFunctions.csv file
#' structure generating using RavenR's forcings.read function
#'
#' @param forcings forcings attribute from forcings.read function
#' @param prd (optional) time period over which the plots are generated
#' @return forcing_plots list of ggplot objects of individual forcing plots and the combined plot
#' @seealso \code{\link{rvn_forcings_read}} for the function used to read in the
#' forcings function data
#'
#' @examples
#'
#' # read in sample forcings data
#' ff <- system.file("extdata","run1_ForcingFunctions.csv", package = "RavenR")
#' fdata <- RavenR::rvn_forcings_read(ff)
#'
#' # plot forcings data
#' p1 <- rvn_forcings_plot(fdata)
#' p1$Precipitation
#' p1$AllForcings
#'
#' # plot subset of forcing data for 2002-2003 water year
#' prd <- "2002-10-01/2003-09-30"
#' rvn_forcings_plot(fdata,prd)$AllForcings
#'
#' # add Legend back to plot (using ggplot2::theme)
#' library(ggplot2)
#' rvn_forcings_plot(fdata,prd)$Temperature+
#' theme(legend.position='top')
#'
#' @export rvn_forcings_plot
#' @importFrom ggplot2 fortify ggplot aes scale_color_manual xlab ylab theme element_blank element_rect element_text ylim xlim scale_x_datetime
#' @importFrom cowplot plot_grid ggdraw draw_label
#' @importFrom tidyr pivot_longer
#' @importFrom lubridate year
rvn_forcings_plot <-function(forcings, prd=NULL)
{

  Index <- value <- variable <- color <- PET <- potential_melt <- NULL

  if ("list" %in% class(forcings)) {
    message("passed forcings as list, disaggregating forcings")
    forcings <- forcings$forcings
  }

  # check prd and subset data
  prd <- rvn_get_prd(forcings,prd)
  forcings <- forcings[prd]

  plot.data <- fortify(forcings)

  # Precipitation
  plot.data$Total_Precip <- plot.data$rain + plot.data$snow
  precip.data <- pivot_longer(plot.data[,c("Index","Total_Precip","snow")], cols = c("Total_Precip","snow"),  names_to = "variable",
                              values_to = "value")
  p1 <- ggplot(precip.data)+
    geom_line(aes(x= Index, y= value, color = variable))+
    scale_color_manual(values = c("blue", "cyan"))+
    ylim(c(0,max(plot.data$Total_Precip)))+
    ylab("Precipitation (mm/d)")+
    xlab("")+
    rvn_theme_RavenR()+
    theme(legend.position = "none", # c(0.8,0.8),
          legend.title = element_blank(),
          legend.background = element_rect(fill = "transparent"),
          axis.title = element_text(size = 7))

  #Temperature
  temp.data <- pivot_longer(plot.data[,c("Index","temp_daily_max","temp_daily_min")], cols = c("temp_daily_max", "temp_daily_min"),
                            names_to = "variable",values_to = "value")
  temp.data$color <- "Above 0 deg C"
  temp.data$color[temp.data$value<0] <- "Below 0 deg C"

  p2 <- ggplot(temp.data)+
    geom_line(aes(x= Index, y= value, group = variable, color = color))+
    geom_hline(yintercept = 0)+
    scale_color_manual(values = c("blue","red"))+
    ylim(c(min(plot.data$temp_daily_min),max(plot.data$temp_daily_max)))+
    ylab(expression(paste("Min/Max Daily Temperature (",degree,"C)")))+
    xlab("")+
    rvn_theme_RavenR()+
    theme(legend.position = "none",
          axis.title = element_text(size = 7))

  #PET
  p3 <- ggplot(plot.data)+
    geom_line(aes(x = Index, y = PET), color="navy")+
    ylab('PET (mm/d)')+
    xlab("")+
    rvn_theme_RavenR()+
    theme(legend.position = "none",
          axis.title = element_text(size = 7))

  #Radiation
  plot.data$SW_LW <- plot.data$net_SW_radiation + plot.data$net_LW_radiation
  rad.data <- pivot_longer(plot.data[,c("Index","net_LW_radiation","SW_radiation","ET_radiation","SW_LW")],
                           cols = c("net_LW_radiation","SW_radiation","ET_radiation","SW_LW"),
                           names_to = "variable",values_to = "value")

  p4 <- ggplot(rad.data)+
    geom_line(aes(x = Index, y = value, color = variable))+
    scale_color_manual(values = c("black", "blue", "red", "purple"))+
    ylab('Radiation (MJ/m2/d)')+
    xlab("")+
    rvn_theme_RavenR()+
    theme(legend.position = "none",
          axis.title = element_text(size = 7))

  # Potential melt
  p5 <- ggplot(plot.data)+
    geom_line(aes(x = Index, y = potential_melt), color = "navy")+
    ylab('Potential Melt (mm/d)')+
    xlab("")+
    rvn_theme_RavenR()+
    theme(legend.position = "none",
          axis.title = element_text(size = 7))

  #Plot Title
  ts=forcings$snow
  N <- nrow(ts)
  titl <- sprintf("Watershed-averaged Forcings (%d-%02d-%02d to %i-%02d-%02d)",year(ts[1,1]),month(ts[1,1]),day(ts[1,1]),year(ts[N,1]),month(ts[N,1]),day(ts[N,1]))

  #Add Title and Create 1 Plot
  title <- ggdraw() +
    draw_label(titl, x = 0.5, hjust = 0.5)
  all_forcing_plots <- plot_grid(title,p1,p2,p3,p4,p5,ncol = 1, rel_heights = c(0.1,1,1,1,1,1))

  # plot(all_forcing_plots)

  forcing_plots <- list("Precipitation" = p1,
                        "Temperature" = p2,
                        "PET" = p3,
                        "Radiation" = p4,
                        "PotentialMelt" = p5,
                        "AllForcings" = all_forcing_plots)

  return(forcing_plots)
}
