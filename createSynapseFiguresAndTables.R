require(synapseClient)
require(rGithubClient)
require(survival)

analysisRepo <- getRepo("Sage-Bionetworks/STM_clearScience") ## ADD TAG INFORMATION WHEN AVAILABLE

## SOURCE IN FILE FROM GITHUB WHICH LOADS METABRIC AND OSLO VAL DATA
sourceRepoFile(analysisRepo, "dataScripts/loadMetabricAndOsloval.R")
sourceRepoFile(analysisRepo, "dataScripts/loadOslovalPredictions.R")

## CREATE A TEMP DIRECTORY TO HOLD FIGS AND TABLES
figDir <- file.path(tempdir(), "figs")
dir.create(figDir)

## SYNAPSE FOLDER TO HOLD FIGS
synFigFolderId <- "syn1725860"
synTableFolderId <- "syn1729476"

###########################################################
## CREATE EACH FIGURE AND TABLE BY SOURCING IN FROM GITHUB
###########################################################

#####
## FIGURE 1
#####
sourceRepoFile(analysisRepo, "figureGeneration/createFigure1.R")
fig1 <- createFigure1()

fig1Activity <- Activity(name="STM Figure 1",
                         used=list(
#                            list(entity=githubLink, wasExecuted=T),
                           list(entity=mbExprEnt, wasExecuted=F),
                           list(entity=mbDssEnt, wasExecuted=F),
                           list(entity=ovExprEnt, wasExecuted=F),
                           list(entity=ovSurvEnt, wasExecuted=F)
                         ))
fig1Activity <- storeEntity(fig1Activity)

fig1Ent <- Data(name=basename(fig1), parentId=synFigFolderId)
fig1Ent <- addFile(fig1Ent, fig1)
generatedBy(fig1Ent) <- fig1Activity
fig1Ent <- storeEntity(fig1Ent)


#####
## FIGURE 2
#####
sourceRepoFile(analysisRepo, "figureGeneration/createFigure2.R")
fig2 <- createFigure2()

fig2Activity <- Activity(name="STM Figure 2",
                         used=list(
                           list(entity=mbClinEnt, wasExecuted=F),
                           list(entity=mbExprEnt, wasExecuted=F),
                           list(entity=mbDssEnt, wasExecuted=F),
                           list(entity=ovClinEnt, wasExecuted=F),
                           list(entity=ovExprEnt, wasExecuted=F),
                           list(entity=ovSurvEnt, wasExecuted=F)
                         ))
fig2Activity <- storeEntity(fig2Activity)

fig2Ent <- Data(name=basename(fig2), parentId=synFigFolderId)
fig2Ent <- addFile(fig2Ent, fig2)
generatedBy(fig2Ent) <- fig2Activity
fig2Ent <- storeEntity(fig2Ent)


#####
## FIGURE 3
#####
sourceRepoFile(analysisRepo, "figureGeneration/createFigure3.R")
fig3 <- createFigure3()

fig3Activity <- Activity(name="STM Figure 3",
                         used=list(
                           list(entity=mbExprEnt, wasExecuted=F),
                           list(entity=mbDssEnt, wasExecuted=F),
                           list(entity=ovExprEnt, wasExecuted=F),
                           list(entity=ovSurvEnt, wasExecuted=F)
                         ))
fig3Activity <- storeEntity(fig3Activity)

fig3Ent <- Data(name=basename(fig3), parentId=synFigFolderId)
fig3Ent <- addFile(fig3Ent, fig3)
generatedBy(fig3Ent) <- fig3Activity
fig3Ent <- storeEntity(fig3Ent)


#####
## FIGURE 4
#####
sourceRepoFile(analysisRepo, "figureGeneration/createFigure4.R")
fig4 <- createFigure4()

fig4Activity <- Activity(name="STM Figure 4",
                         used=list(
                           list(entity=oslovalResEnt, wasExecuted=F),
                           list(entity=ovSurvEnt, wasExecuted=F)
                         ))
fig4Activity <- storeEntity(fig4Activity)

fig4Ent <- Data(name=basename(fig4), parentId=synFigFolderId)
fig4Ent <- addFile(fig4Ent, fig4)
generatedBy(fig4Ent) <- fig4Activity
fig4Ent <- storeEntity(fig4Ent)


#####
## TABLE 1
#####
sourceRepoFile(analysisRepo, "tableGeneration/createTable1.R")
table1 <- createTable1()

table1Activity <- Activity(name="STM Table 1",
                           used=list(
                             list(entity=mbDssEnt, wasExecuted=F),
                             list(entity=mbExprEnt, wasExecuted=F)
                           ))
table1Activity <- storeEntity(table1Activity)

table1aEnt <- Data(name=basename(table1$inducing), parentId=synTableFolderId)
table1aEnt <- addFile(table1aEnt, table1$inducing)
generatedBy(table1aEnt) <- table1Activity
table1aEnt <- storeEntity(table1aEnt)
table1Activity <- generatedBy(table1aEnt)

table1bEnt <- Data(name=basename(table1$protective), parentId=synTableFolderId)
table1bEnt <- addFile(table1bEnt, table1$protective)
generatedBy(table1aEnt) <- table1Activity
table1bEnt <- storeEntity(table1bEnt)
table1Activity <- generatedBy(table1bEnt)

