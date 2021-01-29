# ===========================================================
# Title      : EBQI perturbation function
# Author     : Filippo Ferrario
# Date       : 28/01/2021 
# Version    : 0.1
# Aim        : randomly perturb box weights and recalculate EBQI
# ===========================================================

EBQI function(score_dataset ,weights_dataset, model_description, SITE=NULL,DATA_SP=NULL,SCORE=NULL,W_BOX=NULL,WEIGHTS=NULL, MAX_weight=10,MOD_BOX=NULL,  MODEL_SP=NULL,PERTURBATION=0) 

#' Calculate the Ecosystem-Based Quality Index
#' 
#' Calculate the Ecosystem-Based Quality Index using the formula given in Personnic et al (2014). 
#' 
#' @param score_dataset dataframe with the scores of each box in the EBQI model. `score_dataset` must include the following columns: site name, species name, score value for each species.
#' @param weights_dataset dataframe with the weights of each box in the EBQI in the model. Different models and weighting scenarios can be specified. `weights_dataset` must include the following columns: model name, boxes' names, weighting scenario and weight value.
#' @param model_description dataframe specifying which species are considered in each box of the EBQI model. Different models can be specified.`model_description` must include the following columns: model name, boxes' names and species names.
#' @param W_SCENARIO a character giving the name of the column specifying the scenario(s) in the weights dataset.
#' @param W_MODEL a character giving the name of the column specifying the model(s) in the weights dataset.
#' @param M_MODEL Default as `W_MODEL`. Otherwise character giving the name of the column specifying the model(s) in the weights model description dataset. 
#' @param n_rep number of times perturbation should be repeated.
#' @param seed numeric argument to be passed to set.seed fro the generation of perturbation loads.
#' @param ... arguments to be passed to [EBQI]. All [EBQI] args need to be specified except PERTURBATION 
#' 
#' 
#' @return 
#' 
#' 
#' @details 
#' 
#' @author Filippo Ferrario, \email{filippo.ferrario.1@@ulaval.ca} 
#' 
#' @references 
#' 
#' @seealso [classify]; [EBQI]
#' 
#' @examples
#' 
#' data(box_scores)
#' data(models)
#' data(weights)
#' 
#' 
#' 
#' perturb(score_dataset=box_scores,weights_dataset=weights, model_description=models,
#' 		n_rep=3, W_SCENARIO='scenario', W_MODEL='model', seed=12, 
#' 		SITE='site',DATA_SP='sp',SCORE='status',W_BOX='box',WEIGHTS='weight', MAX_weight=10,MOD_BOX='box',  MODEL_SP='sp')
#' 
#' @export


perturb<-function(score_dataset, weights_dataset , model_description,n_rep=100,W_SCENARIO=NULL, W_MODEL=NULL, M_MODEL=W_MODEL, seed=NULL,...)
{
	# rename dataframes
	wei_set<-weights_dataset
    score_set<-score_dataset 
	mod_set<-model_description# browser()
	
	# retrive the arguments in '...'
	# funArgs<-names(match.call())
	listArgs<-list(...)

	# args control
	if (!is.data.frame(wei_set)) stop('\'weights_dataset\' must be a dataframe')
	if (!is.data.frame(score_set)) stop('\'score_dataset\' must be a dataframe')
	if (!is.data.frame(mod_set)) stop('\'model_description\' must be a dataframe')	
	if (!is.character(W_SCENARIO)) stop ('\'W_SCENARIO\' must be a character giving the name of the column specifying the scenario(s)')
	if (!is.integer(n_rep) | n_rep<=0)	('\'n_rep\' must be a positive integer')
	if (!is.null(seed) & !is.numeric(seed)) stop ('\'seed\' must be numeric if specified')

	# check variables names
	mod_name<-names(mod_set)	
	if( W_MODEL==M_MODEL & (! M_MODEL %in% mod_name)) stop('Model columns in \'weights_dataset\' and \'model_description\' are different. Provide correct M_MODEL argument')
	

	# preparing scenarios & model parameters to be used to calculate the EBQI
	scenarios<-unique(wei_set[,W_SCENARIO])
	mods<-unique(models[,M_MODEL])

	param<-expand.grid(scenarios, mods)
	names(param)<- c('scena', 'mod')
	param$scena<-as.character(param$scena)
	param$mod<-as.character(param$mod)

	# initiate output
	# ------------------
	# Output is a list of arrays for each combination of scenario and model:
	# each slice of the array is a replication of random perturbation.
	# whitin each slice, rows in matrices corresponds to the sites and each coloumn to one perturbation case. 
	# Valuses are EBQI calculated per each site.

	pt.out<-list(NULL)

	# Perturbation loop

	for (i in 1:nrow(param)){

	# subsest datasets	
	scena<-param$scena[i]
	mod<-param$mod[i]
	wei_data<-wei_set[wei_set[,W_SCENARIO]==scena &  wei_set[,W_MODEL]==mod,]

	n_box<- nrow(wei_data)
	box_name<-as.character(unique(wei_data[,listArgs$W_BOX]))
	sites<-as.character(unique(box_scores[,listArgs$SITE]))
	n_sites<-length(sites)

	

	# create list of perturbation vectors of length equal to the number of box considered in the model in use
	# -------------------------------------------------------------------------------------------------------

	nlev<-listArgs$MAX_weight-1
	pert<-array(,dim=c(n_box,nlev,n_rep), dimnames=list(box=box_name,perturbation=paste0('p',1:nlev),replicate=1:n_rep))

	if(!is.null(seed)) set.seed(seed)


	for (k in 1:nlev){
		nvalues<- 1+k*2
		pert[,k,]<-sample(-k:k,size=n_rep*n_box, replace=T, prob=rep(1/nvalues,nvalues))	
		}

	# compute EBQI with perturbation

	temp<-apply(pert, MARGIN=c('perturbation','replicate'),FUN=function(x){ #x; print(x) 
						EBQI(score_dataset, weights_dataset= wei_data, model_description= models[models[,M_MODEL]==mod,] ,..., PERTURBATION=x )$ebqi$EBQI
					})
	dimnames(temp)[[1]]<-sites
	temp
	pt.out[[i]]<-temp
	names(pt.out)[i]<-paste(as.character(param[i,]),collapse='-')

	}

	return(pt.out)



}


#### BENCH

# n_rep=10
# score_dataset=box_scores
# weights_dataset=weights
# model_description=models
# W_SCENARIO='scenario'
# W_MODEL= 'model'
# M_MODEL=W_MODEL
# seed=1235
# # ---------------
# W_BOX='box'
# SITE='site'
# MAX_weight=10


# DATA_SP='sp' 
# SCORE='status'
# WEIGHTS='weight_1_10'
# MOD_BOX='box'
# MODEL_SP='sp'
# # PERTURBATION=x