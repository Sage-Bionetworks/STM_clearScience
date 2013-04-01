#----------------------
#  figure 2: LYM in ER-
#----------------------

createFigure2 <- function(){
  
  fig2 <- file.path(figDir, "fig2.png")
  
  png(file = fig2, width = 7.3, height = 3.5, units = "in", res = 300)
  par(
    mar = c(2,2,2,1),       #plot margin
    mgp = c(1, 0.4, 0),     #axis and label margin
    mfrow = c(1, 2)
  )         #2 columns
  
  #
  #
  # fig2A: LYM | ER- metabric
  #
  #
  ##ER- Samples
  #idx.erN = (meta["er",] < 0 & meta["erbb2", ] < 0)
  idx.erN <- mbClin$ER.Expr=="-" 
  metafeature<-mbMeta["ls",idx.erN]
  metafeature <- metafeature - median(metafeature)
  time<-mbSurv[idx.erN,1]
  status<-mbSurv[idx.erN,2]
  
  ii <- time >= 15*365
  time[ii] <- 15*365
  status[ii] <- 0
  
  X<-cbind(time,status,as.numeric( metafeature<median(metafeature)))
  colnames(X)<-c("time","status", "x")
  fit.erN <- survfit(Surv(time, status) ~ x, data = data.frame(X))
  pval.erN<-summary(coxph(Surv(time, status) ~ metafeature, ))$logtest[3]
  
  #ER- Samples
  plot(
    fit.erN,
    col = c("18","20"),     #Red, Blue
    lwd = 1:1,
    mark.time = FALSE,
    main = "(A) METABRIC ER-",
    xlab = "Days",
    ylab = "Survival (%)",
    yscale = 100,
    cex.main = 0.5,
    cex.axis = 0.5,
    cex.lab = 0.5)
  
  legend(2700, 0.3, c("High", "Low"),title="LYM", lwd=1:1, col=c("18","20"),cex=0.4)
  text(3000,0.4,paste("P value = ",round(pval.erN,4)),cex=0.5, font=3)
  
  #
  #
  #  fig2B: LYM | ER- oslo
  #
  #
  
  idx.erN <- ovClin$ER.Expr=="-" 
  metafeature<-ovMeta["ls",idx.erN]
  metafeature <- metafeature - median(metafeature)
  time<-ovSurv[idx.erN,1]
  status<-ovSurv[idx.erN,2]
  
  ii <- time >= 15*365
  time[ii] <- 15*365
  status[ii] <- 0
  
  X<-cbind(time,status,as.numeric( metafeature<median(metafeature)))
  colnames(X)<-c("time","status", "x")
  fit.erN.oslo <- survfit(Surv(time, status) ~ x, data = data.frame(X))
  pval.erN.oslo<-summary(coxph(Surv(time, status) ~ metafeature, ))$logtest[3]
  
  #ER- Samples
  plot(
    fit.erN.oslo,
    col = c("18","20"),     #Red, Blue
    lwd = 1:1,
    mark.time = FALSE,
    main = "(B) OSLOVAL ER-",
    xlab = "Days",
    ylab = "Survival (%)",
    yscale = 100,
    cex.main = 0.5,
    cex.axis = 0.5,
    cex.lab = 0.5)
  
  legend(3000, 0.9, c("High", "Low"),title="LYM", lwd=1:1, col=c("18","20"),cex=0.4)
  text(3000,0.2,paste("P value = ",round(pval.erN.oslo,4)),cex=0.5)
  
  dev.off()
  
  return(fig2)
}

