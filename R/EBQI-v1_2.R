# ===========================================================
# Title      : EBQI function
# Author     : Filippo Ferrario
# Date       : 30/10/2019 
# Version    : 1.2
# Aim        : Allow flexibility in the function to change both model (i.e. box components) and scenario (i.e. box wheights)
# Changes    : 
#
# ===========================================================




# # Bench

# scores<-read.xlsx('./R_output/datasets/08a-indices-EBQI-box_scores-v0_3-2019-10-30.xlsx', sheetName='Scores', colClasses=NA)
# weights<-read.xlsx('./data/EBQI-literature_search.xlsx', sheetName='WEIGHTs')
# models<-read.xlsx('./data/EBQI-literature_search.xlsx', sheetName='EBQI_models-boxes')


# score_dataset=  scores 
# weights_dataset=filter(weights, Scenario=='ALGAE', model=='mod_1' )
# model_description= filter(models, model=='mod_1' )
# SITE='site'
# # BOX='box'
# DATA_SP='sp'
# SCORE='status'
# W_BOX='box' 
# WEIGHTS='weight_1_10' 
# MOD_BOX='box'
# MODEL_SP='sp'
# PERTURBATION=0
# #PERTURBATION=ptb1[,1]


# EBQI(score_dataset=  scores ,weights_dataset=filter(weights, Scenario=='ALGAE', model=='mod_1'), model_description= filter(models, model=='mod_1' ),
#       SITE='site',DATA_SP='sp',SCORE='status',
#       W_BOX='box' ,WEIGHTS='weight_1_10' ,
#       MOD_BOX='box',MODEL_SP='sp')

# score_dataset=epi_scores;
# weights_dataset=filter(W, Scenario=='ALGAE', model=='mod_1'); 
# model_description=filter(models, model=='mod_1')
# SITE='site'
# DATA_SP='sp'
# SCORE='status'
# W_BOX='box'
# WEIGHTS='weight_1_10'
# MOD_BOX='box'
# MODEL_SP='sp' 


# ==================================
# Function EBQI
# ==================================

#' Calculate the Ecosystem-Based Quality Index
#' 
#' Calculate the Ecosystem-Based Quality Index using the formula given in Personnic et al (2014). 
#' 
#' @param score_dataset dataframe with the scores of each box in the EBQI model. `score_dataset` must include the following columns: site name, species name, score value for each species.
#' @param weights_dataset dataframe with the weights of each box in the EBQI in the model. Different models and weighting scenarios can be specified. `weights_dataset` must include the following columns: model name, boxes' names, weighting scenario and weight value.
#' @param model_description dataframe specifying which species are considered in each box of the EBQI model. Different models can be specified.`model_description` must include the following columns: model name, boxes' names and species names.
#' @param SITE character. Name of the column in `score_dataset` storing the name of the site for which to calculate the EBQI.
#' @param DATA_SP character. Name of the column in`score_dataset` storing the names of the species.
#' @param SCORE character. Name of the column in `score_dataset` storing the species' scores.
#' @param W_BOX character. Name of the column in `weights_dataset` storing the box names.
#' @param WEIGHTS character. Name of the column in `weights_dataset` storing the numerical weights.
#' @param MAX_weight numeric. Maximum value of the weights. So far it is assumed that the weight values for the different model*scenario have a common range.
#' @param MOD_BOX character. Name of the column in `model_description` storing the box names.
#' @param MODEL_SP character. Name of the column in`model_description` storing the names of the species.
#' @param PERTURBATION numerical value to be added to weighs to introduce perturbations. Either one number or a vector of lenght equal to the number of boxes considered in the model in use.
#' 
#' @return 
#' A named list of two elements. `.$ebqi` stores the numerical value of the EBQI index. `.$scores` strores the (mean) scores used to calculate the EQBI.
#' 
#' @details 
#' The three input datasets `score_dataset`,`weights_dataset`,`model_description` can be used to calculate EBQI based on different model and weighting scheme specifications. A model is specified by the boxes considered. Different weighting scenario can be specified for the same model.
#' The names of the model boxes must match between input dataframes.
#' Only boxes for which there are species scored in the `score_dataset` will be actually used. 
#' When 2 or more species are included in the same box their scores are averaged.
# `MAX_weight` is used to avoid that perturbations will result in weights exceeding the range decided for the scenario.
#' 
#' For a real case study using this package please see \url{https://dataverse. } and the related paper.
#' 
#' @author Filippo Ferrario, \email{filippo.ferrario.1@@ulaval.ca} 
#' @references 
#' Personnic, S., Boudouresque, C.F., Astruch, P., Ballesteros, E., Blouet, S., Bellan-Santini, D., Bonhomme, P., Thibault-Botha, D., Feunteun, E., Harmelin-Vivien, M., Pergent, G., Pergent-Martini, C., Pastor, J., Poggiale, J.-C., Renaud, F., Thibaut, T., Ruitton, S., 2014. An Ecosystem-Based Approach to Assess the Status of a Mediterranean Ecosystem, the Posidonia oceanica Seagrass Meadow. PLoS One 9, e98994. https://doi.org/10.1371/journal.pone.0098994
#' 
#' @seealso \code{\link{classify}}
#' 
#' @examples
#' 
#' # create input datasets
#' scores<-data.frame(site=rep('s1',9),
#'                    sp=c('MPO','arenicola_marina','asteriidae','cancer_irroratus','echinarachnius_parma','strongylocentrotus_droebachiensis','OT-Invertivorous_Invertebrates','Suspension_feeders','Bioturbation'),
#'                    parameter=rep('density',9), unit='ind/m-2',
#'                    status=c(2,0,2,4,2,4,4,0,3))
#' 
#' weights<-data.frame(model='m1', scenario='scen1',box=c('MPO','Herbivore','Detritus feeder','Invertivorous Invertebrates','Infauna','OT-Invertivorous Invertebrates','Bioturbation','Suspension feeder'), weight_1_10=c(10,7,3,6,4,1,1,1))
#' 
#' mods<- data.frame(model='m1',
#'                      species=c('MPO','arenicola_marina','asteriidae','cancer_irroratus','echinarachnius_parma','strongylocentrotus_droebachiensis','OT-Invertivorous_Invertebrates','Suspension_feeders','Bioturbation','Nereis_sp'),
#'                      boxes=c('MPO','Detritus feeder','Invertivorous Invertebrates','Invertivorous Invertebrates','Detritus feeder','Herbivore','OT-Invertivorous Invertebrates','Suspension feeder','Bioturbation','Infauna'),
#'                      box_ID=NA) 
#' # run the function
#' EBQI(score_dataset=  scores ,weights_dataset=weights, model_description= mods,
#'       SITE='site',DATA_SP='sp',SCORE='status',
#'       W_BOX='box' ,WEIGHTS='weight_1_10' ,
#'       MOD_BOX='boxes',MODEL_SP='species')
#' 
#' 
#' @export

EBQI<- function(score_dataset ,weights_dataset, model_description, SITE=NULL,DATA_SP=NULL,SCORE=NULL,W_BOX=NULL,WEIGHTS=NULL, MAX_weight=10,MOD_BOX=NULL,  MODEL_SP=NULL,PERTURBATION=0) 
      {
# Version 1.2
# SITE, BOX and SCORE need to be caracters specifying the names of the columns in dataframe "dataset" that store the sites, box name, and status score.
# W_BOX and WEIGHTS are characters specifiyng the name of the column in dataframe "weights_dataset" where box name and weights are stored

      # Semplifiy names
      P=PERTURBATION      
      BX<- W_BOX
      W<- WEIGHTS
      S<- SCORE
      names( model_description)[names( model_description)==MOD_BOX]<-BX
      wei_set<-weights_dataset
      score_set<-score_dataset 
       
       # check consistency of Box names and correspondence between datasets
       chk<-sapply(wei_set[,BX], function(x){ as.character(x) %in% as.character(model_description[,BX])})
       if (sum(chk)<length(chk)) {
            I<-which(chk==F)
            stop('BOX labels not coherent between input datasets! Check for: ',paste(wei_set[I,BX], collapse = ' '))
       }


      # assign a box to each species in the score_set
      score_set<- merge(score_set,model_description, by.x=DATA_SP, by.y=MODEL_SP, all.x=TRUE, all.y=FALSE)

       # 1) Wi x Si
       score_set<-aggregate( score_set[,S], by=list(score_set[,BX],score_set[,SITE]), FUN='mean') # take mean of score per site per box
       names(score_set)<-c(BX,SITE,'mean_score')
       #score_set$mean_score<-round(score_set$mean_score) # turn off the rounding because it artificially creates differencence in the final EBQI when a box has to be splitted into its components.
        
       # add perturbation to Weights and merge it with scores
       wei_set[,W]<-wei_set[,W]+P
       {# 2019-12-02: correct minimum and maximum weight to be not smaller than 1 and not larger than the maximum possible weight
            wei_set[wei_set[,W]<1,W]<-1
            wei_set[wei_set[,W]>MAX_weight,W]<-MAX_weight
       }
       scores_box<- merge(score_set,wei_set, by.x=BX, by.y=W_BOX)

       scores_box$WxS<-scores_box[,'mean_score']*scores_box[,W]
       scores_box<-scores_box[order(scores_box[,SITE],scores_box[,BX] ),]


       # 2) compute numerator
       agg<-list(scores_box[,SITE])
       aggWxS<-aggregate(scores_box[,'WxS'],by=agg,FUN='sum')
       names(aggWxS)<-c(SITE,'WxS') 
       
       # 3) compute denominator
              
       EI_Denom<- aggregate(scores_box[,W],by=agg,FUN='sum')
       EI_Denom$x<-EI_Denom$x*4
       names(EI_Denom)<-c('site','denom')       

       # check on denominator being equal for all sites within a scenario+model
       if  (length(unique(EI_Denom$x) >1))  stop('DENOMINATOR IS NOT THE SAME FOR ALL SITES: possibly boxes/species missing at some site')

       # 4) merge and compute EBQI
       
       EI<- merge(aggWxS,EI_Denom, by=c('site'))
       EI$EBQI<- round((EI$WxS /(EI$denom))*10,1)
       

       # 5) OUTPUT
        res<-list(ebqi=EI, scores=scores_box[,c(SITE,BX,'mean_score')])
        return(res)      

        }

