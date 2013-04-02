require(synapseClient)
require(Biobase)
require(survival)
require(predictiveModeling)
require(BCC)
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
mbDssEnt <- loadEntity("syn1730400")
mbDss <- mbDssEnt$objects$dssSurv
mbDss <- mbDss[rownames(mbSurv), ]

## MAKE SURE SAMPLES ARE LINED UP ACROSS DATA OBJECTS
stopifnot( all(rownames(mbSurv) == colnames(mbExpr)) )
stopifnot( all(rownames(mbClin) == colnames(mbExpr)) )

## IMPUTE MISSING CLINICAL FEATURES
mbClinImputed <- lazyImputeDFClncOslo(mbClin)
mbClinImputed <- expandClncOslo(mbClinImputed)

mbMeta <- CreateMetageneSpace(mbExpr, attractome=attractome.minimalist, map=map)$metaSpace
mbMetaScaled <- mbMeta - apply(mbMeta, 1, median)

mbAll <- cbind.data.frame(mbClin, as.data.frame(t(mbMetaScaled)))
mbImputedAll <- cbind.data.frame(mbClinImputed, as.data.frame(t(mbMetaScaled)))


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
ovMetaScaled <- ovMeta - apply(ovMeta, 1, median)

ovAll <- cbind.data.frame(ovClin, as.data.frame(t(ovMetaScaled)))
ovImputedAll <- cbind.data.frame(ovClinImputed, as.data.frame(t(ovMetaScaled)))
