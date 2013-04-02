#-------------------
# figure 3: LYM in ER+ with positive lymph nodes
#-------------------
# NOTE: OSLO does not have enough samples with ER+ / lymNum+ 
# to perform a meaningful analysis

createFigure3 <- function(){
  
  fig3 <- file.path(figDir, "fig3.png")
  png(file = fig3, width = 3.5, height = 3.5, units = "in", res = 300)
  par(
    mar = c(2,2,2,1),       #plot margin
    mgp = c(1, 0.4, 0)     #axis and label margin
  )
  
  ##lymphNode >4 Samples
  idx.erP <- (mbClinImputed[,"lymph_nodes_positive"] > 4 & mbClin$ER.Expr=="+")
  metafeature<-mbMeta["ls",idx.erP]
  metafeature <- metafeature - median(metafeature)
  time<-mbSurv[idx.erP,1]
  status<-mbSurv[idx.erP,2]
  
  ii <- time >= 15*365
  time[ii] <- 15*365
  status[ii] <- 0
  
  X<-cbind(time,status,as.numeric( metafeature<median(metafeature)))
  colnames(X)<-c("time","status", "x")
  fit.erP <- survfit(Surv(time, status) ~ x, data = data.frame(X))
  pval.erP<-summary(coxph(Surv(time, status) ~ metafeature, ))$logtest[3]
  
  
  #Positive lymph node number >4 Samples
  plot(
    fit.erP,
    col = c("18","20"),     #Red, Blue
    lwd = 1:1,
    mark.time = FALSE,
    main = "METABRIC ER+ | lymph node number > 4",
    xlab = "Days",
    ylab = "Survival (%)",
    yscale = 100,
    cex.main = 0.5,
    cex.axis = 0.5,
    cex.lab = 0.5)
  
  legend(2700, 0.9, c("High", "Low"),title="LYM", lwd=1:1, col=c("18","20"),cex=0.4)
  text(3000,0.1,paste("P value = ",round(pval.erP,4)),cex=0.5, font=3)
  
  dev.off()       #Write
  
  return(fig3)
}
