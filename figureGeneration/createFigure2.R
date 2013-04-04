#----------------------
#  figure 2: LYM in ER-
#----------------------

createFigure2 <- function(){
  
  fig2 <- file.path(figDir, "fig2.png")
  
  png(file = fig2, width = 3.5, height = 10.5, units = "in", res = 300, pointsize=12)
  par(
    mar = c(2.5,3,2.5,1),       #plot margin
    mgp = c(1.5, 0.3, 0),     #axis and label margin
    mfrow = c(3, 1)
  )
  
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
  time<-mbDss[idx.erN,1]
  status<-mbDss[idx.erN,2]
  
  ii <- time >= 15*365
  time[ii] <- 15*365
  status[ii] <- 0
  
  X<-cbind(time,status,as.numeric( metafeature<median(metafeature)))
  colnames(X)<-c("time","status", "x")
  fit.erN <- survfit(Surv(time, status) ~ x, data = data.frame(X))
  pval.erN<-summary(coxph(Surv(time, status) ~ metafeature))$logtest[3]
  
  #ER- Samples
  plot(
    fit.erN,
    col = c("18","20"),     #Red, Blue
    lwd = 1:1,
    mark.time = FALSE,
    xlab = "Days",
    ylab = "Survival (%)",
    yscale = 100,
    cex.main = 1,
    cex.axis = 0.9,
    cex.lab = 1)
  
  legend(2300, 0.3, c("High", "Low"),title="LYM", lwd=1:1, col=c("18","20"),cex=1)
  text(3000,0.4,substitute(paste( italic("P"), " value = ",k ), list(k=round(pval.erN,4))),cex=1)
  
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
  pval.erN.oslo<-summary(coxph(Surv(time, status) ~ metafeature))$logtest[3]
  
  #ER- Samples
  plot(
    fit.erN.oslo,
    col = c("18","20"),     #Red, Blue
    lwd = 1:1,
    mark.time = FALSE,
    xlab = "Days",
    ylab = "Survival (%)",
    yscale = 100,
    cex.main = 1,
    cex.axis = 0.9,
    cex.lab = 1)
  
  legend(3000, 0.9, c("High", "Low"),title="LYM", lwd=1:1, col=c("18","20"),cex=1)
  text(3000,0.2,substitute(paste( italic("P"), " value = ", k ),list(k=round(pval.erN.oslo, 4))),cex=1)
  
  # NOTE: OSLO does not have enough samples with ER+ / lymNum+ 
  # to perform a meaningful analysis
  
  ##lymphNode >4 Samples
  idx.erP <- (mbClinImputed[,"lymph_nodes_positive"] > 4 & mbClin$ER.Expr=="+")
  metafeature<-mbMeta["ls",idx.erP]
  metafeature <- metafeature - median(metafeature)
  time<-mbDss[idx.erP,1]
  status<-mbDss[idx.erP,2]
  
  ii <- time >= 15*365
  time[ii] <- 15*365
  status[ii] <- 0
  
  X<-cbind(time,status,as.numeric( metafeature<median(metafeature)))
  colnames(X)<-c("time","status", "x")
  fit.erP <- survfit(Surv(time, status) ~ x, data = data.frame(X))
  pval.erP<-summary(coxph(Surv(time, status) ~ metafeature))$logtest[3]
  
  
  #Positive lymph node number >4 Samples
  plot(
    fit.erP,
    col = c("18","20"),     #Red, Blue
    lwd = 1:1,
    mark.time = FALSE,
    xlab = "Days",
    ylab = "Survival (%)",
    yscale = 100,
    cex.main = 1,
    cex.axis = 0.9,
    cex.lab = 1)
  
  legend(3000, 0.95, c("High", "Low"),title="LYM", lwd=1:1, col=c("18","20"),cex=1)
  text(3000,0.1,substitute(paste( italic("P"), " value = ", k ),list(k=round(pval.erP, 4))),cex=1)
  
  dev.off()
  
  return(fig2)
}

