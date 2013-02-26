require(synapseClient)
require(devtools)
require(Biobase)
require(survival)
require(devtools)

# install predictiveModeling from github
install_github(repo="predictiveModeling", username="Sage-Bionetworks") ## ADD TAG INFORMATION WHEN AVAILABLE
require(predictiveModeling)

# install BCC package from github
install_github(repo="BCC", username="Sage-Bionetworks") ## ADD TAG INFORMATION WHEN AVAILABLE
require(BCC)

# install DreamBox7 package from github
install_github(repo="DreamBox7", username="weiyi-bitw", ref="master") ## ADD TAG INFORMATION WHEN AVAILABLE
require(DreamBox7)

# install rGithubClient package from github
install_github(repo="rGithubClient", username="brian-bot", ref="rGithubClient-0.6")
require(rGithubClient)

# log in to synapse if credentials not listed in .Rprofile
# synapseLogin()

# Load metabric data
metabric = loadEntity('syn1465025')$objects
#
# Since I don't have read access to the full metabric now, 
# I used the following to load a local copy
#
#load("~/workspace/data/dream7/fullrenorm/metabric2000.rdata")

# Load OSLOVAL data
intClncDat = loadEntity("syn1449480")$objects$xIntClinDat
intCnvEset = loadEntity("syn1449473")$objects$xCnvDat
intSurvObject = loadEntity("syn1449477")$objects$xIntSurvObj
intExprEset = loadEntity("syn1449475")$objects$xExprDat

oslo = list(expr = intExprEset, cnv = intCnvEset, clnc = intClncDat, surv = intSurvObject)

# source model source file
bccRepo <- getRepo("weiyi-bitw/BCCModels") ## ADD TAG INFORMATION ONCE TAGGED
sourceRepoFile(bccRepo, "syn1417992_OSDS.R")

# create new model instance
gdModel = GoldiloxModel$new()

# train model
gdModel$customTrain(
metabric$Complete_METABRIC_Expression_Data, 
metabric$Complete_METABRIC_Copy_Number_Data, 
metabric$Complete_METABRIC_Clinical_Features_Data, 
metabric$Complete_METABRIC_Clinical_Survival_Data_OS, 
metabric$Complete_METABRIC_Clinical_Survival_Data_DSS
)

# get training score

trainPredictions <- gdModel$customPredict(
metabric$Complete_METABRIC_Expression_Data, 
metabric$Complete_METABRIC_Copy_Number_Data,
metabric$Complete_METABRIC_Clinical_Features_Data
)

tr.ci = getCCDIdx(trainPredictions, metabric$Complete_METABRIC_Clinical_Survival_Data_OS);tr.ci

# Create prediction on OSLOVAL dataset

osloPredictions <- gdModel$customPredict(
oslo$expr, 
oslo$cnv,
oslo$clnc
)

# note that since the weights of the subclassifiers contain random factor, 
# the CI will be slightly different each time
oslo.ci = getCCDIdx(osloPredictions, oslo$surv);oslo.ci

