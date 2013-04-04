#------------
# figure 4: 
#------------

createFigure4 <- function(){
  
  fig4 <- file.path(figDir, "fig4.png")
  
  png(file = fig4, width = 3.5, height = 3.5, units = "in", res = 300, pointsize=8)
  par(
    mar = c(3,3,1,1),       #plot margin
    mgp = c(1.5, 0.3, 0)     #axis and label margin
  )
  
  preds <- ovPredictions[rownames(ovClin), "syn1417992"]
  time <- ovSurv[, 1]
  status <- ovSurv[, 2]
  
  ii <- time >= 15*365
  time[ii] <- 15*365
  status[ii] <- 0
  
  X<-cbind(time,status,as.numeric( preds<median(preds)))
  colnames(X)=c("time","status", "x")
  fit.m <- survfit(Surv(time, status) ~ x, data = data.frame(X))
  pval.m<-summary(coxph(Surv(time, status) ~ preds))$logtest[3]
  
  plot(
    fit.m,
    col = c("18","20"),     #Red, Blue
    lwd = 1:1,
    mark.time = FALSE,
    xlab = "Days",
    ylab = "Survival (%)",
    yscale = 100,
    cex.main = 1,
    cex.axis = 0.9,
    cex.lab = 1)
  
  legend(500, 0.3, c("Poor", "Good"),title="Predicted survival", lwd=1:1, col=c("18","20"),cex=1)
  text(3500,0.1,expression(paste( italic("P") , " value < ", 2 %*% 10^{-16} ) ),cex=1)
  
  
  dev.off()
  
  return(fig4)
}
