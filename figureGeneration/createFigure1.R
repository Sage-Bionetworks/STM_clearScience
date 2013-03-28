#-------------------
#  figure 1: mitotic
#-------------------

createFigure1 <- function(){
  fig1 <- file.path(figDir, "fig1.tiff")
  
  tiff(file = fig1, width = 7.3, height = 3.5, units = "in", res = 300, compression="lzw")
  par(mar = c(2,2,2,1),       #plot margin
      mgp = c(1, 0.4, 0),
      mfrow = c(1, 2))     #axis and label margin
  
  #########################
  #
  #
  #  fig1A: metabric mitotic
  #
  #
  #########################
  
  #Mitotc
  metafeature<-mbMeta["mitotic",]
  metafeature <- metafeature - median(metafeature)
  time<-mbSurv[,1]
  status<-mbSurv[,2]
  
  # truncate to 15-year survival
  ii <- time >= 15*365
  time[ii] <- 15*365
  status[ii] <- 0
  
  X<-cbind(time,status,as.numeric( metafeature<median(metafeature)))
  colnames(X)<-c("time","status", "x")
  fit.cin <- survfit(Surv(time, status) ~ x, data = data.frame(X))
  pval.cin<-summary(coxph(Surv(time, status) ~ metafeature, ))$logtest[3]
  
  plot(
    fit.cin,
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
  
  legend(2500, 0.4, c("High", "Low"),title="CIN", lwd=1:1, col=c("18","20"),cex=0.4)
  text(3000,0.5, expression(paste(italic("P value = " ), 2 %*% 10^{-12} )),cex=0.5, font=3)
  
  #########################
  #
  #
  #  fig1B: mitotic oslo
  #
  #
  #########################
  
  metafeature<-ovMeta["mitotic",]
  metafeature <- metafeature - median(metafeature)
  time<-ovSurv[,1]
  status<-ovSurv[,2]
  
  # truncate to 15-year survival
  ii <- time >= 15*365
  time[ii] <- 15*365
  status[ii] <- 0
  
  X<-cbind(time,status,as.numeric( metafeature<median(metafeature)))
  colnames(X)<-c("time","status", "x")
  fit.cin.oslo <- survfit(Surv(time, status) ~ x, data = data.frame(X))
  pval.cin.oslo<-summary(coxph(Surv(time, status) ~ metafeature, ))$logtest[3]
  
  plot(
    fit.cin.oslo,
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
  
  legend(2500, 0.9, c("High", "Low"),title="CIN", lwd=1:1, col=c("18","20"),cex=0.4)
  text(3000,0.3,paste("P value =", round(pval.cin.oslo, 4)),cex=0.5, font=3)
  
  dev.off()       #Write
  return(fig1)
}
