#------------
# figure 3: SUSD3-FGD3 metagene
#------------

createFigure3 <- function(){
  
  fig3 <- file.path(figDir, "fig3.png")
  
  png(file = fig3, width = 7.3, height = 7, units = "in", res = 300, pointsize=11)
  par(
    mar = c(2.5,3,2.5,1),       #plot margin
    mgp = c(1.5, 0.3, 0),    #axis and label margin
    mfrow=c(2, 2)
  )
  
  #
  #
  # SUSD3 vs FGD3
  #
  #
  
  plot(
    mbExpr["ILMN_1772686",],
    mbExpr["ILMN_1785570",],
    lwd = 1:1,
    pch=20,         #dots
    col="blue",
    cex=0.5,
    ylab = expression(italic("SUSD3")),
    xlab = expression(italic("FGD3")),
    cex.main = 1,
    cex.axis = 0.9,
    cex.lab = 1)
  
  
  #
  #
  # fig3B: SUSD3-FGD3 vs ESR1
  #
  #
  
  plot(
    mbMeta["susd3",],
    mbExpr["ILMN_1678535",],
    lwd = 1:1,
    pch=20,         #dots
    col="blue",
    cex=0.5,
    xlab = expression(paste( italic("FGD3"),"-", italic("SUSD3"), " metagene")),
    ylab = expression(italic("ESR1")),
    cex.main = 1,
    cex.axis = 0.9,
    cex.lab = 1)
  
  #
  #
  # fig3A: SUSD3-FGD3 metabric
  #
  #
  
  metafeature<-mbMeta["susd3",]
  metafeature <- metafeature - median(metafeature)
  time<-mbDss[,1]
  status<-mbDss[,2]
  
  ii <- time >= 15*365
  time[ii] <- 15*365
  status[ii] <- 0
  
  X<-cbind(time,status,as.numeric( metafeature<median(metafeature)))
  colnames(X)<-c("time","status", "x")
  fit.susd3 <- survfit(Surv(time, status) ~ x, data = data.frame(X))
  pval.susd3<-summary(coxph(Surv(time, status) ~ metafeature))$logtest[3]
  
  plot(
    fit.susd3,
    col = c("18","20"),     #Red, Blue
    lwd = 1:1,
    mark.time = FALSE,
    xlab = "Days",
    ylab = "Survival (%)",
    yscale = 100,
    cex.main = 1,
    cex.axis = 0.9,
    cex.lab = 1)
  
  legend(900, 0.4, c("High", "Low"),title=expression(paste( italic("FGD3"),"-", italic("SUSD3"), " metagene")), lwd=1:1, col=c("18","20"),cex=1)
  text(2500,0.5,expression(paste( italic("P") , " value < ", 2 %*% 10^{-16} )),cex=1)
  
  #
  #
  # fig3D: SUSD3-FGD3 OSLO
  #
  #
  
  metafeature<-ovMeta["susd3",]
  metafeature <- metafeature - median(metafeature)
  time<-ovSurv[,1]
  status<-ovSurv[,2]
  
  ii <- time >= 15*365
  time[ii] <- 15*365
  status[ii] <- 0
  
  X<-cbind(time,status,as.numeric( metafeature<median(metafeature)))
  colnames(X)<-c("time","status", "x")
  fit.susd3.oslo <- survfit(Surv(time, status) ~ x, data = data.frame(X))
  pval.susd3.oslo<-summary(coxph(Surv(time, status) ~ metafeature))$logtest[3]
  
  plot(
    fit.susd3.oslo,
    col = c("18","20"),     #Red, Blue
    lwd = 1:1,
    mark.time = FALSE,
    xlab = "Days",
    ylab = "Survival (%)",
    yscale = 100,
    cex.main = 1,
    cex.axis = 0.9,
    cex.lab = 1)
  
  legend(1500, 0.3, c("High", "Low"),title=expression(paste( italic("FGD3"),"-", italic("SUSD3"), " metagene")), lwd=1:1, col=c("18","20"),cex=1)
  text(3000,0.35,substitute(paste( italic("P"), " value = ", k ),list(k=round(pval.susd3.oslo, 4))),cex=1)
  
  dev.off()
  
  return(fig3)
}
