# ===========================================================
# Title      : Ecological status class for EBQI 
# Author     : Filippo Ferrario
# Date       : 14/09/2020 
# Version    : 0.2
# Aim        : convert EBQI numerical score into an Ecological status class (i.e. qualitative string)
# ===========================================================



#' Ecological status class for EBQI 
#' 
#' function to classify the EBQI into ecological status.
#' 
#' @param x vector storing the EBQI values to be converted in ecological status class. Can be of lenght of 1 or longer.
#' @param labs character vector with labels for ecological status classes. Default to c('bad','poor','moderate','good','high')
#' @param brks numeric vevtor with breaks to bin EBQI numerical values. Default to c(0,3.5,4.5,6,7.5,11)
#' @param use_lab logical. set "use_lab" equal TRUE to use labels as in `labs`. use_lab=FALSE it returns a numeric value (1= bad to 5 =high)
#'
#' @return 
#' 
#' @author Filippo Ferrario, \email{filippo.ferrario.1@@ulaval.ca} 
#' @references 
#' Personnic, S., Boudouresque, C.F., Astruch, P., Ballesteros, E., Blouet, S., Bellan-Santini, D., Bonhomme, P., Thibault-Botha, D., Feunteun, E., Harmelin-Vivien, M., Pergent, G., Pergent-Martini, C., Pastor, J., Poggiale, J.-C., Renaud, F., Thibaut, T., Ruitton, S., 2014. An Ecosystem-Based Approach to Assess the Status of a Mediterranean Ecosystem, the Posidonia oceanica Seagrass Meadow. PLoS One 9, e98994. https://doi.org/10.1371/journal.pone.0098994
#' 
#' @examples
#' EIs<-c(1,0,9.5,3.5,7,5)
#' 
#' classify(EIs,use_lab=TRUE)
#' classify(EIs,use_lab=FALSE)
#' 
#' @seealso \code{\link{EBQI}}
#' 
#' @export
#' 
classify<-function(x, labs= c('bad','poor','moderate','good','high'), brks=c(0,3.5,4.5,6,7.5,11), use_lab=TRUE){
	if (use_lab==T) labs<-labs else labs<-FALSE
	cut(x, breaks=brks, include.lowest=TRUE, right=FALSE , labels=labs)
}
