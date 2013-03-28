#------------
# figure 4: SUSD3-FGD3 metagene
#------------

createFigure4 <- function(){
  
  fig4 <- file.path(figDir, "fig4.tiff")
  
  tiff(file = fig4, width = 7.3, height = 3.5, units = "in", res = 300, compression="lzw")
  par(
    mar = c(2,2,2,1),       #plot margin
    mgp = c(1, 0.4, 0),    #axis and label margin
    mfrow=c(1, 2)
  )
  
  #
  #
  # fig4A: SUSD3-FGD3 metabric
  #
  #
  
  metafeature<-mbMeta["susd3",]
  metafeature <- metafeature - median(metafeature)
  time<-mbSurv[,1]
  status<-mbSurv[,2]
  
  ii <- time >= 15*365
  time[ii] <- 15*365
  status[ii] <- 0
  
  X<-cbind(time,status,as.numeric( metafeature<median(metafeature)))
  colnames(X)<-c("time","status", "x")
  fit.susd3 <- survfit(Surv(time, status) ~ x, data = data.frame(X))
  pval.susd3<-summary(coxph(Surv(time, status) ~ metafeature, ))$logtest[3]
  
  plot(
    fit.susd3,
    col = c("18","20"),     #Red, Blue
    lwd = 1:1,
    mark.time = FALSE,
    main = "(A) METABRIC",
    xlab = "Days",
    ylab = "Survival (%)",
    yscale = 100,
    cex.main = 0.5,
    cex.axis = 0.5,
    cex.lab = 0.5)
  
  legend(1800, 0.4, c("High", "Low"),title="FGD3-SUSD3 metagene", lwd=1:1, col=c("18","20"),cex=0.4)
  text(2500,0.5,expression(paste( italic("P value = "), 3 %*% 10^{-14} )),cex=0.5)
  
  #
  #
  # fig4B: SUSD3-FGD3 OSLO
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
  pval.susd3.oslo<-summary(coxph(Surv(time, status) ~ metafeature, ))$logtest[3]
  
  plot(
    fit.susd3.oslo,
    col = c("18","20"),     #Red, Blue
    lwd = 1:1,
    mark.time = FALSE,
    main = "(B) OSLOVAL",
    xlab = "Days",
    ylab = "Survival (%)",
    yscale = 100,
    cex.main = 0.5,
    cex.axis = 0.5,
    cex.lab = 0.5)
  
  legend(2500, 0.95, c("High", "Low"),title="FGD3-SUSD3 metagene", lwd=1:1, col=c("18","20"),cex=0.4)
  text(3000,0.4,paste("P value =", round(pval.susd3.oslo, 4)),cex=0.5, font=3)
  
  dev.off()
  
  return(fig4)
}
