load('./data/weights.RData')
#' descr
#' 
#' moer exple
#' 
#' @docType data
#' 
#' @usage data(weights)
#' 
#' @format 
#' An object of class `r class(weights)`, with `r ncol(weights)` columns and `r nrow(weights)` rows.
#' 
#' 
#' \tabular{ll}{
#'    \code{model} \tab name of the EBQI ecosystem model\cr
#'    \tab \cr
#'    \code{scenario} \tab name of the weighting scenario\cr
#'    \tab \cr
#'    \code{id_box} \tab numeric identifer of the EBQI model\'s box \cr
#'    \tab \cr
#'    \code{box} \tab name of the EBQI model\'s box\cr
#'    \tab \cr
#'    \code{weight \tab weight assigned to a box. In this example values range from 1 to 10 \cr
#' }
#'
#' @keywords datasets
#'
#' @references 
#' 
#' paper 
#'
#' @examples
#' data(weights)
#' 
#' head(weights)
#' summary(weights)
#' str(weights)
#' 
'weights'
