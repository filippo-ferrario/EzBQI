load('./data/box_scores.RData')
#' descr
#' 
#' moer exple
#' 
#' @docType data
#' 
#' @usage data(box_scores)
#' 
#' @format 
#' An object of class `r class(box_scores)`, with `r ncol(box_scores)` columns and `r nrow(box_scores)` rows.
#' 
#' \tabular{ll}{
#'    \code{site} \tab Name of the site\cr
#'    \tab \cr
#'    \code{sp} \tab Name of the "species" scored. It can represent a taxon (species or genus) or functional group. \cr
#'    \tab \cr
#'    \code{status} \tab numerical EBQI score assigned to "sp". 0 is bad and 4 is good. \cr
#' }
#'
#' @keywords datasets
#'
#' @references 
#' 
#' paper 
#'
#' @examples
#' data(box_scores)
#' 
#' head(box_scores)
#' summary(box_scores)
#' str(box_scores)
#' 
'box_scores'
