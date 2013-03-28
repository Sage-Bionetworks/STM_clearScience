require(synapseClient)
require(devtools)
require(Biobase)
require(survival)
require(BCC)
require(ggplot2)
require(DreamBox7)

data(map)
data(attractome.minimalist)

#=============================================
#  Load METABRIC and OSLO data
#============================================

## LOG INTO SYNAPSE IF NOT PROVIDED IN .Rprofile
# synapseLogin()

#####
## METABRIC
#####
## GET EXPRESSION DATA
mbExprEnt <- loadEntity("syn1710275")
mbExpr <- exprs(mbExprEnt$objects$metabricExprData)
## GET CLINICAL DATA (AND SURVIVAL DATA)
mbClinEnt <- loadEntity("syn1710260")
mbClin <- mbClinEnt$objects$metabricClinicalTable
mbSurvEnt <- loadEntity("syn1710277")
mbSurv <- mbSurvEnt$objects$metabricSurvData

## MAKE SURE SAMPLES ARE LINED UP ACROSS DATA OBJECTS
stopifnot( all(rownames(mbSurv) == colnames(mbExpr)) )
stopifnot( all(rownames(mbClin) == colnames(mbExpr)) )

## IMPUTE MISSING CLINICAL FEATURES
mbClinImputed <- lazyImputeDFClncOslo(mbClin)
mbClinImputed <- expandClncOslo(mbClinImputed)

mbMeta <- CreateMetageneSpace(mbExpr, attractome=attractome.minimalist, map=map)$metaSpace



#####
## OSLO VAL
#####
## GET EXPRESSION DATA
ovExprEnt <- loadEntity("syn1710255")
ovExpr <- exprs(ovExprEnt$objects$oslovalExprData)
## GET CLINICAL DATA (AND SURVIVAL DATA)
ovClinEnt <- loadEntity("syn1710251")
ovClin <- ovClinEnt$objects$oslovalClinicalTable
ovSurvEnt <- loadEntity("syn1710257")
ovSurv <- ovSurvEnt$objects$oslovalSurvData

## MAKE SURE SAMPLES ARE LINED UP ACROSS DATA OBJECTS
stopifnot( all(rownames(ovSurv) == colnames(ovExpr)) )
stopifnot( all(rownames(ovClin) == colnames(ovExpr)) )

ovClinImputed <- lazyImputeDFClncOslo(ovClin)
ovClinImputed <- expandClncOslo(ovClinImputed)

ovMeta <- CreateMetageneSpace(ovExpr, attractome=attractome.minimalist, map=map)$metaSpace

