require(synapseClient)
require(rGithubClient)
require(survival)
require(predictiveModeling)
require(BCC)
require(DreamBox7)
require(cafr)

analysisRepo <- getRepo("Sage-Bionetworks/STM_clearScience") ## ADD TAG INFORMATION WHEN AVAILABLE

## SOURCE IN FILE FROM GITHUB WHICH LOADS METABRIC AND OSLO VAL DATA
sourceRepoFile(analysisRepo, "dataScripts/loadMetabricAndOsloval.R")
sourceRepoFile(analysisRepo, "dataScripts/loadOslovalPredictions.R")
sourceRepoFile(analysisRepo, "dataScripts/loadNkiAndLoi.R")

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

fig1File <- File(fig1, synapseStore=TRUE, parentId=synFigFolderId)
generatedBy(fig1File) <- fig1Activity
fig1File <- storeEntity(fig1File)


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

fig2File <- File(fig2, synapseStore=TRUE, parentId=synFigFolderId)
generatedBy(fig2File) <- fig2Activity
fig2File <- storeEntity(fig2File)


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

fig3File <- File(fig3, synapseStore=TRUE, parentId=synFigFolderId)
generatedBy(fig3File) <- fig3Activity
fig3File <- storeEntity(fig3File)


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

fig4File <- File(fig4, synapseStore=TRUE, parentId=synFigFolderId)
generatedBy(fig4File) <- fig4Activity
fig4File <- storeEntity(fig4File)


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

table1aFile <- File(table1$inducing, synapseStore=TRUE, parentId=synTableFolderId)
generatedBy(table1aFile) <- table1Activity
table1aFile <- storeEntity(table1aFile)
table1Activity <- generatedBy(table1aFile)

table1bFile <- File(table1$protective, synapseStore=TRUE, parentId=synTableFolderId)
generatedBy(table1bFile) <- table1Activity
table1bFile <- storeEntity(table1bFile)
table1Activity <- generatedBy(table1bFile)


#####
## TABLE 2
#####
sourceRepoFile(analysisRepo, "tableGeneration/createTable2.R")
table2 <- createTable2()

table2Activity <- Activity(name="STM Table 2",
                           used=list(
                             list(entity=sigData, wasExecuted=F),
                             list(entity=nkiData, wasExecuted=F),
                             list(entity=loiData, wasExecuted=F),
                             list(entity=ovExprEnt, wasExecuted=F),
                             list(entity=ovSurvEnt, wasExecuted=F),
                             list(entity=mbSurvEnt, wasExecuted=F),
                             list(entity=mbDssEnt, wasExecuted=F),
                             list(entity=mbExprEnt, wasExecuted=F)
                           ))
table2Activity <- storeEntity(table2Activity)

table2File <- File(table2, synapseStore=TRUE, parentId=synTableFolderId)
generatedBy(table2File) <- table2Activity
table2File <- storeEntity(table2File)
table2Activity <- generatedBy(table2File)

