require(synapseClient)
require(rGithubClient)
require(survival)
require(ggplot2)
require(DreamBox7)

data(map)
data(attractome.minimalist)

## LOAD METABRIC AND OSLO VAL DATA
allDatEnt <- loadEntity("syn1752231")
mbImputedAll <- allDatEnt$objects$mbImputedAll
ovImputedAll <- allDatEnt$objects$ovImputedAll
mbSurvEnt <- loadEntity("syn1710277")
mbSurv <- mbSurvEnt$objects$metabricSurvData
ovSurvEnt <- loadEntity("syn1710257")
ovSurv <- ovSurvEnt$objects$oslovalSurvData

## SOURCE IN FILE FROM GITHUB WHICH LOADS OSLO VAL PREDICTIONS
analysisRepo <- getRepo("Sage-Bionetworks/STM_clearScience") ## ADD TAG INFORMATION WHEN AVAILABLE
sourceRepoFile(analysisRepo, "dataScripts/loadOslovalPredictions.R")

stopifnot( all(rownames(ovSurv)==rownames(ovPredictions)) )

## POSSIBLE COVARIATES TO USE IN MODEL (FROM ui.R)
possibleCovs <- c(names(attractome.minimalist), "age_at_diagnosis", "size", "lymph_nodes_positive", "gradeIdx", "erClin")
possibleCovs <- sub(".", "", possibleCovs, fixed=T)

## CREATE A NULL DISTRIBUTION FOR PLOT
nullData <- matrix(NA, nrow = nrow(ovPredictions), ncol = ncol(ovPredictions))
set.seed(137574512)
for(i in 1:ncol(nullData)){
  nullData[ , i] <- rnorm(nrow(nullData))
}
rownames(nullData) <- rownames(ovPredictions)
colnames(nullData) <- paste("nullData", 1:ncol(nullData), sep="-")
allPredictions <- cbind(ovPredictions, nullData)
allCCI <- apply(allPredictions, 2, function(pred){
  survConcordance(ovSurv ~ pred)$concordance
})

grp <- c(rep("challenge submissions", length(allCCI)/2), rep("null distribution", length(allCCI)/2))
finalDF <- data.frame(cci=allCCI, grp=grp)

awesome <- ggplot(finalDF) + 
  xlab("concordance index") + 
  geom_density(aes(x=cci, fill=factor(grp)), alpha=0.3) + 
  labs(fill="Group") + 
  geom_vline(xintercept=max(finalDF$cci), colour="black", size=1.5) + 
  theme(axis.title=element_text(size=18), 
        axis.text=element_text(size=18), 
        title=element_text(size=32))


# Define server logic required for interaction
shinyServer(function(input, output){
  
  buildModelVars <- reactive({
    modelVars <- character()
    for(this in possibleCovs){
      if( input[[this]] ){
        modelVars <- switch(this,
                            erClin = c(modelVars, "er.N"),
                            gradeIdx = c(modelVars, c("gd.1", "gd.2", "gd.3")),
                            chr7p112 = c(modelVars, "chr7p11.2"),
                            chr15q261 = c(modelVars, "chr15q26.1"),
                            c(modelVars, this))
      }
    }
    return(modelVars)
  })
  
  buildModel <- reactive({
    modelVars <- buildModelVars()
    if( length(modelVars) == 0 ){
      return(NULL)
    } else{
      eq <- paste(modelVars, collapse=" + ")
      mbUse <- mbImputedAll
      ovUse <- ovImputedAll
      if( input$mtEarly ){
        mbMtIdx <- mbUse$size < 30 & mbUse$lymph_nodes_positive == 0
        ovMtIdx <- ovUse$size < 30 & ovUse$lymph_nodes_positive == 0
        
        mbUse$mt <- mbUse$mt - median(mbUse$mt[ mbMtIdx ])
        mbUse$mt[ !mbMtIdx ] <- 0
        ovUse$mt <- ovUse$mt - median(ovUse$mt[ ovMtIdx ])
        ovUse$mt[ !ovMtIdx ] <- 0
      }
      if( input$lsErNeg ){
        mbLsIdx <- mbUse$er.N == 1
        ovLsIdx <- ovUse$er.N == 1
        
        mbUse$ls <- mbUse$ls - median(mbUse$ls[ mbLsIdx ])
        mbUse$ls[ !mbLsIdx ] <- 0
        ovUse$ls <- ovUse$ls - median(ovUse$ls[ ovLsIdx ])
        ovUse$ls[ !ovLsIdx ] <- 0
      }
      mbFormula <- as.formula(paste("mbSurv ~ ", eq, sep=""))
      mbModel <- coxph(mbFormula, data=mbUse)
      mbPredNames <- names(predict(mbModel, type="expected"))
      mbPred <- predict(mbModel)
      mbCCI <- survConcordance(mbSurv[which(rownames(mbUse) %in% mbPredNames), ] ~ mbPred)
      
      ovPred <- predict(mbModel, newdata=ovUse)
      ovPred <- ovPred[!is.na(ovPred)]
      ovCCI <- survConcordance(ovSurv[which(rownames(ovUse) %in% names(ovPred)), ] ~ ovPred)
      
      return(list(mbCCI=mbCCI, ovCCI=ovCCI))
    }
  })
  
  output$mbConcordance <- renderText({
    thisDat <- buildModel()
    if( is.null(thisDat) ){
      return(NULL)
    } else{
      paste("Concordance Index = ", 
            round(thisDat$mbCCI$concordance["concordant"], 4), 
            " (se = ", round(thisDat$mbCCI$std.err["std(c-d)"], 4), ")", sep="")
    }
  })
  
  output$ovConcordance <- renderText({
    thisDat <- buildModel()
    if( is.null(thisDat) ){
      return(NULL)
    } else{
      paste("Concordance Index = ", 
            round(thisDat$ovCCI$concordance["concordant"], 4), 
            " (se = ", round(thisDat$ovCCI$std.err["std(c-d)"], 4), ")", sep="")
    }
  })
  
  output$awesomePlot <- renderPlot({
    plotLines <- buildModel()
    
    if( is.null(plotLines) ){
      show(awesome)
    } else{
      awesomeNew <- awesome + 
        geom_vline(xintercept=plotLines$ovCCI$concordance["concordant"], colour="steelblue", size=1) + 
        geom_vline(xintercept=c(plotLines$ovCCI$concordance["concordant"] - plotLines$ovCCI$std.err["std(c-d)"],
                                plotLines$ovCCI$concordance["concordant"] + plotLines$ovCCI$std.err["std(c-d)"]),
                   linetype="dashed", colour="steelblue", size=.5)
      
      show(awesomeNew)
    }
  })
  
})

