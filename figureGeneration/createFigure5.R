#------------
# figure 5: SUSD3, FGD3, ESR1
#------------

createFigure5 <- function(){
  
  fig5 <- file.path(figDir, "fig5.tiff")
  
  tiff(file = fig5, width = 7.3, height = 3.5, units = "in", res = 300, compression="lzw")
  par(
    mar = c(2,2,2,1),       #plot margin
    mgp = c(1, 0.4, 0),      #axis and label margin
    mfrow = c(1, 2)
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
    main = "(A) FGD3 vs. SUSD3 expression level",
    ylab = "SUSD3",
    xlab = "FGD3",
    cex.main = 0.5,
    cex.axis = 0.5,
    cex.lab = 0.5)
  
  
  #
  #
  # fig5B: SUSD3-FGD3 vs ESR1
  #
  #
  
  plot(
    mbMeta["susd3",],
    mbExpr["ILMN_1678535",],
    lwd = 1:1,
    pch=20,         #dots
    col="blue",
    cex=0.5,
    main = "(B) FGD3-SUSD3 metagene vs. ESR1 expression level",
    xlab = "FGD3-SUSD3 metagene",
    ylab = "ESR1",
    cex.main = 0.5,
    cex.axis = 0.5,
    cex.lab = 0.5)
  dev.off()
  
  return(fig5)
}
