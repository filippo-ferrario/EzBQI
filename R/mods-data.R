load('./data/mods.RData')
#' descr
#' 
#' moer exple
#' 
#' @docType data
#' 
#' @usage data(mods)
#' 
#' @format 
#' An object of class `r class(mods)`, with `r ncol(mods)` columns and `r nrow(mods)` rows.
#' 
#' 
#' \tabular{ll}{
#'    \code{sp} \tab name of the taxonomical or functional group in an EBQI model\'s box\cr
#'    \tab \cr
#'    \code{ID_box} \tab numeric identifer of the EBQI model\'s box \cr
#'    \tab \cr
#'    \code{box} \tab name of the EBQI model\'s box \cr
#'    \tab \cr
#'    \code{model} \tab name of the EBQI ecosystem model\cr
#' }
#'
#' @keywords datasets
#'
#' @references 
#' 
#' paper 
#'
#' @examples
#' data(mods)
#' 
#' head(mods)
#' summary(mods)
#' str(mods)
#' 
'mods'
