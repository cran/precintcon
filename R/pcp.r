#' @name pcp
#' @aliases pcp
#' @author Lucas Venezian Povoa \email{lucasvenez@@gmail.com}
#' @title Precipitation Concentration Period
#' @description Calculates the Precipitation Concentration Period (PCP) on a 
#' daily or monthly precipitation serie.
#' @usage pcp(object)
#' @param object a daily or monthly precipitation serie.
#' @return A data.frame containing the following variables:
#' \itemize{
#' \item \code{year} is the year.
#' \item \code{pcp} is the precipitation concentration period, in degree, corresponding to a year.
#' Results correspond to a month like below when using the `azimuth`  default values:
#' 0 = January, 30 = February, 60 = March, \dots, 300 = November, and 330 = December.
#' }
#' @seealso 
#' \code{\link{pplot.pcp}}
#' \code{\link{read.data}}
#' \code{\link{as.daily}}
#' \code{\link{as.monthly}}
#' @examples 
#' ##
#' # Loading the monthly precipitation serie.
#' data(monthly)
#' 
#' ## 
#' # Performing the Precipitation Concentration Degree analysis
#' pcd(monthly)
#' @references Zhang L.J., Qian Y.F. (2003) Annual distribution features of precipitation in China and their interannual variations. J Acta Meteorological Sinica 17:146-163
#' @keywords precipitation concentration degree PCD
#' @export
pcp <- function(object) {
	
	if (is.element("precintcon.daily", class(object)))
		object <- as.precintcon.monthly(object)
	
	if (!is.element("precintcon.monthly", class(object)))
		stop("Invalid data. Please, check your input object.")
	
	azimuth <- 360 * object$month / 12
	
	rx <- aggregate(object$precipitation * sin(azimuth), by = list(object$year), FUN = sum)[2]
	
	ry <- aggregate(object$precipitation * cos(azimuth), by = list(object$year), FUN = sum)[2]
	
	pcp = atan(rx / ry) / 0.0174532925
	
	r <- data.frame(year = unique(object$year), pcp = pcp)
	
	colnames(r) <- c("year", "pcp")
	
  return(r)
}