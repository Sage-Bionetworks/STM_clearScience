require(synapseClient)
require(rGithubClient)
require(survival)
require(ggplot2)

analysisRepo <- getRepo("Sage-Bionetworks/STM_clearScience") ## ADD TAG INFORMATION WHEN AVAILABLE

## SOURCE IN FILE FROM GITHUB WHICH LOADS METABRIC AND OSLO VAL DATA
sourceRepoFile(analysisRepo, "dataScripts/loadMetabricAndOsloval.R")
sourceRepoFile(analysisRepo, "dataScripts/loadOslovalPredictions.R")

stopifnot( all(rownames(ovSurv)==rownames(ovPredictions)) )

## POSSIBLE COVARIATES TO USE IN MODEL (FROM ui.R)
possibleCovs <- c(rownames(ovMetaScaled), "age_at_diagnosis", "size", "lymph_nodes_positive", "gradeIdx", "erClin")
possibleCovs <- sub(".", "", possibleCovs, fixed=T)

## CREATE A NULL DISTRIBUTION FOR PLOT
nullData <- matrix(NA, nrow = nrow(ovPredictions), ncol = ncol(ovPredictions))
set.seed(1775757677)
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
  geom_vline(xintercept=max(finalDF$cci), colour="red") + 
  theme(axis.title=element_text(size=24), 
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
      mbFormula <- as.formula(paste("mbSurv ~ ", eq, sep=""))
      mbModel <- coxph(mbFormula, data=mbImputedAll)
      mbPredNames <- names(predict(mbModel, type="expected"))
      mbPred <- predict(mbModel)
      mbCCI <- survConcordance(mbSurv[which(rownames(mbAll) %in% mbPredNames), ] ~ mbPred)
      
      ovPred <- predict(mbModel, newdata=ovImputedAll)
      ovPred <- ovPred[!is.na(ovPred)]
      ovCCI <- survConcordance(ovSurv[which(rownames(ovAll) %in% names(ovPred)), ] ~ ovPred)
      
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
        geom_vline(xintercept=plotLines$ovCCI$concordance["concordant"], colour="steelblue") + 
        geom_vline(xintercept=c(plotLines$ovCCI$concordance["concordant"] - plotLines$ovCCI$std.err["std(c-d)"],
                                plotLines$ovCCI$concordance["concordant"] + plotLines$ovCCI$std.err["std(c-d)"]),
                   linetype="dotted", colour="steelblue")
      
      show(awesomeNew)
    }
  })
  
})

