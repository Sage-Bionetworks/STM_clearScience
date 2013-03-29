require(synapseClient)
require(rGithubClient)

analysisRepo <- getRepo("Sage-Bionetworks/STM_clearScience") ## ADD TAG INFORMATION WHEN AVAILABLE

## SOURCE IN FILE FROM GITHUB WHICH LOADS METABRIC AND OSLO VAL DATA
sourceRepoFile(analysisRepo, "dataScripts/loadMetabricAndOsloval.R")

## CREATE A TEMP DIRECTORY TO HOLD FIGS
figDir <- file.path(tempdir(), "figs")
dir.create(figDir)

## SYNAPSE FOLDER TO HOLD FIGS
synFolderId <- "syn1725860"


#################################################
## CREATE EACH FIGURE BY SOURCING IN FROM GITHUB
#################################################

#####
## FIGURE 1
#####
sourceRepoFile(analysisRepo, "figureGeneration/createFigure1.R")
fig1 <- createFigure1()

fig1Activity <- Activity(name="STM 1",
                         used=list(
#                            list(entity=githubLink, wasExecuted=T),
                           list(entity=mbExprEnt, wasExecuted=F),
                           list(entity=mbSurvEnt, wasExecuted=F),
                           list(entity=ovExprEnt, wasExecuted=F),
                           list(entity=ovSurvEnt, wasExecuted=F)
                         ))
fig1Activity <- storeEntity(fig1Activity)

fig1Ent <- Data(name=basename(fig1), parentId=synFolderId)
fig1Ent <- addFile(fig1Ent, fig1)
generatedBy(fig1Ent) <- fig1Activity
fig1Ent <- storeEntity(fig1Ent)


#####
## FIGURE 2
#####
sourceRepoFile(analysisRepo, "figureGeneration/createFigure2.R")
fig2 <- createFigure2()

fig2Activity <- Activity(name="STM 2",
                         used=list(
                           list(entity=mbClinEnt, wasExecuted=F),
                           list(entity=mbExprEnt, wasExecuted=F),
                           list(entity=mbSurvEnt, wasExecuted=F),
                           list(entity=ovClinEnt, wasExecuted=F),
                           list(entity=ovExprEnt, wasExecuted=F),
                           list(entity=ovSurvEnt, wasExecuted=F)
                         ))
fig2Activity <- storeEntity(fig2Activity)

fig2Ent <- Data(name=basename(fig2), parentId=synFolderId)
fig2Ent <- addFile(fig2Ent, fig2)
generatedBy(fig2Ent) <- fig2Activity
fig2Ent <- storeEntity(fig2Ent)


#####
## FIGURE 3
#####
sourceRepoFile(analysisRepo, "figureGeneration/createFigure3.R")
fig3 <- createFigure3()

fig3Activity <- Activity(name="STM 3",
                         used=list(
                           list(entity=mbClinEnt, wasExecuted=F),
                           list(entity=mbExprEnt, wasExecuted=F),
                           list(entity=mbSurvEnt, wasExecuted=F)
                         ))
fig3Activity <- storeEntity(fig3Activity)

fig3Ent <- Data(name=basename(fig3), parentId=synFolderId)
fig3Ent <- addFile(fig3Ent, fig3)
generatedBy(fig3Ent) <- fig3Activity
fig3Ent <- storeEntity(fig3Ent)


#####
## FIGURE 4
#####
sourceRepoFile(analysisRepo, "figureGeneration/createFigure4.R")
fig4 <- createFigure4()

fig4Activity <- Activity(name="STM 4",
                         used=list(
                           list(entity=mbExprEnt, wasExecuted=F),
                           list(entity=mbSurvEnt, wasExecuted=F),
                           list(entity=ovExprEnt, wasExecuted=F),
                           list(entity=ovSurvEnt, wasExecuted=F)
                         ))
fig4Activity <- storeEntity(fig4Activity)

fig4Ent <- Data(name=basename(fig4), parentId=synFolderId)
fig4Ent <- addFile(fig4Ent, fig4)
generatedBy(fig4Ent) <- fig4Activity
fig4Ent <- storeEntity(fig4Ent)

#####
## FIGURE 5
#####
sourceRepoFile(analysisRepo, "figureGeneration/createFigure5.R")
fig5 <- createFigure5()

fig5Activity <- Activity(name="STM 5",
                         used=list(
                           list(entity=mbExprEnt, wasExecuted=F)
                         ))
fig5Activity <- storeEntity(fig5Activity)

fig5Ent <- Data(name=basename(fig5), parentId=synFolderId)
fig5Ent <- addFile(fig5Ent, fig5)
generatedBy(fig5Ent) <- fig5Activity
fig5Ent <- storeEntity(fig5Ent)


